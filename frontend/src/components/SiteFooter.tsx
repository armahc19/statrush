import { Link } from "react-router-dom";

export function SiteFooter() {
  const links = [
    { to: "/rankings", label: "Rankings" },
    { to: "/players/mbappe", label: "Players" },
    { to: "/tournament", label: "Tournament" },
    { to: "/", label: "About" },
    { to: "/", label: "Privacy" },
    { to: "/", label: "Terms" },
  ];
  return (
    <footer className="mt-20 border-t border-border/60 bg-surface/40">
      <div className="mx-auto flex max-w-7xl flex-col items-start justify-between gap-6 px-4 py-10 sm:px-6 md:flex-row md:items-center">
        <div className="flex items-center gap-2">
          <div className="grid h-8 w-8 place-items-center rounded-md bg-primary/15 ring-1 ring-primary/30">
            <span className="font-mono text-sm font-bold text-primary">SR</span>
          </div>
          <div>
            <div className="font-bold">StatRush</div>
            <div className="text-xs text-muted-foreground">The stock market for football players.</div>
          </div>
        </div>
        <div className="flex flex-wrap gap-x-6 gap-y-2 text-sm text-muted-foreground">
          {links.map((l, i) => (
            <Link key={i} to={l.to} className="hover:text-foreground">
              {l.label}
            </Link>
          ))}
        </div>
        <div className="text-xs text-muted-foreground">© 2026 StatRush</div>
      </div>
    </footer>
  );
}
