// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';

class HospitalBookingModel {
  String? id;
  String? hospitalId;
  String? userId;
  String? patientName;
  String? patientAge;
  String? patientGender;
  String? patientPlace;
  String? patientNumber;
  String? paymentMethod;
  int? orderStatus;
  int? totalAmount;
  Timestamp? bookedAt;
  int? paymentStatus;
  DoctorModel? selectedDoctor;
  String? selectedDate;
  String? selectedTimeSlot;
  Timestamp? acceptedAt;
  Timestamp? rejectedAt;
  Timestamp? completedAt;
  HospitalModel? hospitalDetails;
  String? rejectReason;
  bool? isUserAccepted;
  UserModel? userDetails;
  HospitalBookingModel({
    this.id,
    this.hospitalId,
    this.userId,
    this.patientName,
    this.patientAge,
    this.patientGender,
    this.patientPlace,
    this.patientNumber,
    this.paymentMethod,
    this.orderStatus,
    this.totalAmount,
    this.bookedAt,
    this.paymentStatus,
    this.selectedDoctor,
    this.selectedDate,
    this.selectedTimeSlot,
    this.acceptedAt,
    this.rejectedAt,
    this.completedAt,
    this.hospitalDetails,
    this.rejectReason,
    this.isUserAccepted,
    this.userDetails,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hospitalId': hospitalId,
      'userId': userId,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'patientPlace': patientPlace,
      'patientNumber': patientNumber,
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus,
      'totalAmount': totalAmount,
      'bookedAt': bookedAt,
      'paymentStatus': paymentStatus,
      'selectedDoctor': selectedDoctor!.toMap(),
      'selectedDate': selectedDate,
      'selectedTimeSlot': selectedTimeSlot,
      'acceptedAt': acceptedAt,
      'rejectedAt': rejectedAt,
      'completedAt': completedAt,
      'hospitalDetails': hospitalDetails!.toMap(),
      'rejectReason': rejectReason,
      'isUserAccepted': isUserAccepted,
      'userDetails': userDetails!.toMap(),
    };
  }

  factory HospitalBookingModel.fromMap(Map<String, dynamic> map) {
    return HospitalBookingModel(
      id: map['id'] != null ? map['id'] as String : null,
      hospitalId:
          map['hospitalId'] != null ? map['hospitalId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      patientName:
          map['patientName'] != null ? map['patientName'] as String : null,
      patientAge:
          map['patientAge'] != null ? map['patientAge'] as String : null,
      patientGender:
          map['patientGender'] != null ? map['patientGender'] as String : null,
      patientPlace:
          map['patientPlace'] != null ? map['patientPlace'] as String : null,
      patientNumber:
          map['patientNumber'] != null ? map['patientNumber'] as String : null,
      paymentMethod:
          map['paymentMethod'] != null ? map['paymentMethod'] as String : null,
      orderStatus:
          map['orderStatus'] != null ? map['orderStatus'] as int : null,
      totalAmount:
          map['totalAmount'] != null ? map['totalAmount'] as int : null,
      bookedAt: map['bookedAt'] != null ? map['bookedAt'] as Timestamp : null,
      paymentStatus:
          map['paymentStatus'] != null ? map['paymentStatus'] as int : null,
      selectedDoctor: map['selectedDoctor'] != null
          ? DoctorModel.fromMap(map['selectedDoctor'] as Map<String, dynamic>)
          : null,
      selectedDate:
          map['selectedDate'] != null ? map['selectedDate'] as String : null,
      selectedTimeSlot: map['selectedTimeSlot'] != null
          ? map['selectedTimeSlot'] as String
          : null,
      acceptedAt:
          map['acceptedAt'] != null ? map['bookedAt'] as Timestamp : null,
      rejectedAt:
          map['rejectedAt'] != null ? map['bookedAt'] as Timestamp : null,
      completedAt:
          map['completedAt'] != null ? map['bookedAt'] as Timestamp : null,
      hospitalDetails: map['hospitalDetails'] != null
          ? HospitalModel.fromMap(
              map['hospitalDetails'] as Map<String, dynamic>)
          : null,
      rejectReason:
          map['rejectReason'] != null ? map['rejectReason'] as String : null,
      isUserAccepted:
          map['isUserAccepted'] != null ? map['isUserAccepted'] as bool : null,
      userDetails: map['userDetails'] != null
          ? UserModel.fromMap(map['userDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HospitalBookingModel.fromJson(String source) =>
      HospitalBookingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  HospitalBookingModel copyWith({
    String? id,
    String? hospitalId,
    String? userId,
    String? patientName,
    String? patientAge,
    String? patientGender,
    String? patientPlace,
    String? patientNumber,
    String? paymentMethod,
    int? orderStatus,
    int? totalAmount,
    Timestamp? bookedAt,
    int? paymentStatus,
    DoctorModel? selectedDoctor,
    String? selectedDate,
    String? selectedTimeSlot,
    Timestamp? acceptedAt,
    Timestamp? rejectedAt,
    Timestamp? completedAt,
    HospitalModel? hospitalDetails,
    String? rejectReason,
    bool? isUserAccepted,
    UserModel? userDetails,
  }) {
    return HospitalBookingModel(
      id: id ?? this.id,
      hospitalId: hospitalId ?? this.hospitalId,
      userId: userId ?? this.userId,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      patientPlace: patientPlace ?? this.patientPlace,
      patientNumber: patientNumber ?? this.patientNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderStatus: orderStatus ?? this.orderStatus,
      totalAmount: totalAmount ?? this.totalAmount,
      bookedAt: bookedAt ?? this.bookedAt,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      completedAt: completedAt ?? this.completedAt,
      hospitalDetails: hospitalDetails ?? this.hospitalDetails,
      rejectReason: rejectReason ?? this.rejectReason,
      isUserAccepted: isUserAccepted ?? this.isUserAccepted,
      userDetails: userDetails ?? this.userDetails,
    );
  }
}
