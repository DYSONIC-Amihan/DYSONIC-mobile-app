import 'package:dio/dio.dart';

import 'failure.dart';

/// Maps a failed API call to a [Failure] the UI can show.
Failure mapDioError(DioException e) {
  final status = e.response?.statusCode;
  final data = e.response?.data;
  final code = data is Map ? data['code'] as String? : null;
  final message = data is Map ? data['message'] as String? : null;

  if (status == null) return const NetworkFailure();
  if (status == 401) return const UnauthorizedFailure();
  if (status == 403) {
    return code == 'EMAIL_NOT_VERIFIED'
        ? const EmailNotVerifiedFailure()
        : const ForbiddenFailure();
  }
  if (code == 'CREDENTIAL_ACCOUNT_NOT_FOUND') {
    return const ValidationFailure(
      'This account signs in with Google and has no password to change.',
    );
  }
  if (status == 400 || status == 422) {
    return ValidationFailure(message ?? 'Invalid request.');
  }
  return const ServerFailure();
}
