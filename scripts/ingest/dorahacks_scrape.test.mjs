import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { extractDoraHacksEntries } from "./dorahacks_extract.mjs";

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
});
