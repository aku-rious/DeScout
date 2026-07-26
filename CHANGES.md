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

