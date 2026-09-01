/** @param {string} html */
export function extractOutreachyEntries(html) {
  const entries = [];
  const roundRegex =
    /<h2[^>]*class="round-title"[^>]*>([^<]+)<\/h2>[\s\S]*?<p[^>]*class="round-dates"[^>]*>([^<]*)<\/p>[\s\S]*?<a[^>]*class="round-link"[^>]*href="([^"]+)"/gi;
  let match;
  while ((match = roundRegex.exec(html)) !== null) {
    const [, title, datesText, url] = match;
    const opensMatch = datesText.match(/(\w+ \d+, \d{4}) to (\w+ \d+, \d{4})/i);
    entries.push({
      name: `Outreachy — ${title.trim()}`,
      url,
      description: datesText.trim(),
      opens_at: opensMatch ? new Date(opensMatch[1]).toISOString() : null,
      closes_at: opensMatch ? new Date(opensMatch[2]).toISOString() : null,
      stipend_usd: 7000,
    });
  }
  return entries;
}
