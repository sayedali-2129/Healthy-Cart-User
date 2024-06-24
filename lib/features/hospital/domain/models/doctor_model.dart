import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String? id;
  final String? hospitalId;
  final String? categoryId;
  final int? doctorFee;
  final int? doctorExperience;
  final String? doctorImage;
  final String? doctorName;
  final String? doctorTotalTime;
  final List<String>? doctorTimeList;
  final String? doctorSpecialization;
  final String? doctorQualification;
  final String? doctorAbout;
  final Timestamp? createdAt;
  final List<String>? keywords;

  DoctorModel({
    this.id,
    this.hospitalId,
    this.categoryId,
    this.doctorFee,
    this.doctorExperience,
    this.doctorImage,
    this.doctorName,
    this.doctorTotalTime,
    this.doctorTimeList,
    this.doctorSpecialization,
    this.doctorQualification,
    this.doctorAbout,
    this.createdAt,
    this.keywords,
  });

  DoctorModel copyWith({
    String? id,
    String? hospitalId,
    String? categoryId,
    int? doctorFee,
    int? doctorExperience,
    String? doctorImage,
    String? doctorName,
    String? doctorTotalTime,
    List<String>? doctorTimeList,
    String? doctorSpecialization,
    String? doctorQualification,
    String? doctorAbout,
    Timestamp? createdAt,
    List<String>? keywords,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      hospitalId: hospitalId ?? this.hospitalId,
      categoryId: categoryId ?? this.categoryId,
      doctorFee: doctorFee ?? this.doctorFee,
      doctorExperience: doctorExperience ?? this.doctorExperience,
      doctorImage: doctorImage ?? this.doctorImage,
      doctorName: doctorName ?? this.doctorName,
      doctorTotalTime: doctorTotalTime ?? this.doctorTotalTime,
      doctorTimeList: doctorTimeList ?? this.doctorTimeList,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      doctorQualification: doctorQualification ?? this.doctorQualification,
      doctorAbout: doctorAbout ?? this.doctorAbout,
      createdAt: createdAt ?? this.createdAt,
      keywords: keywords ?? this.keywords,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hospitalId': hospitalId,
      'categoryId': categoryId,
      'doctorFee': doctorFee,
      'doctorExperience': doctorExperience,
      'doctorImage': doctorImage,
      'doctorName': doctorName,
      'doctorTotalTime': doctorTotalTime,
      'doctorTimeList': doctorTimeList,
      'doctorSpecialization': doctorSpecialization,
      'doctorQualification': doctorQualification,
      'doctorAbout': doctorAbout,
      'createdAt': createdAt,
      'keywords': keywords,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] != null ? map['id'] as String : null,
      hospitalId:
          map['hospitalId'] != null ? map['hospitalId'] as String : null,
      categoryId:
          map['categoryId'] != null ? map['categoryId'] as String : null,
      doctorFee: map['doctorFee'] != null ? map['doctorFee'] as int : null,
      doctorExperience: map['doctorExperience'] != null
          ? map['doctorExperience'] as int
          : null,
      doctorImage:
          map['doctorImage'] != null ? map['doctorImage'] as String : null,
      doctorName:
          map['doctorName'] != null ? map['doctorName'] as String : null,
      doctorTotalTime: map['doctorTotalTime'] != null
          ? map['doctorTotalTime'] as String
          : null,
      doctorTimeList: map['doctorTimeList'] != null
          ? List<String>.from((map['doctorTimeList'] as List<dynamic>))
          : null,
      doctorSpecialization: map['doctorSpecialization'] != null
          ? map['doctorSpecialization'] as String
          : null,
      doctorQualification: map['doctorQualification'] != null
          ? map['doctorQualification'] as String
          : null,
      doctorAbout:
          map['doctorAbout'] != null ? map['doctorAbout'] as String : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      keywords: map['keywords'] != null
          ? List<String>.from((map['keywords'] as List<dynamic>))
          : null,
    );
  }
}
