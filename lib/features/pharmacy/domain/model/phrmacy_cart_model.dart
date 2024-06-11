// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:healthy_cart_user/features/pharmacy/domain/model/product_quantity_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';

class PharmacyCartModel {
  String? id;
  final String? pharmacyId;
  final String? userId;
  final List<String>? productId;
  final List<ProductAndQuantityModel>? productDetails;
  final int? orderStatus; // 0 means in cart, 1 means in order, 2 means in process, 3 means delivered.
  final List<UserAddressModel>? addresss;
  final Timestamp? createdAt;
  PharmacyCartModel({
    this.id,
    this.pharmacyId,
    this.userId,
    this.productId,
    this.productDetails,
    this.orderStatus,
    this.addresss,
    this.createdAt,
  });

  PharmacyCartModel copyWith({
    String? id,
    String? pharmacyId,
    String? userId,
    List<String>? productId,
    List<ProductAndQuantityModel>? productDetails,
    int? orderStatus,
    List<UserAddressModel>? addresss,
    Timestamp? createdAt,
  }) {
    return PharmacyCartModel(
      id: id ?? this.id,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      productDetails: productDetails ?? this.productDetails,
      orderStatus: orderStatus ?? this.orderStatus,
      addresss: addresss ?? this.addresss,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pharmacyId': pharmacyId,
      'userId': userId,
      'productId': productId,
      'productDetails': productDetails,
      'orderStatus': orderStatus,
      'addresss': addresss,
      'createdAt': createdAt,
    };
  }

  factory PharmacyCartModel.fromMap(Map<String, dynamic> map) {
    return PharmacyCartModel(
      id: map['id'] != null ? map['id'] as String : null,
      pharmacyId: map['pharmacyId'] != null ? map['pharmacyId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      productId: map['productId'] != null ? List<String>.from((map['productId'] as List<dynamic>)) : null,
      productDetails: map['productDetails'] != null ? List<ProductAndQuantityModel>.from((map['productDetails'] as List<int>).map<ProductAndQuantityModel?>((x) => ProductAndQuantityModel.fromMap(x as Map<String,dynamic>),),) : null,
      orderStatus: map['orderStatus'] != null ? map['orderStatus'] as int : null,
      addresss: map['addresss'] != null ? List<UserAddressModel>.from((map['addresss'] as List<int>).map<UserAddressModel?>((x) => UserAddressModel.fromMap(x as Map<String,dynamic>),),) : null,
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp) : null,
    );
  }

}
