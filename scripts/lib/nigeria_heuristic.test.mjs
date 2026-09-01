import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { classifyNigeriaEligibility } from "./nigeria_heuristic.mjs";

describe("classifyNigeriaEligibility", () => {
  it("returns true for worldwide keyword", () => {
    assert.equal(classifyNigeriaEligibility("Open worldwide to students"), true);
  });

  it("returns true for global keyword case-insensitive", () => {
    assert.equal(classifyNigeriaEligibility("GLOBAL hackathon"), true);
  });

  it("returns true for open to all", () => {
    assert.equal(
      classifyNigeriaEligibility("This programme is open to all developers"),
      true,
    );
  });

  it("returns true for international", () => {
    assert.equal(classifyNigeriaEligibility("International fellowship 2026"), true);
  });

  it("returns true for africa", () => {
    assert.equal(classifyNigeriaEligibility("Developers across Africa welcome"), true);
  });

  it("returns true for nigeria", () => {
    assert.equal(classifyNigeriaEligibility("Remote roles in Nigeria"), true);
  });

  it("returns true for sub-saharan", () => {
    assert.equal(classifyNigeriaEligibility("Sub-Saharan Africa eligible"), true);
  });

  it("returns null when no keyword matches", () => {
    assert.equal(classifyNigeriaEligibility("US residents only"), null);
  });

  it("returns null for empty string", () => {
    assert.equal(classifyNigeriaEligibility(""), null);
  });
});
