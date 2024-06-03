import 'package:get_it/get_it.dart';
import 'package:healthy_cart_user/core/di/injection.config.dart';
import 'package:injectable/injectable.dart';

final sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependancy() async {
  await init(sl, environment: Environment.prod);
}
