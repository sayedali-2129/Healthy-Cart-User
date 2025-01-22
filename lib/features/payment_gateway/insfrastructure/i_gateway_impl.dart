// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:healthy_cart_user/core/failures/main_failure.dart';
// import 'package:healthy_cart_user/core/general/firebase_collection.dart';
// import 'package:healthy_cart_user/core/general/typdef.dart';
// import 'package:healthy_cart_user/features/payment_gateway/domain/facade/i_gateway_facade.dart';
// import 'package:healthy_cart_user/features/payment_gateway/domain/model/gateway_model.dart';
// import 'package:injectable/injectable.dart';

// @LazySingleton(as: IGatewayFacade)
// class IGatewayImpl implements IGatewayFacade {
//   IGatewayImpl(this._firestore);

//   final FirebaseFirestore _firestore;

//   @override
//   FutureResult<GatewayModel> getGetwayKey() async {
//     try {
//       final responce = await _firestore
//           .collection(FirebaseCollections.paymentGateway)
//           .doc('paymentGateway')
//           .get();

//       return right(
//           GatewayModel.fromMap(responce.data() as Map<String, dynamic>));
//     } catch (e) {
//       return left(MainFailure.generalException(errMsg: e.toString()));
//     }
//   }
// }
