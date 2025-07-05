import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';

class FirebaseErrorHandler {
  final String errorMessage;
  final String? errorCode;

  FirebaseErrorHandler._(this.errorMessage, this.errorCode);

  factory FirebaseErrorHandler.handleError(FirebaseException firebaseError) {
    String errorMessage = _getErrorMessage(firebaseError.code);
    return FirebaseErrorHandler._(errorMessage, firebaseError.code);
  }

  static String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'auth.emailAlreadyInUse'.tr();
      case 'invalid-email':
        return 'auth.invalidEmail'.tr();
      case 'weak-password':
        return 'auth.weakPassword'.tr();
      case 'user-not-found':
      case 'wrong-password':
        return 'auth.invalidCredentials'.tr();
      case 'too-many-requests':
        return 'auth.tooManyRequests'.tr();
      case 'network-request-failed':
        return 'auth.networkError'.tr();
      case 'operation-not-allowed':
        return 'auth.operationNotAllowed'.tr();
      case 'permission-denied':
        return 'auth.permissionDenied'.tr();
      case 'unavailable':
        return 'auth.serviceUnavailable'.tr();
      case 'not-found':
        return 'auth.resourceNotFound'.tr();
      case 'already-exists':
        return 'auth.resourceAlreadyExists'.tr();
      case 'cancelled':
        return 'auth.requestCancelled'.tr();
      case 'deadline-exceeded':
        return 'auth.requestTimedOut'.tr();
      case 'invalid-argument':
        return 'auth.invalidInput'.tr();
      case 'resource-exhausted':
        return 'auth.resourceLimitExceeded'.tr();
      case 'unauthenticated':
        return 'auth.unauthenticated'.tr();
      case 'internal':
        return 'auth.internalError'.tr();
      case 'unknown':
        return 'auth.unknownError'.tr();
      default:
        return 'auth.unexpectedError'.tr();
    }
  }
}
