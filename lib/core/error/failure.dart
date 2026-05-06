enum ErrorType {
  auth, // Lỗi xác thực (Firebase, etc.)
  network, // Lỗi mạng (không có internet)
  timeout, // Lỗi timeout
  api, // Lỗi từ API (bao gồm cả 200 với message lỗi)
  unknown, // Lỗi không xác định
}

class Failure {
  final String message;
  final int? code; // Status code (ví dụ: 200, 400, 500)
  final ErrorType type; // Loại lỗi để dễ phân loại

  const Failure(this.message, {this.code, this.type = ErrorType.unknown});

  // Factory constructor cho lỗi API để dễ tạo
  factory Failure.api(String message, {int? code}) {
    return Failure(message, code: code, type: ErrorType.api);
  }

  // Factory cho lỗi khác
  factory Failure.auth(String message) {
    return Failure(message, type: ErrorType.auth);
  }

  factory Failure.network(String message) {
    return Failure(message, type: ErrorType.network);
  }

  factory Failure.timeout(String message) {
    return Failure(message, type: ErrorType.timeout);
  }
}
