/// Sealed failure hierarchy for structured error handling across all layers.
sealed class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure($code): $message';
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network connection failed', super.code = 'NETWORK_ERROR'});
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({
    super.message = 'Server returned an error',
    super.code = 'SERVER_ERROR',
    this.statusCode,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed', super.code = 'AUTH_ERROR'});
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;
  const ValidationFailure({
    super.message = 'Validation failed',
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
  });
}

class StorageFailure extends Failure {
  const StorageFailure({super.message = 'Local storage operation failed', super.code = 'STORAGE_ERROR'});
}

class PdfRenderFailure extends Failure {
  const PdfRenderFailure({super.message = 'PDF rendering failed', super.code = 'PDF_RENDER_ERROR'});
}

class SubscriptionFailure extends Failure {
  const SubscriptionFailure({super.message = 'Subscription verification failed', super.code = 'SUBSCRIPTION_ERROR'});
}
