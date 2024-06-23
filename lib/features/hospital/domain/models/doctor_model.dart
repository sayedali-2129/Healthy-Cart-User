// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String? id;
  String? doctorImage;
  String? doctorName;
  String? doctorSpecialization;
  String? doctorQualification;
  List<String>? keywords;
  Timestamp? createdAt;
  DoctorModel({
    this.id,
    this.doctorImage,
    this.doctorName,
    this.doctorSpecialization,
    this.doctorQualification,
    this.keywords,
    this.createdAt,
  });

  DoctorModel copyWith({
    String? id,
    String? doctorImage,
    String? doctorName,
    String? doctorSpecialization,
    String? doctorQualification,
    List<String>? keywords,
    Timestamp? createdAt,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      doctorImage: doctorImage ?? this.doctorImage,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      doctorQualification: doctorQualification ?? this.doctorQualification,
      keywords: keywords ?? this.keywords,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'doctorImage': doctorImage,
      'doctorName': doctorName,
      'doctorSpecialization': doctorSpecialization,
      'doctorQualification': doctorQualification,
      'keywords': keywords,
      'createdAt': createdAt,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] != null ? map['id'] as String : null,
      doctorImage:
          map['doctorImage'] != null ? map['doctorImage'] as String : null,
      doctorName:
          map['doctorName'] != null ? map['doctorName'] as String : null,
      doctorSpecialization: map['doctorSpecialization'] != null
          ? map['doctorSpecialization'] as String
          : null,
      doctorQualification: map['doctorQualification'] != null
          ? map['doctorQualification'] as String
          : null,
      keywords: map['keywords'] != null
          ? List<String>.from(map['keywords'] as List<dynamic>)
          : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
    );
  }
}
