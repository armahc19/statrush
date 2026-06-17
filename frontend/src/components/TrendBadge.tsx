import type { Trend } from "@/lib/mockData";
import { Flame, Snowflake, TrendingDown, TrendingUp, Minus } from "lucide-react";

export function TrendBadge({ trend, value }: { trend: Trend; value: string }) {
  if (trend === "fire") {
    return (
      <span className="inline-flex items-center gap-1 rounded-md bg-fire/15 px-2 py-0.5 text-xs font-semibold text-fire">
        <Flame className="h-3 w-3" /> On Fire
      </span>
    );
  }
  if (trend === "cool") {
    return (
      <span className="inline-flex items-center gap-1 rounded-md bg-cool/15 px-2 py-0.5 text-xs font-semibold text-cool">
        <Snowflake className="h-3 w-3" /> Cooling
      </span>
    );
  }
  if (trend === "up") {
    return (
      <span className="inline-flex items-center gap-1 font-mono text-sm font-semibold text-up">
        <TrendingUp className="h-3.5 w-3.5" /> {value}
      </span>
    );
  }
  if (trend === "down") {
    return (
      <span className="inline-flex items-center gap-1 font-mono text-sm font-semibold text-down">
        <TrendingDown className="h-3.5 w-3.5" /> {value}
      </span>
    );
  }
  return (
    <span className="inline-flex items-center gap-1 font-mono text-sm text-muted-foreground">
      <Minus className="h-3.5 w-3.5" /> 0
    </span>
  );
}

export function Sparkline({ data, color = "var(--up)" }: { data: number[]; color?: string }) {
  const w = 64;
  const h = 20;
  const min = Math.min(...data);
  const max = Math.max(...data);
  const range = max - min || 1;
  const points = data
    .map((d, i) => {
      const x = (i / (data.length - 1)) * w;
      const y = h - ((d - min) / range) * h;
      return `${x.toFixed(1)},${y.toFixed(1)}`;
    })
    .join(" ");
  return (
    <svg width={w} height={h} className="overflow-visible">
      <polyline fill="none" stroke={color} strokeWidth="1.6" points={points} strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}
