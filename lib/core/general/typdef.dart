import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';

typedef FutureResult<T> = Future<Either<MainFailure, T>>;
