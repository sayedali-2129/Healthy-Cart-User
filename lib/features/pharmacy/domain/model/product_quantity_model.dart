// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';

class ProductAndQuantityModel {
  final String? productId;
  final int? quantity;
  final Timestamp? createdAt;
  final PharmacyProductAddModel? productData;
  ProductAndQuantityModel({
    this.productId,
    this.quantity,
    this.createdAt,
    this.productData,
  });

  ProductAndQuantityModel copyWith({
    String? productId,
    int? quantity,
    Timestamp? createdAt,
    PharmacyProductAddModel? productData,
  }) {
    return ProductAndQuantityModel(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      productData: productData ?? this.productData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
      'createdAt': createdAt,
      'productData': productData?.toCartMap(),
    };
  }
  Map<String, dynamic> toUserMap() {
    return <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
    };
  }
  factory ProductAndQuantityModel.fromMap(Map<String, dynamic> map) {
    return ProductAndQuantityModel(
      productId: map['productId'] != null ? map['productId'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      productData: map['productData'] != null ? PharmacyProductAddModel.fromMap(map['productData'] as Map<String,dynamic>) : null,
    );
  }

 
}
