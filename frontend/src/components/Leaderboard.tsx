import { Link } from "react-router-dom";
import { useEffect, useMemo, useState } from "react";
import { type Player } from "@/lib/mockData";
import { Sparkline, TrendBadge } from "./TrendBadge";

const filters = ["All Players", "Attackers", "Midfielders", "Defenders", "Goalkeepers", "Min 2 Matches"] as const;
type Filter = (typeof filters)[number];

const sorts = [
  { key: "score", label: "Impact Score" },
  { key: "goals", label: "Goals" },
  { key: "assists", label: "Assists" },
  { key: "trend", label: "Trend" },
] as const;

export function Leaderboard() {
  const [filter, setFilter] = useState<Filter>("All Players");
  const [sort, setSort] = useState<(typeof sorts)[number]["key"]>("score");

  const [players, setPlayers] = useState<Player[]>([]);
  const [loading, setLoading] = useState(true);

  const [page, setPage] = useState(1);
  const size = 10;
  const [total, setTotal] = useState(0);

  useEffect(() => {
    setLoading(true);

    fetch(`http://153.75.244.15:5001/api/player-stats?page=${page}&size=${size}`)
      .then((res) => res.json())
      .then((data) => {
        setPlayers(Array.isArray(data) ? data : data.players || []);
        setTotal(data.total ?? 0);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Failed to fetch players", err);
        setLoading(false);
      });
  }, [page]);

  const list = useMemo(() => {
    let arr: Player[] = [...players];

    if (filter === "Attackers") arr = arr.filter((p) => p.position === "FW");
    if (filter === "Midfielders") arr = arr.filter((p) => p.position === "MF");
    if (filter === "Defenders") arr = arr.filter((p) => p.position === "DF");
    if (filter === "Goalkeepers") arr = arr.filter((p) => p.position === "GK");
    if (filter === "Min 2 Matches") arr = arr.filter((p) => p.matches >= 2);

    arr.sort((a, b) => {
      if (sort === "score") return b.score - a.score;
      if (sort === "goals") return b.goals - a.goals;
      if (sort === "assists") return b.assists - a.assists;
      return parseInt(b.trendValue) - parseInt(a.trendValue);
    });

    return arr;
  }, [players, filter, sort]);

  const totalPages = Math.ceil(total / size);

  if (loading) {
    return (
      <div className="flex h-64 items-center justify-center">
        <div className="h-8 w-8 animate-spin rounded-full border-4 border-primary border-t-transparent"></div>
      </div>
    );
  }


  return (
    <section className="rounded-2xl border border-border/70 bg-surface/40">
      <div className="flex flex-col gap-4 border-b border-border/60 p-5 lg:flex-row lg:items-end lg:justify-between">
        <div>
          <h2 className="text-xl font-bold sm:text-2xl">World Cup Impact Rankings</h2>
          <p className="text-sm text-muted-foreground">Live player rankings updated in real-time</p>
        </div>
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          <span className="inline-block h-1.5 w-1.5 rounded-full bg-up pulse-dot" />
          Last updated: 12 seconds ago
        </div>
      </div>

      <div className="flex flex-wrap gap-2 border-b border-border/60 p-4">
        {filters.map((f) => (
          <button
            key={f}
            onClick={() => setFilter(f)}
            className={`rounded-full border px-3 py-1 text-xs font-medium transition-colors ${filter === f
                ? "border-primary/50 bg-primary/15 text-primary"
                : "border-border/70 bg-surface/60 text-muted-foreground hover:text-foreground"
              }`}
          >
            {f}
          </button>
        ))}
        <div className="ml-auto flex items-center gap-2 text-xs">
          <span className="text-muted-foreground">Sort by</span>
          <select
            value={sort}
            onChange={(e) => setSort(e.target.value as typeof sort)}
            className="rounded-md border border-border/70 bg-surface/60 px-2 py-1 text-foreground outline-none"
          >
            {sorts.map((s) => (
              <option key={s.key} value={s.key} className="bg-background">
                {s.label}
              </option>
            ))}
          </select>
        </div>
      </div>

      {/* PAGINATION CONTROLS */}
      <div className="flex items-center justify-center gap-4 p-4 border-b border-border/60">
        <button
          onClick={() => setPage((p) => Math.max(p - 1, 1))}
          disabled={page === 1}
          className="rounded-md bg-muted px-3 py-1 text-sm disabled:opacity-50"
        >
          Prev
        </button>

        <div className="text-sm text-muted-foreground">
          Page {page} {totalPages ? `of ${totalPages}` : ""}
        </div>

        <button
          onClick={() => setPage((p) => p + 1)}
          disabled={totalPages ? page >= totalPages : false}
          className="rounded-md bg-muted px-3 py-1 text-sm disabled:opacity-50"
        >
          Next
        </button>
      </div>


      {/* Desktop table */}
      <div className="hidden md:block">
        <div className="grid grid-cols-[60px_2fr_1.2fr_70px_120px_120px_70px_70px_70px] items-center gap-2 px-5 py-3 text-[11px] uppercase tracking-wider text-muted-foreground">
          <div>Rank</div>
          <div>Player</div>
          <div>Team</div>
          <div>Pos</div>
          <div>Impact</div>
          <div>Trend</div>
          <div className="text-right">G</div>
          <div className="text-right">A</div>
          <div className="text-right max-lg:hidden">C</div>
        </div>
        <div className="divide-y divide-border/40">
          {list.map((p, i) => (
            <Link
              key={p.id}
              to={`/players/${p.id}`}
              className={`row-hover grid grid-cols-[60px_2fr_1.2fr_70px_120px_120px_70px_70px_70px] items-center gap-2 px-5 py-3 ${i === 0 ? "flash-up" : ""
                }`}
            >
              <div>
                <RankBadge rank={p.rank} />
              </div>
              <div className="flex items-center gap-3">
                <div className="grid h-9 w-9 place-items-center rounded-full bg-surface-2 text-lg">{p.flag}</div>
                <div>
                  <div className="font-semibold">{p.name}</div>
                  <div className="text-xs text-muted-foreground">#{p.rank} • {p.position}</div>
                </div>
              </div>
              <div className="text-sm text-muted-foreground">{p.team}</div>
              <div className="text-xs text-muted-foreground">{p.position}</div>
              <div className="flex items-center gap-2">
                <span className="font-mono text-xl font-bold tabular">{p.score.toFixed(1)}</span>
                <Sparkline data={p.momentum} color={p.trend === "down" || p.trend === "cool" ? "var(--down)" : "var(--up)"} />
              </div>
              <div><TrendBadge trend={p.trend} value={p.trendValue} /></div>
              <div className="text-right font-mono tabular">{p.goals}</div>
              <div className="text-right font-mono tabular">{p.assists}</div>
              <div className="text-right font-mono tabular max-lg:hidden">{p.cards}</div>
            </Link>
          ))}
        </div>
      </div>

      {/* Mobile cards */}
      <div className="space-y-2 p-3 md:hidden">
        {list.map((p) => (
          <Link
            key={p.id}
            to={`/players/${p.id}`}
            className="card-hover flex items-center gap-3 rounded-xl border border-border/60 bg-surface-2/50 p-3"
          >
            <RankBadge rank={p.rank} />
            <div className="text-2xl">{p.flag}</div>
            <div className="min-w-0 flex-1">
              <div className="truncate font-semibold">{p.name}</div>
              <div className="text-xs text-muted-foreground">{p.team} • {p.position}</div>
              <div className="mt-1 flex items-center gap-3 text-[11px] text-muted-foreground">
                <span>G {p.goals}</span><span>A {p.assists}</span><span>C {p.cards}</span>
              </div>
            </div>
            <div className="text-right">
              <div className="font-mono text-xl font-bold tabular">{p.score.toFixed(1)}</div>
              <div className="mt-1"><TrendBadge trend={p.trend} value={p.trendValue} /></div>
            </div>
          </Link>
        ))}
      </div>
    </section>
  );
}

function RankBadge({ rank }: { rank: number }) {
  const top = rank <= 3;
  return (
    <div
      className={`grid h-8 w-8 place-items-center rounded-md font-mono text-sm font-bold ${top
          ? "text-background shadow-[0_0_18px_-2px_color-mix(in_oklab,var(--gold)_70%,transparent)]"
          : "bg-surface-2 text-muted-foreground"
        }`}
      style={top ? { background: "var(--gradient-gold)" } : undefined}
    >
      {rank}
    </div>
  );
}
