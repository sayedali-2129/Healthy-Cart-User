import 'package:cloud_firestore/cloud_firestore.dart';

class UserAddressModel {
  String? id;
  String? userId;
  String? address;
  String? landmark;
  String? name;
  String? phoneNumber;
  String? addressType;
  String? pincode;
  Timestamp? createdAt;
  UserAddressModel({
    this.id,
    this.userId,
    this.address,
    this.landmark,
    this.name,
    this.phoneNumber,
    this.addressType,
    this.pincode,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'address': address,
      'landmark': landmark,
      'name': name,
      'phoneNumber': phoneNumber,
      'addressType': addressType,
      'pincode': pincode,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toEditMap() {
    return <String, dynamic>{
      'address': address,
      'landmark': landmark,
      'name': name,
      'phoneNumber': phoneNumber,
      'addressType': addressType,
      'pincode': pincode,
      'createdAt': createdAt,
    };
  }

  factory UserAddressModel.fromMap(Map<String, dynamic> map) {
    return UserAddressModel(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      landmark: map['landmark'] != null ? map['landmark'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      addressType:
          map['addressType'] != null ? map['addressType'] as String : null,
      pincode: map['pincode'] != null ? map['pincode'] as String : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
    );
  }

  UserAddressModel copyWith({
    String? id,
    String? userId,
    String? address,
    String? landmark,
    String? name,
    String? phoneNumber,
    String? addressType,
    String? pincode,
    Timestamp? createdAt,
  }) {
    return UserAddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      landmark: landmark ?? this.landmark,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addressType: addressType ?? this.addressType,
      pincode: pincode ?? this.pincode,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
