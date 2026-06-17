import { useEffect, useState } from "react";
import { ChevronDown } from "lucide-react";
import { SiteHeader, MobileTabBar } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

type Status = "live" | "played" | "upcoming";

type Match = {
  id: string;
  home: string;
  homeFlag: string;
  away: string;
  awayFlag: string;
  status: Status;
  scoreHome?: number;
  scoreAway?: number;
  minute?: string;
  date?: string;
  time?: string;
  venue?: string;
  group?: string;
  events?: { id: number; minute: string; icon: string; text: string }[];
};

export default function Matches() {
  const [matches, setMatches] = useState<Match[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const size = 10; // items per page

  const fetchMatches = (p: number) => {
    fetch(`http://153.75.244.15:5001/api/matches?page=${p}&size=${size}`)
      .then((res) => res.json())
      .then((data) => {
        setMatches(data.matches);
        setLoading(false);
      })
      .catch((err) => {
        console.error('Failed to fetch matches', err);
        setLoading(false);
      });
  };

  useEffect(() => {
    setLoading(true);
    fetchMatches(page);
  }, [page]);

  const goPrev = () => setPage((p) => Math.max(p - 1, 1));
  const goNext = () => setPage((p) => p + 1);

  return (
    <div className="min-h-screen pb-24 md:pb-12">
      <SiteHeader />
      <main className="mx-auto max-w-7xl space-y-6 px-4 py-8 sm:px-6">
        <div className="flex items-end justify-between">
          <div>
            <h1 className="text-2xl font-extrabold sm:text-3xl">Matches</h1>
            <p className="text-sm text-muted-foreground">Live, recent, and upcoming fixtures</p>
          </div>
          <Legend />
        </div>

        {loading ? (
          <div className="flex h-64 items-center justify-center">
            <div className="h-8 w-8 animate-spin rounded-full border-4 border-primary border-t-transparent"></div>
          </div>
        ) : (
          <ul className="space-y-3">
            {matches.map((m) => (
              <MatchCard key={m.id} match={m} />
            ))}
          </ul>
        )}
        {/* Pagination controls */}
        <div className="mt-4 flex justify-center gap-4">
          <button
            onClick={goPrev}
            disabled={page === 1 || loading}
            className="rounded-md bg-muted px-3 py-1 text-sm disabled:opacity-50"
          >
            Previous
          </button>
          <span className="flex items-center gap-2 text-sm">
            Page {page}
          </span>
          <button
            onClick={goNext}
            disabled={loading}
            className="rounded-md bg-muted px-3 py-1 text-sm"
          >
            Next
          </button>
        </div>
      </main>
      <SiteFooter />
      <MobileTabBar />
    </div>
  );
}

function Legend() {
  return (
    <div className="hidden gap-3 text-xs text-muted-foreground sm:flex">
      <LegendItem dotClass="bg-up animate-pulse shadow-[0_0_8px_hsl(var(--up))]" label="Live" />
      <LegendItem dotClass="bg-yellow-400" label="Played" />
      <LegendItem dotClass="bg-muted-foreground/50" label="Upcoming" />
    </div>
  );
}

function LegendItem({ dotClass, label }: { dotClass: string; label: string }) {
  return (
    <span className="flex items-center gap-1.5">
      <span className={`h-2 w-2 rounded-full ${dotClass}`} />
      {label}
    </span>
  );
}

function StatusDot({ status }: { status: Status }) {
  if (status === "live") {
    return (
      <span className="relative inline-flex h-2.5 w-2.5">
        <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-up opacity-75" />
        <span className="relative inline-flex h-2.5 w-2.5 rounded-full bg-up shadow-[0_0_10px_hsl(var(--up))]" />
      </span>
    );
  }
  if (status === "played") {
    return <span className="inline-block h-2.5 w-2.5 rounded-full bg-yellow-400 shadow-[0_0_6px_rgba(250,204,21,0.6)]" />;
  }
  return <span className="inline-block h-2.5 w-2.5 rounded-full bg-muted-foreground/50" />;
}

function StatusLabel({ match }: { match: Match }) {
  if (match.status === "live") return <span className="font-mono text-xs font-bold uppercase tracking-wider text-up">Live · {match.minute}</span>;
  if (match.status === "played") return <span className="font-mono text-xs font-semibold uppercase tracking-wider text-yellow-400">Full Time</span>;
  return <span className="font-mono text-xs font-semibold uppercase tracking-wider text-muted-foreground">{match.date} · {match.time}</span>;
}

function MatchCard({ match }: { match: Match }) {
  const [open, setOpen] = useState(false);
  const expandable = match.status !== "upcoming";
  const toggle = () => expandable && setOpen((v) => !v);

  return (
    <li>
      <div
        onClick={toggle}
        className={`group rounded-2xl border border-border/70 bg-surface/40 transition-colors ${
          expandable ? "cursor-pointer hover:bg-surface/70" : "opacity-90"
        }`}
      >
        <div className="grid grid-cols-[auto_1fr_auto_1fr_auto] items-center gap-3 px-4 py-4 sm:gap-6 sm:px-6">
          <div className="flex flex-col items-center gap-1.5">
            <StatusDot status={match.status} />
            <span className="hidden text-[10px] uppercase text-muted-foreground sm:block">{match.group ?? "—"}</span>
          </div>

          <Side flag={match.homeFlag} name={match.home} align="right" />

          <div className="text-center">
            {match.status === "upcoming" ? (
              <div className="font-mono text-lg font-bold text-muted-foreground">vs</div>
            ) : (
              <div className="font-mono text-2xl font-extrabold tabular sm:text-3xl">
                {match.scoreHome} <span className="text-muted-foreground">-</span> {match.scoreAway}
              </div>
            )}
            <div className="mt-1"><StatusLabel match={match} /></div>
          </div>

          <Side flag={match.awayFlag} name={match.away} align="left" />

          <div className="flex items-center gap-2">
            <span className="hidden text-xs text-muted-foreground md:inline">{match.venue}</span>
            {expandable && (
              <ChevronDown
                className={`h-4 w-4 text-muted-foreground transition-transform ${open ? "rotate-180" : ""}`}
              />
            )}
          </div>
        </div>

        {expandable && open && match.events && (
          <div className="border-t border-border/40 px-4 py-4 sm:px-6">
            <div className="mb-3 flex items-center justify-between">
              <h3 className="text-sm font-bold">Match Events</h3>
              {match.status === "live" && (
                <span className="font-mono text-xs font-bold uppercase tracking-wider text-up">Updating live</span>
              )}
            </div>
            <ul className="space-y-2">
              {match.events.map((e) => (
                <li key={e.id} className="flex items-center gap-3 rounded-md border border-border/40 bg-surface-2/40 px-3 py-2">
                  <span className="text-xl">{e.icon}</span>
                  <span className="font-mono text-xs text-muted-foreground w-10">{e.minute}</span>
                  <span className="text-sm">{e.text}</span>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    </li>
  );
}

function Side({ flag, name, align }: { flag: string; name: string; align: "left" | "right" }) {
  return (
    <div className={`flex items-center gap-2 sm:gap-3 ${align === "right" ? "justify-end" : "justify-start"}`}>
      {align === "left" && <span className="text-2xl sm:text-3xl">{flag}</span>}
      <div className={`text-sm font-bold sm:text-base ${align === "right" ? "text-right" : ""}`}>{name}</div>
      {align === "right" && <span className="text-2xl sm:text-3xl">{flag}</span>}
    </div>
  );
}
