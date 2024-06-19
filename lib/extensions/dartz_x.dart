import 'package:arrow_navigator/failure.dart';
import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  R getOrCrash() {
    return fold((l) => throw Failure("Invalid value"), (r) => r);
  }

  L getLeft() {
    return fold((l) => l, (r) => throw Failure("Invalid value"));
  }
}
