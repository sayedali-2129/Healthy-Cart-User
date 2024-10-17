import 'package:firebase_storage/firebase_storage.dart';
import 'package:healthy_cart_user/core/di/injection.dart';
import 'package:healthy_cart_user/core/services/image_picker.dart';
import 'package:healthy_cart_user/core/services/location_service.dart';
import 'package:healthy_cart_user/core/services/pdf_picker.dart';
import 'package:healthy_cart_user/core/services/sound_services.dart';
import 'package:healthy_cart_user/core/services/url_launcher.dart';
import 'package:injectable/injectable.dart';

@module
abstract class GeneralInjecatbleModule {
  @lazySingleton
  ImageService get imageServices => ImageService(sl<FirebaseStorage>());
  @lazySingleton
  LocationService get locationServices => LocationService();
  @lazySingleton
  PdfPickerService get pdfPickerService =>
      PdfPickerService(sl<FirebaseStorage>());
  @lazySingleton
  UrlService get urlService => UrlService();
  @lazySingleton
  SoundServices get soundServices => SoundServices();
 
}
