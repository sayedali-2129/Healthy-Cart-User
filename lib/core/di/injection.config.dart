// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i6;
import 'package:firebase_auth/firebase_auth.dart' as _i4;
import 'package:firebase_storage/firebase_storage.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/authentication/application/provider/authenication_provider.dart'
    as _i43;
import '../../features/authentication/domain/facade/i_auth_facade.dart' as _i27;
import '../../features/authentication/infrastructure/i_auth_impl.dart' as _i28;
import '../../features/home/application/provider/home_provider.dart' as _i42;
import '../../features/home/domain/facade/i_home_facade.dart' as _i16;
import '../../features/home/infrastructure/i_home_impl.dart' as _i17;
import '../../features/hospital/application/provider/hosp_booking_provider.dart'
    as _i40;
import '../../features/hospital/application/provider/hospital_provider.dart'
    as _i33;
import '../../features/hospital/domain/facade/i_hospital_booking_facade.dart'
    as _i25;
import '../../features/hospital/domain/facade/i_hospital_facade.dart' as _i14;
import '../../features/hospital/infrastructure/i_hospital_booking_impl.dart'
    as _i26;
import '../../features/hospital/infrastructure/i_hospital_impl.dart' as _i15;
import '../../features/laboratory/application/provider/lab_orders_provider.dart'
    as _i31;
import '../../features/laboratory/application/provider/lab_provider.dart'
    as _i38;
import '../../features/laboratory/domain/facade/i_lab_facade.dart' as _i20;
import '../../features/laboratory/domain/facade/i_lab_orders_facade.dart'
    as _i22;
import '../../features/laboratory/infrastructure/i_lab_impl.dart' as _i21;
import '../../features/laboratory/infrastructure/i_lab_orders_impl.dart'
    as _i23;
import '../../features/location_picker/location_picker/application/location_provider.dart'
    as _i24;
import '../../features/location_picker/location_picker/domain/i_location_facde.dart'
    as _i18;
import '../../features/location_picker/location_picker/infrastructure/i_location_impl.dart'
    as _i19;
import '../../features/notifications/application/provider/notification_provider.dart'
    as _i39;
import '../../features/notifications/domain/i_notification_facade.dart' as _i29;
import '../../features/notifications/infrastructure/i_notification_impl.dart'
    as _i30;
import '../../features/pharmacy/application/pharmacy_order_provider.dart'
    as _i32;
import '../../features/pharmacy/application/pharmacy_provider.dart' as _i41;
import '../../features/pharmacy/domain/i_pharmacy_facade.dart' as _i36;
import '../../features/pharmacy/domain/i_pharmacy_order_facade.dart' as _i12;
import '../../features/pharmacy/infrastructure/i_pharmacy_impl.dart' as _i37;
import '../../features/pharmacy/infrastructure/i_pharmacy_order_impl.dart'
    as _i13;
import '../../features/profile/application/provider/user_address_provider.dart'
    as _i44;
import '../../features/profile/application/provider/user_family_provider.dart'
    as _i46;
import '../../features/profile/application/provider/user_profile_provider.dart'
    as _i45;
import '../../features/profile/domain/facade/i_user_profile_facade.dart'
    as _i34;
import '../../features/profile/infrastructure/i_user_profile_impl.dart' as _i35;
import '../services/image_picker.dart' as _i7;
import '../services/location_service.dart' as _i8;
import '../services/pdf_picker.dart' as _i9;
import '../services/sound_services.dart' as _i11;
import '../services/url_launcher.dart' as _i10;
import 'firebase_injectable_module.dart' as _i3;
import 'general_injectable_module.dart' as _i47;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final firebaseInjecatbleModule = _$FirebaseInjecatbleModule();
  final generalInjecatbleModule = _$GeneralInjecatbleModule();
  await gh.factoryAsync<_i3.FirebaseService>(
    () => firebaseInjecatbleModule.firebaseService,
    preResolve: true,
  );
  gh.lazySingleton<_i4.FirebaseAuth>(() => firebaseInjecatbleModule.auth);
  gh.lazySingleton<_i5.FirebaseStorage>(() => firebaseInjecatbleModule.storage);
  gh.lazySingleton<_i6.FirebaseFirestore>(() => firebaseInjecatbleModule.repo);
  gh.lazySingleton<_i7.ImageService>(
      () => generalInjecatbleModule.imageServices);
  gh.lazySingleton<_i8.LocationService>(
      () => generalInjecatbleModule.locationServices);
  gh.lazySingleton<_i9.PdfPickerService>(
      () => generalInjecatbleModule.pdfPickerService);
  gh.lazySingleton<_i10.UrlService>(() => generalInjecatbleModule.urlService);
  gh.lazySingleton<_i11.SoundServices>(
      () => generalInjecatbleModule.soundServices);
  gh.lazySingleton<_i12.IPharmacyOrderFacade>(
      () => _i13.IPharmacyOrdersImpl(gh<_i6.FirebaseFirestore>()));
  gh.lazySingleton<_i14.IHospitalFacade>(
      () => _i15.IHospitalImpl(gh<_i6.FirebaseFirestore>()));
  gh.lazySingleton<_i16.IHomeFacade>(
      () => _i17.IHomeImpl(gh<_i6.FirebaseFirestore>()));
  gh.lazySingleton<_i18.ILocationFacade>(() => _i19.ILocationImpl(
        gh<_i8.LocationService>(),
        gh<_i6.FirebaseFirestore>(),
      ));
  gh.lazySingleton<_i20.ILabFacade>(() => _i21.ILabImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i11.SoundServices>(),
      ));
  gh.lazySingleton<_i22.ILabOrdersFacade>(() => _i23.ILabOrdersImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i7.ImageService>(),
      ));
  gh.factory<_i24.LocationProvider>(
      () => _i24.LocationProvider(gh<_i18.ILocationFacade>()));
  gh.lazySingleton<_i25.IHospitalBookingFacade>(
      () => _i26.IHospitalBookingImpl(gh<_i6.FirebaseFirestore>()));
  gh.lazySingleton<_i27.IAuthFacade>(() => _i28.IAuthImpl(
        gh<_i4.FirebaseAuth>(),
        gh<_i6.FirebaseFirestore>(),
      ));
  gh.lazySingleton<_i29.INotificationFacade>(
      () => _i30.INotificationImpl(gh<_i6.FirebaseFirestore>()));
  gh.factory<_i31.LabOrdersProvider>(
      () => _i31.LabOrdersProvider(gh<_i22.ILabOrdersFacade>()));
  gh.factory<_i32.PharmacyOrderProvider>(
      () => _i32.PharmacyOrderProvider(gh<_i12.IPharmacyOrderFacade>()));
  gh.factory<_i33.HospitalProvider>(() => _i33.HospitalProvider(
        gh<_i14.IHospitalFacade>(),
        gh<_i25.IHospitalBookingFacade>(),
      ));
  gh.lazySingleton<_i34.IUserProfileFacade>(() => _i35.IUserProfileImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i7.ImageService>(),
      ));
  gh.lazySingleton<_i36.IPharmacyFacade>(() => _i37.IPharmacyImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i7.ImageService>(),
      ));
  gh.factory<_i38.LabProvider>(() => _i38.LabProvider(
        gh<_i20.ILabFacade>(),
        gh<_i22.ILabOrdersFacade>(),
      ));
  gh.factory<_i39.NotificationProvider>(
      () => _i39.NotificationProvider(gh<_i29.INotificationFacade>()));
  gh.factory<_i40.HospitalBookingProivder>(
      () => _i40.HospitalBookingProivder(gh<_i25.IHospitalBookingFacade>()));
  gh.factory<_i41.PharmacyProvider>(
      () => _i41.PharmacyProvider(gh<_i36.IPharmacyFacade>()));
  gh.factory<_i42.HomeProvider>(
      () => _i42.HomeProvider(gh<_i16.IHomeFacade>()));
  gh.factory<_i43.AuthenticationProvider>(
      () => _i43.AuthenticationProvider(gh<_i27.IAuthFacade>()));
  gh.factory<_i44.UserAddressProvider>(
      () => _i44.UserAddressProvider(gh<_i34.IUserProfileFacade>()));
  gh.factory<_i45.UserProfileProvider>(
      () => _i45.UserProfileProvider(gh<_i34.IUserProfileFacade>()));
  gh.factory<_i46.UserFamilyMembersProvider>(
      () => _i46.UserFamilyMembersProvider(gh<_i34.IUserProfileFacade>()));
  return getIt;
}

class _$FirebaseInjecatbleModule extends _i3.FirebaseInjecatbleModule {}

class _$GeneralInjecatbleModule extends _i47.GeneralInjecatbleModule {}
