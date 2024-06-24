import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/home/domain/facade/i_home_facade.dart';
import 'package:healthy_cart_user/features/home/domain/models/home_banner_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IHomeFacade)
class IHomeImpl implements IHomeFacade {
  IHomeImpl(this._firestore);

  final FirebaseFirestore _firestore;

/* ---------------------------- FETCH HOME BANNER --------------------------- */
  @override
  FutureResult<List<HomeBannerModel>> getBanner() async {
    List<HomeBannerModel> bannerList;

    try {
      final result = await _firestore
          .collection(FirebaseCollections.homeBannerCollection)
          .orderBy('createdAt', descending: true)
          .get();

      bannerList = result.docs
          .map((e) => HomeBannerModel.fromMap(e.data()).copyWith(id: e.id))
          .toList();

      return right(bannerList);
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
}
