// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyCategoryModel {
  String? id;
  final String image;
  final String category;
  final Timestamp isCreated;
  final List<String>? keywords;
  PharmacyCategoryModel({
    this.id,
    required this.image,
    required this.category,
    required this.isCreated,
    this.keywords,
  });


  PharmacyCategoryModel copyWith({
    String? id,
    String? image,
    String? category,
    Timestamp? isCreated,
     List<String>? keywords,
  }) {
    return PharmacyCategoryModel(
      id: id ?? this.id,
      image: image ?? this.image,
      category: category ?? this.category,
      isCreated: isCreated ?? this.isCreated,
      keywords: keywords ?? this.keywords,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'category': category,
      'isCreated': isCreated,
      'keywords': keywords,
    };
  }

  factory PharmacyCategoryModel.fromMap(Map<String, dynamic> map) {
    return PharmacyCategoryModel(
      id: map['id'] != null ? map['id'] as String : null,
      image: map['image'] as String,
      category: map['category'] as String,
      isCreated:map['isCreated'] as  Timestamp,
      keywords : map['keywords'] != null ? List<String>.from((map['keywords'] as List<dynamic>)) : null, 
    );
  }

}
