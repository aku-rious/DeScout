const SLUG_BLOCKLIST = new Set([
  "hackathon",
  "hackathons",
  "hackathon-organizer-guide",
]);

/**
 * Extract DoraHacks listings from rendered HTML (Playwright page content).
 * Uses anchor tags when present, then falls back to slug paths in SSR/NUXT payload.
 * @param {string} html
 * @returns {Array<{name: string, url: string, description?: string}>}
 */
export function extractDoraHacksEntries(html) {
  /** @type {Map<string, {name: string, url: string, description: string}>} */
  const bySlug = new Map();

  const linkRegex =
    /<a[^>]*href="\/hackathon\/([a-z0-9-]+)\/?"[^>]*>([\s\S]*?)<\/a>/gi;
  let match;

  while ((match = linkRegex.exec(html)) !== null) {
    const slug = match[1];
    if (SLUG_BLOCKLIST.has(slug)) continue;
    const inner = match[2].replace(/<[^>]+>/g, " ").replace(/\s+/g, " ").trim();
    bySlug.set(slug, {
      name: inner || slugToTitle(slug),
      url: `https://dorahacks.io/hackathon/${slug}/`,
      description: inner,
    });
  }

  const slugPattern = /\/hackathon\/([a-z0-9-]+)\//g;
  while ((match = slugPattern.exec(html)) !== null) {
    const slug = match[1];
    if (SLUG_BLOCKLIST.has(slug) || bySlug.has(slug)) continue;
    bySlug.set(slug, {
      name: slugToTitle(slug),
      url: `https://dorahacks.io/hackathon/${slug}/`,
      description: "",
    });
  }

  return [...bySlug.values()];
}

/** True when page HTML is an AWS WAF challenge (no programme data). */
export function isWafChallengeHtml(html) {
  return (
    /<title>\s*Human Verification\s*<\/title>/i.test(html) ||
    html.includes("window.gokuProps")
  );
}

function slugToTitle(slug) {
  return slug
    .split("-")
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(" ");
}
