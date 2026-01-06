/// Custom failure classes for error handling.
library;

/// Base failure class
sealed class Failure {
  final String message;
  const Failure(this.message);
}

/// Database operation failures
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// File operation failures
class FileFailure extends Failure {
  const FileFailure(super.message);
}
