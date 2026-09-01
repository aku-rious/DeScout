/**
 * Extract LFX mentorship projects from rendered HTML.
 * @param {string} html
 * @returns {Array<{name: string, url: string, description?: string, stipend_usd?: number|null}>}
 */
export function extractLfxEntries(html) {
  const entries = [];
  const cardRegex =
    /<a[^>]*class="project-title"[^>]*href="([^"]+)"[^>]*>([^<]+)<\/a>[\s\S]*?<p[^>]*class="project-description"[^>]*>([^<]*)<\/p>[\s\S]*?<span[^>]*class="stipend"[^>]*>([^<]*)<\/span>/gi;
  let match;
  while ((match = cardRegex.exec(html)) !== null) {
    const [, path, name, description, stipendText] = match;
    const url = path.startsWith("http")
      ? path
      : `https://mentorship.lfx.linuxfoundation.org${path}`;
    const stipendMatch = stipendText.match(/[\d,]+/);
    const stipend_usd = stipendMatch
      ? Number(stipendMatch[0].replace(/,/g, ""))
      : null;
    entries.push({ name: name.trim(), url, description: description.trim(), stipend_usd });
  }
  return entries;
}
