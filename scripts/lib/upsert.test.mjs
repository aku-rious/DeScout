import { describe, it, mock } from "node:test";
import assert from "node:assert/strict";

describe("upsertProgramme", () => {
  it("forces reviewed false and upserts on url conflict", async () => {
    let capturedRow = null;
    let capturedOpts = null;

    const fakeClient = {
      from: (_table) => ({
        upsert: (row, opts) => {
          capturedRow = row;
          capturedOpts = opts;
          return Promise.resolve({ error: null });
        },
      }),
    };

    const { upsertProgramme } = await import("./upsert.mjs");

    await upsertProgramme(
      {
        name: "Test",
        url: "https://example.com",
        type: "hackathon",
        source: "playwright_lfx",
        reviewed: true,
      },
      fakeClient,
    );

    assert.equal(capturedRow.reviewed, false);
    assert.equal(capturedRow.name, "Test");
    assert.equal(capturedOpts.onConflict, "url");
  });

  it("exits with code 1 on Supabase error", async () => {
    const fakeClient = {
      from: (_table) => ({
        upsert: () =>
          Promise.resolve({ error: { message: "permission denied" } }),
      }),
    };

    const exitMock = mock.method(process, "exit", () => {});

    const { upsertProgramme } = await import("./upsert.mjs");

    await upsertProgramme(
      {
        name: "Fail",
        url: "https://example.com/fail",
        type: "programme",
        source: "custom_search",
      },
      fakeClient,
    );

    assert.equal(exitMock.mock.callCount(), 1);
    assert.equal(exitMock.mock.calls[0].arguments[0], 1);
    exitMock.mock.restore();
  });
});
