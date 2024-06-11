import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyCartModel {
  String? id;
  final String? pharmacyId;
  final String? categoryId;
  final List<String>? productId;
  final int? orderStatus; // 0 means in cart, 1 means in order, 2 means in process, 3 means delivered.
  final 
  final Timestamp? createdAt;
}
