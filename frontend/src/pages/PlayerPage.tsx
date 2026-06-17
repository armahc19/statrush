import { Link, useParams } from "react-router-dom";
import { useState, useEffect } from "react";
import { SiteHeader, MobileTabBar } from "@/components/SiteHeader";

import type { Trend } from "@/lib/mockData";

//import type { Player} from "@/lib/mockData";

// Remove custom Player interface definition
interface Player {
  id: string;
  flag: string;
  rank: number;
  position: string;
  name: string;
  team: string;
  score: number;
  momentum: number[];
  trend: Trend;
  trendValue: string;
  goals: number;
  assists: number;
  minutes: number;
  matches: number;
  yellow: number;
  red: number;
}
import { SiteFooter } from "@/components/SiteFooter";
import { Sparkline, TrendBadge } from "@/components/TrendBadge";
// Player data will be fetched from backend API
import { ArrowLeft, TrendingUp } from "lucide-react";

export default function PlayerPage() {
  const { id } = useParams<{ id: string }>();
  const [player, setPlayer] = useState<Player | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetch(`/api/player-stats`)
      .then((res) => res.json())
      .then((data: Player[]) => {
        const p = data.find((pl) => pl.id === id);
        if (!p) {
          setError('Player not found');
        } else {
          setPlayer(p);
        }
        setLoading(false);
      })
      .catch((err) => {
        console.error(err);
        setError('Failed to load player data');
        setLoading(false);
      });
  }, [id]);

  if (loading) {
    return (
      <div className="grid min-h-screen place-items-center bg-background text-foreground">
        Loading...
      </div>
    );
  }

  if (error) {
    return (
      <div className="grid min-h-screen place-items-center bg-background text-foreground">
        {error}
      </div>
    );
  }

  if (!player) {
    return (
      <div className="grid min-h-screen place-items-center bg-background text-foreground">
        Player data unavailable
      </div>
    );
  }

  const p = player;
const w = 720;
  const h = 240;
  const pad = 24;
  const min = 0;
  const max = 10;
  const pts = p.momentum.map((v: number, i: number) => {
    const x = pad + (i / (p.momentum.length - 1)) * (w - pad * 2);
    const y = h - pad - ((v - min) / (max - min)) * (h - pad * 2);
    return { x, y, v };
  });
  const linePath = pts.map((pt, i) => `${i === 0 ? "M" : "L"}${pt.x},${pt.y}`).join(" ");
  const areaPath = `${linePath} L${pts[pts.length - 1].x},${h - pad} L${pts[0].x},${h - pad} Z`;

  const timeline = [
    { match: "vs Argentina", events: [
      { icon: "⚽", min: "67'", text: "Goal" },
      { icon: "🎯", min: "52'", text: "Assist" },
      { icon: "🟨", min: "81'", text: "Yellow Card" },
    ]},
    { match: "vs Spain", events: [
      { icon: "⚽", min: "34'", text: "Goal" },
      { icon: "⚽", min: "71'", text: "Goal" },
    ]},
    { match: "vs Brazil", events: [
      { icon: "🎯", min: "12'", text: "Assist" },
    ]},
  ];

  return (
    <div className="min-h-screen pb-24 md:pb-12">
      <SiteHeader />
      <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6">
        <Link to="/rankings" className="mb-6 inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
          <ArrowLeft className="h-4 w-4" /> Back to rankings
        </Link>

        <section className="relative overflow-hidden rounded-2xl border border-border/70 bg-surface/50 p-6 sm:p-8">
          <div className="absolute inset-0" style={{ background: "var(--gradient-hero)" }} />
          <div className="bg-grid absolute inset-0 opacity-25" />
          <div className="relative grid items-center gap-6 md:grid-cols-[auto_1fr_auto]">
            <div className="grid h-28 w-28 place-items-center rounded-3xl bg-gradient-to-br from-primary/30 to-up/20 text-6xl ring-1 ring-white/10">
              {p.flag}
            </div>
            <div>
              <div className="text-xs uppercase tracking-wider text-muted-foreground">#{p.rank} • {p.position}</div>
              <h1 className="text-3xl font-extrabold sm:text-4xl">{p.name}</h1>
              <div className="mt-1 text-sm text-muted-foreground">{p.team}</div>
              <div className="mt-3 inline-flex items-center gap-2 rounded-md bg-up/15 px-2 py-1 text-xs font-semibold text-up">
                <TrendingUp className="h-3.5 w-3.5" /> +2 Positions this week
              </div>
            </div>
            <div className="text-right">
              <div className="text-[11px] uppercase tracking-wider text-muted-foreground">Impact Score</div>
              <div className="font-mono text-6xl font-extrabold tabular text-up sm:text-7xl">{p.score.toFixed(1)}</div>
              <div className="mt-2 flex justify-end"><Sparkline data={p.momentum} /></div>
            </div>
          </div>
        </section>

        <div className="mt-6 grid gap-6 lg:grid-cols-[1.4fr_1fr]">
          <section className="rounded-2xl border border-border/70 bg-surface/40 p-5">
            <div className="mb-4 flex items-center justify-between">
              <div>
                <h2 className="font-bold">Performance Graph</h2>
                <p className="text-xs text-muted-foreground">Impact Score across tournament matches</p>
              </div>
              <TrendBadge trend={p.trend} value={p.trendValue} />
            </div>
            <div className="overflow-x-auto">
              <svg viewBox={`0 0 ${w} ${h}`} className="w-full">
                <defs>
                  <linearGradient id="area" x1="0" x2="0" y1="0" y2="1">
                    <stop offset="0%" stopColor="var(--up)" stopOpacity="0.35" />
                    <stop offset="100%" stopColor="var(--up)" stopOpacity="0" />
                  </linearGradient>
                </defs>
                {[2, 4, 6, 8, 10].map((g) => {
                  const y = h - pad - ((g - min) / (max - min)) * (h - pad * 2);
                  return (
                    <g key={g}>
                      <line x1={pad} x2={w - pad} y1={y} y2={y} stroke="oklch(0.28 0.04 264)" strokeDasharray="3 4" />
                      <text x={4} y={y + 4} fill="var(--muted-foreground)" fontSize="10" fontFamily="JetBrains Mono">{g}</text>
                    </g>
                  );
                })}
                <path d={areaPath} fill="url(#area)" />
                <path d={linePath} fill="none" stroke="var(--up)" strokeWidth="2.4" strokeLinecap="round" />
                {pts.map((pt, i) => (
                  <g key={i}>
                    <circle cx={pt.x} cy={pt.y} r="4" fill="var(--background)" stroke="var(--up)" strokeWidth="2" />
                    <text x={pt.x} y={h - 6} fill="var(--muted-foreground)" fontSize="10" textAnchor="middle" fontFamily="JetBrains Mono">
                      M{i + 1}
                    </text>
                  </g>
                ))}
              </svg>
            </div>
          </section>

          <section className="grid grid-cols-2 gap-3">
            <StatCard label="Goals" value={p.goals} accent="up" />
            <StatCard label="Assists" value={p.assists} accent="cool" />
            <StatCard label="Minutes" value={p.minutes} />
            <StatCard label="Matches" value={p.matches} />
            <StatCard label="Yellow Cards" value={p.yellow} accent="fire" />
            <StatCard label="Red Cards" value={p.red} accent="down" />
          </section>
        </div>

        <section className="mt-6 rounded-2xl border border-border/70 bg-surface/40 p-5">
          <h2 className="mb-4 font-bold">Recent Match Timeline</h2>
          <div className="space-y-6">
            {timeline.map((m, i) => (
              <div key={i}>
                <div className="mb-2 text-xs font-semibold uppercase tracking-wider text-muted-foreground">{m.match}</div>
                <ul className="space-y-1">
                  {m.events.map((e, j) => (
                    <li key={j} className="ticker-in flex items-center gap-3 rounded-md border border-border/40 bg-surface-2/40 px-3 py-2">
                      <span className="text-lg">{e.icon}</span>
                      <span className="font-mono text-xs text-muted-foreground">{e.min}</span>
                      <span className="text-sm">{e.text}</span>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </section>
      </main>
      <SiteFooter />
      <MobileTabBar />
    </div>
  );
}

function StatCard({ label, value, accent }: { label: string; value: number; accent?: "up" | "down" | "fire" | "cool" }) {
  const color =
    accent === "up" ? "text-up"
    : accent === "down" ? "text-down"
    : accent === "fire" ? "text-fire"
    : accent === "cool" ? "text-cool"
    : "text-foreground";
  return (
    <div className="card-hover rounded-2xl border border-border/70 bg-surface/40 p-4">
      <div className="text-[11px] uppercase tracking-wider text-muted-foreground">{label}</div>
      <div className={`mt-1 font-mono text-3xl font-extrabold tabular ${color}`}>{value}</div>
    </div>
  );
}
