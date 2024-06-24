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
    as _i31;
import '../../features/authentication/domain/facade/i_auth_facade.dart' as _i21;
import '../../features/authentication/infrastructure/i_auth_impl.dart' as _i22;
import '../../features/laboratory/application/provider/lab_orders_provider.dart'
    as _i23;
import '../../features/laboratory/application/provider/lab_provider.dart'
    as _i29;
import '../../features/laboratory/domain/facade/i_lab_facade.dart' as _i16;
import '../../features/laboratory/domain/facade/i_lab_orders_facade.dart'
    as _i18;
import '../../features/laboratory/infrastructure/i_lab_impl.dart' as _i17;
import '../../features/laboratory/infrastructure/i_lab_orders_impl.dart'
    as _i19;
import '../../features/location_picker/location_picker/application/location_provider.dart'
    as _i20;
import '../../features/location_picker/location_picker/domain/i_location_facde.dart'
    as _i14;
import '../../features/location_picker/location_picker/infrastructure/i_location_impl.dart'
    as _i15;
import '../../features/pharmacy/application/pharmacy_order_provider.dart'
    as _i24;
import '../../features/pharmacy/application/pharmacy_provider.dart' as _i30;
import '../../features/pharmacy/domain/i_pharmacy_facade.dart' as _i27;
import '../../features/pharmacy/domain/i_pharmacy_order_facade.dart' as _i12;
import '../../features/pharmacy/infrastructure/i_pharmacy_impl.dart' as _i28;
import '../../features/pharmacy/infrastructure/i_pharmacy_order_impl.dart'
    as _i13;
import '../../features/profile/application/provider/user_address_provider.dart'
    as _i32;
import '../../features/profile/application/provider/user_profile_provider.dart'
    as _i33;
import '../../features/profile/domain/facade/i_user_profile_facade.dart'
    as _i25;
import '../../features/profile/infrastructure/i_user_profile_impl.dart' as _i26;
import '../services/image_picker.dart' as _i7;
import '../services/location_service.dart' as _i8;
import '../services/pdf_picker.dart' as _i9;
import '../services/sound_services.dart' as _i11;
import '../services/url_launcher.dart' as _i10;
import 'firebase_injectable_module.dart' as _i3;
import 'general_injectable_module.dart' as _i34;

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
  gh.lazySingleton<_i14.ILocationFacade>(() => _i15.ILocationImpl(
        gh<_i8.LocationService>(),
        gh<_i6.FirebaseFirestore>(),
      ));
  gh.lazySingleton<_i16.ILabFacade>(() => _i17.ILabImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i11.SoundServices>(),
      ));
  gh.lazySingleton<_i18.ILabOrdersFacade>(() => _i19.ILabOrdersImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i7.ImageService>(),
      ));
  gh.factory<_i20.LocationProvider>(
      () => _i20.LocationProvider(gh<_i14.ILocationFacade>()));
  gh.lazySingleton<_i21.IAuthFacade>(() => _i22.IAuthImpl(
        gh<_i4.FirebaseAuth>(),
        gh<_i6.FirebaseFirestore>(),
      ));
  gh.factory<_i23.LabOrdersProvider>(
      () => _i23.LabOrdersProvider(gh<_i18.ILabOrdersFacade>()));
  gh.factory<_i24.PharmacyOrderProvider>(
      () => _i24.PharmacyOrderProvider(gh<_i12.IPharmacyOrderFacade>()));
  gh.lazySingleton<_i25.IUserProfileFacade>(() => _i26.IUserProfileImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i7.ImageService>(),
      ));
  gh.lazySingleton<_i27.IPharmacyFacade>(() => _i28.IPharmacyImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i7.ImageService>(),
      ));
  gh.factory<_i29.LabProvider>(() => _i29.LabProvider(
        gh<_i16.ILabFacade>(),
        gh<_i18.ILabOrdersFacade>(),
      ));
  gh.factory<_i30.PharmacyProvider>(
      () => _i30.PharmacyProvider(gh<_i27.IPharmacyFacade>()));
  gh.factory<_i31.AuthenticationProvider>(
      () => _i31.AuthenticationProvider(gh<_i21.IAuthFacade>()));
  gh.factory<_i32.UserAddressProvider>(
      () => _i32.UserAddressProvider(gh<_i25.IUserProfileFacade>()));
  gh.factory<_i33.UserProfileProvider>(
      () => _i33.UserProfileProvider(gh<_i25.IUserProfileFacade>()));
  return getIt;
}

class _$FirebaseInjecatbleModule extends _i3.FirebaseInjecatbleModule {}

class _$GeneralInjecatbleModule extends _i34.GeneralInjecatbleModule {}
