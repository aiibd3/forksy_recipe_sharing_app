import 'package:firebase_core/firebase_core.dart';

class FirebaseErrorHandler {
  final String errorMessage;
  final String? errorCode;

  FirebaseErrorHandler._(this.errorMessage, this.errorCode);

  factory FirebaseErrorHandler.handleError(FirebaseException firebaseError) {
    String errorMessage;
    String? errorCode = firebaseError.code;

    errorMessage = _getErrorMessage(firebaseError.code);

    return FirebaseErrorHandler._(errorMessage, errorCode);
  }

  static String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'permission-denied':
        return 'You do not have permission to access this resource.';
      case 'unavailable':
        return 'The service is currently unavailable. Please try again later.';
      case 'not-found':
        return 'The requested resource could not be found.';
      case 'already-exists':
        return 'The resource already exists.';
      case 'cancelled':
        return 'The request was cancelled.';
      case 'deadline-exceeded':
        return 'The request timed out. Please try again later.';
      case 'invalid-argument':
        return 'Invalid input provided. Please check your data.';
      case 'resource-exhausted':
        return 'Resource limit exceeded. Please try again later.';
      case 'unauthenticated':
        return 'You must be authenticated to access this resource.';
      case 'internal':
        return 'An internal error occurred. Please try again later.';
      case 'unknown':
        return 'An unknown error occurred. Please try again later.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
