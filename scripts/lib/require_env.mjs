/**
 * Exit with a clear message when Supabase env vars are missing (e.g. GHA secrets).
 */
export function requireSupabaseEnv(label = "ingestion") {
  const missing = [];
  if (!process.env.SUPABASE_URL?.trim()) missing.push("SUPABASE_URL");
  if (!process.env.SUPABASE_SERVICE_ROLE_KEY?.trim()) {
    missing.push("SUPABASE_SERVICE_ROLE_KEY");
  }
  if (missing.length === 0) return;

  console.error(
    `[${label}] missing required env: ${missing.join(", ")}. ` +
      "Add GitHub Actions repository secrets SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY.",
  );
  process.exit(1);
}
