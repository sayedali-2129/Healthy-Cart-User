

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/product_quantity_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';

class PharmacyOrderModel {
  String? id;
  final String? pharmacyId;
  final String? userId;
  final UserModel? userDetails;
  final List<String>? productId;
  final List<ProductAndQuantityModel>? productDetails;
  final int? orderStatus;
  final int? paymentStatus;
  final UserAddressModel? addresss;
  final PharmacyModel? pharmacyDetails;
  final num? deliveryCharge;
  final String? deliveryType;
  final num? totalAmount;
  final num? totalDiscountAmount;
  final num? finalAmount;
  final String? rejectReason;
  final Timestamp? createdAt;
  final Timestamp? acceptedAt;
  final Timestamp? rejectedAt;
  final Timestamp? completedAt;
  final String? prescription;
  final bool? isUserAccepted;
  final bool? isRejectedByUser;
  final bool? isOrderPacked;
  final bool? isOrderDelivered;
  final bool? isPaymentRecieved;
  final String? productBillPdf;
  final String? paymentType;
    final String? description;
  PharmacyOrderModel({
    this.id,
    this.pharmacyId,
    this.userId,
    this.userDetails,
    this.productId,
    this.productDetails,
    this.orderStatus,
    this.paymentStatus,
    this.addresss,
    this.pharmacyDetails,
    this.deliveryCharge,
    this.deliveryType,
    this.totalAmount,
    this.totalDiscountAmount,
    this.finalAmount,
    this.rejectReason,
    this.createdAt,
    this.acceptedAt,
    this.rejectedAt,
    this.completedAt,
    this.prescription,
    this.isUserAccepted,
    this.isRejectedByUser,
    this.isOrderPacked,
    this.isOrderDelivered,
    this.isPaymentRecieved,
    this.productBillPdf,
    this.paymentType,
    this.description,
  });

  PharmacyOrderModel copyWith({
    String? id,
    String? pharmacyId,
    String? userId,
    UserModel? userDetails,
    List<String>? productId,
    List<ProductAndQuantityModel>? productDetails,
    int? orderStatus,
    int? paymentStatus,
    PharmacyModel? pharmacyDetails,
    UserAddressModel? addresss,
    num? deliveryCharge,
    String? deliveryType,
    num? totalAmount,
    num? totalDiscountAmount,
    num? finalAmount,
    String? rejectReason,
    Timestamp? createdAt,
    Timestamp? acceptedAt,
    Timestamp? rejectedAt,
    Timestamp? completedAt,
    String? prescription,
    bool? isUserAccepted,
    bool? isRejectedByUser,
    bool? isOrderPacked,
    bool? isOrderDelivered,
    bool? isPaymentRecieved,
    String? productBillPdf,
    String? paymentType,
    String? description,
  }) {
    return PharmacyOrderModel(
      id: id ?? this.id,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      userId: userId ?? this.userId,
      userDetails: userDetails ?? this.userDetails,
      productId: productId ?? this.productId,
      productDetails: productDetails ?? this.productDetails,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      addresss: addresss ?? this.addresss,
      pharmacyDetails: pharmacyDetails ?? this.pharmacyDetails,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      deliveryType: deliveryType ?? this.deliveryType,
      totalAmount: totalAmount ?? this.totalAmount,
      totalDiscountAmount: totalDiscountAmount ?? this.totalDiscountAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      rejectReason: rejectReason ?? this.rejectReason,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      completedAt: completedAt ?? this.completedAt,
      prescription: prescription ?? this.prescription,
      isUserAccepted: isUserAccepted ?? this.isUserAccepted,
      isRejectedByUser: isRejectedByUser ?? this.isRejectedByUser,
      isOrderPacked: isOrderPacked ?? this.isOrderPacked,
      isOrderDelivered: isOrderDelivered ?? this.isOrderDelivered,
      isPaymentRecieved: isPaymentRecieved ?? this.isPaymentRecieved,
      productBillPdf: productBillPdf ?? this.productBillPdf,
      paymentType: paymentType ?? this.paymentType,
       description: description ?? this.description
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pharmacyId': pharmacyId,
      'userId': userId,
      'userDetails': userDetails?.toMap(),
      'productId': productId,
      'productDetails': productDetails?.map((e) => e.toMap()).toList(),
      'orderStatus': orderStatus,
      'paymentStatus': paymentStatus,
      'addresss': addresss?.toMap(),
      'pharmacyDetails': pharmacyDetails?.toProductMap(),
      'deliveryCharge': deliveryCharge,
      'deliveryType': deliveryType,
      'totalAmount': totalAmount,
      'totalDiscountAmount': totalDiscountAmount,
      'finalAmount': finalAmount,
      'rejectReason': rejectReason,
      'createdAt': createdAt,
      'acceptedAt': acceptedAt,
      'rejectedAt': rejectedAt,
      'completedAt': completedAt,
      'prescription': prescription,
      'isUserAccepted': isUserAccepted,
      'isRejectedByUser': isRejectedByUser,
      'isOrderPacked': isOrderPacked,
      'isOrderDelivered': isOrderDelivered,
      'isPaymentRecieved': isPaymentRecieved,
      'productBillPdf': productBillPdf,
      'paymentType': paymentType,
       'description': description,
    };
  }

  Map<String, dynamic> toEditMap() {
    return <String, dynamic>{
      'productDetails': productDetails?.map((e) => e.toMap()).toList(),
      'orderStatus': orderStatus,
      'paymentStatus': paymentStatus,
      'deliveryCharge': deliveryCharge,
      'totalAmount': totalAmount,
      'totalDiscountAmount': totalDiscountAmount,
      'finalAmount': finalAmount,
      'rejectReason': rejectReason,
      'acceptedAt': acceptedAt,
      'rejectedAt': rejectedAt,
      'isRejectedByUser': isRejectedByUser,
      'isOrderPacked': isOrderPacked,
      'isOrderDelivered': isOrderDelivered,
      'isPaymentRecieved': isPaymentRecieved,

    };
  }

  factory PharmacyOrderModel.fromMap(Map<String, dynamic> map) {
    return PharmacyOrderModel(
      id: map['id'] != null ? map['id'] as String : null,
      pharmacyId:
          map['pharmacyId'] != null ? map['pharmacyId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      userDetails: map['userDetails'] != null
          ? UserModel.fromMap(map['userDetails'] as Map<String, dynamic>)
          : null,
      productId: map['productId'] != null
          ? List<String>.from((map['productId'] as List<dynamic>))
          : null,
      productDetails: map['productDetails'] != null
          ? List<ProductAndQuantityModel>.from(
              (map['productDetails'] as List<dynamic>)
                  .map<ProductAndQuantityModel?>(
                (x) =>
                    ProductAndQuantityModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      orderStatus:
          map['orderStatus'] != null ? map['orderStatus'] as int : null,
      paymentStatus:
          map['paymentStatus'] != null ? map['paymentStatus'] as int : null,
      addresss: map['addresss'] != null
          ? UserAddressModel.fromMap(map['addresss'] as Map<String, dynamic>)
          : null,
      pharmacyDetails: map['pharmacyDetails'] != null
          ? PharmacyModel.fromMap(
              map['pharmacyDetails'] as Map<String, dynamic>)
          : null,
      deliveryCharge:
          map['deliveryCharge'] != null ? map['deliveryCharge'] as num : null,
      deliveryType:
          map['deliveryType'] != null ? map['deliveryType'] as String : null,
      totalAmount:
          map['totalAmount'] != null ? map['totalAmount'] as num : null,
      totalDiscountAmount: map['totalDiscountAmount'] != null
          ? map['totalDiscountAmount'] as num
          : null,
      finalAmount:
          map['finalAmount'] != null ? map['finalAmount'] as num : null,
      rejectReason:
          map['rejectReason'] != null ? map['rejectReason'] as String : null,
      createdAt:
          map['createdAt'] != null ? (map['createdAt'] as Timestamp) : null,
      acceptedAt:
          map['acceptedAt'] != null ? (map['acceptedAt'] as Timestamp) : null,
      rejectedAt:
          map['rejectedAt'] != null ? (map['rejectedAt'] as Timestamp) : null,
      completedAt:
          map['completedAt'] != null ? (map['completedAt'] as Timestamp) : null,
      prescription:
          map['prescription'] != null ? map['prescription'] as String : null,
      isUserAccepted:
          map['isUserAccepted'] != null ? map['isUserAccepted'] as bool : null,
      isRejectedByUser: map['isRejectedByUser'] != null
          ? map['isRejectedByUser'] as bool
          : null,
      isOrderPacked:
          map['isOrderPacked'] != null ? map['isOrderPacked'] as bool : null,
      isOrderDelivered: map['isOrderDelivered'] != null
          ? map['isOrderDelivered'] as bool
          : null,
      isPaymentRecieved: map['isPaymentRecieved'] != null
          ? map['isPaymentRecieved'] as bool
          : null,
      productBillPdf: map['productBillPdf'] != null
          ? map['productBillPdf'] as String
          : null,
      paymentType:
          map['paymentType'] != null ? map['paymentType'] as String : null,
           description: map['description'] != null ? map['description'] as String : null,     
    );
  }
}
