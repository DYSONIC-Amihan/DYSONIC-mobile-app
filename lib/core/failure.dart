// lib/core/failure.dart
abstract class Failure implements Exception {
  const Failure(this.message, {this.code});
  final String message;
  final String? code;

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Cannot reach the server. Check your connection.'])
      : super(code: 'network');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Invalid credentials or session expired.'])
      : super(code: 'unauthorized');
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'You do not have access to this.'])
      : super(code: 'forbidden');
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Please check your input.'])
      : super(code: 'validation');
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong. Please try again.'])
      : super(code: 'unknown');
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Try again.']);
}

final class EmailNotVerifiedFailure extends Failure {
  const EmailNotVerifiedFailure(
      [super.message = 'Please verify your email before signing in.']);
}