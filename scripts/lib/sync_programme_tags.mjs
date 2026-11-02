/**
 * Replace programme_tags for a programme from slug list.
 * @param {import('@supabase/supabase-js').SupabaseClient} client
 * @param {string} programmeId
 * @param {string[]} slugs
 */
export async function syncProgrammeTags(client, programmeId, slugs) {
  if (!slugs.length) {
    return;
  }

  const { data: tags, error: tagError } = await client
    .from("tags")
    .select("id, slug")
    .in("slug", slugs);

  if (tagError) {
    console.error("syncProgrammeTags tag lookup:", tagError.message);
    return;
  }

  if (!tags?.length) {
    return;
  }

  await client.from("programme_tags").delete().eq("programme_id", programmeId);

  const rows = tags.map((tag) => ({
    programme_id: programmeId,
    tag_id: tag.id,
  }));

  const { error: insertError } = await client.from("programme_tags").insert(rows);
  if (insertError) {
    console.error("syncProgrammeTags insert:", insertError.message);
  }
}
