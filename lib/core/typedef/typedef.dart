import 'package:clips_tack/core/error/failure.dart';
import 'package:dartz/dartz.dart';

typedef DataState<T> = Future<Either<Failure, T>>;
