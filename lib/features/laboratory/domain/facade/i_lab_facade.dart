import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_banner_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_test_model.dart';

abstract class ILabFacade {
  FutureResult<List<LabModel>> getLabs({required String? labSearch});

  void clearData();
  FutureResult<List<LabBannerModel>> getLabBanner({required labId});
  FutureResult<List<LabTestModel>> getAvailableTests({required labId});
  FutureResult<List<LabTestModel>> getDoorStepOnly({required labId});
  Future<void> playPaymentSound();
}
