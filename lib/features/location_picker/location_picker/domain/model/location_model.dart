
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';



class PlaceMark  {
  const PlaceMark({
    required this.localArea,
    required this.district,
    required this.state,
    required this.country,
    required this.pincode,
    required this.geoPoint,
  });
  final String? localArea;
  final String district;
  final String state;
  final String country;
  final String pincode;
  final LandMark geoPoint;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'localArea': localArea,
      'district': district,
      'state': state,
      'country': country,
      'pincode': pincode,
      'geoPoint': geoPoint.toMap(),
    };
  }

  PlaceMark copyWith({
    String? localArea,
    String? district,
    String? state,
    String? country,
    String? pincode,
    LandMark? geoPoint,
  }) {
    return PlaceMark(
      localArea: localArea ?? this.localArea,
      district: district ?? this.district,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      geoPoint: geoPoint ?? this.geoPoint,
    );
  }

  factory PlaceMark.fromMap(Map<String, dynamic> map) {
    return PlaceMark(
      localArea: map['localArea'] != null
          ? map['localArea'] as String
          : map['district'] as String,
      district: map['district'] as String,
      state: map['state'] as String,
      country: map['country'] as String,
      pincode: map['pincode'] != null ? map['pincode'] as String : 'No Pincode',
      geoPoint: LandMark.fromMap(map['geoPoint'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceMark.fromJson(String source) =>
      PlaceMark.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [localArea, district, country, pincode, geoPoint];
}

class LandMark  {
  const LandMark({
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LandMark.fromMap(Map<String, dynamic> map) {
    return LandMark(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  LandMark copyWith({
    double? latitude,
    double? longitude,
  }) {
    return LandMark(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  String toJson() => json.encode(toMap());

  factory LandMark.fromJson(String source) =>
      LandMark.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [latitude, longitude];
}