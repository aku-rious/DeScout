# DeScout — Hackathon & Programme Tracker

> Find your summit. Remote, paid, Nigeria-eligible hackathons and open-source fellowships — filtered, tracked, and notified.

Flutter mobile app that aggregates remote, paid, Nigeria-eligible hackathons and open-source fellowships (GSoC, Outreachy, LFX, DoraHacks, Devpost, and others) into a filterable, deadline-tracked directory for Nigerian developers.

**Status:** 🚧 v0.1 in development

---

## The problem

Finding remote, paid, Nigeria-eligible hackathons and open-source fellowships (GSoC, Outreachy,
LFX, Hyperledger, DoraHacks, etc.) is a manual exercise across 10+ websites with no
country-eligibility filter, no stipend filter, and no deadline notifications.

DeScout aggregates them in one place, filters for Nigeria-eligibility and remote status, and
notifies you before deadlines close.

## Features

| Release | Feature |
|---------|---------|
| v0.1 ✅ | Browse and filter programmes by type, eligibility, stipend, remote, status |
| v0.1 ✅ | Deadline countdown badges |
| v0.1 ✅ | Supabase auth (email/password) |
| v0.2   | Save programmes, track application status |
| v0.2   | Push notifications before deadlines |
| v0.2   | iOS build, F-Droid APK, Huawei AppGallery APK |
| v0.3   | Automated ingestion (Devpost, DoraHacks, MLH, Playwright scraping) |
| v0.3   | Admin review queue, in-app programme submission |
| v0.4   | Public REST API, static JSON feed, web app |

## Tech stack

- **Flutter** + Riverpod + go_router
- **Supabase** (Postgres + Auth + auto-REST)
- **OneSignal** (push, standard build) / UnifiedPush (F-Droid) / huawei_push (Huawei)
- **Sentry** (error tracking), **Shorebird** (OTA, standard build)
- **GitHub Actions** (CI/CD + ingestion cron), **CodeMagic** (iOS)
- Licence: **AGPL-3.0**

---

## Prerequisites

- Flutter SDK ≥ 3.22
- Dart SDK ≥ 3.4 (included with Flutter)
- Android Studio / VS Code with Flutter extension
- Supabase CLI (`npm install -g supabase`)
- Node.js ≥ 20 (for ingestion scripts)
- Python ≥ 3.11 (for seed script)

---

## Setup

### 1. Clone and install dependencies
```bash
git clone https://github.com/<your-org>/DeScout.git
cd DeScout
flutter pub get
```

### 2. Set up Supabase
```bash
supabase login
supabase init        # if starting fresh
supabase start       # local dev instance
```

Apply migrations (in order):
```bash
supabase db push
```

Generate Dart types:
```bash
supabase gen types dart --local > lib/src/core/supabase/database_types.dart
```

### 3. Environment variables

Create `.env.local` (never commit this):
```
DESCOUT_SUPABASE_URL=http://localhost:54321
DESCOUT_SUPABASE_ANON_KEY=your-local-anon-key
```

Pass at build time via `--dart-define`:
```bash
flutter run --flavor standard -t lib/main_standard.dart \
  --dart-define=SUPABASE_URL=$DESCOUT_SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$DESCOUT_SUPABASE_ANON_KEY
```

### 4. Seed the database (first run)
```bash
# Parse internships.txt into JSON
python scripts/seed/parse_internships.py

# Upload to Supabase (requires service role key locally)
SUPABASE_SERVICE_ROLE_KEY=your-local-service-role-key \
  node scripts/seed/upload_seed.mjs
```

---

## Build commands

### Development (hot reload)
```bash
flutter run --flavor standard -t lib/main_standard.dart \
  --dart-define=DESCOUT_SUPABASE_URL=... \
  --dart-define=DESCOUT_SUPABASE_ANON_KEY=...
```

### Release APKs
```bash
# Standard build (APKPure, Uptodown)
flutter build apk --flavor standard -t lib/main_standard.dart --release \
  --dart-define=DESCOUT_SUPABASE_URL=... \
  --dart-define=DESCOUT_SUPABASE_ANON_KEY=...

# F-Droid build
flutter build apk --flavor fdroid -t lib/main_fdroid.dart --release \
  --dart-define=DESCOUT_SUPABASE_URL=... \
  --dart-define=DESCOUT_SUPABASE_ANON_KEY=...

# Huawei AppGallery build
flutter build apk --flavor huawei -t lib/main_huawei.dart --release \
  --dart-define=DESCOUT_SUPABASE_URL=... \
  --dart-define=DESCOUT_SUPABASE_ANON_KEY=...
```

### Code generation (Riverpod)
```bash
dart run build_runner build --delete-conflicting-outputs
# or watch mode during development:
dart run build_runner watch --delete-conflicting-outputs
```

---

## Data ingestion (v0.3+)

Cron scripts in `scripts/`. See `.cursor/rules/ingestion.mdc` for conventions.

```bash
# Run individual feeds locally (requires service role key)
export SUPABASE_URL=...
export SUPABASE_SERVICE_ROLE_KEY=...

node scripts/ingest/devpost_rss.mjs
node scripts/ingest/dorahacks_api.mjs
node scripts/ingest/mlh_ical.mjs
```

---

## Contributing

DeScout is AGPL-3.0 licensed. Contributions are welcome.

### Add a missing programme
Open a PR editing `data/programmes.yaml` with:
```yaml
- name: "Programme Name"
  url: "https://official-url"
  type: fellowship          # hackathon | fellowship | programme
  stipend_usd: 3000         # null if unpaid or unknown
  remote: true
  nigeria_eligible: true    # true | false | null (unknown)
  opens_at: "2026-01-15"    # null if unknown
  closes_at: "2026-03-31"   # null if unknown
  tags: [open-source, linux]
```

PRs merged to `main` are synced to the Supabase database automatically via GitHub Actions.

### Code contributions
1. Fork the repo
2. Create a branch: `feature/<description>`
3. Follow conventions in `.cursor/rules/conventions.mdc`
4. Open a PR with a description of what and why

---

## Project structure

See `ARCHITECTURE.md` for the full folder structure, layer rules, routes, and build flavor setup.
See `SCHEMA.md` for the complete Supabase schema.
See `docs/PRD.md` for the product requirements document.

---

## Licence

AGPL-3.0 — see `LICENSE`.

Programme data in `data/` will be separately licensed (CC0 or ODbL — decision pending before v0.4).
