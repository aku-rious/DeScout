# Changelog

## v0.1 scaffold (2026-07-18)

- Feature-first `lib/src/` folder tree with placeholder files per ARCHITECTURE.md
- Core wiring: theme (`app_theme.dart`), router (`routes.dart`, `app_router.dart`), Supabase (`supabase_init.dart`, `supabase_client.dart`, `table_names.dart`), notifications abstraction
- Riverpod `@riverpod` providers with `build_runner` codegen
- Auth state stream, `isAdmin` provider chain, router redirect guards
- Three flavor entry points: `main_standard.dart`, `main_fdroid.dart`, `main_huawei.dart`
- Sentry bootstrap per flavor; `NotificationService` overridden per entry point
- Settings feature folder and `/settings` route
- `prefer_double_quotes` lint enabled
- Documentation: ARCHITECTURE.md, flutter.mdc, conventions.mdc, AGENTS.md rewrite, `docs/PRD.md`
- Removed default Flutter counter `main.dart` and `widget_test.dart`

GitHub epic: [#1](https://github.com/aku-rious/DeScout/issues/1)

## v0.1 features (2026-07-18)

- Applied initial schema to Supabase project `DeScout` via MCP (`supabase/migrations/20260718000000_initial_schema.sql`)
- Seeded 8 reviewed programmes for development
- `database_types.dart` populated from MCP `generate_typescript_types`
- Programmes browse: list, filter sheet, detail screen, deadline badges
- Auth: email/password sign-in, sign-up, sign-out; `isCurrentUserAdmin()` queries `users` table
- Settings screen with sign-out
- Added `url_launcher` for programme URLs

## v0.1 seed + polish (2026-07-18)

- Tier-1 seed: `data/seed/programmes_seed.json` (19 programmes); uploaded via Supabase MCP
- Removed one-off `scripts/seed/` and `scripts/lib/` after seeding; Tier 2+ crons add `scripts/` back in v0.3
- `ingestion.mdc`: Tier-1 via MCP `execute_sql`; `reviewed: true` for manual seed
- Programmes list: empty state with bookmark icon + Clear filters
- Programme detail: `DeadlineBadge` `nullLabel` → "Deadline TBA" when no deadline
- Auth: login redirect preserves `from` query param for protected routes
- Tests: router redirect, empty state, detail TBA chip (`test/`)

GitHub slices: [#9](https://github.com/aku-rious/DeScout/issues/9)–[#15](https://github.com/aku-rious/DeScout/issues/15) (closed) · PRD in `docs/PRD.md`

## Error handling + Talker (2026-07-18)

- Copyright holder renamed to **Polymath** (was in conventions template)
- Centralised `DeScoutException`, `ErrorMapper`, `ErrorReporter` (Talker + Sentry)
- `AsyncErrorView` for user-safe async error UI
- Talker overlay in debug; Settings → Diagnostics for admins in prod
- Dependencies: `talker`, `talker_flutter`

## v0.2 save, push, auth (2026-07-26)

- Saved programmes: `SavedRepository` with Realtime stream, `ApplicationStatus`, notes, bookmark UI
- Saved tab: pipeline sections (Interested → Applied → Accepted → Rejected), swipe-to-unsave with undo
- Unreviewed programme placeholder cards (Option B) when RLS blocks joined programme data
- Bottom nav shell: Programmes / Saved / Settings via `StatefulShellRoute`
- Auth polish: register honors `?from=`; bookmark SnackBar Sign in passes current URI
- OneSignal (standard flavor): init, permission after first save, deep link via `programme_id`
- Settings: notification days dropdown (3/5/7/14), enable-notifications tile when denied
- `UserSettingsRepository` for `users.notification_days_before` and `push_flavor`
- Dependencies: `onesignal_flutter`, `shared_preferences`
- Tests: `saved_repository_test.dart`; router shell + settings redirect tests

## v0.3 admin review queue + community submit (2026-07-31)

- Admin review queue: `AdminRepository` invokes Edge Functions (`admin_fetch_unreviewed`, `admin_update_programme`); approve, reject (with confirm dialog), edit-then-approve sheet
- `ReviewQueueScreen` with source badges, pull-to-refresh, empty state
- Community submit: `SubmitRepository` inserts `reviewed=false`, `source=community` via RLS; duplicate URL friendly message
- `SubmitProgrammeScreen` with required type, guest sign-in prompt; FAB on Programmes + Settings tile
- Supabase: community INSERT policy migration; Edge Functions deployed to DeScout project
- Tests: `submit_repository_test.dart`, `admin_repository_test.dart`; router admin/submit guard tests

## v0.3 automated ingestion (2026-08-09)

- **CONTEXT.md** — ingestion glossary and ADRs (Tier 2/4 Edge Functions, service-role seam, MLH iCal-first)
- **Tier 2 Edge Functions** (gitignored, deploy via MCP): `ingest-devpost`, `ingest-dorahacks`, `ingest-mlh`
- **Tier 4 Edge Function**: `ingest-custom-search` (5 sequential CSE queries/day)
- **Shared library**: `supabase/functions/_shared/` (`supabase_admin`, `nigeria_heuristic`, `upsert`)
- **pg_cron**: `supabase/migrations/20260809000000_cron_jobs.sql` — daily 06:00–07:00 UTC
- **Tier 3 Playwright**: `scripts/ingest/` (LFX, GSoC, Outreachy, Hyperledger, LFN) + fixture-tested extractors
- **GitHub Actions**: `.github/workflows/ingest_playwright.yml` — Mondays 08:00 UTC
- All Tier 2–4 upserts force `reviewed: false`; upsert on `url` conflict
- Node tests: `scripts/lib/*.test.mjs`, `scripts/ingest/*.test.mjs` (16 passing)

**Deploy checklist (manual):**
1. Set Edge Function secrets: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `GOOGLE_CSE_API_KEY`, `GOOGLE_CSE_CX`
2. Deploy functions via Supabase MCP/CLI
3. Replace `<ANON_KEY>` in cron migration and apply
4. Add `SUPABASE_URL` + `SUPABASE_SERVICE_ROLE_KEY` to GitHub Actions secrets

## v0.3 ingestion verification (2026-09-01)

Production Edge Function smoke tests (on Supabase project):

| Function | Result | Notes |
|----------|--------|-------|
| `ingest-devpost` | `{ ok: true, count: 61 }` | JSON API (`/api/hackathons?status[]=open`); Atom feed returns 406 |
| `ingest-dorahacks` | `{ ok: true, count: 5 }` | HTML SSR fallback (~featured set); WAF may intermittently block → `{ skipped: true, reason: "waf_blocked" }` |
| `ingest-mlh` | `{ ok: true, count: 1 }` | iCal primary |
| `ingest-custom-search` | `CSE_ACCESS_DENIED` | Google closed Custom Search JSON API to new GCP projects |

**Feed fixes deployed:**
- Devpost v2: Atom → JSON API
- DoraHacks v5: legacy API graceful fallback, HTML SSR, WAF detection + skip (no 500 on block)
- Custom Search v3: surfaces Google error body + `CSE_ACCESS_DENIED` hint

**Tier 4 status:** Deferred. `ingest-custom-search` remains deployed but fails on this GCP project. Replacement provider (SerpAPI or Vertex AI Search) to be chosen before re-enabling discovery cron.

**DoraHacks full catalog:** Weekly Playwright (`dorahacks_scrape.mjs` in `.github/workflows/ingest_playwright.yml`) — authoritative when Edge Function sees WAF or partial SSR.

**Next:** Run `workflow_dispatch` on Tier 3 Playwright workflow; review admin queue for `reviewed = false` rows.
