import { Link, useLocation } from "react-router-dom";
import { Bell, Search } from "lucide-react";
import { useNavigate } from "react-router-dom";

const nav = [
  { to: "/rankings", label: "Rankings" },
  { to: "/fixtures", label:"Fixtures"},
  { to: "/matches", label: "Matches" },
 /* to: "/players/mbappe", label: "Players" },*/
];

export function SiteHeader() {
  const path = useLocation().pathname;
   const navigate = useNavigate();
  return (
    <header className="sticky top-0 z-40 border-b border-border/60 bg-background/70 backdrop-blur-xl">
      <div className="mx-auto flex h-16 max-w-7xl items-center gap-6 px-4 sm:px-6">
        <Link to="/" className="flex items-center gap-2">
          <div className="grid h-8 w-8 place-items-center rounded-md bg-primary/15 ring-1 ring-primary/30">
            <span className="font-mono text-sm font-bold text-primary">SR</span>
          </div>
          <span className="text-lg font-bold tracking-tight">StatRush</span>
        </Link>

        <nav className="hidden items-center gap-1 md:flex">
          {nav.map((n) => {
            const active = path.startsWith(n.to.split("/").slice(0, 2).join("/"));
            return (
              <Link
                key={n.to}
                to={n.to}
                className={`relative rounded-md px-3 py-1.5 text-sm transition-colors ${
                  active ? "text-foreground" : "text-muted-foreground hover:text-foreground"
                }`}
              >
                {n.label}
                {active && (
                  <span className="absolute inset-x-3 -bottom-[17px] h-[2px] rounded bg-primary" />
                )}
              </Link>
            );
          })}
        </nav>

        <div className="ml-auto flex items-center gap-2">
          <div className="hidden items-center gap-2 rounded-md border border-border/70 bg-surface/60 px-3 py-1.5 text-sm text-muted-foreground sm:flex">
            <Search className="h-3.5 w-3.5" />
            <input
              className="w-40 bg-transparent outline-none placeholder:text-muted-foreground/70"
              placeholder="Search players, teams..."
            />
          </div>
          <button className="grid h-9 w-9 place-items-center rounded-md border border-border/70 bg-surface/60 text-muted-foreground hover:text-foreground">
            <Bell className="h-4 w-4" />
          </button>
          <Link to="/admin/login" className="flex items-center gap-2">
          <div className="grid h-9 w-9 place-items-center rounded-full bg-gradient-to-br from-primary to-up text-xs font-bold text-background">
            SR
          </div>
          </Link>
        </div>
      </div>
    </header>
  );
}

export function MobileTabBar() {
  const path = useLocation().pathname;
  return (
    <nav className="fixed inset-x-0 bottom-0 z-40 grid grid-cols-4 border-t border-border/60 bg-background/90 backdrop-blur-xl md:hidden">
      {nav.map((n) => {
        const active = path.startsWith(n.to.split("/").slice(0, 2).join("/"));
        return (
          <Link
            key={n.to}
            to={n.to}
            className={`py-3 text-center text-xs ${active ? "text-primary" : "text-muted-foreground"}`}
          >
            {n.label}
          </Link>
        );
      })}
    </nav>
  );
}
