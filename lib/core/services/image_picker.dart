import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  ImageService(this._storage);

  final FirebaseStorage _storage;
  final ImagePicker picker = ImagePicker();
  Future<Either<MainFailure, File>> getGalleryImage() async {
    final XFile? pickedImageFile;
    final File? imageFile;
    try {
      pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImageFile != null) {
        imageFile = File(pickedImageFile.path);
        return right(imageFile);
      } else {
        return left(
            const MainFailure.generalException(errMsg: 'Image is not picked'));
      }
    } catch (e) {
      return left(
          const MainFailure.generalException(errMsg: 'Image is not picked'));
    }
  }

//save image

  Future<Either<MainFailure, String>> saveImage({
    required String folderName,
    required File imageFile,
  }) async {
    final String imageName =
        '$folderName/${DateTime.now().microsecondsSinceEpoch}.png';
    final String? downloadUrl;
    try {
      final imageBytes = await imageFile.readAsBytes();

      final resultImage = await FlutterImageCompress.compressWithList(
        imageBytes,
        quality: 70, // Lower quality for more aggressive compression
        minHeight: 720, // Lower minimum height
        minWidth: 1280, // Lower minimum width
        // Increase downsampling for more aggressive compression
      );
      await _storage
          .ref(imageName)
          .putData(resultImage, SettableMetadata(contentType: 'image/png'));
      downloadUrl = await _storage.ref(imageName).getDownloadURL();

      return right(downloadUrl);
    } catch (e) {
      return left(const MainFailure.generalException(
          errMsg: "Can't able to save image."));
    }
  }

//delete Image

  Future<Either<MainFailure, Unit>> deleteImageUrl({
    required String? imageUrl,
  }) async {
    if (imageUrl == null) {
      return left(const MainFailure.generalException(
          errMsg: "Can't able to remove previous image."));
    }
    final imageRef = _storage.refFromURL(imageUrl);
    try {
      await imageRef.delete();
      return right(unit);
    } catch (e) {
      return left(const MainFailure.generalException(
          errMsg: "Can't able to remove previous image."));
    }
  }
}
