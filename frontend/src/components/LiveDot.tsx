export function LiveDot({ label = "LIVE UPDATES" }: { label?: string }) {
  return (
    <span className="inline-flex items-center gap-2 rounded-full border border-up/30 bg-up/10 px-3 py-1 text-xs font-semibold text-up">
      <span className="pulse-dot inline-block h-2 w-2 rounded-full bg-up" />
      {label}
    </span>
  );
}
