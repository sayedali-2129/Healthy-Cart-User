import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_booking_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_banner_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_booking_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_category_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class HospitalProvider with ChangeNotifier {
  HospitalProvider(this.iHospitalFacade, this.iHospitalBookingFacade);
  final IHospitalFacade iHospitalFacade;
  final IHospitalBookingFacade iHospitalBookingFacade;

  TextEditingController hospitalSearch = TextEditingController();

  List<HospitalModel> hospitalList = [];
  List<HospitalBannerModel> hospitalBanner = [];
  List<HospitalCategoryModel> hospitalCategoryList = [];
  List<DoctorModel> doctorsList = [];
  Set<String> doctorIds = {};

  bool hospitalFetchLoading = false;
  bool isLoading = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final doctorSearchController = TextEditingController();

  /* ---------------------------- TEXT CONTROLLERS ---------------------------- */
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  String? genderDropdownValue;
  //booking date
  String? seletedBookingDate;
  //booking time
  String? selectedSlot;
/* -------------------------------------------------------------------------- */

/* ------------------------------ SET TIME SLOT ----------------------------- */
  void setTimeSlot(String selectedTimeSlot) {
    selectedSlot = selectedTimeSlot;

    notifyListeners();
  }

/* ------------------------ GET HOSPITALS AND SEARCH ------------------------ */

  Future<void> getAllHospitals() async {
    hospitalFetchLoading = true;
    notifyListeners();

    final result = await iHospitalFacade.getAllHospitals(
        hospitalSearch: hospitalSearch.text);
    result.fold((err) {
      log('ERROR :: ${err.errMsg}');
      CustomToast.errorToast(text: "Couldn't able to show hospitals near you.");
    }, (success) {
      hospitalList.addAll(success);
    });
    hospitalFetchLoading = false;
    notifyListeners();
  }

  void searchHospitals() {
    clearHospitalData();
    getAllHospitals();
    notifyListeners();
  }

  void clearHospitalData() {
    iHospitalFacade.clearHospitalData();
    hospitalList = [];
    notifyListeners();
  }

  void hospitalInit(ScrollController scrollController) {
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge &&
            scrollController.position.pixels != 0 &&
            hospitalFetchLoading == false) {
          getAllHospitals();
        }
      },
    );
  }
  /* -------------------------------------------------------------------------- */

  /* -------------------------- FETCH HOSPITAL BANNER ------------------------- */
  Future<void> getHospitalBanner({required String hospitalId}) async {
    isLoading = true;
    notifyListeners();
    final result =
        await iHospitalFacade.getHospitalBanner(hospitalId: hospitalId);
    result.fold((err) {
      log('ERROR :: ${err.errMsg}');
    }, (success) {
      hospitalBanner = success;
    });
    isLoading = false;
    notifyListeners();
  }

  /* -------------------------- GET HOSPITAL CATEGORY ------------------------- */
  Future<void> getHospitalCategory(
      {required List<String> categoryIdList}) async {
    isLoading = true;
    hospitalCategoryList.clear();
    notifyListeners();

    final result = await iHospitalFacade.getHospitalCategory(
        categoryIdList: categoryIdList);
    result.fold((err) {
      CustomToast.errorToast(text: "Couldn't able to fetch category");
      log('ERROR IN CATEGORY :: ${err.errMsg}');
    }, (success) {
      hospitalCategoryList = success;
    });
    isLoading = false;
    notifyListeners();
  }

  /* ------------------------------- GET DOCTORS ------------------------------ */
  Future<void> getDoctors(
      {required String hospitalId, String? categoryId}) async {
    isLoading = true;
    notifyListeners();

    final result = await iHospitalFacade.getDoctors(
        hospitalId: hospitalId,
        doctorSearch: doctorSearchController.text,
        categoryId: categoryId);

    result.fold((err) {
      CustomToast.errorToast(text: 'Unable to get doctors');
      log('ERROR IN GET DOCTOR :: ${err.errMsg}');
    }, (success) {
      final uniqueDoctors =
          success.where((doctor) => !doctorIds.contains(doctor.id)).toList();
      doctorIds.addAll(uniqueDoctors.map((doctor) => doctor.id!));
      doctorsList.addAll(uniqueDoctors);
      notifyListeners();
    });
    isLoading = false;
    notifyListeners();
  }

  void searchDoctor({required String hospitalId}) {
    clearDoctorData();
    getDoctors(hospitalId: hospitalId);
    notifyListeners();
  }

  void clearDoctorData() {
    iHospitalFacade.clearDoctorData();
    doctorIds.clear();
    doctorsList = [];
    notifyListeners();
  }

  void doctorinit(
      {required ScrollController scrollController,
      required String hospitalId}) {
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge &&
            scrollController.position.pixels != 0 &&
            isLoading == false) {
          getDoctors(hospitalId: hospitalId);
        }
      },
    );
  }

  void getCategoryWiseDoctor(
      {required String hospitalId, required String categoryId}) {
    clearDoctorData();
    getDoctors(hospitalId: hospitalId, categoryId: categoryId);
    notifyListeners();
  }
  /* -------------------------------------------------------------------------- */

/* ----------------------------- GET ALL SUNDAY ----------------------------- */
  List<DateTime> findAllSundaysFromNow(int daysCount) {
    List<DateTime> sundays = [];
    DateTime currentDate = DateTime.now();

    for (int i = 0; i < daysCount; i++) {
      DateTime date = currentDate.add(Duration(days: i));
      if (date.weekday == DateTime.sunday) {
        sundays.add(date);
      }
    }

    return sundays;
  }

  HospitalBookingModel? hospitalBookingModel;
  /* ------------------------- CREATE HOSPITAL BOOKING ------------------------ */
  Future<void> addHospitalBooking(
      {required String hospitalId,
      required String userId,
      required UserModel userModel,
      required HospitalModel hospitalModel,
      required int totalAmount,
      required DoctorModel selectedDoctor
      // required String fcmtoken,

      }) async {
    hospitalBookingModel = HospitalBookingModel(
      hospitalId: hospitalId,
      bookedAt: Timestamp.now(),
      patientName: nameController.text,
      patientAge: ageController.text,
      patientGender: genderDropdownValue,
      patientNumber: numberController.text,
      patientPlace: placeController.text,
      orderStatus: 0,
      paymentStatus: 0,
      totalAmount: totalAmount,
      userDetails: userModel,
      hospitalDetails: hospitalModel,
      isUserAccepted: false,
      selectedDate: seletedBookingDate,
      selectedTimeSlot: selectedSlot,
      selectedDoctor: selectedDoctor,
      userId: userId,
    );

    final result = await iHospitalBookingFacade.createHospitalBooking(
        hospitalBookingModel: hospitalBookingModel!);
    result.fold(
      (err) {
        log('error in addHospitalOrders() :: ${err.errMsg}');
      },
      (success) {
        // sendFcmMessage(
        //     token: fcmtoken,
        //     body:
        //         'New Booking Received from $userName. Please check the details and accept the order',
        //     title: 'New Booking Received!!!');
        CustomToast.sucessToast(text: success);
        log('Order Request Send Successfully');
      },
    );
    notifyListeners();
  }

  void clearControllerData() {
    nameController.clear();
    ageController.clear();
    placeController.clear();
    numberController.clear();
    genderDropdownValue = null;
    selectedSlot = null;
    seletedBookingDate = null;
    notifyListeners();
  }
}
