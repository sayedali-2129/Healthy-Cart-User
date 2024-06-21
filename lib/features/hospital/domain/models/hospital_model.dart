// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';

class HospitalModel {
  String? id;
  String? phoneNo;
  PlaceMark? placemark;

  String? hospitalName;
  String? address;
  String? ownerName;
  String? image;
  List<String>? selectedCategoryId;
  bool? isActive;
  bool? ishospitalON;
  Timestamp? createdAt;
  List<String>? keywords;
  String? fcmToken;

  HospitalModel({
    this.id,
    this.hospitalName,
    this.address,
    this.ownerName,
    this.image,
    this.selectedCategoryId,
    this.isActive,
    this.ishospitalON,
    this.createdAt,
    this.keywords,
    this.fcmToken,
    this.phoneNo,
    this.placemark,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hospitalName': hospitalName,
      'address': address,
      'ownerName': ownerName,
      'image': image,
      'selectedCategoryId': selectedCategoryId,
      'isActive': isActive,
      'ishospitalON': ishospitalON,
      'createdAt': createdAt,
      'keywords': keywords,
      'fcmToken': fcmToken,
      'phoneNo': phoneNo,
      'placemark': placemark?.toJson(),
    };
  }

  factory HospitalModel.fromMap(Map<String, dynamic> map) {
    return HospitalModel(
      id: map['id'] != null ? map['id'] as String : null,
      hospitalName:
          map['hospitalName'] != null ? map['hospitalName'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      ownerName: map['ownerName'] != null ? map['ownerName'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      selectedCategoryId: map['selectedCategoryId'] != null
          ? List<String>.from((map['selectedCategoryId'] as List<dynamic>))
          : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      ishospitalON:
          map['ishospitalON'] != null ? map['ishospitalON'] as bool : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      keywords: map['keywords'] != null
          ? List<String>.from((map['keywords'] as List<dynamic>))
          : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      placemark: map['placemark'] != null
          ? PlaceMark.fromMap(map['placemark'] as Map<String, dynamic>)
          : null,
    );
  }

  HospitalModel copyWith({
    String? hospitalName,
    String? address,
    String? ownerName,
    String? image,
    List<String>? selectedCategoryId,
    bool? isActive,
    bool? ishospitalON,
    Timestamp? createdAt,
    List<String>? keywords,
    String? id,
    String? fcmToken,
    String? phoneNo,
    PlaceMark? placemark,
  }) {
    return HospitalModel(
      hospitalName: hospitalName ?? this.hospitalName,
      address: address ?? this.address,
      ownerName: ownerName ?? this.ownerName,
      image: image ?? this.image,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isActive: isActive ?? this.isActive,
      ishospitalON: ishospitalON ?? this.ishospitalON,
      createdAt: createdAt ?? this.createdAt,
      keywords: keywords ?? this.keywords,
      id: id ?? this.id,
      fcmToken: fcmToken ?? this.fcmToken,
      phoneNo: phoneNo ?? this.phoneNo,
      placemark: placemark ?? this.placemark,
    );
  }
}
