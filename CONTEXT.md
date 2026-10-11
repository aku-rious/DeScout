# DeScout — Agent Context

Domain glossary and architecture decisions for automated programme ingestion (v0.3).

## Glossary

| Term | Meaning |
|------|---------|
| **Tier 1** | One-off manual seed from `data/seed/programmes_seed.json` via Supabase MCP. May set `reviewed: true`. |
| **Tier 2** | Structured feeds (Devpost JSON API, DoraHacks HTML SSR, MLH iCal) via **Supabase Edge Functions** invoked daily by **pg_cron**. |
| **Tier 3** | Playwright browser scrapes (LFX, GSoC, Outreachy, Hyperledger, LFN, DoraHacks) via **GitHub Actions** weekly. |
| **Tier 4** | Programme discovery via **Edge Function** (`ingest-custom-search`). **Deferred** on project — Google CSE blocked for new GCP projects. |
| **`reviewed`** | `false` on every Tier 2–4 upsert. Admin sets `true` in the review queue. Never set `true` from ingestion. |
| **`source`** | Provenance tag on `programmes`. Must match values in `.cursor/rules/ingestion.mdc` exactly. |
| **`upsert`** | Insert or update on `url` conflict. Never create duplicate URLs. |
| **`nigeria_eligible`** | `true` if eligibility text matches heuristic keywords; `null` if unknown. Never `false` from ingestion. |
| **Review queue** | Admin screen showing `reviewed = false` entries. Existing Flutter feature — ingestion feeds it. |
| **Exchange rate** | USD→NGN row in `exchange_rates`; `source` is `'api'` (Frankfurter cron) or `'admin'` (manual override). |
| **Community tip** | Short applicant advice (`programme_tips`), 10–280 chars; public read, auth insert own. |
| **Custom reminder** | Per-saved-programme override of `users.notification_days_before` via `saved_programmes.custom_reminder_days`. |

## ADRs

### ADR-001: Tier 2/4 live in Edge Functions, not `scripts/`

**Status:** Accepted

Tier 2 (Devpost, DoraHacks, MLH) and Tier 4 (Custom Search) run as Deno Edge Functions under `supabase/functions/`, scheduled via pg_cron + pg_net. Tier 3 stays in `scripts/ingest/` as Playwright Node scripts.

Supersedes Tier 2 script paths previously shown in `ingestion.mdc` / `ARCHITECTURE.md`.

### ADR-002: Service role key placement

**Status:** Accepted

`SUPABASE_SERVICE_ROLE_KEY` appears only in:

1. Supabase Edge Function Secrets (Dashboard)
2. GitHub Actions repository secrets

Single factories:

- `supabase/functions/_shared/supabase_admin.ts` (Deno)
- `scripts/lib/supabase_client.mjs` (Node)

Never in Flutter code, committed files, or chat.

### ADR-003: MLH fetch strategy

**Status:** Accepted

1. Primary: `https://mlh.io/mlh-hackathon-2026-ical.ics` parsed with `ical.js`
2. Fallback: HTML at `https://mlh.io/seasons/2026/events` via `deno_dom`
3. On total failure: HTTP 500 `{ ok: false, error }` — never silent success

### ADR-004: Gitignored Supabase artifacts

**Status:** Accepted

`supabase/functions/` and `supabase/migrations/` are gitignored. Code is authored locally and deployed via Supabase CLI or MCP. Post-deploy changes recorded in `CHANGES.md`.

### ADR-005: CI lockfile policy

**Status:** Accepted

`package-lock.json` is gitignored repo-wide. GitHub Actions uses `npm install` with caret-pinned deps in `scripts/package.json`.

### ADR-006: DoraHacks Edge Function is best-effort only

**Status:** Accepted

DoraHacks sits behind AWS WAF. The retired REST API returns 404; the Edge Function uses HTML SSR discovery with browser headers. Outcomes:

- **~5 featured hackathons** when WAF allows datacenter IPs (verified 2026-09-01)
- `{ ok: true, count: 0, skipped: true, reason: "waf_blocked" }` when WAF serves "Human Verification"

The **weekly Playwright scraper** (`dorahacks_scrape.mjs`) is the authoritative source for the full catalog.

### ADR-007: Tier 4 discovery deferred (Google CSE blocked)

**Status:** Accepted (deferred)

Google closed the Custom Search JSON API to new GCP customers (sunset Jan 1, 2027). Supabase project function returns `403 PERMISSION_DENIED` ("This project does not have the access to Custom Search JSON API") regardless of billing or API enablement.

**Decision:** Defer Tier 4 until a replacement provider is chosen. Candidates under evaluation: **SerpAPI**, **Vertex AI Search**. `ingest-custom-search` stays deployed for legacy GCP access but the daily cron is non-operational on this project until migration.

**Do not assume Brave Search API** — evaluated as paid for this use case.

## TDD seams

| Seam | Deno | Node |
|------|------|------|
| `classifyNigeriaEligibility(text)` | `_shared/nigeria_heuristic.ts` | `lib/nigeria_heuristic.mjs` |
| `upsertProgramme(data)` | `_shared/upsert.ts` | `lib/upsert.mjs` |
| Feed mappers | per-function `*_test.ts` + fixtures | per-scraper `extractEntries(html)` + fixtures |

Live HTTP fetches and real Supabase writes are validated manually or via `workflow_dispatch`.
