// Listing data is rendered client-side (Next.js); Playwright is required — plain fetch has no entries.
import { chromium } from "@playwright/test";
import { upsertProgramme } from "../lib/upsert.mjs";
import { requireSupabaseEnv } from "../lib/require_env.mjs";
import { classifyNigeriaEligibility } from "../lib/nigeria_heuristic.mjs";

requireSupabaseEnv("wemakedevs");

const TARGETS = [
  { url: "https://wemakedevs.org/hackathons", type: "hackathon" },
  { url: "https://wemakedevs.org/scholarships", type: "programme" },
];

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage();

try {
  let total = 0;

  for (const target of TARGETS) {
    await page.goto(target.url, { waitUntil: "domcontentloaded", timeout: 60000 });
    await page.waitForTimeout(3000);

    const entries = await page.evaluate(() => {
      const results = [];
      const anchors = document.querySelectorAll("a[href]");
      for (const anchor of anchors) {
        const href = anchor.getAttribute("href") ?? "";
        const text = (anchor.textContent ?? "").trim();
        if (!text || text.toLowerCase().includes("meetup")) {
          continue;
        }
        if (
          href.includes("/hackathon/") ||
          href.includes("/scholarship/") ||
          href.includes("/event/")
        ) {
          const url = href.startsWith("http")
            ? href
            : `https://wemakedevs.org${href.startsWith("/") ? href : `/${href}`}`;
          results.push({ name: text, url });
        }
      }
      const byUrl = new Map();
      for (const row of results) {
        byUrl.set(row.url, row);
      }
      return [...byUrl.values()];
    });

    for (const entry of entries) {
      await upsertProgramme({
        name: entry.name,
        url: entry.url,
        type: target.type,
        source: "playwright_wemakedevs",
        remote: true,
        nigeria_eligible: classifyNigeriaEligibility(entry.name),
        description: `WeMakeDevs ${target.type} listing.`,
      });
      total += 1;
    }

    console.log(`[wemakedevs] ${target.url} → ${entries.length} entries`);
  }

  console.log(`[wemakedevs] upserted ${total} entries total`);
} catch (err) {
  console.error("[wemakedevs] failed:", err);
  process.exit(1);
} finally {
  await browser.close();
}
