import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/payment_gateway/domain/model/gateway_model.dart';

abstract class IGatewayFacade {
  FutureResult<GatewayModel> getGetwayKey();
}
