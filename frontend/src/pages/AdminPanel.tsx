// pages/AdminPanel.tsx
import { useState, useEffect, useRef, useCallback } from "react";
import { useNavigate } from "react-router-dom";
import { Search, Plus, Trash2, X, Calendar, Users, Trophy, Loader2, AlertCircle, Clock } from "lucide-react";
import { useAuth } from "@/context/AuthContext";

type EventType =
  | "Goal ⚽"
  | "Assist 🎯"
  | "Yellow Card 🟨"
  | "Red Card 🟥";

interface MatchEvent {
  id: number;
  player: string;
  type: EventType;
  team: string;
  minute: number;
}

// Updated to match the backend response (fixture data)
interface MatchResult {
  id: number;
  home_team: string;
  away_team: string;
  group_name: string;
  stage: string;
  matchday: number;
  kickoff_time: string | null;
  status: string;
  created_at: string;
  display: string;
  // These will be added by the frontend for display
  home_score?: number;
  away_score?: number;
  result?: string;
  winner_team?: string | null;
  event_id?: number;
}

interface MatchEventsResponse {
  match_id: number;
  event_id: number;
  home_team: string;
  away_team: string;
  events: Array<{
    id: number;
    type: string;
    minute: number;
    team: string;
    player: string;
    created_at: string;
  }>;
}

const API_BASE_URL = import.meta.env.VITE_API_URL || "https://statrush.meshbase.online/api";

export default function AdminPanel() {
  // Search states
  const [search, setSearch] = useState("");
  const [searchResults, setSearchResults] = useState<MatchResult[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [selectedMatch, setSelectedMatch] = useState<MatchResult | null>(null);
  const [matchEvents, setMatchEvents] = useState<MatchEventsResponse | null>(null);
  const [showResults, setShowResults] = useState(false);
  const [searchError, setSearchError] = useState<string | null>(null);
  
  // Event form states
  const [player, setPlayer] = useState("");
  const [type, setType] = useState<EventType>("Goal ⚽");
  const [team, setTeam] = useState("");
  const [minute, setMinute] = useState("");
  const [events, setEvents] = useState<MatchEvent[]>([]);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [formErrors, setFormErrors] = useState<{player?: string; minute?: string}>({});
  
  // Auth
  const { isAuthenticated, adminId, logout, checkAuth } = useAuth();
  const navigate = useNavigate();
  
  // Refs
  const dropdownRef = useRef<HTMLDivElement>(null);
  const searchTimeoutRef = useRef<NodeJS.Timeout | null>(null);
  const playerInputRef = useRef<HTMLInputElement>(null);
  const minuteInputRef = useRef<HTMLInputElement>(null);

  // Bing scraping states
  const [bingUrl, setBingUrl] = useState("");
  const [isFetchingBing, setIsFetchingBing] = useState(false);
  const [bingFetchError, setBingFetchError] = useState<string | null>(null);
  const [bingFetchSummary, setBingFetchSummary] = useState<{
    loaded: number;
    skipped: number;
    skippedTypes: string[];
    teamWarnings: number;
  } | null>(null);

  // Check authentication on mount
  useEffect(() => {
    const verifyAuth = async () => {
      const isValid = await checkAuth();
      if (!isValid) {
        navigate('/admin/login');
      }
    };
    verifyAuth();
  }, [checkAuth, navigate]);

  // Click outside to close dropdown
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setShowResults(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Keyboard shortcuts
  useEffect(() => {
    const handleKeyPress = (e: KeyboardEvent) => {
      if (e.key === 'Enter' && document.activeElement?.tagName === 'INPUT') {
        const activeId = (document.activeElement as HTMLInputElement).id;
        if (activeId === 'player-input' || activeId === 'minute-input') {
          addEvent();
        }
      }
      if (e.key === 'Escape') {
        setPlayer("");
        setMinute("");
        setFormErrors({});
      }
    };

    window.addEventListener('keydown', handleKeyPress);
    return () => window.removeEventListener('keydown', handleKeyPress);
  }, []);

  // Live search function
  const performLiveSearch = useCallback(async (searchTerm: string) => {
    if (!searchTerm.trim() || searchTerm.length < 2) {
      setSearchResults([]);
      setShowResults(false);
      setIsSearching(false);
      return;
    }

    setIsSearching(true);
    setSearchError(null);

    try {
      const token = localStorage.getItem('sr_admin_token');
      const response = await fetch(
        `${API_BASE_URL}/matches/live-search?q=${encodeURIComponent(searchTerm)}`,
        {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
        }
      );

      if (response.status === 401) {
        logout();
        navigate('/admin/login');
        return;
      }

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      
      if (data.status === 'success') {
        // Enrich fixtures with default score data for display
        const enrichedMatches = data.matches.map((match: MatchResult) => ({
          ...match,
          home_score: 0,
          away_score: 0,
          result: 'Scheduled',
          winner_team: null,
          event_id: 0
        }));
        setSearchResults(enrichedMatches);
        setShowResults(enrichedMatches.length > 0);
      } else {
        setSearchResults([]);
        setShowResults(false);
        setSearchError(data.message || 'No matches found');
      }
    } catch (error) {
      console.error('Search error:', error);
      setSearchError('Failed to search matches');
      setSearchResults([]);
      setShowResults(false);
    } finally {
      setIsSearching(false);
    }
  }, [logout, navigate]);

  // Debounced search when typing
  useEffect(() => {
    if (searchTimeoutRef.current) {
      clearTimeout(searchTimeoutRef.current);
    }

    if (!search.trim() || selectedMatch) {
      setSearchResults([]);
      setShowResults(false);
      return;
    }

    searchTimeoutRef.current = setTimeout(() => {
      performLiveSearch(search);
    }, 300);

    return () => {
      if (searchTimeoutRef.current) {
        clearTimeout(searchTimeoutRef.current);
      }
    };
  }, [search, selectedMatch, performLiveSearch]);

    // Select a match
  const selectMatch = (match: MatchResult) => {
  setSelectedMatch(match);
  setShowResults(false);
  setSearch(`${match.home_team} vs ${match.away_team}`);

  setSearchResults([]);
  setEvents([]);
  setMatchEvents(null);

  setTeam(match.home_team);
  setPlayer("");
  setMinute("");
  setBingUrl("");
  setBingFetchError(null);
  setBingFetchSummary(null);

  setTimeout(() => playerInputRef.current?.focus(), 100);
};

  // Clear selected match
  const clearSelectedMatch = () => {
    if (events.length > 0) {
      if (!confirm(`You have ${events.length} pending events. Clear them and deselect match?`)) {
        return;
      }
    }
    setSelectedMatch(null);
    setMatchEvents(null);
    setSearch("");
    setSearchResults([]);
    setShowResults(false);
    setEvents([]);
    setTeam("");
    setPlayer("");
    setMinute("");
    setFormErrors({});
  };

  // Add event function
  const addEvent = () => {
    const newErrors: {player?: string; minute?: string} = {};
    
    if (!player.trim()) newErrors.player = "Player name is required";
    if (!team) newErrors.player = "Team is required";
    if (!minute) newErrors.minute = "Minute is required";
    if (minute && (Number(minute) < 0 || Number(minute) > 120)) {
      newErrors.minute = "Minute must be between 0 and 120";
    }
    
    if (Object.keys(newErrors).length > 0) {
      setFormErrors(newErrors);
      return;
    }
    
    setFormErrors({});

    const newEvent: MatchEvent = {
      id: Date.now(),
      player: player.trim(),
      type,
      team,
      minute: Number(minute),
    };

    setEvents((prev) => {
      const updated = [...prev, newEvent];
      return updated.sort((a, b) => a.minute - b.minute);
    });
    
    setPlayer("");
    setMinute("");
    
    setTimeout(() => playerInputRef.current?.focus(), 50);
  };

  const removeEvent = (id: number) => {
    setEvents((prev) => prev.filter((e) => e.id !== id));
  };

  const clearAllEvents = () => {
    if (events.length === 0) return;
    if (confirm(`Clear all ${events.length} pending events?`)) {
      setEvents([]);
    }
  };

  // Fetch events from Bing URL
const fetchBingEvents = async () => {
  if (!bingUrl.trim() || !selectedMatch) return;

  setIsFetchingBing(true);
  setBingFetchError(null);
  setBingFetchSummary(null);

  try {
    const token = localStorage.getItem('sr_admin_token');
    const response = await fetch(`${API_BASE_URL}/scrape/bing-events`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`,
      },
      body: JSON.stringify({
        url: bingUrl.trim(),
        home_team: selectedMatch.home_team,
        away_team: selectedMatch.away_team,
      }),
    });

    if (response.status === 401) {
      logout();
      navigate('/admin/login');
      return;
    }

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.message || 'Failed to fetch events');
    }

    const data = await response.json();

    if (data.status === "success") {
      // Map backend events to MatchEvent format for the queue
      const mappedEvents: MatchEvent[] = data.events.map((e: any, index: number) => ({
        id: Date.now() + index,
        player: e.player || "Unknown",
        type: e.type as EventType,
        team: e.team,
        minute: e.minute,
      }));

      // Count team assignment warnings
      const teamWarnings = data.events.filter((e: any) => !e.team_confirmed).length;

      // Add to existing events queue (merge and sort)
      setEvents((prev) => {
        const merged = [...prev, ...mappedEvents];
        return merged.sort((a, b) => a.minute - b.minute);
      });

      // Set summary for user feedback
      const skippedTypes: string[] = data.skipped.map((s: any) => s.type);
      const uniqueSkippedTypes = [...new Set(skippedTypes)] as string[];

      setBingFetchSummary({
        loaded: data.total_mapped,
        skipped: data.total_found - data.total_mapped,
        skippedTypes: uniqueSkippedTypes,
        teamWarnings: teamWarnings,
      });

      setBingUrl(""); // Clear input on success
    } else {
      setBingFetchError(data.message || "Failed to fetch events");
    }
  } catch (error) {
    console.error('Bing fetch error:', error);
    setBingFetchError(
      error instanceof Error ? error.message : "Failed to fetch Bing events"
    );
  } finally {
    setIsFetchingBing(false);
  }
};

  const submitAll = async () => {
    if (events.length === 0 || !selectedMatch) {
      alert("No events to submit or no match selected");
      return;
    }
    
    if (!confirm(`Submit ${events.length} events for ${selectedMatch.home_team} vs ${selectedMatch.away_team}?`)) {
      return;
    }
    
    setIsSubmitting(true);
    
    try {
      const token = localStorage.getItem('sr_admin_token');
      const response = await fetch(`${API_BASE_URL}/events/bulk`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`,
        },
        body: JSON.stringify({
          match_id: selectedMatch.id,
          events: events,
        }),
      });

      if (response.status === 401) {
        logout();
        navigate('/admin/login');
        return;
      }

      if (!response.ok) {
        const data = await response.json();
        throw new Error(data.message || 'Failed to submit events');
      }

      const data = await response.json();
      alert(`✅ ${events.length} events submitted successfully for ${selectedMatch.home_team} vs ${selectedMatch.away_team}`);
      setEvents([]);
      
      // Refresh match events
      if (selectedMatch) {
        selectMatch(selectedMatch);
      }
    } catch (err) {
      console.error(err);
      alert("❌ Failed to submit events: " + (err instanceof Error ? err.message : "Unknown error"));
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleLogout = () => {
    if (events.length > 0) {
      if (!confirm(`You have ${events.length} pending events. Logout anyway?`)) {
        return;
      }
    }
    logout();
    navigate('/admin/login');
  };

  // Get event type color
  const getEventTypeColor = (type: string) => {
    if (type.includes('Goal')) return 'bg-green-500/20 text-green-500 border-green-500/20';
    if (type.includes('Assist')) return 'bg-blue-500/20 text-blue-500 border-blue-500/20';
    if (type.includes('Yellow')) return 'bg-yellow-500/20 text-yellow-500 border-yellow-500/20';
    if (type.includes('Red')) return 'bg-red-500/20 text-red-500 border-red-500/20';
    return 'bg-gray-500/20 text-gray-500 border-gray-500/20';
  };

  // Get status color
  const getStatusColor = (status: string) => {
    if (status === 'Finished' || status === 'Completed') return 'text-green-500';
    if (status === 'Live' || status === 'In Progress') return 'text-yellow-500';
    if (status === 'Scheduled') return 'text-blue-500';
    return 'text-muted-foreground';
  };

  // Format date for display
  const formatDate = (dateString: string | null) => {
    if (!dateString) return 'TBD';
    return new Date(dateString).toLocaleString();
  };

  if (!isAuthenticated) {
    return null;
  }

  return (
    <div className="min-h-screen bg-background px-4 py-10">
      <div className="mx-auto max-w-4xl">
        {/* Admin header with logout */}
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-2xl font-bold">Admin Panel</h1>
            <p className="text-sm text-muted-foreground">
              Logged in as: {adminId}
            </p>
          </div>
          <button
            onClick={handleLogout}
            className="px-4 py-2 text-sm bg-red-500/10 text-red-500 rounded-lg hover:bg-red-500/20 transition"
          >
            Logout
          </button>
        </div>

        {/* Main Container */}
        <div className="rounded-2xl border border-border bg-card p-6 shadow-lg">
          
          {/* Match Selection */}
          <div className="rounded-xl border border-border p-5">
            <h2 className="mb-3 text-lg font-semibold flex items-center gap-2">
              <Trophy size={20} />
              Select Match
            </h2>

            <div className="relative" ref={dropdownRef}>
              <div className="flex gap-2">
                <div className="flex-1 relative">
                  <input
                    value={search}
                    onChange={(e) => {
                      setSearch(e.target.value);
                      if (!e.target.value) {
                        setShowResults(false);
                        setSearchResults([]);
                      }
                    }}
                    placeholder="Search by team name..."
                    className="w-full rounded-lg border border-border bg-background px-4 py-2 outline-none focus:border-up"
                    disabled={!!selectedMatch}
                  />
                  {isSearching && (
                    <div className="absolute right-3 top-2.5">
                      <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
                    </div>
                  )}
                </div>

                {selectedMatch && (
                  <button
                    onClick={clearSelectedMatch}
                    className="rounded-lg border border-border px-3 py-2 hover:bg-muted/20 transition"
                    title="Clear selected match"
                  >
                    <X size={18} />
                  </button>
                )}
              </div>

              {/* Search Results Dropdown - Updated for fixture data */}
              {showResults && searchResults.length > 0 && (
                <div className="absolute z-10 mt-1 w-full rounded-lg border border-border bg-card shadow-lg max-h-72 overflow-y-auto">
                  {searchResults.map((match) => (
                    <button
                      key={match.id}
                      onClick={() => selectMatch(match)}
                      className="w-full px-4 py-3 text-left hover:bg-muted/20 border-b border-border last:border-0 transition group"
                    >
                      <div className="flex justify-between items-start">
                        <div className="flex-1">
                          <div className="font-medium group-hover:text-up transition">
                            {match.home_team} vs {match.away_team}
                          </div>
                          <div className="text-sm text-muted-foreground flex flex-wrap gap-4 mt-1">
                            {match.status && (
                              <span className={`${getStatusColor(match.status)}`}>
                                {match.status}
                              </span>
                            )}
                            {match.kickoff_time && (
                              <span className="flex items-center gap-1">
                                <Clock size={14} />
                                {formatDate(match.kickoff_time)}
                              </span>
                            )}
                          </div>
                          {match.group_name && (
                            <div className="text-xs text-muted-foreground mt-1">
                              {match.group_name} • {match.stage} • Matchday {match.matchday}
                            </div>
                          )}
                        </div>
                        <div className="text-xs text-muted-foreground whitespace-nowrap ml-2">
                          <span className="bg-muted/30 px-2 py-0.5 rounded">
                            ID: {match.id}
                          </span>
                        </div>
                      </div>
                    </button>
                  ))}
                </div>
              )}

              {/* No Results */}
              {showResults && searchResults.length === 0 && !isSearching && search.length >= 2 && !selectedMatch && (
                <div className="absolute z-10 mt-1 w-full rounded-lg border border-border bg-card shadow-lg p-4 text-center text-muted-foreground">
                  <p>No matches found for "{search}"</p>
                  <p className="text-xs mt-1">Try searching by team name</p>
                </div>
              )}

              {/* Search Error */}
              {searchError && (
                <div className="absolute z-10 mt-1 w-full rounded-lg border border-red-500/40 bg-red-500/10 p-3 text-center text-red-400 text-sm">
                  {searchError}
                </div>
              )}
            </div>

            {/* Selected Match Details - Updated for fixture data */}
            {selectedMatch && (
              <div className="mt-4 p-4 rounded-lg bg-gradient-to-r from-up/5 to-transparent border border-up/20">
                <div className="flex justify-between items-start">
                  <div>
                    <h3 className="font-semibold text-lg">
                      {selectedMatch.home_team} vs {selectedMatch.away_team}
                    </h3>
                    <div className="text-sm text-muted-foreground space-y-1 mt-2">
                      <div className="flex items-center gap-2">
                        <Calendar size={14} className="text-muted-foreground" />
                        Score: <span className="font-semibold text-foreground">-</span>
                      </div>
                      {selectedMatch.status && (
                        <div className={`flex items-center gap-2 ${getStatusColor(selectedMatch.status)}`}>
                          Status: {selectedMatch.status}
                        </div>
                      )}
                      {selectedMatch.kickoff_time && (
                        <div className="flex items-center gap-2 text-muted-foreground">
                          <Clock size={14} />
                          Kickoff: {formatDate(selectedMatch.kickoff_time)}
                        </div>
                      )}
                      <div className="flex items-center gap-2 text-xs">
                        <span className="bg-muted/30 px-2 py-0.5 rounded">
                          Match ID: {selectedMatch.id}
                        </span>
                      </div>
                      {selectedMatch.group_name && (
                        <div className="text-xs text-muted-foreground">
                          {selectedMatch.group_name} • {selectedMatch.stage} • Matchday {selectedMatch.matchday}
                        </div>
                      )}
                    </div>
                  </div>
                  <div className="text-xs text-muted-foreground">
                    Created: {formatDate(selectedMatch.created_at)}
                  </div>
                </div>
              </div>
            )}
          </div>

          {/* Match Events Display */}
          {matchEvents && (
            <div className="mt-6 rounded-xl border border-border p-5">
              <h3 className="mb-3 text-lg font-semibold flex items-center gap-2">
                <Users size={20} />
                Existing Match Events
                <span className="text-sm font-normal text-muted-foreground">
                  ({matchEvents.events.length} events)
                </span>
              </h3>
              
              <div className="space-y-2 max-h-48 overflow-y-auto">
                {matchEvents.events.length === 0 ? (
                  <p className="text-sm text-muted-foreground text-center py-4">
                    No events recorded for this match
                  </p>
                ) : (
                  matchEvents.events.map((event, index) => (
                    <div key={index} className="flex items-center gap-3 p-2 bg-muted/10 rounded-lg hover:bg-muted/20 transition">
                      <span className="text-sm font-medium min-w-[40px]">{event.minute}'</span>
                      <span className={`text-xs px-2 py-0.5 rounded-full ${getEventTypeColor(event.type)}`}>
                        {event.type}
                      </span>
                      <span className="text-sm font-medium">{event.player}</span>
                      <span className="text-xs text-muted-foreground">({event.team})</span>
                    </div>
                  ))
                )}
              </div>
            </div>
          )}


          

          {/* Add Event */}
          {selectedMatch && (
            <>
              <div className="mt-8">
                <h2 className="mb-4 text-lg font-semibold flex items-center gap-2">
                  <Plus size={20} />
                  Add New Event
                  <span className="text-sm font-normal text-muted-foreground">
                    for {selectedMatch.home_team} vs {selectedMatch.away_team}
                  </span>
                  {events.length > 0 && (
                    <span className="ml-2 bg-up/20 text-up text-xs px-2 py-0.5 rounded-full">
                      {events.length} pending
                    </span>
                  )}
                </h2>

                {/* Quick Team Selection */}
                <div className="flex gap-2 mb-3">
                  <button
                    onClick={() => setTeam(selectedMatch.home_team)}
                    className={`px-3 py-1 text-sm rounded-lg border transition ${
                      team === selectedMatch.home_team 
                        ? 'border-up bg-up/10 text-up' 
                        : 'border-border hover:bg-muted/10'
                    }`}
                  >
                    {selectedMatch.home_team} (Home)
                  </button>
                  <button
                    onClick={() => setTeam(selectedMatch.away_team)}
                    className={`px-3 py-1 text-sm rounded-lg border transition ${
                      team === selectedMatch.away_team 
                        ? 'border-up bg-up/10 text-up' 
                        : 'border-border hover:bg-muted/10'
                    }`}
                  >
                    {selectedMatch.away_team} (Away)
                  </button>
                </div>

                {/* Event Type Quick Select */}
                <div className="flex gap-2 mb-3 flex-wrap">
                  {["Goal ⚽", "Assist 🎯", "Yellow Card 🟨", "Red Card 🟥"].map((eventType) => (
                    <button
                      key={eventType}
                      onClick={() => setType(eventType as EventType)}
                      className={`px-3 py-1 text-sm rounded-lg border transition ${
                        type === eventType 
                          ? 'border-up bg-up/10 text-up' 
                          : 'border-border hover:bg-muted/10'
                      }`}
                    >
                      {eventType}
                    </button>
                  ))}
                </div>

                <div className="grid gap-3 md:grid-cols-5">
                  <div className="md:col-span-2">
                    <input
                      id="player-input"
                      ref={playerInputRef}
                      value={player}
                      onChange={(e) => {
                        setPlayer(e.target.value);
                        if (formErrors.player) setFormErrors({...formErrors, player: undefined});
                      }}
                      placeholder="Player name"
                      className={`w-full rounded-lg border ${formErrors.player ? 'border-red-500' : 'border-border'} px-3 py-2 focus:border-up outline-none`}
                    />
                    {formErrors.player && (
                      <p className="text-xs text-red-500 mt-1 flex items-center gap-1">
                        <AlertCircle size={12} />
                        {formErrors.player}
                      </p>
                    )}
                  </div>

                  <div className="md:col-span-1">
                    <input
                      id="minute-input"
                      ref={minuteInputRef}
                      value={minute}
                      onChange={(e) => {
                        setMinute(e.target.value);
                        if (formErrors.minute) setFormErrors({...formErrors, minute: undefined});
                      }}
                      placeholder="Minute"
                      type="number"
                      min="0"
                      max="120"
                      className={`w-full rounded-lg border ${formErrors.minute ? 'border-red-500' : 'border-border'} px-3 py-2 focus:border-up outline-none`}
                    />
                    {formErrors.minute && (
                      <p className="text-xs text-red-500 mt-1 flex items-center gap-1">
                        <AlertCircle size={12} />
                        {formErrors.minute}
                      </p>
                    )}
                  </div>

                  <div className="md:col-span-1">
                    <button
                      onClick={addEvent}
                      className="w-full flex items-center justify-center gap-2 rounded-lg bg-up px-4 py-2 text-background transition hover:brightness-110"
                    >
                      <Plus size={18} />
                      Add
                    </button>
                  </div>
                </div>

                <div className="mt-2 text-xs text-muted-foreground">
                  Press <kbd className="px-1.5 py-0.5 bg-muted/30 rounded text-xs">Enter</kbd> to add, <kbd className="px-1.5 py-0.5 bg-muted/30 rounded text-xs">Esc</kbd> to clear
                </div>
              </div>



              {/* Fetch from Bing — moved inside Add Event section */}
    <div className="mt-6 rounded-xl border-2 border-dashed border-up/30 bg-up/5 p-5">
      <div className="flex items-center gap-2 mb-3">
        <div className="w-8 h-8 rounded-full bg-up/20 flex items-center justify-center">
          <Search size={16} className="text-up" />
        </div>
        <div>
          <h2 className="text-lg font-semibold">
            Fetch Events from Bing
          </h2>
          <p className="text-xs text-muted-foreground">
            Auto-extract goals, assists, yellow & red cards
          </p>
        </div>
      </div>

      <div className="flex gap-2">
        <div className="flex-1">
          <input
            value={bingUrl}
            onChange={(e) => {
              setBingUrl(e.target.value);
              if (bingFetchError) setBingFetchError(null);
            }}
            placeholder="Paste Bing SportsDetails URL here..."
            className={`w-full rounded-lg border ${
              bingFetchError ? 'border-red-500' : 'border-border'
            } bg-background px-4 py-3 outline-none focus:border-up text-sm`}
          />
        </div>
        <button
          onClick={fetchBingEvents}
          disabled={!bingUrl.trim() || isFetchingBing}
          className="rounded-lg bg-up px-6 py-3 text-white font-medium transition hover:brightness-110 disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2 whitespace-nowrap"
        >
          {isFetchingBing ? (
            <>
              <Loader2 className="h-4 w-4 animate-spin" />
              Fetching...
            </>
          ) : (
            <>
              <Search size={16} />
              Fetch Events
            </>
          )}
        </button>
      </div>

      {/* Fetch Summary */}
      {bingFetchSummary && (
        <div className="mt-3 p-3 rounded-lg bg-green-500/10 border border-green-500/20 text-sm">
          <div className="flex items-center gap-2 text-green-500 font-medium">
            ✅ {bingFetchSummary.loaded} event{bingFetchSummary.loaded !== 1 ? 's' : ''} loaded into queue below
          </div>
          {bingFetchSummary.skipped > 0 && (
            <div className="text-muted-foreground mt-1">
              ⏭️ {bingFetchSummary.skipped} event{bingFetchSummary.skipped !== 1 ? 's' : ''} skipped 
              ({bingFetchSummary.skippedTypes.map(t => t.replace(/_/g, ' ')).join(', ')})
            </div>
          )}
          {bingFetchSummary.teamWarnings > 0 && (
            <div className="text-yellow-500 mt-1">
              ⚠️ {bingFetchSummary.teamWarnings} event{bingFetchSummary.teamWarnings !== 1 ? 's' : ''} with uncertain team — review before submitting
            </div>
          )}
        </div>
      )}

      {/* Bing Fetch Error */}
      {bingFetchError && (
        <div className="mt-3 p-3 rounded-lg bg-red-500/10 border border-red-500/20 text-sm text-red-500 flex items-center gap-2">
          <AlertCircle size={14} />
          {bingFetchError}
        </div>
      )}
    </div>


              {/* Event Table */}
              <div className="mt-8 overflow-hidden rounded-xl border border-border">
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-muted/30">
                      <tr>
                        <th className="p-4 text-left">Player</th>
                        <th className="p-4 text-left">Type</th>
                        <th className="p-4 text-left">Team</th>
                        <th className="p-4 text-left">Min</th>
                        <th className="p-4 text-center">Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      {events.length === 0 ? (
                        <tr>
                          <td colSpan={5} className="p-6 text-center text-muted-foreground">
                            No pending events
                          </td>
                        </tr>
                      ) : (
                        events.map((event) => (
                          <tr key={event.id} className="border-t border-border hover:bg-muted/10 transition">
                            <td className="p-4 font-medium">{event.player}</td>
                            <td className="p-4">
                              <span className={`text-xs px-2 py-0.5 rounded-full ${getEventTypeColor(event.type)}`}>
                                {event.type}
                              </span>
                            </td>
                            <td className="p-4">{event.team}</td>
                            <td className="p-4 font-semibold">{event.minute}'</td>
                            <td className="p-4 text-center">
                              <button
                                onClick={() => removeEvent(event.id)}
                                className="text-red-500 hover:text-red-600 transition p-1 hover:bg-red-500/10 rounded"
                              >
                                <Trash2 size={18} />
                              </button>
                            </td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Submit */}
              <div className="mt-8 flex justify-center gap-4 flex-wrap">
                <button
                  onClick={submitAll}
                  disabled={events.length === 0 || isSubmitting}
                  className="rounded-xl bg-green-600 px-10 py-3 font-semibold text-white transition hover:bg-green-700 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {isSubmitting ? (
                    <span className="flex items-center gap-2">
                      <Loader2 className="h-4 w-4 animate-spin" />
                      Submitting...
                    </span>
                  ) : (
                    `Submit ${events.length} Event${events.length > 1 ? 's' : ''}`
                  )}
                </button>
                
                {events.length > 0 && (
                  <button
                    onClick={clearAllEvents}
                    className="rounded-xl bg-red-600/10 px-6 py-3 font-semibold text-red-600 transition hover:bg-red-600/20"
                  >
                    Clear All
                  </button>
                )}
              </div>

              <div className="mt-4 text-center text-xs text-muted-foreground">
                Submitting events for match: {selectedMatch.home_team} vs {selectedMatch.away_team}
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
}