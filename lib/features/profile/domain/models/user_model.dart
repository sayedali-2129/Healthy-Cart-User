import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';

class UserModel {
  String? id;
  PlaceMark? placemark;
  String? phoneNo;
  String? userName;
  String? image;
  bool? isActive;
  Timestamp? createdAt;
  List<String>? keywords;
  String? userAge;
  String? gender;
  String? userEmail;

  String? fcmToken;
  UserModel({
    this.id,
    this.placemark,
    this.phoneNo,
    this.userName,
    this.image,
    this.isActive,
    this.createdAt,
    this.keywords,
    this.userAge,
    this.gender,
    this.userEmail,
    this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'placemark': placemark?.toMap(),
      'phoneNo': phoneNo,
      'userName': userName,
      'image': image,
      'isActive': isActive,
      'createdAt': createdAt??FieldValue.serverTimestamp(),
      'keywords': keywords,
      'userAge': userAge,
      'gender': gender,
      'userEmail': userEmail,
      'fcmToken': fcmToken,
    };
  }

  Map<String, dynamic> toEditMap() {
    return <String, dynamic>{
      'userName': userName,
      'image': image,
      'keywords': keywords,
      'userAge': userAge,
      'userEmail': userEmail,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      placemark: map['placemark'] != null
          ? PlaceMark.fromMap(map['placemark'] as Map<String, dynamic>)
          : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      keywords: map['keywords'] != null
          ? List<String>.from((map['keywords'] as List<dynamic>))
          : null,
      userAge: map['userAge'] != null ? map['userAge'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      userEmail: map['userEmail'] != null ? map['userEmail'] as String : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
    );
  }

  UserModel copyWith({
    String? id,
    PlaceMark? placemark,
    String? phoneNo,
    String? userName,
    String? image,
    bool? isActive,
    Timestamp? createdAt,
    List<String>? keywords,
    String? userAge,
    String? gender,
    String? userEmail,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      placemark: placemark ?? this.placemark,
      phoneNo: phoneNo ?? this.phoneNo,
      userName: userName ?? this.userName,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      keywords: keywords ?? this.keywords,
      userAge: userAge ?? this.userAge,
      gender: gender ?? this.gender,
      userEmail: userEmail ?? this.userEmail,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
