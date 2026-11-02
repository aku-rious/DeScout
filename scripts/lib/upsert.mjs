/**
 * Upsert a programme row. Never sends moderation_status or reviewed (DB default / admin only).
 * @param {object} data
 * @param {import('@supabase/supabase-js').SupabaseClient} [client]
 */
export async function upsertProgramme(data, client) {
  const db =
    client ?? (await import("./supabase_client.mjs")).supabaseAdmin;
  const row = { ...data };
  delete row.moderation_status;
  delete row.reviewed;

  const { data: existing, error: lookupError } = await db
    .from("programmes")
    .select("id, moderation_status")
    .eq("url", row.url)
    .maybeSingle();

  if (lookupError) {
    console.error("upsertProgramme lookup failed:", lookupError.message);
    process.exit(1);
  }

  if (existing?.moderation_status === "rejected") {
    console.info(
      `upsertProgramme: updating rejected tombstone url=${row.url}`,
    );
  }

  const { data: upserted, error } = await db
    .from("programmes")
    .upsert(row, { onConflict: "url" })
    .select("id")
    .maybeSingle();

  if (error) {
    console.error("upsertProgramme failed:", error.message);
    process.exit(1);
  }

  if (upserted?.id) {
    const { inferTagSlugs } = await import("./tag_heuristic.mjs");
    const { syncProgrammeTags } = await import("./sync_programme_tags.mjs");
    const slugs = inferTagSlugs(row);
    if (slugs.length) {
      await syncProgrammeTags(db, upserted.id, slugs);
    }
  }
}
