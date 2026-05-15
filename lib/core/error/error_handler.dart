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
          return Failure.auth('Không tìm thấy tài khoản');
        case 'wrong-password':
          return Failure.auth('Sai mật khẩu');
        case 'invalid-credential':
          return Failure.auth('Email hoặc mật khẩu không đúng');
        case 'invalid-email':
          return Failure.auth('Email không hợp lệ');
        case 'email-already-in-use':
          return Failure.auth('Email này đã được đăng ký');
        case 'weak-password':
          return Failure.auth('Mật khẩu quá yếu');
        case 'network-request-failed':
          return Failure.network('Không có kết nối mạng');
        case 'account-exists-with-different-credential':
          return Failure.auth('Email này đã đăng nhập bằng phương thức khác');
        default:
          return Failure.auth(error.message ?? 'Lỗi đăng nhập');
      }
    }

    if (error is GoogleSignInException) {
      switch (error.code) {
        case GoogleSignInExceptionCode.canceled:
          return Failure.auth('Bạn đã hủy đăng nhập Google');
        case GoogleSignInExceptionCode.clientConfigurationError:
          if (_isMissingGoogleServerClientId(error)) {
            return Failure.auth(
              'Google Sign-In chưa có Web client ID. Hãy thêm SHA-1/SHA-256 trong Firebase, bật Google provider rồi tải lại google-services.json.',
            );
          }
          return Failure.auth(
            error.description ?? 'Cấu hình Google Sign-In chưa đúng',
          );
        case GoogleSignInExceptionCode.providerConfigurationError:
          return Failure.auth(
            error.description ?? 'Cấu hình Google Sign-In chưa đúng',
          );
        case GoogleSignInExceptionCode.uiUnavailable:
          return Failure.auth(
            'Google Sign-In không khả dụng trên thiết bị này',
          );
        default:
          return Failure.auth(error.description ?? 'Đăng nhập Google thất bại');
      }
    }

    /// Network
    if (error is SocketException) {
      return Failure.network('Không có kết nối mạng');
    }

    /// Timeout
    if (error is TimeoutException) {
      return Failure.timeout('Yêu cầu quá thời gian chờ');
    }

    /// API Exception (mới thêm)
    if (error is ApiException) {
      return Failure.api(error.message, code: error.statusCode);
    }

    /// Unknown
    return const Failure('Có lỗi xảy ra');
  }

  static bool _isMissingGoogleServerClientId(GoogleSignInException error) {
    return error.description?.contains('serverClientId must be provided') ??
        false;
  }
}
