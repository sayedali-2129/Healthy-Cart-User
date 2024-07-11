import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_banner_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_test_model.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';

abstract class ILabFacade {
  FutureResult<List<LabModel>> getLabs({required String? labSearch});

  void clearData();
  FutureResult<List<LabBannerModel>> getLabBanner({required labId});
  FutureResult<List<LabTestModel>> getAvailableTests({required labId});
  FutureResult<List<LabTestModel>> getDoorStepOnly({required labId});
  Future<void> playPaymentSound();
  
  FutureResult<List<LabModel>> fetchLabortaryLocationBasedData(PlaceMark placeMark) {
    throw UnimplementedError('fetchProduct is not implemented');
  }

  FutureResult<Unit> fecthLabortaryLocation(PlaceMark placeMark) {
    throw UnimplementedError('fecthUserLocaltion is not implemented');
  }

  void clearLabortaryLocationData() {
    throw UnimplementedError('clearData is not implemented');
  }
}
