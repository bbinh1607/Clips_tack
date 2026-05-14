import 'package:clips_tack/core/typedef/typedef.dart';

abstract class UseCase<Result, Params> {
  DataState<Result> call(Params params);
}

abstract class UseCaseNoParams<Result> {
  DataState<Result> call();
}
