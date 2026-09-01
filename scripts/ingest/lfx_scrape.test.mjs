import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { extractLfxEntries } from "./lfx_extract.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
const fixture = readFileSync(join(__dirname, "__fixtures__/lfx.html"), "utf8");

describe("extractLfxEntries", () => {
  it("extracts name and url from fixture", () => {
    const entries = extractLfxEntries(fixture);
    assert.equal(entries.length, 2);
    assert.equal(entries[0].name, "Sample Kernel Driver");
    assert.equal(
      entries[0].url,
      "https://mentorship.lfx.linuxfoundation.org/project/sample-kernel",
    );
    assert.equal(entries[0].stipend_usd, 6000);
  });
});
