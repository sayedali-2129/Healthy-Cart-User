import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalCategoryModel {
  String? id;
  String? category;
  String? image;
  Timestamp? isCreated;
  List<String>? keywords;
  HospitalCategoryModel({
    this.id,
    this.category,
    this.image,
    this.isCreated,
    this.keywords,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'image': image,
      'isCreated': isCreated,
      'keywords': keywords,
    };
  }

  factory HospitalCategoryModel.fromMap(Map<String, dynamic> map) {
    return HospitalCategoryModel(
      id: map['id'] != null ? map['id'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      isCreated:
          map['isCreated'] != null ? map['isCreated'] as Timestamp : null,
      keywords: map['keywords'] != null
          ? List<String>.from(map['keywords'] as List<dynamic>)
          : null,
    );
  }

  HospitalCategoryModel copyWith({
    String? id,
    String? category,
    String? image,
    Timestamp? isCreated,
    List<String>? keywords,
  }) {
    return HospitalCategoryModel(
      id: id ?? this.id,
      category: category ?? this.category,
      image: image ?? this.image,
      isCreated: isCreated ?? this.isCreated,
      keywords: keywords ?? this.keywords,
    );
  }
}
