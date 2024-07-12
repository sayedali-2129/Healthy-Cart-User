

import 'package:cloud_firestore/cloud_firestore.dart';

class UserFamilyMembersModel {
  String? id;
  String? userId;
  String? phoneNo;
  String? name;
  String? place;
    String? age;
  String? gender;
  Timestamp? createdAt;
  UserFamilyMembersModel({
    this.id,
    this.userId,
    this.phoneNo,
    this.name,
    this.place,
    this.age,
    this.gender,
    this.createdAt,
  });



  UserFamilyMembersModel copyWith({
    String? id,
    String? userId,
    String? phoneNo,
    String? name,
    String? place,
    String? age,
    String? gender,
    Timestamp? createdAt,
  }) {
    return UserFamilyMembersModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      phoneNo: phoneNo ?? this.phoneNo,
      name: name ?? this.name,
      place: place ?? this.place,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'phoneNo': phoneNo,
      'name': name,
      'place': place,
      'age': age,
      'gender': gender,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toEditMap() {
    return <String, dynamic>{
      'phoneNo': phoneNo,
      'name': name,
      'place': place,
      'age': age,
      'gender': gender,
    };
  }
  factory UserFamilyMembersModel.fromMap(Map<String, dynamic> map) {
    return UserFamilyMembersModel(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      place: map['place'] != null ? map['place'] as String : null,
      age: map['age'] != null ? map['age'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
    );
  }

}
