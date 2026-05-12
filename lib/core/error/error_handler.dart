// core/errors/error_handler.dart

import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'failure.dart';

// Custom exception cho lỗi API
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException: $statusCode - $message';
}

class ErrorHandler {
  // Xử lý lỗi chung (giữ nguyên logic cũ)
  static Failure handle(Object error) {
    /// Firebase
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return Failure.auth('User not found');
        case 'wrong-password':
          return Failure.auth('Wrong password');
        case 'invalid-email':
          return Failure.auth('Invalid email');
        default:
          return Failure.auth(error.message ?? 'Auth error');
      }
    }

    if (error is GoogleSignInException) {
      switch (error.code) {
        case GoogleSignInExceptionCode.canceled:
          return Failure.auth('Google sign-in was canceled');
        case GoogleSignInExceptionCode.clientConfigurationError:
        case GoogleSignInExceptionCode.providerConfigurationError:
          return Failure.auth(
            error.description ?? 'Google sign-in is not configured',
          );
        case GoogleSignInExceptionCode.uiUnavailable:
          return Failure.auth(
            'Google sign-in is not available on this platform',
          );
        default:
          return Failure.auth(error.description ?? 'Google sign-in failed');
      }
    }

    /// Network
    if (error is SocketException) {
      return Failure.network('No internet connection');
    }

    /// Timeout
    if (error is TimeoutException) {
      return Failure.timeout('Request timeout');
    }

    /// API Exception (mới thêm)
    if (error is ApiException) {
      return Failure.api(error.message, code: error.statusCode);
    }

    /// Unknown
    return const Failure('Something went wrong');
  }
}
