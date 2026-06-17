import { ArrowDownRight, ArrowUpRight } from "lucide-react";
import { fallers, risers } from "@/lib/mockData";

export function MarketMovers() {
  return (
    <aside className="rounded-2xl border border-border/70 bg-surface/40 p-5">
      <div className="mb-4 flex items-center justify-between">
        <h3 className="font-bold">Market Movers</h3>
        <span className="text-[10px] uppercase tracking-wider text-muted-foreground">Today</span>
      </div>

      <div className="mb-3 text-xs font-semibold uppercase tracking-wider text-up">Top Risers</div>
      <ul className="mb-5 space-y-1">
        {risers.map((r) => (
          <li key={r.name} className="card-hover flex items-center justify-between rounded-md border border-border/40 bg-surface-2/40 px-3 py-2">
            <span className="text-sm">{r.name}</span>
            <span className="inline-flex items-center gap-1 font-mono text-sm font-semibold text-up">
              <ArrowUpRight className="h-3.5 w-3.5" /> {r.value}
            </span>
          </li>
        ))}
      </ul>

      <div className="mb-3 text-xs font-semibold uppercase tracking-wider text-down">Top Fallers</div>
      <ul className="space-y-1">
        {fallers.map((r) => (
          <li key={r.name} className="card-hover flex items-center justify-between rounded-md border border-border/40 bg-surface-2/40 px-3 py-2">
            <span className="text-sm">{r.name}</span>
            <span className="inline-flex items-center gap-1 font-mono text-sm font-semibold text-down">
              <ArrowDownRight className="h-3.5 w-3.5" /> {r.value}
            </span>
          </li>
        ))}
      </ul>
    </aside>
  );
}
