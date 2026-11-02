import { chromium } from "@playwright/test";
import { upsertProgramme } from "../lib/upsert.mjs";
import { requireSupabaseEnv } from "../lib/require_env.mjs";
import { classifyNigeriaEligibility } from "../lib/nigeria_heuristic.mjs";
import { extractOutreachyEntries } from "./outreachy_extract.mjs";

requireSupabaseEnv("outreachy");

const TARGET_URL = "https://www.outreachy.org/apply/";

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage();

try {
  await page.goto(TARGET_URL, { waitUntil: "networkidle", timeout: 30000 });
  const html = await page.content();
  const entries = extractOutreachyEntries(html);

  for (const entry of entries) {
    await upsertProgramme({
      ...entry,
      type: "fellowship",
      remote: true,
      nigeria_eligible: classifyNigeriaEligibility(
        `${entry.name ?? ""} ${entry.description ?? ""}`,
      ),
      source: "playwright_outreachy",
    });
  }

  console.log(`[outreachy] upserted ${entries.length} entries`);
} catch (err) {
  console.error("[outreachy] failed:", err);
  process.exit(1);
} finally {
  await browser.close();
}
