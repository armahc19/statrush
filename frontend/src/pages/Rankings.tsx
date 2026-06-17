import { SiteHeader, MobileTabBar } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { LiveDot } from "@/components/LiveDot";
import { TopPerformer } from "@/components/TopPerformer";
import { Leaderboard } from "@/components/Leaderboard";
import { TeamRankings } from "@/components/TeamRankings";
import { MarketMovers } from "@/components/MarketMovers";
import { players, upcomingFixtures } from "@/lib/mockData";

export default function Rankings() {
  const top = players[0];
  return (
    <div className="min-h-screen pb-24 md:pb-12">
      <SiteHeader />

      <section className="relative overflow-hidden border-b border-border/60">
        <div className="absolute inset-0" style={{ background: "var(--gradient-hero)" }} />
        <div className="relative mx-auto flex max-w-7xl flex-col items-start gap-4 px-4 py-8 sm:px-6 md:flex-row md:items-center md:justify-between">
          <div className="flex items-center gap-4">
            <div
              className="grid h-14 w-14 place-items-center rounded-2xl text-2xl ring-1 ring-white/10"
              style={{ background: "var(--gradient-gold)" }}
            >
              🏆
            </div>
            <div>
              <div className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">FIFA World Cup</div>
              <div className="text-2xl font-bold sm:text-3xl">WORLD CUP 2026</div>
              <div className="text-sm text-muted-foreground">June 11 – July 19, 2026</div>
            </div>
          </div>
          <LiveDot />
        </div>
      </section>

      <main className="mx-auto max-w-7xl space-y-6 px-4 py-8 sm:px-6">
        {/*  <TopPerformer p={top} />*/}

        <TeamRankings />

      {/* <div className="grid gap-6 lg:grid-cols-[1fr_320px]"> */}
      <div className="mx-auto max-w-7xl space-y-6 px-4 py-8 sm:px-6">
          <Leaderboard />
        {/* <div className="space-y-6">
            <MarketMovers />
            <UpcomingMini />
          </div>*/}
        </div>
      </main>

      <SiteFooter />
      <MobileTabBar />
    </div>
  );
}

function UpcomingMini() {
  return (
    <aside className="rounded-2xl border border-border/70 bg-surface/40 p-5">
      <h3 className="mb-4 font-bold">Upcoming Fixtures</h3>
      <ul className="space-y-2">
        {upcomingFixtures.slice(0, 4).map((f, i) => (
          <li key={i} className="card-hover rounded-md border border-border/40 bg-surface-2/40 p-3">
            <div className="flex items-center justify-between text-sm">
              <span className="font-semibold">{f.home} <span className="text-muted-foreground">vs</span> {f.away}</span>
              <span className="font-mono text-xs text-muted-foreground">{f.date}</span>
            </div>
            <div className="mt-1 text-xs text-muted-foreground">{f.time} • {f.venue}</div>
          </li>
        ))}
      </ul>
    </aside>
  );
}
