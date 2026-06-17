import { SiteHeader, MobileTabBar } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { groups, upcomingFixtures } from "@/lib/mockData";

const stages = ["Round of 16", "Quarter Finals", "Semi Finals", "Final"];
const bracketMatches: Record<string, { a: string; b: string; sa?: number; sb?: number; done?: boolean }[]> = {
  "Round of 16": [
    { a: "🇫🇷 France", b: "🇲🇽 Mexico", sa: 3, sb: 1, done: true },
    { a: "🇦🇷 Argentina", b: "🇯🇵 Japan", sa: 2, sb: 0, done: true },
    { a: "🇧🇷 Brazil", b: "🇺🇸 USA", sa: 4, sb: 1, done: true },
    { a: "🏴 England", b: "🇲🇦 Morocco", sa: 2, sb: 1, done: true },
  ],
  "Quarter Finals": [
    { a: "🇫🇷 France", b: "🇦🇷 Argentina" },
    { a: "🇧🇷 Brazil", b: "🏴 England" },
  ],
  "Semi Finals": [{ a: "TBD", b: "TBD" }],
  "Final": [{ a: "TBD", b: "TBD" }],
};

export default function Tournament() {
  return (
    <div className="min-h-screen pb-24 md:pb-12">
      <SiteHeader />

      <section className="relative overflow-hidden border-b border-border/60">
        <div className="absolute inset-0" style={{ background: "var(--gradient-hero)" }} />
        <div className="relative mx-auto max-w-7xl px-4 py-10 sm:px-6">
          <div className="text-xs font-semibold uppercase tracking-wider text-primary">FIFA World Cup</div>
          <h1 className="mt-2 text-3xl font-extrabold sm:text-4xl">Tournament Overview 2026</h1>
          <p className="mt-2 text-muted-foreground">Bracket progression, group standings and upcoming fixtures.</p>
        </div>
      </section>

      <main className="mx-auto max-w-7xl space-y-8 px-4 py-8 sm:px-6">
        <section className="rounded-2xl border border-border/70 bg-surface/40 p-5">
          <h2 className="mb-4 font-bold">Knockout Progress</h2>
          <div className="flex items-center gap-2 overflow-x-auto">
            {stages.map((s, i) => {
              const done = i === 0;
              const active = i === 1;
              return (
                <div key={s} className="flex items-center gap-2">
                  <div
                    className={`whitespace-nowrap rounded-full border px-3 py-1.5 text-xs font-semibold ${
                      done ? "border-up/40 bg-up/15 text-up"
                      : active ? "border-primary/50 bg-primary/15 text-primary"
                      : "border-border/70 bg-surface-2/40 text-muted-foreground"
                    }`}
                  >
                    {s}
                  </div>
                  {i < stages.length - 1 && <div className={`h-px w-8 ${done ? "bg-up/40" : "bg-border"}`} />}
                </div>
              );
            })}
          </div>
        </section>

        <section className="rounded-2xl border border-border/70 bg-surface/40 p-5">
          <h2 className="mb-5 font-bold">Bracket</h2>
          <div className="grid gap-5 md:grid-cols-4">
            {stages.map((s) => (
              <div key={s}>
                <div className="mb-2 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">{s}</div>
                <div className="space-y-3">
                  {bracketMatches[s].map((m, i) => (
                    <div key={i} className="rounded-xl border border-border/60 bg-surface-2/40 p-3 text-sm">
                      <Row team={m.a} score={m.sa} winner={m.done && (m.sa ?? 0) > (m.sb ?? 0)} />
                      <div className="my-1 h-px bg-border/60" />
                      <Row team={m.b} score={m.sb} winner={m.done && (m.sb ?? 0) > (m.sa ?? 0)} />
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </section>

        <section className="grid gap-5 md:grid-cols-2 xl:grid-cols-3">
          {groups.map((g) => (
            <div key={g.name} className="rounded-2xl border border-border/70 bg-surface/40 p-5">
              <h3 className="mb-3 font-bold">{g.name}</h3>
              <table className="w-full text-sm">
                <thead className="text-[11px] uppercase tracking-wider text-muted-foreground">
                  <tr>
                    <th className="py-1.5 text-left">Team</th>
                    <th className="py-1.5 text-right">P</th>
                    <th className="py-1.5 text-right">W</th>
                    <th className="py-1.5 text-right">D</th>
                    <th className="py-1.5 text-right">L</th>
                    <th className="py-1.5 text-right">GD</th>
                    <th className="py-1.5 text-right">Pts</th>
                  </tr>
                </thead>
                <tbody className="font-mono tabular">
                  {g.rows.map((r, i) => (
                    <tr key={i} className="border-t border-border/40">
                      <td className="py-2 font-sans">{r.team}</td>
                      <td className="text-right">{r.p}</td>
                      <td className="text-right text-up">{r.w}</td>
                      <td className="text-right">{r.d}</td>
                      <td className="text-right text-down">{r.l}</td>
                      <td className="text-right">{r.gd}</td>
                      <td className="text-right font-bold">{r.pts}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ))}
        </section>

        <section className="rounded-2xl border border-border/70 bg-surface/40 p-5">
          <h2 className="mb-4 font-bold">Match Schedule</h2>
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
            {upcomingFixtures.map((f, i) => (
              <div key={i} className="card-hover rounded-xl border border-border/40 bg-surface-2/40 p-4">
                <div className="flex items-center justify-between text-sm font-semibold">
                  <span>{f.home}</span><span className="text-xs text-muted-foreground">vs</span><span>{f.away}</span>
                </div>
                <div className="mt-2 font-mono text-xs text-muted-foreground">{f.date} • {f.time}</div>
                <div className="mt-1 text-xs text-muted-foreground">{f.venue}</div>
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

function Row({ team, score, winner }: { team: string; score?: number; winner?: boolean }) {
  return (
    <div className={`flex items-center justify-between ${winner ? "text-foreground" : "text-muted-foreground"}`}>
      <span className={winner ? "font-semibold" : ""}>{team}</span>
      <span className="font-mono tabular">{score ?? "—"}</span>
    </div>
  );
}
