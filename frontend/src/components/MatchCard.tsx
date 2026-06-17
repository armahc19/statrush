// src/components/MatchCard.tsx
import { useState } from "react";
import { ChevronDown } from "lucide-react";

type Status = "live" | "played" | "upcoming";

export type Match = {
  id: string;
  home: string;
  homeFlag: string;
  away: string;
  awayFlag: string;
  status: Status;
  scoreHome?: number;
  scoreAway?: number;
  minute?: string;
  date?: string;
  time?: string;
  venue?: string;
  group?: string;
  events?: {
    id: number;
    minute: string;
    icon: string;
    text: string;
  }[];
};

function StatusDot({ status }: { status: Status }) {
  if (status === "live") {
    return (
      <span className="relative inline-flex h-2.5 w-2.5">
        <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-up opacity-75" />
        <span className="relative inline-flex h-2.5 w-2.5 rounded-full bg-up shadow-[0_0_10px_hsl(var(--up))]" />
      </span>
    );
  }
  if (status === "played") {
    return (
      <span className="inline-block h-2.5 w-2.5 rounded-full bg-yellow-400 shadow-[0_0_6px_rgba(250,204,21,0.6)]" />
    );
  }
  return (
    <span className="inline-block h-2.5 w-2.5 rounded-full bg-muted-foreground/50" />
  );
}

function StatusLabel({ match }: { match: Match }) {
  if (match.status === "live")
    return (
      <span className="font-mono text-xs font-bold uppercase tracking-wider text-up">
        Live · {match.minute}
      </span>
    );
  if (match.status === "played")
    return (
      <span className="font-mono text-xs font-semibold uppercase tracking-wider text-yellow-400">
        Full Time
      </span>
    );
  return (
    <span className="font-mono text-xs font-semibold uppercase tracking-wider text-muted-foreground">
      {match.date} · {match.time}
    </span>
  );
}

function Side({ flag, name, align }: { flag: string; name: string; align: "left" | "right" }) {
  return (
    <div
      className={`flex items-center gap-2 sm:gap-3 ${
        align === "right" ? "justify-end" : "justify-start"
      }`}
    >
      {align === "left" && <span className="text-2xl sm:text-3xl">{flag}</span>}
      <div className={`text-sm font-bold sm:text-base ${align === "right" ? "text-right" : ""}`}>{name}</div>
      {align === "right" && <span className="text-2xl sm:text-3xl">{flag}</span>}
    </div>
  );
}

export default function MatchCard({ match }: { match: Match }) {
  const [open, setOpen] = useState(false);
  const expandable = match.status !== "upcoming";
  const toggle = () => expandable && setOpen((v) => !v);

  return (
    <li>
      <div
        onClick={toggle}
        className={`group rounded-2xl border border-border/70 bg-surface/40 transition-colors ${
          expandable ? "cursor-pointer hover:bg-surface/70" : "opacity-90"
        }`}
      >
        <div className="grid grid-cols-[auto_1fr_auto_1fr_auto] items-center gap-3 px-4 py-4 sm:gap-6 sm:px-6">
          <div className="flex flex-col items-center gap-1.5">
            <StatusDot status={match.status} />
            <span className="hidden text-[10px] uppercase text-muted-foreground sm:block">
              {match.group ?? "—"}
            </span>
          </div>
          <Side flag={match.homeFlag} name={match.home} align="right" />
          <div className="text-center">
            {match.status === "upcoming" ? (
              <div className="font-mono text-lg font-bold text-muted-foreground">vs</div>
            ) : (
              <div className="font-mono text-2xl font-extrabold tabular sm:text-3xl">
                {match.scoreHome} <span className="text-muted-foreground">-</span> {match.scoreAway}
              </div>
            )}
            <div className="mt-1">
              <StatusLabel match={match} />
            </div>
          </div>
          <Side flag={match.awayFlag} name={match.away} align="left" />
          <div className="flex items-center gap-2">
            <span className="hidden text-xs text-muted-foreground md:inline">{match.venue}</span>
            {expandable && (
              <ChevronDown
                className={`h-4 w-4 text-muted-foreground transition-transform ${
                  open ? "rotate-180" : ""
                }`}
              />
            )}
          </div>
        </div>
        {expandable && open && match.events && match.events.length > 0 && (
          <div className="border-t border-border/40 px-4 py-4 sm:px-6">
            <div className="mb-3 flex items-center justify-between">
              <h3 className="text-sm font-bold">Match Events</h3>
            </div>
            <ul className="space-y-2">
              {match.events.map((e) => (
                <li
                  key={e.id}
                  className="flex items-center gap-3 rounded-md border border-border/40 bg-surface-2/40 px-3 py-2"
                >
                  <span className="text-xl">{e.icon}</span>
                  <span className="font-mono text-xs text-muted-foreground w-10">{e.minute}</span>
                  <span className="text-sm">{e.text}</span>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    </li>
  );
}
