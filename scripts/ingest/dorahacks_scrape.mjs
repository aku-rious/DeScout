import { chromium } from "@playwright/test";
import { upsertProgramme } from "../lib/upsert.mjs";
import { requireSupabaseEnv } from "../lib/require_env.mjs";
import { classifyNigeriaEligibility } from "../lib/nigeria_heuristic.mjs";
import {
  extractDoraHacksEntries,
  isWafChallengeHtml,
} from "./dorahacks_extract.mjs";

requireSupabaseEnv("dorahacks");

const TARGET_URL = "https://dorahacks.io/hackathon";
const BROWSER_UA =
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126 Safari/537.36";

const browser = await chromium.launch({ headless: true });
const context = await browser.newContext({
  userAgent: BROWSER_UA,
  viewport: { width: 1280, height: 720 },
  locale: "en-US",
});
const page = await context.newPage();

try {
  await page.goto(TARGET_URL, { waitUntil: "domcontentloaded", timeout: 60000 });
  await page.waitForLoadState("networkidle", { timeout: 30000 }).catch(() => {});

  await page
    .waitForSelector('a[href*="/hackathon/"]', { timeout: 20000 })
    .catch(() => {});

  for (let i = 0; i < 5; i++) {
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await page.waitForTimeout(1500);
  }

  const html = await page.content();

  if (isWafChallengeHtml(html)) {
    console.warn(
      "[dorahacks] AWS WAF blocked this runner — skipping (Edge Function may still ingest ~5 featured)",
    );
    process.exit(0);
  }

  const entries = extractDoraHacksEntries(html);

  if (entries.length === 0) {
    throw new Error(
      "[dorahacks] no hackathon slugs found after page load (page may have changed layout)",
    );
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
    });
  }

  console.log(`[dorahacks] upserted ${entries.length} entries`);
} catch (err) {
  console.error("[dorahacks] failed:", err);
  process.exit(1);
} finally {
  await context.close();
  await browser.close();
}
