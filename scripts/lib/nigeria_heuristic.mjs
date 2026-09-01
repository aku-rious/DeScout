/**
 * Nigeria eligibility heuristic for Tier 3 Playwright scripts.
 * Mirror of supabase/functions/_shared/nigeria_heuristic.ts
 */

const KEYWORDS = [
  "worldwide",
  "global",
  "open to all",
  "international",
  "africa",
  "nigeria",
  "sub-saharan",
];

/**
 * @param {string} text
 * @returns {boolean | null}
 */
export function classifyNigeriaEligibility(text) {
  const lower = text.toLowerCase();
  for (const keyword of KEYWORDS) {
    if (lower.includes(keyword)) {
      return true;
    }
  }
  return null;
}
