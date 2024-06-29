// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? id;
  String? imageUrl;
  String? title;
  String? description;
  Timestamp? isCreated;
  NotificationModel({
    this.id,
    this.imageUrl,
    this.title,
    this.description,
    this.isCreated,
  });

  NotificationModel copyWith({
    String? id,
    String? imageUrl,
    String? title,
    String? description,
    Timestamp? isCreated,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      isCreated: isCreated ?? this.isCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'isCreated': isCreated,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] != null ? map['id'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      isCreated:
          map['isCreated'] != null ? map['isCreated'] as Timestamp : null,
    );
  }
}
