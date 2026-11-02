import assert from "node:assert/strict";
import { describe, it } from "node:test";

describe("upsertProgramme", () => {
  it("strips moderation_status and reviewed before upsert", async () => {
    let capturedRow;
    const fakeClient = {
      from(table) {
        assert.equal(table, "programmes");
        return {
          select() {
            return {
              eq() {
                return { maybeSingle: async () => ({ data: null, error: null }) };
              },
            };
          },
          upsert(row) {
            capturedRow = row;
            return {
              select() {
                return { maybeSingle: async () => ({ data: { id: "p1" }, error: null }) };
              },
            };
          },
        };
      },
    };

    const { upsertProgramme } = await import("./upsert.mjs");
    await upsertProgramme(
      {
        name: "Test",
        url: "https://example.com/t",
        type: "hackathon",
        source: "manual",
        moderation_status: "admin_verified",
        reviewed: true,
      },
      fakeClient,
    );

    assert.equal(capturedRow.moderation_status, undefined);
    assert.equal(capturedRow.reviewed, undefined);
    assert.equal(capturedRow.name, "Test");
  });
});
