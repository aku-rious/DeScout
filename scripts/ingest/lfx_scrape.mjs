import { chromium } from "@playwright/test";
import { upsertProgramme } from "../lib/upsert.mjs";
import { classifyNigeriaEligibility } from "../lib/nigeria_heuristic.mjs";
import { extractLfxEntries } from "./lfx_extract.mjs";

const TARGET_URL = "https://mentorship.lfx.linuxfoundation.org";

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage();

try {
  await page.goto(TARGET_URL, { waitUntil: "networkidle", timeout: 30000 });
  const html = await page.content();
  const entries = extractLfxEntries(html);

  for (const entry of entries) {
    await upsertProgramme({
      ...entry,
      type: "fellowship",
      remote: true,
      nigeria_eligible: classifyNigeriaEligibility(
        `${entry.name ?? ""} ${entry.description ?? ""}`,
      ),
      source: "playwright_lfx",
      reviewed: false,
    });
  }

  console.log(`[lfx] upserted ${entries.length} entries`);
} catch (err) {
  console.error("[lfx] failed:", err);
  process.exit(1);
} finally {
  await browser.close();
}
