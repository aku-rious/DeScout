/**
 * Upsert a programme row. Always forces reviewed = false.
 * @param {object} data
 * @param {import('@supabase/supabase-js').SupabaseClient} [client]
 */
export async function upsertProgramme(data, client) {
  const db =
    client ?? (await import("./supabase_client.mjs")).supabaseAdmin;
  const row = { ...data, reviewed: false };
  const { error } = await db.from("programmes").upsert(row, {
    onConflict: "url",
  });
  if (error) {
    console.error("upsertProgramme failed:", error.message);
    process.exit(1);
  }
}
