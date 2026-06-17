import { BrowserRouter,Routes, Route, Link } from "react-router-dom";
import Landing from "./pages/Landing";
import Rankings from "./pages/Rankings";
import Matches from "./pages/Matches";
import Tournament from "./pages/Tournament";
import PlayerPage from "./pages/PlayerPage";
import Fixtures from "./pages/Fixtures";
import AdminLogin from "./pages/AdminLogin";
import AdminPanel from "./pages/AdminPanel";
import { AuthProvider } from '@/context/AuthContext';
import { ProtectedRoute } from '@/components/ProtectedRoute';

function NotFound() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-background px-4">
      <div className="max-w-md text-center">
        <h1 className="text-7xl font-bold text-foreground">404</h1>
        <h2 className="mt-4 text-xl font-semibold text-foreground">Page not found</h2>
        <p className="mt-2 text-sm text-muted-foreground">
          The page you're looking for doesn't exist or has been moved.
        </p>
        <div className="mt-6">
          <Link
            to="/"
            className="inline-flex items-center justify-center rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90"
          >
            Go home
          </Link>
        </div>
      </div>
    </div>
  );
}

export default function App() {
  return (
          <AuthProvider>
              <Routes>
                <Route path="/" element={<Landing />} />
                <Route path="/rankings" element={<Rankings />} />
                <Route path="/matches" element={<Matches />} />
                <Route path="/tournament" element={<Tournament />} />
                <Route path="/players/:id" element={<PlayerPage />} />
                <Route path="/fixtures" element={<Fixtures />} />
                <Route path="/admin/login" element={<AdminLogin />} />
                {/*
                  <Route path="/admin/panel" element={<AdminPanel />} />
                */}
                          {/* Protected admin routes */}
                  <Route 
                    path="/admin/panel" 
                    element={
                      <ProtectedRoute>
                        <AdminPanel />
                      </ProtectedRoute>
                    } 
                  />
                  
                  {/*<Route 
                    path="/admin/*" 
                    element={
                      <ProtectedRoute>
                        <AdminDashboard />
                      </ProtectedRoute>
                    } 
                  />*/}

                <Route path="*" element={<NotFound />} />
              </Routes>
          </AuthProvider>
  );
}
