

import 'package:flutter/material.dart';
import 'package:healthy_cart_user/features/payment_gateway/domain/facade/i_gateway_facade.dart';
import 'package:healthy_cart_user/features/payment_gateway/domain/model/gateway_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class GatewayProvider extends ChangeNotifier {
  GatewayProvider(this.iGatewayFacade);
  final IGatewayFacade iGatewayFacade;

  GatewayModel? gatewayModel;

  Future<void> getGatewayKey() async {
    final result = await iGatewayFacade.getGetwayKey();
    result.fold((err) {
     // log('ERROR :: $err');
    }, (success) {
      gatewayModel = success;
    });
    notifyListeners();
  }
}
