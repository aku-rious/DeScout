# DeScout — Product Requirements (v0.1 scaffold)

GitHub epic: [#1](https://github.com/aku-rious/DeScout/issues/1)

## Problem Statement

Finding remote, paid, Nigeria-eligible hackathons and open-source fellowships (GSoC, Outreachy, LFX, DoraHacks, Devpost, etc.) requires checking many sites manually. There is no single directory with eligibility filters, stipend filters, and deadline tracking for Nigerian developers.

## Solution

DeScout aggregates programmes into a Flutter mobile app with filtering, deadline badges, auth, saved programmes, and push notifications (per distribution flavor). Programme data is stored in Supabase and exposed as a public AGPL-licensed feed in later releases.

## User Stories

1. As a Nigerian developer, I want to browse reviewed programmes in one list, so that I do not visit ten websites daily.
2. As a developer, I want to filter by type, remote status, stipend, and Nigeria eligibility, so that I see only relevant opportunities.
3. As a developer, I want deadline urgency badges on programme cards, so that I know what closes soon.
4. As a developer, I want to sign in with email/password, so that I can save programmes across devices.
5. As a developer, I want push reminders before deadlines, so that I do not miss applications.
6. As a developer, I want to save programmes and track application status (v0.2), so that I manage my pipeline.
7. As an admin, I want a review queue for unreviewed ingested entries (v0.3), so that only verified programmes appear publicly.
8. As a community member, I want to submit programmes in-app (v0.3), so that the directory stays current.
9. As a developer, I want F-Droid and Huawei builds without Google Play dependencies, so that I can install from my preferred store.
10. As a developer, I want a settings screen, so that I can configure preferences in v0.2+.
11. As a developer, I want a feature-first codebase with clear layer boundaries, so that contributions are predictable.
12. As a developer, I want Riverpod codegen providers, so that state wiring is type-safe.
13. As a developer, I want go_router auth redirects, so that protected routes are enforced centrally.
14. As a developer, I want three flavor entry points with isolated push backends, so that F-Droid policy is respected.
15. As a developer, I want Supabase initialised via dart-define env vars, so that credentials are never hardcoded.
16. As a developer, I want Tables/Cols constants and generated database types, so that queries are typo-safe.
17. As a developer, I want DeScoutLightTheme/DeScoutDarkTheme wrapping the Material Theme Builder palette, so that UI is consistent.
18. As a developer, I want placeholder screens for every route in v0.1, so that navigation can be tested before feature UI.
19. As a developer, I want an isAdmin provider chain wired to the router, so that admin guards exist before v0.3 UI.
20. As a developer, I want AGENTS.md as an index to rule files, so that agents read one file then follow links.

## Implementation Decisions

- **v0.1 scope:** Scaffold only — folder tree, core plumbing, placeholder screens, no feature logic, no real push SDK calls.
- **Route map:** `/programmes` home; `/programmes/:id`; `/auth/login`; `/auth/register`; `/saved`; `/settings`; `/submit`; `/admin/review`; `/` redirects to `/programmes`.
- **Route constants:** `abstract final class Routes` in `routes.dart`.
- **Supabase:** `initSupabase()` in `supabase_init.dart`; env vars `DESCOUT_SUPABASE_URL`, `DESCOUT_SUPABASE_ANON_KEY`; PKCE auth; `@riverpod supabaseClient`.
- **Type safety:** `table_names.dart` for query strings; `database_types.dart` for generated row/enum shapes.
- **Riverpod:** `@riverpod` + `riverpod_generator` for all providers.
- **Admin guard:** `AuthRepository.isCurrentUserAdmin()` stub (returns false); `isAdminProvider`; router redirect on `/admin/review`.
- **Notifications:** `NotificationService` abstract class; flavor stubs; `notificationServiceProvider` overridden in each `main_*.dart`.
- **Theme:** `lib/theme.dart` unchanged; `app_theme.dart` exposes `DeScoutLightTheme`/`DeScoutDarkTheme` and `deadlineColour`; `deadline_utils.dart` has `classifyDeadline`.
- **Entry points:** Sentry → Supabase init → `ProviderScope` overrides → `DeScoutApp`. Shorebird TODO in `main_standard.dart` only.
- **Lint:** `prefer_double_quotes: true`.

### Scaffold child issues

| Issue | Slice |
|-------|-------|
| [#2](https://github.com/aku-rious/DeScout/issues/2) | Bootstrap deps, lint, codegen |
| [#3](https://github.com/aku-rious/DeScout/issues/3) | Theme + deadline utils |
| [#4](https://github.com/aku-rious/DeScout/issues/4) | Supabase init/client/types |
| [#5](https://github.com/aku-rious/DeScout/issues/5) | Auth + admin providers |
| [#6](https://github.com/aku-rious/DeScout/issues/6) | Router + placeholder screens |
| [#7](https://github.com/aku-rious/DeScout/issues/7) | Notifications + flavor entry points |
| [#8](https://github.com/aku-rious/DeScout/issues/8) | Documentation consolidation |

## Testing Decisions

- **Scaffold epic:** no automated tests (counter `widget_test.dart` removed).
- **Post-scaffold tracer bullets:** `classifyDeadline`/`deadlineColour` unit tests; router redirect widget tests; `DeScoutApp` smoke with provider overrides.
- Test public behavior only — not provider codegen internals.

## Out of Scope (v0.1 scaffold)

- Programmes list/filter/detail logic, real Supabase repository queries
- OneSignal / UnifiedPush / Huawei SDK integration, Shorebird init
- Android Gradle flavor wiring, CI workflows
- Bottom navigation shell, real admin review UI
- README Kibo→DeScout rename

## Further Notes

- Open product decisions: data licence (CC0 vs ODbL), Shorebird on Huawei, `users.push_flavor` column — see [SCHEMA.md](../SCHEMA.md) and [.cursor/rules/project.mdc](../.cursor/rules/project.mdc).
