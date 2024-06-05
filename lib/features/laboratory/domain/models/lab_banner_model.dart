// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class LabBannerModel {
  String? id;
  String? hospitalId;
  String? image;
  Timestamp? isCreated;
  LabBannerModel({
    this.id,
    this.hospitalId,
    this.image,
    this.isCreated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hospitalId': hospitalId,
      'image': image,
      'isCreated': isCreated,
    };
  }

  factory LabBannerModel.fromMap(Map<String, dynamic> map) {
    return LabBannerModel(
      id: map['id'] != null ? map['id'] as String : null,
      hospitalId:
          map['hospitalId'] != null ? map['hospitalId'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      isCreated:
          map['isCreated'] != null ? map['isCreated'] as Timestamp : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LabBannerModel.fromJson(String source) =>
      LabBannerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  LabBannerModel copyWith({
    String? id,
    String? hospitalId,
    String? image,
    Timestamp? isCreated,
  }) {
    return LabBannerModel(
      id: id ?? this.id,
      hospitalId: hospitalId ?? this.hospitalId,
      image: image ?? this.image,
      isCreated: isCreated ?? this.isCreated,
    );
  }
}
