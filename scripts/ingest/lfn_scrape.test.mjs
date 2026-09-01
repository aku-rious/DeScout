import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { extractLfnEntries } from "./wiki_extract.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
const fixture = readFileSync(join(__dirname, "__fixtures__/lfn.html"), "utf8");

describe("extractLfnEntries", () => {
  it("extracts wiki table row", () => {
    const entries = extractLfnEntries(fixture);
    assert.equal(entries.length, 1);
    assert.ok(entries[0].name.includes("ONAP Integration"));
    assert.equal(entries[0].stipend_usd, 6000);
  });
});
