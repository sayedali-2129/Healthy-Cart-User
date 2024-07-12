import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/send_fcm_message.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_booking_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_banner_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_booking_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_category_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_family_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';

@injectable
class HospitalProvider with ChangeNotifier {
  HospitalProvider(this.iHospitalFacade, this.iHospitalBookingFacade);
  final IHospitalFacade iHospitalFacade;
  final IHospitalBookingFacade iHospitalBookingFacade;
  TextEditingController hospitalSearchController = TextEditingController();
  List<HospitalModel> hospitalListSearch = [];
  List<HospitalBannerModel> hospitalBanner = [];
  List<HospitalCategoryModel> hospitalCategoryList = [];
  List<DoctorModel> doctorsList = [];
  Set<String> doctorIds = {};

  bool hospitalFetchLoading = false;
  bool isLoading = true;
  //final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final doctorSearchController = TextEditingController();

  /* ---------------------------- TEXT CONTROLLERS ---------------------------- */
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
  final ScrollController searchScrollController = ScrollController();
  Future<void> getAllHospitals() async {
    hospitalFetchLoading = true;
    notifyListeners();

    final result = await iHospitalFacade.getAllHospitals( hospitalSearch: hospitalSearchController.text);
    result.fold((err) {
      CustomToast.errorToast(text: "Couldn't able to show hospitals near you.");
    }, (success) {
      hospitalListSearch.addAll(success);
    });

    hospitalFetchLoading = false;
    notifyListeners();
  }

  void searchHospitals() {
    hospitalListSearch.clear();
    iHospitalFacade.clearHospitalData();
    getAllHospitals();
    hospitalInit();
    notifyListeners();
  }

  void clearHospitalData() {
    iHospitalFacade.clearHospitalData();
    hospitalListSearch = [];
    hospitalSearchController.clear();
    notifyListeners();
  }

  void hospitalInit() {
    searchScrollController.addListener(
      () {
        if (searchScrollController.position.atEdge &&
            searchScrollController.position.pixels != 0 &&
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
      CustomToast.errorToast(
          text: "Couldn't able to fetch hospital categories.");
      log('ERROR IN CATEGORY :: ${err.errMsg}');
    }, (success) {
      hospitalCategoryList = success;
    });
    isLoading = false;
    notifyListeners();
  }

/* -------------------------------------------------------------------------- */

  /* -------------------------- GET  HOSPITAL ALL CATEGORY FOR HOME PAGE------------------------- */
  List<HospitalCategoryModel> hospitalAllCategoryList = [];
  Future<void> getHospitalAllCategory() async {
    if (hospitalAllCategoryList.isNotEmpty) return;
    isLoading = true;
    notifyListeners();

    final result = await iHospitalFacade.getHospitalAllCategory();
    result.fold((err) {
      CustomToast.errorToast(
          text: "Couldn't able to fetch hospital categories.");
      log('ERROR IN CATEGORY :: ${err.errMsg}');
    }, (success) {
      hospitalAllCategoryList = success;
    });
    isLoading = false;
    notifyListeners();
  }

  /* ------------------------------- GET ALL CATEGORY WISE DOCTORS FOR HOME PAGE ------------------------------ */
  List<DoctorModel> categoryWiseDoctorsList = [];
  Set<String> categoryWiseDoctorIds = {};

  final ScrollController doctorSearchScrollController = ScrollController();

  Future<void> getAllDoctorsCategoryWise({required String categoryId}) async {
    isLoading = true;
    notifyListeners();
    final result = await iHospitalFacade.getAllDoctorsCategoryWise(
        doctorSearch: doctorSearchController.text, categoryId: categoryId);

    result.fold((err) {
      CustomToast.errorToast(text: 'Unable to fetch doctors.');
      log('ERROR IN GET DOCTOR :: ${err.errMsg}');
    }, (success) {
          log('SEARCH DOCTOR LENGTH:::::::${success.length}');
      final uniqueDoctors = success
          .where((doctor) => !categoryWiseDoctorIds.contains(doctor.id))
          .toList();
      categoryWiseDoctorIds.addAll(uniqueDoctors.map((doctor) => doctor.id!));
      categoryWiseDoctorsList.addAll(uniqueDoctors);
  
      notifyListeners();
    });
    isLoading = false;
    notifyListeners();
  }

  void searchAllDoctorsCategoryWise({required String categoryId}) {
    iHospitalFacade.clearAllDoctorsCategoryWiseData();
    categoryWiseDoctorIds.clear();
    categoryWiseDoctorsList = [];
    getAllDoctorsCategoryWise(categoryId: categoryId,);
    getAllDoctorsCategoryWiseinit(
      scrollController: doctorSearchScrollController,
      categoryId: categoryId,
    );
    notifyListeners();
  }

  void clearAllDoctorsCategoryWiseData() {
    iHospitalFacade.clearAllDoctorsCategoryWiseData();
    doctorSearchController.clear();
    categoryWiseDoctorIds.clear();
    categoryWiseDoctorsList = [];
    notifyListeners();
  }

  void getAllDoctorsCategoryWiseinit(
      {required ScrollController scrollController,
      required String categoryId}) {
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge &&
            scrollController.position.pixels != 0 &&
            isLoading == false) {
          getAllDoctorsCategoryWise(categoryId: categoryId);
        }
      },
    );
  }

  /* -------------------------- FETCH SINGLE HOSPITAL for main page category wise ------------------------- */
  HospitalModel? selectedCategoryWiseHospital;

  Future<void> getCategoryWiseHospital({required String hospitalId}) async {
    isLoading = true;
    notifyListeners();
    final result =
        await iHospitalFacade.getCategoryWiseHospital(hospitalId: hospitalId);
    result.fold((err) {
      log('ERROR :: ${err.errMsg}');
    }, (success) {
      selectedCategoryWiseHospital = success;
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
      CustomToast.errorToast(text: 'Unable to fetch doctors.');
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

  Future<void> getCategoryWiseDoctor(
      {required String hospitalId, required String categoryId}) async {
    clearDoctorData();
    await getDoctors(hospitalId: hospitalId, categoryId: categoryId);
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
  Future<void> addHospitalBooking({
    required String hospitalId,
    required String userId,
    required UserModel userModel,
    required HospitalModel hospitalModel,
    required int totalAmount,
    required DoctorModel selectedDoctor,
    required String fcmtoken,
    required String userName,
    required UserFamilyMembersModel selectedMember,
  }) async {
    hospitalBookingModel = HospitalBookingModel(
      hospitalId: hospitalId,
      bookedAt: Timestamp.now(),
      patientName: selectedMember.name,
      patientAge: selectedMember.age,
      patientGender: selectedMember.gender,
      patientNumber: selectedMember.phoneNo,
      patientPlace: selectedMember.place,
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
        sendFcmMessage(
            token: fcmtoken,
            body:
                'New Booking Received from $userName. Please check the details and accept the order',
            title: 'New Booking Received!!!');
        CustomToast.sucessToast(text: success);
        log('Order Request Send Successfully');
      },
    );
    notifyListeners();
  }

  void clearControllerData() {
    selectedSlot = null;
    seletedBookingDate = null;
    notifyListeners();
  }

  DoctorModel? relatedSelectedDoctor;

  void setRelatedSelectedDoctor({required String selectedDoctorId}) {
    final result = doctorsList.firstWhere(
      (element) {
        return selectedDoctorId == element.id;
      },
    );
    relatedSelectedDoctor = result;
    log(relatedSelectedDoctor.toString());
    notifyListeners();
  }

  /* ------------------------- Location based fetching Hospitals------------------------ */

  final ScrollController mainScrollController = ScrollController();
  bool isFirebaseDataLoding = true;
  bool circularProgressLOading = true;
  bool isFunctionProcessing = false;
  PlaceMark? _checkPlaceMark;
  List<HospitalModel> hospitalList = [];

  Future<void> fetchHospitalLocationBasedData(BuildContext context) async {
    isFunctionProcessing = true;
    if (hospitalList.isEmpty) {
      isFirebaseDataLoding = true;
    }

    notifyListeners();

    final placeMark =
        context.read<LocationProvider>().locallySavedHospitalplacemark!;
    _checkPlaceMark = placeMark;
    final result =
        await iHospitalFacade.fetchHospitalLocationBasedData(placeMark);

    result.fold((l) {
      l.maybeMap(
        orElse: () {},
        firebaseException: (value) => CustomToast.errorToast(
          text: l.errMsg,
        ),
        generalException: (value) {
          circularProgressLOading = false;
          notifyListeners();
        },
      );
    }, (r) {
      if (r.length < 10) {
        circularProgressLOading = false;
      }
      hospitalList.addAll(r);
    });
    isFirebaseDataLoding = false;
    isFunctionProcessing = false;
    notifyListeners();
  }

  bool checkNearestHospitalLocation() {
    return (hospitalList.first.placemark?.localArea !=
        _checkPlaceMark?.localArea);
  }

  Future<void> hospitalFetchInitData({
    required BuildContext context,
  }) async {
    notifyListeners();
    log('called');
    final placeMark =
        context.read<LocationProvider>().locallySavedHospitalplacemark!;
    if (hospitalList.isEmpty ||
        _checkPlaceMark?.localArea != placeMark.localArea) {
      fecthHospitalLocation(
        context: context,
        success: () async {
          clearHospitalLocationData();
          await fetchHospitalLocationBasedData(context);
        },
      );
    }

    mainScrollController.addListener(() {
      if (mainScrollController.position.atEdge &&
          mainScrollController.position.pixels != 0 &&
          isFunctionProcessing == false &&
          circularProgressLOading == true) {
        fetchHospitalLocationBasedData(context);
      }
    });
  }

  void clearHospitalLocationData() {
    hospitalList.clear();
    iHospitalFacade.clearHospitalLocationData();
    isFirebaseDataLoding = true;
    circularProgressLOading = true;
    isFunctionProcessing = false;
    notifyListeners();
  }

  Future<void> fecthHospitalLocation({
    required BuildContext context,
    required void Function() success,
  }) async {
    final placeMark =
        context.read<LocationProvider>().locallySavedHospitalplacemark;
    final result = await iHospitalFacade.fecthHospitalLocation(placeMark!);
    result.fold(
      (l) {
        CustomToast.errorToast(
          text: l.errMsg,
        );
      },
      (r) {
        success.call();
      },
    );
  }
}
