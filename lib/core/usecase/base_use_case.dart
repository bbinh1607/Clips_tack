import 'package:clips_tack/core/typedef/typedef.dart';

abstract class UseCase<Type, Params> {
  DataState<Type> call(Params params);
}

abstract class UseCaseNoParams<Type> {
  DataState<Type> call();
}
