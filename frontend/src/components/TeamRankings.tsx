import { useEffect, useMemo, useState } from "react";
import { type TeamRank } from "@/lib/mockData";
import { ChevronUp, ChevronDown, Minus } from "lucide-react";

type SortKey = "rank" | "rating" | "points" | "gd";
const sorts: { key: SortKey; label: string }[] = [
  { key: "rank", label: "Power Rank" },
  { key: "rating", label: "Rating" },
  { key: "points", label: "Points" },
  { key: "gd", label: "Goal Diff" },
];

export function TeamRankings() {
  const [sort, setSort] = useState<SortKey>("rank");
  const [group, setGroup] = useState<string>("All");
  const [teamRankings, setTeamRankings] = useState<TeamRank[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [size, setSize] = useState(5);
  const [total, setTotal] = useState(0);

useEffect(() => {
  setLoading(true);

  fetch(`http://127.0.0.1:5000/api/team-stats?page=${page}&size=${size}`)
    .then((res) => res.json())
    .then((data) => {
      setTeamRankings(Array.isArray(data) ? data : data.teams || []);
      setTotal(data.total || 0);
      setLoading(false);
    })
    .catch((err) => {
      console.error("Failed to fetch team rankings", err);
      setLoading(false);
    });
}, [page]);

  const totalPages = Math.ceil(total / size);

  const groups = useMemo(() => ["All", ...Array.from(new Set(teamRankings.map((t) => t.group))).sort()], [teamRankings]);

  const list = useMemo(() => {
    let arr: TeamRank[] = [...teamRankings];
    if (group !== "All") arr = arr.filter((t) => t.group === group);
    arr.sort((a, b) => {
      if (sort === "rank") return a.rank - b.rank;
      if (sort === "rating") return b.rating - a.rating;
      if (sort === "points") return b.points - a.points || b.gd - a.gd;
      return b.gd - a.gd;
    });
    return arr;
  }, [teamRankings, sort, group]);

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
          <h2 className="text-xl font-bold sm:text-2xl">National Team Rankings</h2>
          <p className="text-sm text-muted-foreground">Live tournament power ratings · Updated after every match</p>
        </div>
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          <span className="inline-block h-1.5 w-1.5 rounded-full bg-up pulse-dot" />
          {teamRankings.length} teams tracked
        </div>
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
      </div>

      <div className="flex flex-wrap gap-2 border-b border-border/60 p-4">
        {groups.map((g) => (
          <button
            key={g}
            onClick={() => setGroup(g)}
            className={`rounded-full border px-3 py-1 text-xs font-medium transition-colors ${
              group === g
                ? "border-primary/50 bg-primary/15 text-primary"
                : "border-border/70 bg-surface/60 text-muted-foreground hover:text-foreground"
            }`}
          >
            {g === "All" ? "All Groups" : `Group ${g}`}
          </button>
        ))}
        <div className="ml-auto flex items-center gap-2 text-xs">
          <span className="text-muted-foreground">Sort by</span>
          <select
            value={sort}
            onChange={(e) => setSort(e.target.value as SortKey)}
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

      {/* Desktop table */}
      <div className="hidden md:block">
        <div className="grid grid-cols-[60px_2fr_70px_90px_60px_60px_60px_70px_120px] items-center gap-2 px-5 py-3 text-[11px] uppercase tracking-wider text-muted-foreground">
          <div>Rank</div>
          <div>Team</div>
          <div>Group</div>
          <div>Rating</div>
          <div className="text-right">P</div>
          <div className="text-right">Pts</div>
          <div className="text-right">GD</div>
          <div className="text-center">Move</div>
          <div>Form</div>
        </div>
        <div className="divide-y divide-border/40">
          {list.map((t) => (
            <div
              key={t.team}
              className="row-hover grid grid-cols-[60px_2fr_70px_90px_60px_60px_60px_70px_120px] items-center gap-2 px-5 py-3"
            >
              <div><RankBadge rank={t.rank} /></div>
              <div className="flex items-center gap-3">
                <span className="text-2xl">{t.flag}</span>
                <div>
                  <div className="font-semibold">{t.team}</div>
                  <div className="text-xs text-muted-foreground">
                    {t.wins}W · {t.draws}D · {t.losses}L
                  </div>
                </div>
              </div>
              <div className="text-xs text-muted-foreground">Group {t.group}</div>
              <div className="font-mono text-lg font-bold tabular">{t.rating.toFixed(1)}</div>
              <div className="text-right font-mono tabular">{t.played}</div>
              <div className="text-right font-mono font-bold tabular">{t.points}</div>
              <div className={`text-right font-mono tabular ${t.gd > 0 ? "text-up" : t.gd < 0 ? "text-down" : "text-muted-foreground"}`}>
                {t.gd > 0 ? "+" : ""}{t.gd}
              </div>
              <div className="flex justify-center"><MoveBadge rank={t.rank} prev={t.prevRank} /></div>
              <div className="flex items-center gap-1">
                {t.form.map((f, i) => <FormDot key={i} r={f} />)}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Mobile cards */}
      <div className="space-y-2 p-3 md:hidden">
        {list.map((t) => (
          <div key={t.team} className="card-hover flex items-center gap-3 rounded-xl border border-border/60 bg-surface-2/50 p-3">
            <RankBadge rank={t.rank} />
            <div className="text-2xl">{t.flag}</div>
            <div className="min-w-0 flex-1">
              <div className="flex items-center gap-2">
                <span className="truncate font-semibold">{t.team}</span>
                <MoveBadge rank={t.rank} prev={t.prevRank} />
              </div>
              <div className="text-xs text-muted-foreground">Group {t.group} · {t.wins}W {t.draws}D {t.losses}L · GD {t.gd > 0 ? "+" : ""}{t.gd}</div>
              <div className="mt-1 flex items-center gap-1">
                {t.form.map((f, i) => <FormDot key={i} r={f} />)}
              </div>
            </div>
            <div className="text-right">
              <div className="font-mono text-xl font-bold tabular">{t.rating.toFixed(1)}</div>
              <div className="text-[11px] text-muted-foreground">{t.points} pts</div>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}

function RankBadge({ rank }: { rank: number }) {
  const top = rank <= 3;
  return (
    <div
      className={`grid h-8 w-8 place-items-center rounded-md font-mono text-sm font-bold ${
        top
          ? "text-background shadow-[0_0_18px_-2px_color-mix(in_oklab,var(--gold)_70%,transparent)]"
          : "bg-surface-2 text-muted-foreground"
      }`}
      style={top ? { background: "var(--gradient-gold)" } : undefined}
    >
      {rank}
    </div>
  );
}

function MoveBadge({ rank, prev }: { rank: number; prev: number }) {
  const diff = prev - rank;
  if (diff > 0) {
    return (
      <span className="inline-flex items-center gap-0.5 rounded-md bg-up/15 px-1.5 py-0.5 font-mono text-xs font-semibold text-up">
        <ChevronUp className="h-3 w-3" />{diff}
      </span>
    );
  }
  if (diff < 0) {
    return (
      <span className="inline-flex items-center gap-0.5 rounded-md bg-down/15 px-1.5 py-0.5 font-mono text-xs font-semibold text-down">
        <ChevronDown className="h-3 w-3" />{Math.abs(diff)}
      </span>
    );
  }
  return (
    <span className="inline-flex items-center rounded-md bg-surface-2 px-1.5 py-0.5 text-muted-foreground">
      <Minus className="h-3 w-3" />
    </span>
  );
}

function FormDot({ r }: { r: "W" | "D" | "L" }) {
  const cls = r === "W" ? "bg-up/20 text-up" : r === "L" ? "bg-down/20 text-down" : "bg-surface-2 text-muted-foreground";
  return (
    <span className={`grid h-5 w-5 place-items-center rounded text-[10px] font-bold ${cls}`}>{r}</span>
  );
}
