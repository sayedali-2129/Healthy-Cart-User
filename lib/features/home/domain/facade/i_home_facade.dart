import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/home/domain/models/home_banner_model.dart';

abstract class IHomeFacade {
  FutureResult<List<HomeBannerModel>> getBanner();
}
