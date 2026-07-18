// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/de_scout_exception.dart";
import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/logging/talker_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:sentry_flutter/sentry_flutter.dart";
import "package:talker/talker.dart";

part "error_reporter.g.dart";

/// Captures failures, logs full detail to Talker/Sentry, throws [DeScoutException].
class ErrorReporter {
  const ErrorReporter(this._talker);

  final Talker _talker;

  Future<T> guard<T>({
    required String userMessage,
    required Future<T> Function() action,
  }) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      return _handle(error, stackTrace, userMessage);
    }
  }

  T guardSync<T>({required String userMessage, required T Function() action}) {
    try {
      return action();
    } catch (error, stackTrace) {
      return _handle(error, stackTrace, userMessage);
    }
  }

  Never _handle(Object error, StackTrace stackTrace, String userMessage) {
    final failure = ErrorMapper.map(error, fallback: userMessage);
    _talker.handle(failure.cause ?? failure, stackTrace, failure.userMessage);
    Sentry.captureException(failure.cause ?? failure, stackTrace: stackTrace);
    throw failure;
  }
}

@riverpod
ErrorReporter errorReporter(ErrorReporterRef ref) {
  return ErrorReporter(ref.watch(talkerProvider));
}
