import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_banner_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_category_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';

abstract class IHospitalFacade {
  FutureResult<List<HospitalModel>> getAllHospitals({String? hospitalSearch});
  FutureResult<List<HospitalBannerModel>> getHospitalBanner(
      {required String hospitalId});
  FutureResult<List<HospitalCategoryModel>> getHospitalCategory(
      {required List<String> categoryIdList});
  FutureResult<List<DoctorModel>> getDoctors(
      {required String hospitalId, String? doctorSearch, String? categoryId});

  void clearHospitalData();
  void clearDoctorData();

  FutureResult<List<HospitalModel>> fetchProduct(PlaceMark placeMark) {
    throw UnimplementedError('fetchProduct is not implemented');
  }

  FutureResult<Unit> fecthUserLocaltion(PlaceMark placeMark) {
    throw UnimplementedError('fecthUserLocaltion is not implemented');
  }

  void clearData() {
    throw UnimplementedError('clearData is not implemented');
  }
}
