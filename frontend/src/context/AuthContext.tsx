// context/AuthContext.tsx
import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { useNavigate } from 'react-router-dom';

interface AuthContextType {
  isAuthenticated: boolean;
  isLoading: boolean;
  adminId: string | null;
  login: (token: string) => Promise<void>;
  logout: () => void;
  checkAuth: () => Promise<boolean>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

const API_BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:5000/api";

export function AuthProvider({ children }: { children: ReactNode }) {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [adminId, setAdminId] = useState<string | null>(null);
  const navigate = useNavigate();

  const checkAuth = async (): Promise<boolean> => {
    const token = localStorage.getItem('sr_admin_token');
    
    if (!token) {
      setIsAuthenticated(false);
      setAdminId(null);
      return false;
    }

    try {
      const response = await fetch(`${API_BASE_URL}/auth/verify`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        const data = await response.json();
        setIsAuthenticated(true);
        setAdminId(data.admin_id);
        return true;
      } else {
        // Token invalid or expired
        localStorage.removeItem('sr_admin_token');
        localStorage.removeItem('sr_admin_id');
        localStorage.removeItem('sr_admin_role');
        localStorage.removeItem('sr_admin_expires');
        setIsAuthenticated(false);
        setAdminId(null);
        return false;
      }
    } catch (error) {
      console.error('Auth check failed:', error);
      setIsAuthenticated(false);
      setAdminId(null);
      return false;
    }
  };

  const login = async (token: string) => {
    localStorage.setItem('sr_admin_token', token);
    const isValid = await checkAuth();
    if (isValid) {
      navigate('/admin/panel');
    }
  };

  const logout = () => {
    localStorage.removeItem('sr_admin_token');
    localStorage.removeItem('sr_admin_id');
    localStorage.removeItem('sr_admin_role');
    localStorage.removeItem('sr_admin_expires');
    setIsAuthenticated(false);
    setAdminId(null);
    navigate('/admin/login');
  };

  useEffect(() => {
    const initAuth = async () => {
      setIsLoading(true);
      await checkAuth();
      setIsLoading(false);
    };
    initAuth();
  }, []);

  return (
    <AuthContext.Provider value={{ 
      isAuthenticated, 
      isLoading, 
      adminId, 
      login, 
      logout, 
      checkAuth 
    }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}