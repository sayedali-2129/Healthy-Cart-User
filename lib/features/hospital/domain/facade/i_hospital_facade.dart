import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_banner_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';

abstract class IHospitalFacade {
  FutureResult<List<HospitalModel>> getAllHospitals({String? hospitalSearch});
  FutureResult<List<HospitalBannerModel>> getHospitalBanner(
      {required String hospitalId});
  void clearHospitalData();
}
