// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "dart:io";

import "package:de_scout/src/core/errors/de_scout_exception.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// Maps raw exceptions to user-safe [DeScoutException] messages.
abstract final class ErrorMapper {
  static const genericMessage = "Something went wrong. Please try again.";
  static const networkMessage =
      "Could not connect. Check your internet and try again.";
  static const authMessage = "Sign-in failed. Check your email and password.";
  static const programmesMessage =
      "Could not load programmes. Please try again.";

  /// Returns a [DeScoutException] with a safe [userMessage].
  static DeScoutException map(Object error, {required String fallback}) {
    if (error is DeScoutException) {
      return error;
    }

    return DeScoutException(_userMessage(error, fallback), cause: error);
  }

  /// Safe message for any error object (e.g. Riverpod [AsyncError]).
  static String userMessage(Object? error, {String? fallback}) {
    if (error == null) {
      return fallback ?? genericMessage;
    }
    if (error is DeScoutException) {
      return error.userMessage;
    }
    return map(error, fallback: fallback ?? genericMessage).userMessage;
  }

  static String _userMessage(Object error, String fallback) {
    if (error is AuthException) {
      return _mapAuth(error);
    }
    if (error is PostgrestException) {
      return fallback;
    }
    if (error is SocketException || error is HttpException) {
      return networkMessage;
    }
    if (error is IOException) {
      return networkMessage;
    }
    return fallback;
  }

  static String _mapAuth(AuthException error) {
    final code = error.code?.toLowerCase() ?? "";
    final status = error.statusCode?.toString() ?? "";

    if (code.contains("invalid") ||
        code.contains("credentials") ||
        status == "400") {
      return "Email or password is incorrect.";
    }
    if (code.contains("email") && code.contains("confirm")) {
      return "Confirm your email before signing in.";
    }
    if (code.contains("weak") || code.contains("password")) {
      return "Choose a stronger password (at least 6 characters).";
    }
    if (code.contains("rate") || status == "429") {
      return "Too many attempts. Wait a moment and try again.";
    }
    return authMessage;
  }
}
