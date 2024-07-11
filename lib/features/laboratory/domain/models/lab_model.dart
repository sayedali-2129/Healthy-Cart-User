import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';

class LabModel {
  String? id;
  PlaceMark? placemark;
  String? phoneNo;
  String? laboratoryName;
  String? address;
  String? ownerName;
  String? uploadLicense;
  String? image;
  bool? isActive;
  Timestamp? createdAt;
  bool? isLabotaroryOn;
  int? requested;
  String? rejectionReason;
  List<String>? keywords;
  String? fcmToken;
  String? email;
  LabModel({
    this.id,
    this.placemark,
    this.phoneNo,
    this.laboratoryName,
    this.address,
    this.ownerName,
    this.uploadLicense,
    this.image,
    this.isActive,
    this.createdAt,
    this.isLabotaroryOn,
    this.requested,
    this.rejectionReason,
    this.keywords,
    this.fcmToken,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'phoneNo': phoneNo,
      'laboratoryName': laboratoryName,
      'address': address,
      'ownerName': ownerName,
      'uploadLicense': uploadLicense,
      'image': image,
      'isActive': isActive,
      'createdAt': createdAt,
      'isLabotaroryOn': isLabotaroryOn,
      'requested': requested,
      'rejectionReason': rejectionReason,
      'keywords': keywords,
      'fcmToken': fcmToken,
      'email': email,
    };
  }

  Map<String, dynamic> toEditMap() {
    return {
      'laboratoryName': laboratoryName,
      'address': address,
      'ownerName': ownerName,
      'uploadLicense': uploadLicense,
      'image': image,
      'keywords': keywords,
      'email': email,
    };
  }

  factory LabModel.fromMap(Map<String, dynamic> map) {
    return LabModel(
      id: map['id'] != null ? map['id'] as String : null,
      placemark: map['placemark'] != null
          ? PlaceMark.fromMap(map['placemark'] as Map<String, dynamic>)
          : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      laboratoryName: map['laboratoryName'] != null
          ? map['laboratoryName'] as String
          : null,
      address: map['address'] != null ? map['address'] as String : null,
      ownerName: map['ownerName'] != null ? map['ownerName'] as String : null,
      uploadLicense:
          map['uploadLicense'] != null ? map['uploadLicense'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      isLabotaroryOn:
          map['isLabotaroryOn'] != null ? map['isLabotaroryOn'] as bool : null,
      requested: map['requested'] != null ? map['requested'] as int : null,
      rejectionReason: map['rejectionReason'] != null
          ? map['rejectionReason'] as String
          : null,
      keywords: map['keywords'] != null
          ? List<String>.from((map['keywords'] as List<dynamic>))
          : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  LabModel copyWith({
    String? id,
    PlaceMark? placemark,
    String? phoneNo,
    String? laboratoryName,
    String? address,
    String? ownerName,
    String? uploadLicense,
    String? image,
    bool? isActive,
    Timestamp? createdAt,
    bool? isLabotaroryOn,
    int? requested,
    String? rejectionReason,
    List<String>? keywords,
    String? fcmToken,
    String? email,
  }) {
    return LabModel(
      id: id ?? this.id,
      placemark: placemark ?? this.placemark,
      phoneNo: phoneNo ?? this.phoneNo,
      laboratoryName: laboratoryName ?? this.laboratoryName,
      address: address ?? this.address,
      ownerName: ownerName ?? this.ownerName,
      uploadLicense: uploadLicense ?? this.uploadLicense,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      isLabotaroryOn: isLabotaroryOn ?? this.isLabotaroryOn,
      requested: requested ?? this.requested,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      keywords: keywords ?? this.keywords,
      fcmToken: fcmToken ?? this.fcmToken,
      email: email ?? this.email,
    );
  }
}
