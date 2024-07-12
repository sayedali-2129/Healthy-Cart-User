import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_banner_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_category_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';

abstract class IHospitalFacade {
  FutureResult<List<HospitalModel>> getAllHospitals({String? hospitalSearch});
    FutureResult<HospitalModel> getCategoryWiseHospital({required String hospitalId});
  FutureResult<List<HospitalBannerModel>> getHospitalBanner(
      {required String hospitalId});
  FutureResult<List<HospitalCategoryModel>> getHospitalCategory(
      {required List<String> categoryIdList});
  FutureResult<List<HospitalCategoryModel>> getHospitalAllCategory();    
  FutureResult<List<DoctorModel>> getDoctors(
      {required String hospitalId, String? doctorSearch, String? categoryId});
    FutureResult<List<DoctorModel>> getAllDoctorsCategoryWise(
      {String? doctorSearch,required String categoryId});    

  void clearHospitalData();
  void clearDoctorData();
  void clearAllDoctorsCategoryWiseData();
  FutureResult<List<HospitalModel>> fetchHospitalLocationBasedData(PlaceMark placeMark) {
    throw UnimplementedError('fetchProduct is not implemented');
  }

  FutureResult<Unit> fecthHospitalLocation(PlaceMark placeMark) {
    throw UnimplementedError('fecthUserLocaltion is not implemented');
  }

  void clearHospitalLocationData() {
    throw UnimplementedError('clearData is not implemented');
  }

}
