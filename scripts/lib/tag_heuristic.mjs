/**
 * Keyword rules → tag slugs (aligned with SCHEMA.md seed tags).
 * @param {{ name?: string, description?: string, url?: string }} programme
 * @returns {string[]}
 */
export function inferTagSlugs(programme) {
  const text = [
    programme.name ?? "",
    programme.description ?? "",
    programme.url ?? "",
  ]
    .join(" ")
    .toLowerCase();

  /** @type {string[]} */
  const slugs = [];

  const rules = [
    { slug: "blockchain", keywords: ["blockchain", "web3", "crypto", "hyperledger"] },
    { slug: "hyperledger", keywords: ["hyperledger"] },
    { slug: "open-source", keywords: ["open source", "open-source", "gsoc", "outreachy", "lf mentorship"] },
    { slug: "google", keywords: ["google", "gsoc"] },
    { slug: "linux", keywords: ["linux", "kernel", "lf networking"] },
    { slug: "students-only", keywords: ["student", "university", "college"] },
    { slug: "mobile", keywords: ["mobile", "android", "ios", "flutter"] },
    { slug: "web", keywords: ["web", "frontend", "full stack"] },
    { slug: "ai-ml", keywords: ["ai", "machine learning", "ml", "llm", "data science"] },
    { slug: "design", keywords: ["design", "ui", "ux", "figma"] },
    { slug: "devops", keywords: ["devops", "kubernetes", "cloud", "infrastructure"] },
  ];

  for (const { slug, keywords } of rules) {
    if (keywords.some((kw) => text.includes(kw))) {
      slugs.push(slug);
    }
  }

  return [...new Set(slugs)];
}
