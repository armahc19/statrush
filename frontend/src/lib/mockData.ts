export type Trend = "up" | "down" | "same" | "fire" | "cool";

export type Player = {
  rank: number;
  id: string;
  name: string;
  team: string;
  flag: string;
  position: "FW" | "MF" | "DF" | "GK";
  score: number;
  trend: Trend;
  trendValue: string;
  goals: number;
  assists: number;
  cards: number;
  minutes: number;
  matches: number;
  yellow: number;
  red: number;
  momentum: number[]; // last N impact scores
};

export const players: Player[] = [
  { rank: 1, id: "mbappe", name: "Kylian Mbappé", team: "France", flag: "🇫🇷", position: "FW", score: 9.2, trend: "fire", trendValue: "+1", goals: 5, assists: 2, cards: 0, minutes: 360, matches: 4, yellow: 0, red: 0, momentum: [7.8, 8.4, 8.9, 9.0, 9.2] },
  { rank: 2, id: "messi", name: "Lionel Messi", team: "Argentina", flag: "🇦🇷", position: "FW", score: 9.1, trend: "down", trendValue: "-1", goals: 4, assists: 3, cards: 0, minutes: 358, matches: 4, yellow: 0, red: 0, momentum: [9.4, 9.3, 9.2, 9.2, 9.1] },
  { rank: 3, id: "bellingham", name: "Jude Bellingham", team: "England", flag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", position: "MF", score: 8.7, trend: "up", trendValue: "+3", goals: 2, assists: 4, cards: 1, minutes: 360, matches: 4, yellow: 1, red: 0, momentum: [7.9, 8.0, 8.3, 8.5, 8.7] },
  { rank: 4, id: "vinicius", name: "Vinicius Jr", team: "Brazil", flag: "🇧🇷", position: "FW", score: 8.5, trend: "same", trendValue: "0", goals: 3, assists: 1, cards: 1, minutes: 340, matches: 4, yellow: 1, red: 0, momentum: [8.5, 8.4, 8.6, 8.5, 8.5] },
  { rank: 5, id: "rodri", name: "Rodri", team: "Spain", flag: "🇪🇸", position: "MF", score: 8.4, trend: "fire", trendValue: "+5", goals: 1, assists: 2, cards: 0, minutes: 360, matches: 4, yellow: 0, red: 0, momentum: [7.0, 7.4, 7.9, 8.2, 8.4] },
  { rank: 6, id: "kane", name: "Harry Kane", team: "England", flag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", position: "FW", score: 8.2, trend: "cool", trendValue: "-2", goals: 3, assists: 0, cards: 0, minutes: 360, matches: 4, yellow: 0, red: 0, momentum: [8.6, 8.5, 8.4, 8.3, 8.2] },
  { rank: 7, id: "musiala", name: "Jamal Musiala", team: "Germany", flag: "🇩🇪", position: "MF", score: 8.1, trend: "up", trendValue: "+2", goals: 1, assists: 3, cards: 0, minutes: 320, matches: 4, yellow: 0, red: 0, momentum: [7.6, 7.8, 7.9, 8.0, 8.1] },
  { rank: 8, id: "valverde", name: "Federico Valverde", team: "Uruguay", flag: "🇺🇾", position: "MF", score: 7.9, trend: "up", trendValue: "+4", goals: 1, assists: 1, cards: 1, minutes: 360, matches: 4, yellow: 1, red: 0, momentum: [7.2, 7.3, 7.5, 7.7, 7.9] },
  { rank: 9, id: "dias", name: "Ruben Dias", team: "Portugal", flag: "🇵🇹", position: "DF", score: 7.8, trend: "down", trendValue: "-1", goals: 0, assists: 0, cards: 1, minutes: 360, matches: 4, yellow: 1, red: 0, momentum: [8.0, 7.9, 7.9, 7.8, 7.8] },
  { rank: 10, id: "alisson", name: "Alisson Becker", team: "Brazil", flag: "🇧🇷", position: "GK", score: 7.7, trend: "same", trendValue: "0", goals: 0, assists: 0, cards: 0, minutes: 360, matches: 4, yellow: 0, red: 0, momentum: [7.7, 7.6, 7.8, 7.7, 7.7] },
];

export const risers = [
  { name: "Mbappé", value: "+8" },
  { name: "Bellingham", value: "+6" },
  { name: "Musiala", value: "+4" },
];
export const fallers = [
  { name: "Haaland", value: "-4" },
  { name: "Dias", value: "-3" },
  { name: "Kane", value: "-2" },
];

export const liveEvents = [
  { id: 1, minute: "67'", type: "goal", text: "Mbappé scores for France", icon: "⚽" },
  { id: 2, minute: "61'", type: "yellow", text: "Otamendi booked", icon: "🟨" },
  { id: 3, minute: "52'", type: "assist", text: "Griezmann assist", icon: "🎯" },
  { id: 4, minute: "44'", type: "goal", text: "Messi equalises", icon: "⚽" },
  { id: 5, minute: "23'", type: "sub", text: "Substitution — Argentina", icon: "🔄" },
];

export const upcomingFixtures = [
  { home: "Spain", away: "Germany", date: "Jun 18", time: "20:00", venue: "MetLife Stadium" },
  { home: "Brazil", away: "Portugal", date: "Jun 19", time: "17:00", venue: "SoFi Stadium" },
  { home: "England", away: "Netherlands", date: "Jun 20", time: "21:00", venue: "AT&T Stadium" },
  { home: "Argentina", away: "Uruguay", date: "Jun 21", time: "18:30", venue: "Mercedes-Benz" },
];

export const groups = [
  {
    name: "Group A",
    rows: [
      { team: "France 🇫🇷", p: 3, w: 3, d: 0, l: 0, gd: "+6", pts: 9 },
      { team: "Argentina 🇦🇷", p: 3, w: 2, d: 0, l: 1, gd: "+3", pts: 6 },
      { team: "Mexico 🇲🇽", p: 3, w: 1, d: 0, l: 2, gd: "-2", pts: 3 },
      { team: "Canada 🇨🇦", p: 3, w: 0, d: 0, l: 3, gd: "-7", pts: 0 },
    ],
  },
  {
    name: "Group B",
    rows: [
      { team: "Brazil 🇧🇷", p: 3, w: 2, d: 1, l: 0, gd: "+4", pts: 7 },
      { team: "Spain 🇪🇸", p: 3, w: 2, d: 0, l: 1, gd: "+2", pts: 6 },
      { team: "Japan 🇯🇵", p: 3, w: 1, d: 1, l: 1, gd: "0", pts: 4 },
      { team: "Morocco 🇲🇦", p: 3, w: 0, d: 0, l: 3, gd: "-6", pts: 0 },
    ],
  },
  {
    name: "Group C",
    rows: [
      { team: "England 🏴", p: 3, w: 3, d: 0, l: 0, gd: "+5", pts: 9 },
      { team: "Germany 🇩🇪", p: 3, w: 1, d: 1, l: 1, gd: "+1", pts: 4 },
      { team: "Portugal 🇵🇹", p: 3, w: 1, d: 1, l: 1, gd: "0", pts: 4 },
      { team: "USA 🇺🇸", p: 3, w: 0, d: 0, l: 3, gd: "-6", pts: 0 },
    ],
  },
];

export type TeamRank = {
  rank: number;
  prevRank: number;
  team: string;
  flag: string;
  group: string;
  played: number;
  wins: number;
  draws: number;
  losses: number;
  gf: number;
  ga: number;
  gd: number;
  points: number;
  rating: number; // Tournament power rating 0-100
  trend: Trend;
  form: ("W" | "D" | "L")[]; // most recent first
};

export const teamRankings: TeamRank[] = [
  { rank: 1, prevRank: 2, team: "France", flag: "🇫🇷", group: "A", played: 3, wins: 3, draws: 0, losses: 0, gf: 8, ga: 2, gd: 6, points: 9, rating: 94.2, trend: "fire", form: ["W", "W", "W"] },
  { rank: 2, prevRank: 1, team: "England", flag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", group: "C", played: 3, wins: 3, draws: 0, losses: 0, gf: 7, ga: 2, gd: 5, points: 9, rating: 92.8, trend: "up", form: ["W", "W", "W"] },
  { rank: 3, prevRank: 4, team: "Brazil", flag: "🇧🇷", group: "B", played: 3, wins: 2, draws: 1, losses: 0, gf: 6, ga: 2, gd: 4, points: 7, rating: 90.5, trend: "up", form: ["W", "D", "W"] },
  { rank: 4, prevRank: 3, team: "Argentina", flag: "🇦🇷", group: "A", played: 3, wins: 2, draws: 0, losses: 1, gf: 6, ga: 3, gd: 3, points: 6, rating: 89.4, trend: "down", form: ["L", "W", "W"] },
  { rank: 5, prevRank: 6, team: "Spain", flag: "🇪🇸", group: "B", played: 3, wins: 2, draws: 0, losses: 1, gf: 5, ga: 3, gd: 2, points: 6, rating: 88.1, trend: "up", form: ["W", "L", "W"] },
  { rank: 6, prevRank: 5, team: "Germany", flag: "🇩🇪", group: "C", played: 3, wins: 1, draws: 1, losses: 1, gf: 4, ga: 3, gd: 1, points: 4, rating: 84.7, trend: "down", form: ["D", "L", "W"] },
  { rank: 7, prevRank: 7, team: "Portugal", flag: "🇵🇹", group: "C", played: 3, wins: 1, draws: 1, losses: 1, gf: 4, ga: 4, gd: 0, points: 4, rating: 83.9, trend: "same", form: ["W", "D", "L"] },
  { rank: 8, prevRank: 10, team: "Netherlands", flag: "🇳🇱", group: "D", played: 3, wins: 1, draws: 2, losses: 0, gf: 5, ga: 3, gd: 2, points: 5, rating: 82.6, trend: "fire", form: ["D", "W", "D"] },
  { rank: 9, prevRank: 8, team: "Japan", flag: "🇯🇵", group: "B", played: 3, wins: 1, draws: 1, losses: 1, gf: 3, ga: 3, gd: 0, points: 4, rating: 80.3, trend: "same", form: ["D", "W", "L"] },
  { rank: 10, prevRank: 9, team: "Uruguay", flag: "🇺🇾", group: "D", played: 3, wins: 1, draws: 1, losses: 1, gf: 4, ga: 4, gd: 0, points: 4, rating: 79.8, trend: "down", form: ["L", "D", "W"] },
  { rank: 11, prevRank: 12, team: "Italy", flag: "🇮🇹", group: "E", played: 3, wins: 1, draws: 1, losses: 1, gf: 3, ga: 3, gd: 0, points: 4, rating: 78.4, trend: "up", form: ["W", "L", "D"] },
  { rank: 12, prevRank: 11, team: "Belgium", flag: "🇧🇪", group: "E", played: 3, wins: 1, draws: 0, losses: 2, gf: 3, ga: 4, gd: -1, points: 3, rating: 76.2, trend: "down", form: ["L", "W", "L"] },
  { rank: 13, prevRank: 13, team: "Croatia", flag: "🇭🇷", group: "F", played: 3, wins: 1, draws: 0, losses: 2, gf: 2, ga: 4, gd: -2, points: 3, rating: 74.5, trend: "same", form: ["L", "L", "W"] },
  { rank: 14, prevRank: 15, team: "Mexico", flag: "🇲🇽", group: "A", played: 3, wins: 1, draws: 0, losses: 2, gf: 3, ga: 5, gd: -2, points: 3, rating: 72.1, trend: "up", form: ["L", "W", "L"] },
  { rank: 15, prevRank: 14, team: "Morocco", flag: "🇲🇦", group: "B", played: 3, wins: 0, draws: 0, losses: 3, gf: 1, ga: 7, gd: -6, points: 0, rating: 68.9, trend: "down", form: ["L", "L", "L"] },
  { rank: 16, prevRank: 16, team: "USA", flag: "🇺🇸", group: "C", played: 3, wins: 0, draws: 0, losses: 3, gf: 2, ga: 8, gd: -6, points: 0, rating: 66.4, trend: "same", form: ["L", "L", "L"] },
];
