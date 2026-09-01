import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { extractOutreachyEntries } from "./outreachy_extract.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
const fixture = readFileSync(join(__dirname, "__fixtures__/outreachy.html"), "utf8");

describe("extractOutreachyEntries", () => {
  it("extracts internship round from fixture", () => {
    const entries = extractOutreachyEntries(fixture);
    assert.equal(entries.length, 1);
    assert.equal(entries[0].name, "Outreachy — May 2026 to August 2026 Internships");
    assert.ok(entries[0].url.includes("outreachy.org"));
  });
});
