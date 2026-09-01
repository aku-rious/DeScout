import { chromium } from "@playwright/test";
import { upsertProgramme } from "../lib/upsert.mjs";
import { classifyNigeriaEligibility } from "../lib/nigeria_heuristic.mjs";
import { extractDoraHacksEntries } from "./dorahacks_extract.mjs";

const TARGET_URL = "https://dorahacks.io/hackathon";

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage();

try {
  await page.goto(TARGET_URL, { waitUntil: "networkidle", timeout: 60000 });

  // Scroll to load lazy-rendered hackathon cards.
  for (let i = 0; i < 5; i++) {
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await page.waitForTimeout(1500);
  }

  const html = await page.content();
  const entries = extractDoraHacksEntries(html);

  if (entries.length === 0) {
    throw new Error("[dorahacks] no hackathon cards found after page load");
  }

  for (const entry of entries) {
    await upsertProgramme({
      ...entry,
      type: "hackathon",
      remote: true,
      nigeria_eligible: classifyNigeriaEligibility(
        `${entry.name ?? ""} ${entry.description ?? ""}`,
      ),
      source: "dorahacks_api",
      reviewed: false,
    });
  }

  console.log(`[dorahacks] upserted ${entries.length} entries`);
} catch (err) {
  console.error("[dorahacks] failed:", err);
  process.exit(1);
} finally {
  await browser.close();
}
