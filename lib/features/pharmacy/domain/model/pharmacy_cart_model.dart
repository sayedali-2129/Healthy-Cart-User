// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/product_quantity_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';

class PharmacyCartModel {
  String? id;
  final String? pharmacyId;
  final String? userId;
  final UserModel? userDetails;
  final List<String>? productId;
  final List<ProductAndQuantityModel>? productDetails;
  final int? orderStatus; // 0 means in cart, 1 means in order, 2 means in process, 3 means delivered.
  final  UserAddressModel? addresss;
   final int? paymentStatus;
  final num? deliveryCharge;
  final String? deliveryType;
  final num? totalAmount;
   final num? finalAmount;
  final Timestamp? createdAt;
  final Timestamp? acceptedTime;
  PharmacyCartModel({
    this.id,
    this.pharmacyId,
    this.userId,
    this.userDetails,
    this.productId,
    this.productDetails,
    this.orderStatus,
    this.addresss,
    this.paymentStatus,
    this.deliveryCharge,
    this.deliveryType,
    this.totalAmount,
    this.createdAt,
    this.acceptedTime,
    this.finalAmount
  });



  PharmacyCartModel copyWith({
    String? id,
    String? pharmacyId,
    String? userId,
    UserModel? userDetails,
    List<String>? productId,
    List<ProductAndQuantityModel>? productDetails,
    int? orderStatus,
    UserAddressModel? addresss,
    int? paymentStatus,
    num? deliveryCharge,
    String? deliveryType,
    num? totalAmount,
    num? finalAmount,
    Timestamp? createdAt,
    Timestamp? acceptedTime,
  }) {
    return PharmacyCartModel(
      id: id ?? this.id,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      userId: userId ?? this.userId,
      userDetails: userDetails ?? this.userDetails,
      productId: productId ?? this.productId,
      productDetails: productDetails ?? this.productDetails,
      orderStatus: orderStatus ?? this.orderStatus,
      addresss: addresss ?? this.addresss,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      deliveryType: deliveryType ?? this.deliveryType,
      totalAmount: totalAmount ?? this.totalAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      createdAt: createdAt ?? this.createdAt,
      acceptedTime: acceptedTime ?? this.acceptedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pharmacyId': pharmacyId,
      'userId': userId,
      'userDetails': userDetails?.toMap(),
      'productId': productId,
      'productDetails': productDetails,
      'orderStatus': orderStatus,
      'addresss': addresss?.toMap(),
      'paymentStatus': paymentStatus,
      'deliveryCharge': deliveryCharge,
      'deliveryType': deliveryType,
      'totalAmount': totalAmount,
      'finalAmount': finalAmount,
      'createdAt': createdAt,
      'acceptedTime' : acceptedTime,
    };
  }
  

  factory PharmacyCartModel.fromMap(Map<String, dynamic> map) {
    return PharmacyCartModel(
      id: map['id'] != null ? map['id'] as String : null,
      pharmacyId: map['pharmacyId'] != null ? map['pharmacyId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      userDetails: map['userDetails'] != null ? UserModel.fromMap(map['userDetails'] as Map<String,dynamic>) : null,
      productId: map['productId'] != null ? List<String>.from((map['productId'] as List<dynamic>)) : null,
      productDetails: map['productDetails'] != null ? List<ProductAndQuantityModel>.from((map['productDetails'] as List<int>).map<ProductAndQuantityModel?>((x) => ProductAndQuantityModel.fromMap(x as Map<String,dynamic>),),) : null,
      orderStatus: map['orderStatus'] != null ? map['orderStatus'] as int : null,
      addresss: map['addresss'] != null ? UserAddressModel.fromMap(map['addresss'] as Map<String,dynamic>) : null,
      paymentStatus: map['paymentStatus'] != null ? map['paymentStatus'] as int : null,
      deliveryCharge: map['deliveryCharge'] != null ? map['deliveryCharge'] as num : null,
      deliveryType: map['deliveryType'] != null ? map['deliveryType'] as String : null,
      totalAmount: map['totalAmount'] != null ? map['totalAmount'] as num : null,
      finalAmount: map['finalAmount'] != null ? map['finalAmount'] as num : null,
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp) : null,
      acceptedTime: map['acceptedTime'] != null ? (map['acceptedTime'] as Timestamp) : null,
    );
  }

}
