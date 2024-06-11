
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductAndQuantityModel {
  final String? productId;
  final int? quantity;
  final Timestamp? createdAt;
  ProductAndQuantityModel({
    this.productId,
    this.quantity,
    this.createdAt,
  });

  ProductAndQuantityModel copyWith({
    String? productId,
    int? quantity,
    Timestamp? createdAt,
  }) {
    return ProductAndQuantityModel(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
      'createdAt': createdAt,
    };
  }

  factory ProductAndQuantityModel.fromMap(Map<String, dynamic> map) {
    return ProductAndQuantityModel(
      productId: map['productId'] != null ? map['productId'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp) : null,
    );
  }
}
