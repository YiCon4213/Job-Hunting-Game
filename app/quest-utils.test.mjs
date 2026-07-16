import assert from "node:assert/strict";
import test from "node:test";

const utils = await import("../tmp/quest-utils/quest-utils.js");

test("accepts only BOSS job-detail HTTPS links", () => {
  assert.equal(utils.isBossJobUrl("https://www.zhipin.com/job_detail/example.html?securityId=x"), true);
  assert.equal(utils.isBossJobUrl("https://example.com/job_detail/example.html"), false);
  assert.equal(utils.isBossJobUrl("javascript:alert(1)"), false);
});

test("creates spreadsheet-safe CSV text", () => {
  const csv = utils.toCsv([["企业", "任务情报"], ["=unsafe", "A, B\n\"quoted\""]]);
  assert.equal(csv, "企业,任务情报\r\n'=unsafe,\"A, B\n\"\"quoted\"\"\"");
});

test("filters exports by an optional inclusive date range", () => {
  const quests = [
    { appliedAt: "2026-07-15T09:00" },
    { appliedAt: "2026-07-16T09:00" },
    { appliedAt: "2026-07-17T09:00" },
  ];
  assert.deepEqual(utils.filterByAppliedDate(quests), quests);
  assert.deepEqual(utils.filterByAppliedDate(quests, "2026-07-16", "2026-07-16"), [quests[1]]);
  assert.deepEqual(utils.filterByAppliedDate(quests, "2026-07-16", "2026-07-17"), [quests[1], quests[2]]);
});