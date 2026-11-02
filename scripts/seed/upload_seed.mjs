/**
 * One-off Tier-1 seed upload. Sets moderation_status admin_verified for curated rows.
 * Do NOT re-run after live moderation has started (would reset community curation state).
 */
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { supabaseAdmin } from "../lib/supabase_client.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
const seedPath = join(__dirname, "../../data/seed/programmes_seed.json");

const rows = JSON.parse(readFileSync(seedPath, "utf8"));

for (const row of rows) {
  const payload = { ...row };
  delete payload.reviewed;
  payload.moderation_status = "admin_verified";

  const { error } = await supabaseAdmin.from("programmes").upsert(payload, {
    onConflict: "url",
  });
  if (error) {
    console.error("seed upsert failed:", error.message, row.url);
    process.exit(1);
  }
}

console.log(`Seeded ${rows.length} programmes (admin_verified).`);
