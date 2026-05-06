// core/errors/error_handler.dart

import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
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
