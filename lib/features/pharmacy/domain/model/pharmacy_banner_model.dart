

import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyBannerModel {
  String? id;
  final String? image;
  final Timestamp? isCreated;
  final String pharmacyId;
  PharmacyBannerModel({
    this.id,
    this.image,
    this.isCreated,
    required this.pharmacyId,
  });



  PharmacyBannerModel copyWith({
    String? id,
    String? image,
    Timestamp? isCreated,
    String? pharmacyId,
  }) {
    return PharmacyBannerModel(
      id: id ?? this.id,
      image: image ?? this.image,
      isCreated: isCreated ?? this.isCreated,
      pharmacyId: pharmacyId ?? this.pharmacyId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'isCreated': isCreated,
      'pharmacyId': pharmacyId,
    };
  }

  factory PharmacyBannerModel.fromMap(Map<String, dynamic> map) {
    return PharmacyBannerModel(
      id: map['id'] != null ? map['id'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      isCreated: map['isCreated'] != null ? map['isCreated'] as Timestamp : null,
      pharmacyId: map['pharmacyId'] as String,
    );
  }


}

