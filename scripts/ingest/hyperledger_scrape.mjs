import { chromium } from "@playwright/test";
import { upsertProgramme } from "../lib/upsert.mjs";
import { classifyNigeriaEligibility } from "../lib/nigeria_heuristic.mjs";
import { extractHyperledgerEntries } from "./wiki_extract.mjs";

const TARGET_URL =
  "https://wiki.hyperledger.org/display/INTERN/Hyperledger+Mentorship+Program";

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage();

try {
  await page.goto(TARGET_URL, { waitUntil: "networkidle", timeout: 30000 });
  const html = await page.content();
  const entries = extractHyperledgerEntries(html);

  for (const entry of entries) {
    await upsertProgramme({
      ...entry,
      type: "fellowship",
      remote: true,
      nigeria_eligible: classifyNigeriaEligibility(
        `${entry.name ?? ""} ${entry.description ?? ""}`,
      ),
      source: "playwright_hyperledger",
      reviewed: false,
    });
  }

  console.log(`[hyperledger] upserted ${entries.length} entries`);
} catch (err) {
  console.error("[hyperledger] failed:", err);
  process.exit(1);
} finally {
  await browser.close();
}
