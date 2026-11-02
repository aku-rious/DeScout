// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

// Generated from Supabase project DeScout via MCP (generate_typescript_types).
// Regenerate after migrations: supabase gen types dart --linked

typedef Json = Map<String, dynamic>;

/// Supabase [Database] schema root.
abstract final class Database {
  static const public = PublicSchema();
}

/// Public schema tables and enums.
final class PublicSchema {
  const PublicSchema();
}

/// Postgres `programme_type` enum values.
enum ProgrammeTypeDb {
  hackathon,
  fellowship,
  programme;

  static ProgrammeTypeDb fromJson(String value) => values.byName(value);
}

/// Postgres `programme_status` enum values.
enum ProgrammeStatusDb {
  open,
  upcoming,
  closed,
  unknown;

  static ProgrammeStatusDb fromJson(String value) => values.byName(value);
}

/// Postgres `application_status` enum values.
enum ApplicationStatusDb {
  interested,
  applied,
  accepted,
  rejected;

  static ApplicationStatusDb fromJson(String value) => values.byName(value);
}

/// Row shape for `programmes`.
class ProgrammesRow {
  const ProgrammesRow({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    this.description,
    this.stipendUsd,
    this.stipendNgnApprox,
    this.remote,
    this.nigeriaEligible,
    this.opensAt,
    this.closesAt,
    required this.status,
    required this.source,
    required this.moderationStatus,
    this.rejectedAt,
    required this.isAdminSubmitted,
    this.contributorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProgrammesRow.fromJson(Json json) {
    return ProgrammesRow(
      id: json["id"] as String,
      name: json["name"] as String,
      url: json["url"] as String,
      type: ProgrammeTypeDb.fromJson(json["type"] as String),
      description: json["description"] as String?,
      stipendUsd: (json["stipend_usd"] as num?)?.toDouble(),
      stipendNgnApprox: (json["stipend_ngn_approx"] as num?)?.toDouble(),
      remote: json["remote"] as bool?,
      nigeriaEligible: json["nigeria_eligible"] as bool?,
      opensAt: json["opens_at"] == null
          ? null
          : DateTime.parse(json["opens_at"] as String),
      closesAt: json["closes_at"] == null
          ? null
          : DateTime.parse(json["closes_at"] as String),
      status: ProgrammeStatusDb.fromJson(json["status"] as String),
      source: json["source"] as String,
      moderationStatus: json["moderation_status"] as String,
      rejectedAt: json["rejected_at"] == null
          ? null
          : DateTime.parse(json["rejected_at"] as String),
      isAdminSubmitted: json["is_admin_submitted"] as bool,
      contributorId: json["contributor_id"] as String?,
      createdAt: DateTime.parse(json["created_at"] as String),
      updatedAt: DateTime.parse(json["updated_at"] as String),
    );
  }

  final String id;
  final String name;
  final String url;
  final ProgrammeTypeDb type;
  final String? description;
  final double? stipendUsd;
  final double? stipendNgnApprox;
  final bool? remote;
  final bool? nigeriaEligible;
  final DateTime? opensAt;
  final DateTime? closesAt;
  final ProgrammeStatusDb status;
  final String source;
  final String moderationStatus;
  final DateTime? rejectedAt;
  final bool isAdminSubmitted;
  final String? contributorId;
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// Row shape for `users`.
class UsersRow {
  const UsersRow({
    required this.id,
    required this.email,
    required this.notificationDaysBefore,
    this.pushFlavor,
    required this.isAdmin,
    required this.createdAt,
  });

  factory UsersRow.fromJson(Json json) {
    return UsersRow(
      id: json["id"] as String,
      email: json["email"] as String,
      notificationDaysBefore: json["notification_days_before"] as int,
      pushFlavor: json["push_flavor"] as String?,
      isAdmin: json["is_admin"] as bool,
      createdAt: DateTime.parse(json["created_at"] as String),
    );
  }

  final String id;
  final String email;
  final int notificationDaysBefore;
  final String? pushFlavor;
  final bool isAdmin;
  final DateTime createdAt;
}

/// Row shape for `saved_programmes`.
class SavedProgrammesRow {
  const SavedProgrammesRow({
    required this.id,
    required this.userId,
    required this.programmeId,
    required this.applicationStatus,
    this.notes,
    this.customReminderDays,
    required this.createdAt,
    this.programme,
  });

  factory SavedProgrammesRow.fromJson(Json json) {
    final programmeJson = json["programmes"];
    return SavedProgrammesRow(
      id: json["id"] as String,
      userId: json["user_id"] as String,
      programmeId: json["programme_id"] as String,
      applicationStatus: ApplicationStatusDb.fromJson(
        json["application_status"] as String,
      ),
      notes: json["notes"] as String?,
      customReminderDays: json["custom_reminder_days"] as int?,
      createdAt: DateTime.parse(json["created_at"] as String),
      programme: programmeJson == null
          ? null
          : ProgrammesRow.fromJson(programmeJson as Json),
    );
  }

  final String id;
  final String userId;
  final String programmeId;
  final ApplicationStatusDb applicationStatus;
  final String? notes;
  final int? customReminderDays;
  final DateTime createdAt;
  final ProgrammesRow? programme;
}

/// Row shape for `exchange_rates`.
class ExchangeRatesRow {
  const ExchangeRatesRow({
    required this.currency,
    required this.ngnRate,
    required this.source,
    required this.updatedAt,
  });

  factory ExchangeRatesRow.fromJson(Json json) {
    return ExchangeRatesRow(
      currency: json["currency"] as String,
      ngnRate: (json["ngn_rate"] as num).toDouble(),
      source: json["source"] as String,
      updatedAt: DateTime.parse(json["updated_at"] as String),
    );
  }

  final String currency;
  final double ngnRate;
  final String source;
  final DateTime updatedAt;
}

/// Row shape for `tags`.
class TagsRow {
  const TagsRow({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory TagsRow.fromJson(Json json) {
    return TagsRow(
      id: json["id"] as String,
      name: json["name"] as String,
      slug: json["slug"] as String,
    );
  }

  final String id;
  final String name;
  final String slug;
}

/// Row shape for `programme_tips`.
class ProgrammeTipsRow {
  const ProgrammeTipsRow({
    required this.id,
    required this.programmeId,
    required this.userId,
    required this.tipText,
    required this.createdAt,
  });

  factory ProgrammeTipsRow.fromJson(Json json) {
    return ProgrammeTipsRow(
      id: json["id"] as String,
      programmeId: json["programme_id"] as String,
      userId: json["user_id"] as String,
      tipText: json["tip_text"] as String,
      createdAt: DateTime.parse(json["created_at"] as String),
    );
  }

  final String id;
  final String programmeId;
  final String userId;
  final String tipText;
  final DateTime createdAt;
}
