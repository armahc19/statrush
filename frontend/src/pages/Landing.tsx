import { Link } from "react-router-dom";
import { ArrowRight, BarChart3, Flame, Gauge, TrendingUp } from "lucide-react";
import { SiteHeader, MobileTabBar } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { LiveDot } from "@/components/LiveDot";
import { players } from "@/lib/mockData";
import { Sparkline, TrendBadge } from "@/components/TrendBadge";

export default function Landing() {
  const top5 = players.slice(0, 5);
  return (
    <div className="min-h-screen pb-20 md:pb-0">
      <SiteHeader />
      <section className="relative overflow-hidden">
        <div className="absolute inset-0" style={{ background: "var(--gradient-hero)" }} />
        <div className="bg-grid absolute inset-0 opacity-40" />
        <div className="relative mx-auto grid max-w-7xl gap-12 px-4 py-20 sm:px-6 lg:grid-cols-[1.1fr_1fr] lg:py-28">
          <div>
            <LiveDot label="LIVE • WORLD CUP 2026" />
            <h1 className="mt-5 text-5xl font-extrabold leading-[1.05] sm:text-6xl lg:text-7xl">
              One board.<br />
              One tournament.<br />
              <span className="gold-text">All players.</span>
            </h1>
            <p className="mt-5 max-w-xl text-lg text-muted-foreground">
              Real-time football rankings powered by match impact. Track every player. Watch ranks change live. See who dominates the tournament.
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <Link
                to="/rankings"
                className="group inline-flex items-center gap-2 rounded-lg bg-up px-5 py-3 text-sm font-semibold text-background transition hover:brightness-110"
                style={{ boxShadow: "0 10px 30px -10px color-mix(in oklab, var(--up) 70%, transparent)" }}
              >
                View Live Rankings
                <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-0.5" />
              </Link>
              <Link
                to="/players/mbappe"
                className="inline-flex items-center gap-2 rounded-lg border border-border/80 bg-surface/40 px-5 py-3 text-sm font-semibold text-foreground hover:bg-surface"
              >
                Explore Players
              </Link>
            </div>
            <div className="mt-10 flex items-center gap-6 text-xs text-muted-foreground">
              <Stat label="Players tracked" value="736" />
              <Stat label="Matches live" value="3" />
              <Stat label="Updates / min" value="42" />
            </div>
          </div>

          <div className="relative">
            <div
              className="absolute -inset-6 -z-10 rounded-3xl opacity-60 blur-3xl"
              style={{ background: "radial-gradient(circle, var(--primary), transparent 60%)" }}
            />
            <div className="glass float-slow rounded-2xl p-4">
              <div className="mb-3 flex items-center justify-between px-2">
                <div>
                  <div className="text-xs uppercase tracking-wider text-muted-foreground">Top 5 — Live</div>
                  <div className="text-sm font-semibold">Impact Leaderboard</div>
                </div>
                <LiveDot label="LIVE" />
              </div>
              <ul className="space-y-1">
                {top5.map((p) => (
                  <li
                    key={p.id}
                    className="row-hover grid grid-cols-[36px_1fr_auto_auto] items-center gap-3 rounded-lg px-3 py-2.5"
                  >
                    <div
                      className={`grid h-7 w-7 place-items-center rounded-md font-mono text-xs font-bold ${
                        p.rank <= 3 ? "text-background" : "bg-surface-2 text-muted-foreground"
                      }`}
                      style={p.rank <= 3 ? { background: "var(--gradient-gold)" } : undefined}
                    >
                      {p.rank}
                    </div>
                    <div className="flex items-center gap-2 min-w-0">
                      <span className="text-lg">{p.flag}</span>
                      <div className="min-w-0">
                        <div className="truncate text-sm font-semibold">{p.name}</div>
                        <div className="text-[11px] text-muted-foreground">{p.team}</div>
                      </div>
                    </div>
                    <Sparkline data={p.momentum} color={p.trend === "down" || p.trend === "cool" ? "var(--down)" : "var(--up)"} />
                    <div className="flex items-center gap-2">
                      <span className="font-mono text-base font-bold tabular">{p.score.toFixed(1)}</span>
                      <TrendBadge trend={p.trend} value={p.trendValue} />
                    </div>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-7xl px-4 py-16 sm:px-6">
        <div className="mb-10 max-w-2xl">
          <div className="text-xs font-semibold uppercase tracking-wider text-primary">Why StatRush</div>
          <h2 className="mt-2 text-3xl font-bold sm:text-4xl">The stock market for football players.</h2>
          <p className="mt-3 text-muted-foreground">
            Performance becomes measurable. Momentum becomes visible. Every match moves the board.
          </p>
        </div>
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          <Feature icon={<BarChart3 className="h-5 w-5" />} title="Live Rankings" desc="Rankings update the moment matches happen." accent="primary" />
          <Feature icon={<Gauge className="h-5 w-5" />} title="Impact Score" desc="A unique tournament-wide rating per player." accent="up" />
          <Feature icon={<TrendingUp className="h-5 w-5" />} title="Market Movers" desc="See the biggest risers and fallers today." accent="cool" />
          <Feature icon={<Flame className="h-5 w-5" />} title="Momentum Meter" desc="Visualize player form at a glance." accent="fire" />
        </div>
      </section>

      <SiteFooter />
      <MobileTabBar />
    </div>
  );
}

function Stat({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <div className="font-mono text-2xl font-bold tabular text-foreground">{value}</div>
      <div className="text-xs text-muted-foreground">{label}</div>
    </div>
  );
}

function Feature({
  icon, title, desc, accent,
}: { icon: React.ReactNode; title: string; desc: string; accent: "primary" | "up" | "fire" | "cool" }) {
  const tint =
    accent === "up" ? "bg-up/15 text-up"
    : accent === "fire" ? "bg-fire/15 text-fire"
    : accent === "cool" ? "bg-cool/15 text-cool"
    : "bg-primary/15 text-primary";
  return (
    <div className="card-hover rounded-2xl border border-border/70 bg-surface/40 p-5">
      <div className={`mb-4 grid h-10 w-10 place-items-center rounded-lg ${tint}`}>{icon}</div>
      <div className="font-bold">{title}</div>
      <div className="mt-1 text-sm text-muted-foreground">{desc}</div>
    </div>
  );
}
