import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { extractGsocEntries } from "./gsoc_extract.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
const fixture = readFileSync(join(__dirname, "__fixtures__/gsoc.html"), "utf8");

describe("extractGsocEntries", () => {
  it("extracts organisations from fixture", () => {
    const entries = extractGsocEntries(fixture);
    assert.equal(entries.length, 2);
    assert.equal(entries[0].name, "KDE Community");
    assert.equal(
      entries[0].url,
      "https://summerofcode.withgoogle.com/2026/org/kde",
    );
  });
});
