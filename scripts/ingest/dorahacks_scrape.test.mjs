import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { extractDoraHacksEntries, isWafChallengeHtml } from "./dorahacks_extract.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
const fixture = readFileSync(
  join(__dirname, "__fixtures__/dorahacks.html"),
  "utf8",
);

describe("extractDoraHacksEntries", () => {
  it("extracts hackathon links from fixture HTML", () => {
    const entries = extractDoraHacksEntries(fixture);
    assert.equal(entries.length, 2);
    assert.equal(entries[0].url, "https://dorahacks.io/hackathon/weex-ai-wars2/");
    assert.ok(entries[0].name.length > 0);
  });

  it("extracts slugs from NUXT SSR paths without anchor tags", () => {
    const html = `
      <script id="__NUXT_DATA__">["/hackathon/weex-ai-wars2/","/hackathon/buidl-ctc-2026-fall/"]</script>
    `;
    const entries = extractDoraHacksEntries(html);
    assert.equal(entries.length, 2);
    assert.equal(entries[1].name, "Buidl Ctc 2026 Fall");
  });

  it("detects AWS WAF challenge HTML", () => {
    assert.equal(isWafChallengeHtml("<title>Human Verification</title>"), true);
    assert.equal(isWafChallengeHtml(fixture), false);
  });
});
