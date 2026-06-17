import { Flame } from "lucide-react";
import type { Player } from "@/lib/mockData";
import { Sparkline } from "./TrendBadge";

export function TopPerformer({ p }: { p: Player }) {
  return (
    <div className="relative overflow-hidden rounded-2xl border border-border/70 bg-surface/50 p-6 shadow-[var(--shadow-card)]">
      <div className="bg-grid absolute inset-0 opacity-30" />
      <div
        className="absolute -right-20 -top-20 h-64 w-64 rounded-full opacity-30 blur-3xl"
        style={{ background: "radial-gradient(circle, var(--fire), transparent 60%)" }}
      />
      <div className="relative grid items-center gap-6 sm:grid-cols-[auto_1fr_auto]">
        <div className="flex items-center gap-4">
          <div className="grid h-20 w-20 place-items-center rounded-2xl bg-gradient-to-br from-primary/30 to-up/20 text-4xl ring-1 ring-white/10">
            {p.flag}
          </div>
        </div>
        <div>
          <div className="mb-1 flex items-center gap-2">
            <span className="rounded-md bg-fire/15 px-2 py-0.5 text-[11px] font-bold uppercase tracking-wider text-fire">
              <Flame className="mr-1 inline h-3 w-3" /> On Fire
            </span>
            <span className="text-xs text-muted-foreground">Current #1 • Top Performer</span>
          </div>
          <h3 className="text-2xl font-bold sm:text-3xl">{p.name}</h3>
          <p className="text-sm text-muted-foreground">
            {p.team} • {p.position} • {p.goals} goals, {p.assists} assists in {p.matches} matches
          </p>
        </div>
        <div className="text-right">
          <div className="text-[11px] uppercase tracking-wider text-muted-foreground">Impact Score</div>
          <div className="font-mono text-5xl font-extrabold tabular text-up">{p.score.toFixed(1)}</div>
          <div className="mt-1 flex justify-end">
            <Sparkline data={p.momentum} />
          </div>
        </div>
      </div>
    </div>
  );
}
