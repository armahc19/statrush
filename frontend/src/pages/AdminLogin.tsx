import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { SiteHeader, MobileTabBar } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { ShieldCheck } from "lucide-react";
import { useAuth } from "@/hooks/useAuth";

const API_BASE_URL = import.meta.env.VITE_API_URL || "https://statrush.meshbase.online/api";

export default function AdminLogin() {
  const [adminId, setAdminId] = useState("");
  const [keypass, setKeypass] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    
    setError(null);
    setIsLoading(true);

    try {
      const response = await fetch(`${API_BASE_URL}/auth/login`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          admin_id: adminId,
          keypass: keypass,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        if (response.status === 401) {
          throw new Error("Invalid credentials. Access denied.");
        } else if (response.status === 400) {
          throw new Error(data.message || "Missing required fields.");
        } else {
          throw new Error(data.message || "Login failed. Please try again.");
        }
      }

      // Use the login function from hook
      await login(data.access_token);
      
    } catch (err) {
      setError(err instanceof Error ? err.message : "Login failed. Please try again.");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen pb-20 md:pb-0 relative">
      <SiteHeader />

      <div className="absolute inset-0 bg-gradient-to-br from-background via-background to-surface/30" />
      <div className="bg-grid absolute inset-0 opacity-30" />

      <main className="relative mx-auto flex max-w-7xl items-center justify-center px-4 py-20 sm:px-6">
        <div className="w-full max-w-md">
          <div className="glass rounded-2xl border border-border/70 p-6 shadow-2xl">
            
            <div className="mb-6 text-center">
              <div className="mx-auto mb-3 grid h-12 w-12 place-items-center rounded-xl bg-up/15 text-up">
                <ShieldCheck className="h-6 w-6" />
              </div>

              <h1 className="text-2xl font-extrabold">Admin Console</h1>
              <p className="text-sm text-muted-foreground">
                StatRush World Cup Control Center
              </p>
            </div>

            <form onSubmit={handleLogin} className="space-y-4">
              <div>
                <label className="text-xs uppercase tracking-wider text-muted-foreground">
                  Admin ID
                </label>
                <input
                  value={adminId}
                  onChange={(e) => setAdminId(e.target.value)}
                  placeholder="Enter admin ID"
                  disabled={isLoading}
                  className="mt-1 w-full rounded-lg border border-border/70 bg-surface/40 px-3 py-2 text-sm outline-none focus:border-up disabled:opacity-50"
                  autoComplete="username"
                />
              </div>

              <div>
                <label className="text-xs uppercase tracking-wider text-muted-foreground">
                  Keypass
                </label>
                <input
                  type="password"
                  value={keypass}
                  onChange={(e) => setKeypass(e.target.value)}
                  placeholder="Enter keypass"
                  disabled={isLoading}
                  className="mt-1 w-full rounded-lg border border-border/70 bg-surface/40 px-3 py-2 text-sm outline-none focus:border-up disabled:opacity-50"
                  autoComplete="current-password"
                />
              </div>

              {error && (
                <div className="rounded-lg border border-red-500/40 bg-red-500/10 px-3 py-2 text-xs text-red-400">
                  {error}
                </div>
              )}

              <button
                type="submit"
                disabled={isLoading || !adminId || !keypass}
                className="w-full rounded-lg bg-up px-4 py-2 text-sm font-semibold text-background transition hover:brightness-110 disabled:opacity-50"
              >
                {isLoading ? "Logging in..." : "Login to Console"}
              </button>
            </form>

            <div className="mt-6 text-center text-[11px] text-muted-foreground">
              Authorized personnel only
            </div>
          </div>
        </div>
      </main>

      <SiteFooter />
      <MobileTabBar />
    </div>
  );
}