import 'package:dio/dio.dart';

import 'failure.dart';
import 'util/result.dart';

Failure mapDioError(DioException e) {
  final status = e.response?.statusCode;
  final data = e.response?.data;
  final code = data is Map && data['code'] is String
      ? data['code'] as String
      : null;

  if (status == null) return const NetworkFailure();
  if (status == 401) return const UnauthorizedFailure();
  if (status == 403) {
    return code == 'EMAIL_NOT_VERIFIED'
        ? const EmailNotVerifiedFailure()
        : const ForbiddenFailure();
  }
  if (status == 400 || status == 422) {
    return ValidationFailure(_extractMessage(data) ?? 'Invalid request.');
  }
  return const ServerFailure();
}

/// Prefers the first field error from the backend's VALIDATION_ERROR body.
String? _extractMessage(Object? data) {
  if (data is! Map) return null;
  final details = data['details'];
  if (details is List && details.isNotEmpty) {
    final first = details.first;
    if (first is Map && first['message'] is String) {
      return first['message'] as String;
    }
  }
  final message = data['message'];
  return message is String ? message : null;
}

/// Runs [call] and converts any thrown error into an [Err].
Future<Result<T>> guardApi<T>(Future<T> Function() call) async {
  try {
    return Success(await call());
  } on DioException catch (e) {
    return Err(mapDioError(e));
  } on Failure catch (f) {
    return Err(f);
  } catch (_) {
    return const Err(ServerFailure());
  }
}
