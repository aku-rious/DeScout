# DeScout — Architecture

---

## Folder structure

```
DeScout/
├── .cursor/rules/               # Cursor AI rules (always read before generating)
├── .github/workflows/           # CI/CD + ingestion cron workflows
├── android/
│   └── app/
│       ├── src/
│       │   ├── standard/        # standard flavor assets (google-services.json)
│       │   ├── fdroid/          # fdroid flavor assets
│       │   └── huawei/          # huawei flavor assets (agconnect-services.json)
│       └── build.gradle         # productFlavors defined here
├── data/
│   └── seed/
│       └── internships_seed.json  # Tier 1 seed data parsed from internships.txt
├── docs/
│   └── PRD.md                   # full Product Requirements Document
├── ios/                         # CodeMagic builds iOS from here
├── lib/
│   ├── main_standard.dart       # entry: injects OneSignalNotificationService
│   ├── main_fdroid.dart         # entry: injects UnifiedPushNotificationService
│   ├── main_huawei.dart         # entry: injects HuaweiNotificationService
│   └── src/
│       ├── app.dart             # MaterialApp.router — theme + router
│       ├── features/
│       │   ├── programmes/
│       │   │   ├── data/
│       │   │   │   ├── programmes_repository.dart
│       │   │   │   └── programmes_remote_data_source.dart
│       │   │   ├── domain/
│       │   │   │   ├── programme.dart           # model + fromJson/toJson
│       │   │   │   ├── programme_type.dart      # enum: hackathon/fellowship/programme
│       │   │   │   ├── programme_status.dart    # enum: open/upcoming/closed/unknown
│       │   │   │   └── filter_state.dart        # value object for active filters
│       │   │   └── presentation/
│       │   │       ├── programmes_list_screen.dart
│       │   │       ├── programme_detail_screen.dart
│       │   │       ├── programmes_filter_sheet.dart
│       │   │       └── providers/
│       │   │           ├── programmes_provider.dart
│       │   │           └── filter_provider.dart
│       │   ├── auth/
│       │   │   ├── data/auth_repository.dart
│       │   │   └── presentation/
│       │   │       ├── login_screen.dart
│       │   │       ├── register_screen.dart
│       │   │       └── providers/auth_provider.dart
│       │   ├── saved/
│       │   │   ├── data/saved_repository.dart
│       │   │   └── presentation/
│       │   │       ├── saved_screen.dart
│       │   │       └── providers/saved_provider.dart
│       │   ├── notifications/
│       │   │   └── presentation/
│       │   │       └── providers/notification_provider.dart
│       │   ├── admin/
│       │   │   └── presentation/
│       │   │       ├── review_queue_screen.dart
│       │   │       └── providers/review_queue_provider.dart
│       │   └── submit/
│       │       └── presentation/
│       │           └── submit_programme_screen.dart
│       └── core/
│           ├── notifications/
│           │   ├── notification_service.dart               # abstract interface
│           │   ├── onesignal_notification_service.dart
│           │   ├── unified_push_notification_service.dart
│           │   └── huawei_notification_service.dart
│           ├── router/
│           │   ├── app_router.dart                         # GoRouter instance
│           │   └── app_routes.dart                         # route name constants
│           ├── supabase/
│           │   ├── supabase_init.dart                      # Supabase.initialize()
│           │   ├── database_types.dart                     # generated types
│           │   └── table_names.dart                        # Tables + Cols constants
│           ├── theme/
│           │   └── app_theme.dart                          # MaterialTheme class
│           └── utils/
│               ├── date_utils.dart
│               ├── deadline_utils.dart                     # DeadlineState classifier
│               └── constants.dart
├── scripts/
│   ├── seed/parse_internships.py
│   ├── ingest/
│   │   ├── devpost_rss.mjs
│   │   ├── dorahacks_api.mjs
│   │   ├── mlh_ical.mjs
│   │   ├── lfx_scrape.mjs
│   │   ├── gsoc_scrape.mjs
│   │   └── outreachy_scrape.mjs
│   ├── discovery/custom_search.mjs
│   └── lib/
│       ├── supabase_client.mjs
│       ├── nigeria_heuristic.mjs
│       └── upsert.mjs
├── ARCHITECTURE.md              # this file
├── SCHEMA.md                    # authoritative Supabase schema
├── README.md
└── LICENSE
```

---

## Layer responsibilities

```
Widget (presentation)
  └─ reads AsyncValue from Provider
        └─ Provider (AsyncNotifier / Notifier)
              └─ calls Repository
                    └─ Repository calls Supabase (via data source)
                          └─ Supabase (Postgres / Auth)
```

| Layer        | Owns                                          | Must not                                          |
|--------------|-----------------------------------------------|---------------------------------------------------|
| Widget       | UI rendering, user input, `Theme.of` lookups  | Business logic, Supabase calls, try/catch         |
| Provider     | State, async orchestration, error wrapping    | Direct Supabase calls (use repository)            |
| Repository   | Supabase queries, data mapping, exceptions    | UI concerns, Riverpod                             |
| Domain model | Data shape, fromJson/toJson, enums            | Supabase imports, Flutter imports                 |
| Core         | Shared infrastructure (router, theme, client) | Feature-specific logic                            |

---

## Routes

Defined in `lib/src/core/router/app_router.dart`.

| Route name             | Path                      | Screen                        | Auth required | Admin required |
|------------------------|---------------------------|-------------------------------|---------------|----------------|
| `AppRoutes.home`       | `/`                       | ProgrammesListScreen          | No            | No             |
| `AppRoutes.detail`     | `/programmes/:id`         | ProgrammeDetailScreen         | No            | No             |
| `AppRoutes.saved`      | `/saved`                  | SavedScreen                   | Yes           | No             |
| `AppRoutes.login`      | `/auth/login`             | LoginScreen                   | No            | No             |
| `AppRoutes.register`   | `/auth/register`          | RegisterScreen                | No            | No             |
| `AppRoutes.submit`     | `/submit`                 | SubmitProgrammeScreen         | Yes (v0.3)    | No             |
| `AppRoutes.adminQueue` | `/admin/review-queue`     | ReviewQueueScreen             | Yes           | Yes            |

**Bottom navigation:** Home (`/`), Saved (`/saved`), Submit (`/submit`)

---

## Build flavors

Defined in `android/app/build.gradle`:

```gradle
android {
    flavorDimensions "distribution"
    productFlavors {
        standard {
            dimension "distribution"
            applicationId "com.polymath.de_scout"          // update when name confirmed
            resValue "string", "app_name", "DeScout"
        }
        fdroid {
            dimension "distribution"
            applicationId "com.polymath.de_scout"
            resValue "string", "app_name", "DeScout"
        }
        huawei {
            dimension "distribution"
            applicationId "com.polymath.de_scout"
            resValue "string", "app_name", "DeScout"
        }
    }
}
```

Flavor-specific Gradle dependencies:
```gradle
dependencies {
    standardImplementation 'com.onesignal:OneSignal:[5.0.0,5.99.99]'
    huaweiImplementation   'com.huawei.hms:push:6.13.0.300'
    // fdroid: UnifiedPush is a Dart package — no native Gradle dep needed
}
```

Build commands:
```bash
flutter build apk --flavor standard -t lib/main_standard.dart --release
flutter build apk --flavor fdroid   -t lib/main_fdroid.dart   --release
flutter build apk --flavor huawei   -t lib/main_huawei.dart   --release
```

---

## CI/CD overview

```
.github/workflows/
  build_standard.yml      # on push to main: build standard APK, upload artifact
  build_fdroid.yml        # on release tag: build fdroid APK
  build_huawei.yml        # on release tag: build huawei APK
  ingest_daily.yml        # cron 0 6 * * *: run Tier 2 feeds (Devpost, DoraHacks, MLH)
  ingest_weekly.yml       # cron 0 7 * * 1: run Tier 3 Playwright scrapes
  discovery_daily.yml     # cron 0 8 * * *: run Tier 4 Custom Search (10–15 queries)
  sync_yaml_to_db.yml     # on push to main (data/ path): sync data/programmes.yaml → Supabase
```

iOS builds run on CodeMagic triggered by release tags. Not managed in GitHub Actions.

---

## Key architectural decisions

| Decision | Choice | Rationale |
|---|---|---|
| State management | Riverpod + code gen | Type-safe, testable, no context dependency |
| Navigation | go_router | Declarative, deep link support, auth redirect |
| Backend | Supabase | Postgres + auto-REST API + Auth + free tier |
| Push notifications | Per-flavor abstraction | F-Droid policy, HMS compatibility |
| OTA updates | Shorebird (standard only) | F-Droid prohibits dynamic code; Huawei TBD |
| No Google Play | Direct APK + F-Droid + AppGallery | Avoids Play policy friction, serves F-Droid OSS users |
| Data licence | Pending (CC0 recommended) | Decision before v0.4 public API launch |
| Web hosting | Cloudflare Pages (v0.4) | Free tier, no request cap, SPA routing via _redirects |
