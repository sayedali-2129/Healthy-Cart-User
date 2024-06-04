import 'package:cloud_firestore/cloud_firestore.dart';

class LabModel {
  String? id;
  String? address;
  String? laboratoryName;
  String? image;
  String? phoneNo;
  int? requested;
  bool? isActive;
  List<String>? keywords;
  Timestamp? createdAt;
  bool? isLabotaroryOn;
  LabModel({
    this.id,
    this.address,
    this.laboratoryName,
    this.image,
    this.phoneNo,
    this.requested,
    this.isActive,
    this.keywords,
    this.createdAt,
    this.isLabotaroryOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'address': address,
      'laboratoryName': laboratoryName,
      'image': image,
      'phoneNo': phoneNo,
      'requested': requested,
      'isActive': isActive,
      'keywords': keywords,
      'createdAt': createdAt,
      'isLabotaroryOn': isLabotaroryOn,
    };
  }

  factory LabModel.fromMap(Map<String, dynamic> map) {
    return LabModel(
      id: map['id'] != null ? map['id'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      laboratoryName: map['laboratoryName'] != null
          ? map['laboratoryName'] as String
          : null,
      image: map['image'] != null ? map['image'] as String : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      requested: map['requested'] != null ? map['requested'] as int : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      keywords: map['keywords'] != null
          ? List<String>.from((map['keywords'] as List<dynamic>))
          : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      isLabotaroryOn:
          map['isLabotaroryOn'] != null ? map['isLabotaroryOn'] as bool : null,
    );
  }

  LabModel copyWith({
    String? id,
    String? address,
    String? laboratoryName,
    String? image,
    String? phoneNo,
    int? requested,
    bool? isActive,
    List<String>? keywords,
    Timestamp? createdAt,
    bool? isLabotaroryOn,
  }) {
    return LabModel(
      id: id ?? this.id,
      address: address ?? this.address,
      laboratoryName: laboratoryName ?? this.laboratoryName,
      image: image ?? this.image,
      phoneNo: phoneNo ?? this.phoneNo,
      requested: requested ?? this.requested,
      isActive: isActive ?? this.isActive,
      keywords: keywords ?? this.keywords,
      createdAt: createdAt ?? this.createdAt,
      isLabotaroryOn: isLabotaroryOn ?? this.isLabotaroryOn,
    );
  }
}
