sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Invalid credentials.']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Try again.']);
}

final class CancelledFailure extends Failure {
  const CancelledFailure([super.message = 'Cancelled.']);
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure(
      [super.message = 'You do not have access to this app.']);
}

final class EmailNotVerifiedFailure extends Failure {
  const EmailNotVerifiedFailure(
      [super.message = 'Please verify your email before signing in.']);
}