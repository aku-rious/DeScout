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
    required this.reviewed,
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
      reviewed: json["reviewed"] as bool,
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
  final bool reviewed;
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
