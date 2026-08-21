import { supabase } from "./supabaseClient";

// Sign in an existing staff member (owner creates accounts in Supabase
// Dashboard → Authentication → Users, or via signUp() below during setup).
export async function signIn(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) throw error;
  return data.user;
}

export async function signOut() {
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
}

// One-time setup helper — creates a login for a new staff member.
// After this runs, insert a matching row into `staff` (see schema.sql)
// linking their auth user id to your restaurant_id and a role.
export async function signUp(email, password) {
  const { data, error } = await supabase.auth.signUp({ email, password });
  if (error) throw error;
  return data.user;
}

// Call once when the app loads, and keep listening so the UI updates
// automatically if someone logs out in another tab.
export function onAuthChange(callback) {
  supabase.auth.getSession().then(({ data }) => callback(data.session));
  const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => callback(session));
  return () => listener.subscription.unsubscribe();
}

// Fetches the logged-in staff member's restaurant_id + role + name.
// Call this right after login to know which restaurant's data to load.
export async function getStaffProfile(userId) {
  const { data, error } = await supabase
    .from("staff")
    .select("id, full_name, role, restaurant_id")
    .eq("id", userId)
    .single();
  if (error) throw error;
  return data;
}
