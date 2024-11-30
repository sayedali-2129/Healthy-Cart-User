import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';


class PharmacyModel {
  String? id;
  final String? phoneNo;
  PlaceMark? placemark;
  final String? pharmacyName;
  final String? contactNumber;
  final String? pharmacyAddress;
  final String? pharmacyownerName;
  final String? pharmacyDocumentLicense;
  final String? pharmacyImage;
  final int? pharmacyRequested;
  final bool? isActive;
  final bool? isHomeDelivery;
  final bool? isPharmacyON;
  final Timestamp? createdAt;
  final List<String>? selectedCategoryId;
  final List<String>? pharmacyKeywords;
  final String? rejectionReason;
  final String? fcmToken;
  final String? email;
  PharmacyModel({
    this.id,
    this.phoneNo,
    this.placemark,
    this.pharmacyName,
    this.contactNumber,
    this.pharmacyAddress,
    this.pharmacyownerName,
    this.pharmacyDocumentLicense,
    this.pharmacyImage,
    this.pharmacyRequested,
    this.isActive,
     this.isHomeDelivery,
    this.isPharmacyON,
    this.createdAt,
    this.selectedCategoryId,
    this.fcmToken,
    this.email,
    this.pharmacyKeywords,
    this.rejectionReason,
  });

  PharmacyModel copyWith({
    String? id,
    String? phoneNo,
    PlaceMark? placemark,
    String? pharmacyName,
     String? contactNumber,
    String? pharmacyAddress,
    String? pharmacyownerName,
    String? pharmacyDocumentLicense,
    String? pharmacyImage,
    List<String>? selectedCategoryId,
    int? pharmacyRequested,
    bool? isActive,
    bool? isHomeDelivery,
    bool? isPharmacyON,
    Timestamp? createdAt,
    List<String>? pharmacyKeywords,
    String? fcmToken,
    String? email,
    String? rejectionReason,
  }) {
    return PharmacyModel(
      id: id ?? this.id,
      phoneNo: phoneNo ?? this.phoneNo,
      placemark: placemark ?? this.placemark,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      contactNumber: contactNumber ?? this.contactNumber,
      pharmacyAddress: pharmacyAddress ?? this.pharmacyAddress,
      pharmacyownerName: pharmacyownerName ?? this.pharmacyownerName,
      pharmacyDocumentLicense:
      pharmacyDocumentLicense ?? this.pharmacyDocumentLicense,
      pharmacyImage: pharmacyImage ?? this.pharmacyImage,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      pharmacyRequested: pharmacyRequested ?? this.pharmacyRequested,
      isHomeDelivery: isHomeDelivery ?? this.isHomeDelivery,
       isActive: isActive ?? this.isActive,
      fcmToken: fcmToken ?? this.fcmToken,
      email: email ?? this.email,
      isPharmacyON: isPharmacyON ?? this.isPharmacyON,
      createdAt: createdAt ?? this.createdAt,
      pharmacyKeywords: pharmacyKeywords ?? this.pharmacyKeywords,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'phoneNo': phoneNo,
      'placemark': placemark?.toMap(),
      'pharmacyName': pharmacyName,
       'contactNumber' : contactNumber,
      'pharmacyAddress': pharmacyAddress,
      'pharmacyownerName': pharmacyownerName,
      'pharmacyDocumentLicense': pharmacyDocumentLicense,
      'pharmacyImage': pharmacyImage,
      'selectedCategoryId': selectedCategoryId,
      'pharmacyRequested': pharmacyRequested,
      'isActive': isActive,
       'isHomeDelivery': isHomeDelivery,
      'isPharmacyON': isPharmacyON,
      'createdAt': createdAt,
      'pharmacyKeywords': pharmacyKeywords,
      'email': email,
      'fcmToken': fcmToken,
      'rejectionReason': rejectionReason,
    };
  }

  
  Map<String, dynamic> toProductMap() {
    return <String, dynamic>{
      'pharmacyName': pharmacyName,
       'contactNumber' : contactNumber,
      'pharmacyAddress': pharmacyAddress,
      'pharmacyImage': pharmacyImage,
      'phoneNo': phoneNo,
      'fcmToken': fcmToken,
      'email': email,
      'pharmacyKeywords': pharmacyKeywords,
    };
  }

  factory PharmacyModel.fromMap(Map<String, dynamic> map) {
    return PharmacyModel(
      id: map['id'] != null ? map['id'] as String : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      placemark: map['placemark'] != null
          ? PlaceMark.fromMap(map['placemark'] as Map<String, dynamic>)
          : null,
      pharmacyName:
          map['pharmacyName'] != null ? map['pharmacyName'] as String : null,
       contactNumber: map['contactNumber'] as String?,       
      pharmacyAddress: map['pharmacyAddress'] != null
          ? map['pharmacyAddress'] as String
          : null,
      pharmacyownerName: map['pharmacyownerName'] != null
          ? map['pharmacyownerName'] as String
          : null,
      pharmacyDocumentLicense: map['pharmacyDocumentLicense'] != null
          ? map['pharmacyDocumentLicense'] as String
          : null,
      pharmacyImage:
          map['pharmacyImage'] != null ? map['pharmacyImage'] as String : null,
      selectedCategoryId: map['selectedCategoryId'] != null
          ? List<String>.from((map['selectedCategoryId'] as List<dynamic>))
          : null,
      pharmacyRequested: map['pharmacyRequested'] != null
          ? map['pharmacyRequested'] as int
          : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
       isHomeDelivery: map['isHomeDelivery'] != null ? map['isHomeDelivery'] as bool : null,
      isPharmacyON:
          map['isPharmacyON'] != null ? map['isPharmacyON'] as bool : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      email: map['email'] != null ? map['email'] as String : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      pharmacyKeywords: map['pharmacyKeywords'] != null
          ? List<String>.from((map['pharmacyKeywords'] as List<dynamic>))
          : null,
      rejectionReason: map['rejectionReason'] != null
          ? map['rejectionReason'] as String
          : null,
    );
  }
}