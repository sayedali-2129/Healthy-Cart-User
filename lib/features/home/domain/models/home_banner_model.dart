import 'package:cloud_firestore/cloud_firestore.dart';

class HomeBannerModel {
  String? id;
  String? imageUrl;
  Timestamp? createdAt;
  bool? isBlocked;
  HomeBannerModel({this.id, this.imageUrl, this.createdAt, this.isBlocked});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'isBlocked': isBlocked
    };
  }

  factory HomeBannerModel.fromMap(Map<String, dynamic> map) {
    return HomeBannerModel(
        id: map['id'] != null ? map['id'] as String : null,
        imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
        createdAt:
            map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
        isBlocked: map['isBlocked'] != null ? map['isBlocked'] as bool : null);
  }

  HomeBannerModel copyWith(
      {String? id, String? imageUrl, Timestamp? createdAt, bool? isBlocked}) {
    return HomeBannerModel(
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
        isBlocked: isBlocked ?? this.isBlocked);
  }
}
