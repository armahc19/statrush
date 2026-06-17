import { useEffect, useState } from "react";
import { ChevronDown } from "lucide-react";
import { SiteHeader, MobileTabBar } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import MatchCard, { type Match } from "../components/MatchCard";
// reuse existing card component

export default function Fixtures() {
  const [fixtures, setFixtures] = useState<Match[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const size = 10;

  const fetchFixtures = (p: number) => {
    fetch(`http://153.75.244.15:5001/api/fixtures?page=${p}&size=${size}`)
      .then((res) => res.json())
      .then((data) => {
        // Map backend objects to Match shape
        const mapped: Match[] = (data.fixtures ?? []).map((f: any) => ({
          id: f.id?.toString() ?? "",
          home: f.home,
          homeFlag: f.homeFlag,
          away: f.away,
          awayFlag: f.awayFlag,
          status: f.status === "TIMED" ? "upcoming" : f.status.toLowerCase() as any,
          date: f.date,
          time: f.time,
          venue: f.venue,
          group: f.group,
          events: f.events ?? []
        }));
        setFixtures(mapped);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Failed to fetch fixtures", err);
        setFixtures([]);
        setLoading(false);
      });
  };

  useEffect(() => {
    setLoading(true);
    fetchFixtures(page);
  }, [page]);

  const goPrev = () => setPage((p) => Math.max(p - 1, 1));
  const goNext = () => setPage((p) => p + 1);

  return (
    <div className="min-h-screen pb-24 md:pb-12">
      <SiteHeader />
      <main className="mx-auto max-w-7xl space-y-6 px-4 py-8 sm:px-6">
        <div className="flex items-end justify-between">
          <div>
            <h1 className="text-2xl font-extrabold sm:text-3xl">Upcoming Fixtures</h1>
            <p className="text-sm text-muted-foreground">World Cup fixtures not yet played</p>
          </div>
        </div>
        {loading ? (
          <div className="flex h-64 items-center justify-center">
            <div className="h-8 w-8 animate-spin rounded-full border-4 border-primary border-t-transparent" />
          </div>
        ) : (
          <ul className="space-y-3">
            {fixtures.map((f) => (
              <MatchCard key={f.id} match={f as any} />
            ))}
          </ul>
        )}
        {/* Pagination controls */}
        <div className="mt-4 flex justify-center gap-4">
          <button
            onClick={goPrev}
            disabled={page === 1 || loading}
            className="rounded-md bg-muted px-3 py-1 text-sm disabled:opacity-50"
          >
            Previous
          </button>
          <span className="flex items-center gap-2 text-sm">Page {page}</span>
          <button
            onClick={goNext}
            disabled={loading}
            className="rounded-md bg-muted px-3 py-1 text-sm"
          >
            Next
          </button>
        </div>
      </main>
      <SiteFooter />
      <MobileTabBar />
    </div>
  );
}
