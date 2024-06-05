// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class LabTestModel {
  String? id;
  String? labId;
  String? testName;
  String? testImage;
  num? testPrice;
  num? offerPrice;
  Timestamp? createdAt;
  bool? isDoorstepAvailable;
  LabTestModel({
    this.id,
    this.labId,
    this.testName,
    this.testImage,
    this.testPrice,
    this.offerPrice,
    this.createdAt,
    this.isDoorstepAvailable,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'labId': labId,
      'testName': testName,
      'testImage': testImage,
      'testPrice': testPrice,
      'offerPrice': offerPrice,
      'createdAt': createdAt,
      'isDoorstepAvailable': isDoorstepAvailable,
    };
  }

  factory LabTestModel.fromMap(Map<String, dynamic> map) {
    return LabTestModel(
      id: map['id'] != null ? map['id'] as String : null,
      labId: map['labId'] != null ? map['labId'] as String : null,
      testName: map['testName'] != null ? map['testName'] as String : null,
      testImage: map['testImage'] != null ? map['testImage'] as String : null,
      testPrice: map['testPrice'] != null ? map['testPrice'] as num : null,
      offerPrice: map['offerPrice'] != null ? map['offerPrice'] as num : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      isDoorstepAvailable: map['isDoorstepAvailable'] != null
          ? map['isDoorstepAvailable'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LabTestModel.fromJson(String source) =>
      LabTestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  LabTestModel copyWith({
    String? id,
    String? labId,
    String? testName,
    String? testImage,
    num? testPrice,
    num? offerPrice,
    Timestamp? createdAt,
    bool? isDoorstepAvailable,
  }) {
    return LabTestModel(
      id: id ?? this.id,
      labId: labId ?? this.labId,
      testName: testName ?? this.testName,
      testImage: testImage ?? this.testImage,
      testPrice: testPrice ?? this.testPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      createdAt: createdAt ?? this.createdAt,
      isDoorstepAvailable: isDoorstepAvailable ?? this.isDoorstepAvailable,
    );
  }
}
