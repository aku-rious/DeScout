/**
 * Extract DoraHacks listings from rendered HTML (Playwright page content).
 * @param {string} html
 * @returns {Array<{name: string, url: string, description?: string}>}
 */
export function extractDoraHacksEntries(html) {
  const entries = [];
  const seen = new Set();
  const linkRegex =
    /<a[^>]*href="\/hackathon\/([a-z0-9-]+)\/?"[^>]*>([\s\S]*?)<\/a>/gi;
  let match;

  while ((match = linkRegex.exec(html)) !== null) {
    const slug = match[1];
    if (slug === "hackathon" || seen.has(slug)) continue;
    seen.add(slug);
    const inner = match[2].replace(/<[^>]+>/g, " ").replace(/\s+/g, " ").trim();
    const name = inner || slugToTitle(slug);
    entries.push({
      name,
      url: `https://dorahacks.io/hackathon/${slug}/`,
      description: inner,
    });
  }

  return entries;
}

function slugToTitle(slug) {
  return slug
    .split("-")
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(" ");
}
