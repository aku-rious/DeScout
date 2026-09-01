/** @param {string} html */
export function extractWikiTableEntries(html, baseLabel) {
  const entries = [];
  const rowRegex =
    /<tr>[\s\S]*?<a[^>]*href="([^"]+)"[^>]*>([^<]+)<\/a>[\s\S]*?<td>([^<]*)<\/td>[\s\S]*?<td>([^<]*)<\/td>[\s\S]*?<\/tr>/gi;
  let match;
  while ((match = rowRegex.exec(html)) !== null) {
    const [, url, name, description, stipendText] = match;
    const stipendMatch = stipendText.match(/[\d,]+/);
    entries.push({
      name: `${baseLabel}: ${name.trim()}`,
      url,
      description: description.trim(),
      stipend_usd: stipendMatch
        ? Number(stipendMatch[0].replace(/,/g, ""))
        : null,
    });
  }
  return entries;
}

export function extractHyperledgerEntries(html) {
  return extractWikiTableEntries(html, "Hyperledger Mentorship");
}

export function extractLfnEntries(html) {
  return extractWikiTableEntries(html, "LFN Mentorship");
}
