import { useState, useEffect } from "react";
import { onAuthChange, signIn, signOut, getStaffProfile } from "./lib/auth";
import BYOBRestaurantSystem from "./byob-restaurant-system.jsx";

export default function App() {
  const [session, setSession] = useState(undefined); // undefined = still checking, null = logged out
  const [profile, setProfile] = useState(null);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => onAuthChange(setSession), []);

  useEffect(() => {
    if (session?.user) {
      getStaffProfile(session.user.id)
        .then(setProfile)
        .catch(() => setError("Logged in, but no staff record found for this account. Ask your admin to add you in the 'staff' table."));
    } else {
      setProfile(null);
    }
  }, [session]);

  async function handleLogin(e) {
    e.preventDefault();
    setError("");
    setLoading(true);
    try {
      await signIn(email, password);
    } catch (err) {
      setError(err.message || "Login failed");
    } finally {
      setLoading(false);
    }
  }

  // Still checking for an existing session on first load
  if (session === undefined) {
    return <div style={{ display: "flex", height: "100vh", alignItems: "center", justifyContent: "center", fontFamily: "sans-serif" }}>Loading…</div>;
  }

  // Logged in, staff profile confirmed → show the POS
  if (session && profile) {
    return <BYOBRestaurantSystem restaurantId={profile.restaurant_id} cashierName={profile.full_name} onLogout={signOut} />;
  }

  // Logged in but profile still loading / missing
  if (session && !profile) {
    return (
      <div style={{ display: "flex", height: "100vh", alignItems: "center", justifyContent: "center", fontFamily: "sans-serif", flexDirection: "column", gap: 12 }}>
        <div>{error || "Loading your profile…"}</div>
        {error && <button onClick={signOut}>Log out</button>}
      </div>
    );
  }

  // Not logged in → show login form
  return (
    <div style={{ display: "flex", height: "100vh", alignItems: "center", justifyContent: "center", fontFamily: "sans-serif", background: "#F4F1EC" }}>
      <form onSubmit={handleLogin} style={{ background: "#fff", padding: 32, borderRadius: 14, width: 320, boxShadow: "0 4px 24px rgba(0,0,0,0.08)" }}>
        <div style={{ fontSize: 20, fontWeight: 700, marginBottom: 4 }}>The Tropical Bistro</div>
        <div style={{ fontSize: 13, color: "#7A756B", marginBottom: 20 }}>Staff sign in</div>
        <label style={{ fontSize: 12, fontWeight: 600 }}>Email</label>
        <input type="email" value={email} onChange={e => setEmail(e.target.value)} required
          style={{ width: "100%", padding: "8px 10px", marginTop: 4, marginBottom: 14, borderRadius: 8, border: "1px solid #ddd", boxSizing: "border-box" }} />
        <label style={{ fontSize: 12, fontWeight: 600 }}>Password</label>
        <input type="password" value={password} onChange={e => setPassword(e.target.value)} required
          style={{ width: "100%", padding: "8px 10px", marginTop: 4, marginBottom: 18, borderRadius: 8, border: "1px solid #ddd", boxSizing: "border-box" }} />
        {error && <div style={{ color: "#B4463C", fontSize: 12.5, marginBottom: 12 }}>{error}</div>}
        <button type="submit" disabled={loading}
          style={{ width: "100%", padding: "10px 0", borderRadius: 8, border: "none", background: "#5B7553", color: "#fff", fontWeight: 700, cursor: "pointer" }}>
          {loading ? "Signing in…" : "Sign in"}
        </button>
      </form>
    </div>
  );
}
