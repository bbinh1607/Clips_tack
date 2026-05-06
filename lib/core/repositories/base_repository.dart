import 'package:clips_tack/core/error/error_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:clips_tack/core/error/failure.dart';

mixin BaseRepository {
  Future<Either<Failure, R>> safeCall<T, R>({
    required Future<T> Function() call,
    required R Function(T data) map,
  }) async {
    try {
      final response = await call();
      return Right(map(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
