import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { extractHyperledgerEntries } from "./wiki_extract.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
const fixture = readFileSync(join(__dirname, "__fixtures__/hyperledger.html"), "utf8");

describe("extractHyperledgerEntries", () => {
  it("extracts wiki table row", () => {
    const entries = extractHyperledgerEntries(fixture);
    assert.equal(entries.length, 1);
    assert.ok(entries[0].name.includes("Hyperledger Fabric Tooling"));
    assert.equal(entries[0].stipend_usd, 3000);
  });
});
