import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_test_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';

class LabOrdersModel {
  String? id;
  String? labId;
  String? userId;
  String? name;
  String? testMode;
  Timestamp? orderAt;
  UserAddressModel? userAddress;
  UserModel? userDetails;
  num? totalAmount;
  int? orderStatus;
  int? paymentStatus;
  String? paymentMethod;
  List<LabTestModel>? selectedTest;
  num? doorStepCharge;
  num? finalAmount;
  String? rejectReason;
  Timestamp? acceptedAt;
  Timestamp? rejectedAt;
  String? timeSlot;
  Timestamp? completedAt;
  LabModel? labDetails;
  String? prescription;
  bool? isUserAccepted;
  String? resultUrl;
  bool? isRejectedByUser;

  LabOrdersModel({
    this.id,
    this.labId,
    this.userId,
    this.name,
    this.testMode,
    this.orderAt,
    this.userAddress,
    this.userDetails,
    this.totalAmount,
    this.orderStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.selectedTest,
    this.doorStepCharge,
    this.finalAmount,
    this.rejectReason,
    this.acceptedAt,
    this.rejectedAt,
    this.timeSlot,
    this.completedAt,
    this.labDetails,
    this.prescription,
    this.isUserAccepted,
    this.resultUrl,
    this.isRejectedByUser,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'labId': labId,
      'userId': userId,
      'name': name,
      'testMode': testMode,
      'orderAt': orderAt,
      'userAddress': userAddress!.toMap(),
      'userDetails': userDetails!.toMap(),
      'totalAmount': totalAmount,
      'orderStatus': orderStatus,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'selectedTest': selectedTest?.map((x) => x.toMap()).toList(),
      'doorStepCharge': doorStepCharge,
      'finalAmount': finalAmount,
      'rejectReason': rejectReason,
      'acceptedAt': acceptedAt,
      'rejectedAt': rejectedAt,
      'timeSlot': timeSlot,
      'completedAt': completedAt,
      'labDetails': labDetails!.toMap(),
      'prescription': prescription,
      'isUserAccepted': isUserAccepted,
      'resultUrl': resultUrl,
      'isRejectedByUser': isRejectedByUser,
    };
  }

  factory LabOrdersModel.fromMap(Map<String, dynamic> map) {
    return LabOrdersModel(
      id: map['id'] != null ? map['id'] as String : null,
      labId: map['labId'] != null ? map['labId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      testMode: map['testMode'] != null ? map['testMode'] as String : null,
      orderAt: map['orderAt'] != null ? map['orderAt'] as Timestamp : null,
      userAddress: map['userAddress'] != null
          ? UserAddressModel.fromMap(map['userAddress'] as Map<String, dynamic>)
          : null,
      userDetails: map['userDetails'] != null
          ? UserModel.fromMap(map['userDetails'] as Map<String, dynamic>)
          : null,
      totalAmount:
          map['totalAmount'] != null ? map['totalAmount'] as num : null,
      orderStatus:
          map['orderStatus'] != null ? map['orderStatus'] as int : null,
      paymentStatus:
          map['paymentStatus'] != null ? map['paymentStatus'] as int : null,
      paymentMethod:
          map['paymentMethod'] != null ? map['paymentMethod'] as String : null,
      selectedTest: map['selectedTest'] != null
          ? List<LabTestModel>.from(
              (map['selectedTest'] as List<dynamic>).map<LabTestModel?>(
                (x) => LabTestModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      doorStepCharge:
          map['doorStepCharge'] != null ? map['doorStepCharge'] as num : null,
      finalAmount:
          map['finalAmount'] != null ? map['finalAmount'] as num : null,
      rejectReason:
          map['rejectReason'] != null ? map['rejectReason'] as String : null,
      acceptedAt:
          map['acceptedAt'] != null ? map['acceptedAt'] as Timestamp : null,
      rejectedAt:
          map['rejectedAt'] != null ? map['rejectedAt'] as Timestamp : null,
      timeSlot: map['timeSlot'] != null ? map['timeSlot'] as String : null,
      completedAt:
          map['completedAt'] != null ? map['completedAt'] as Timestamp : null,
      labDetails: map['labDetails'] != null
          ? LabModel.fromMap(map['labDetails'] as Map<String, dynamic>)
          : null,
      prescription:
          map['prescription'] != null ? map['prescription'] as String : null,
      resultUrl: map['resultUrl'] != null ? map['resultUrl'] as String : null,
      isUserAccepted:
          map['isUserAccepted'] != null ? map['isUserAccepted'] as bool : null,
      isRejectedByUser: map['isRejectedByUser'] != null
          ? map['isRejectedByUser'] as bool
          : null,
    );
  }

  LabOrdersModel copyWith({
    String? id,
    String? labId,
    String? userId,
    String? name,
    String? testMode,
    Timestamp? orderAt,
    UserAddressModel? userAddress,
    UserModel? userDetails,
    num? totalAmount,
    int? orderStatus,
    int? paymentStatus,
    String? paymentMethod,
    List<LabTestModel>? selectedTest,
    num? doorStepCharge,
    num? finalAmount,
    String? rejectReason,
    Timestamp? acceptedAt,
    Timestamp? rejectedAt,
    String? timeSlot,
    Timestamp? completedAt,
    LabModel? labDetails,
    String? prescription,
    bool? isUserAccepted,
    bool? isRejectedByUser,
    String? resultUrl,
  }) {
    return LabOrdersModel(
      id: id ?? this.id,
      labId: labId ?? this.labId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      testMode: testMode ?? this.testMode,
      orderAt: orderAt ?? this.orderAt,
      userAddress: userAddress ?? this.userAddress,
      userDetails: userDetails ?? this.userDetails,
      totalAmount: totalAmount ?? this.totalAmount,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      selectedTest: selectedTest ?? this.selectedTest,
      doorStepCharge: doorStepCharge ?? this.doorStepCharge,
      finalAmount: finalAmount ?? this.finalAmount,
      rejectReason: rejectReason ?? this.rejectReason,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      timeSlot: timeSlot ?? this.timeSlot,
      completedAt: completedAt ?? this.completedAt,
      labDetails: labDetails ?? this.labDetails,
      prescription: prescription ?? this.prescription,
      isUserAccepted: isUserAccepted ?? this.isUserAccepted,
      resultUrl: resultUrl ?? this.resultUrl,
      isRejectedByUser: isRejectedByUser ?? this.isRejectedByUser,
    );
  }
}
