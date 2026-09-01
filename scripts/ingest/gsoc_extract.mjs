/** @param {string} html */
export function extractGsocEntries(html) {
  const entries = [];
  const cardRegex =
    /<a[^>]*href="(\/2026\/org\/[^"]+)"[^>]*>([^<]+)<\/a>[\s\S]*?<p[^>]*class="org-desc"[^>]*>([^<]*)<\/p>/gi;
  let match;
  while ((match = cardRegex.exec(html)) !== null) {
    const [, path, name, description] = match;
    entries.push({
      name: name.trim(),
      url: `https://summerofcode.withgoogle.com${path}`,
      description: description.trim(),
      stipend_usd: 6000,
    });
  }
  return entries;
}
