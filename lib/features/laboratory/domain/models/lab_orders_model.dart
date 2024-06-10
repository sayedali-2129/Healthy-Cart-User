import 'package:cloud_firestore/cloud_firestore.dart';
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
              (map['selectedTest'] as List<int>).map<LabTestModel?>(
                (x) => LabTestModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      doorStepCharge:
          map['doorStepCharge'] != null ? map['doorStepCharge'] as num : null,
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
    );
  }
}
