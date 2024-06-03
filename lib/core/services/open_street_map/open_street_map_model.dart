//get data from latitude and longitud model

// ignore_for_file: sort_constructors_first

import 'package:flutter/material.dart';

class OpentreetMapModel {
  final String? localArea;
  final String? district;
  final String? state;
  final String? country;
  final String? pincode;
  final double? latitude;
  final double? longitude;

  OpentreetMapModel({
    required this.localArea,
    required this.district,
    required this.state,
    required this.country,
    required this.pincode,
    required this.latitude,
    required this.longitude,
  });

  factory OpentreetMapModel.fromMap(Map<String, dynamic> map) {
    debugPrint('MAP: $map');
    return OpentreetMapModel(
      localArea: _getLocalArea(map),
      district: _getDistrict(map),
      state: _getState(map),
      country: _getCountry(map),
      // ignore: avoid_dynamic_calls
      pincode: map['address']['postcode'] as String? ?? '',
      latitude: _getLatitude(map),
      longitude: _getLongitude(map),
    );
  }

  //GETTING LOCAL AREA
  static String _getLocalArea(Map<String, dynamic> map) {
    var localArea = '';
    final name = map['name'] as String?;
    final address = map['address'] as Map<String, dynamic>?;
    final village = address?['village'] as String?;
    final town = address?['town'] as String?;
    final suburb = address?['suburb'] as String?;
    final cityDistrict = address?['city_district'] as String?;
    final historic = address?['historic'] as String?;
    final county = address?['county'] as String?;

    if ((village ?? '').isNotEmpty) {
      localArea = village!;
    } else if ((town ?? '').isNotEmpty) {
      localArea = town!;
    } else if ((name ?? '').isNotEmpty) {
      localArea = name!;
    } else if ((suburb ?? '').isNotEmpty) {
      localArea = suburb!;
    } else if ((cityDistrict ?? '').isNotEmpty) {
      localArea = cityDistrict!;
    } else if ((historic ?? '').isNotEmpty) {
      localArea = historic!;
    } else if ((county ?? '').isNotEmpty) {
      localArea = county!;
    } else {
      //other wise local area is district
      localArea = _getDistrict(map);
    }
    return localArea;
  }

  //GETTING DISTRICT
  static String _getDistrict(Map<String, dynamic> map) {
    var district = '';
    final address = map['address'] as Map<String, dynamic>?;
    final stateDistrict = address?['state_district'] as String?;
    final city = address?['city'] as String?;

    if ((stateDistrict ?? '').isNotEmpty) {
      district = stateDistrict!;
    } else if ((city ?? '').isNotEmpty) {
      district = city!;
    } else {
      //other wise district is state
      district = _getState(map);
    }
    return _removeDistrict(district);
  }

  //GETTING STATE
  static String _getState(Map<String, dynamic> map) {
    var state = '';
    final address = map['address'] as Map<String, dynamic>?;
    final stat = address?['state'] as String?;
    final country = address?['country'] as String?;

    if ((stat ?? '').isNotEmpty) {
      state = stat!;
    } else {
      //other wise state is country
      state = country!;
    }
    return _stateFullNameConverter(state);
  }

  //GETTING COUNTRY
  static String _getCountry(Map<String, dynamic> map) {
    var country = '';
    final address = map['address'] as Map<String, dynamic>?;
    final countryName = address?['country'] as String?;

    if ((countryName ?? '').isNotEmpty) {
      country = countryName!;
    } else {
      country = 'India';
    }
    return country;
  }

  //GETTING LATITUDE AND LONGITUDE
  static double _getLatitude(Map<String, dynamic> map) {
    final bounding = List<String>.from(
      map['boundingbox'] as List<dynamic>? ?? [],
    );
    if (bounding.isNotEmpty) {
      return double.parse(bounding[0]);
    } else {
      return double.parse(map['lat'] as String? ?? '0.0');
    }
  }

  static double _getLongitude(Map<String, dynamic> map) {
    final bounding = List<String>.from(
      map['boundingbox'] as List<dynamic>? ?? [],
    );
    if (bounding.isNotEmpty && bounding.length > 2) {
      return double.parse(bounding[2]);
    } else {
      return double.parse(map['lon'] as String? ?? '0.0');
    }
  }

  static String _stateFullNameConverter(String shortName) {
    switch (shortName.toUpperCase()) {
      case 'AP':
        return 'Andhra Pradesh';
      case 'AR':
        return 'Arunachal Pradesh';
      case 'AS':
        return 'Assam';
      case 'BR':
        return 'Bihar';
      case 'CG':
        return 'Chhattisgarh';
      case 'GA':
        return 'Goa';
      case 'GJ':
        return 'Gujarat';
      case 'HR':
        return 'Haryana';
      case 'HP':
        return 'Himachal Pradesh';
      case 'JH':
        return 'Jharkhand';
      case 'KA':
        return 'Karnataka';
      case 'KL':
        return 'Kerala';
      case 'MP':
        return 'Madhya Pradesh';
      case 'MH':
        return 'Maharashtra';
      case 'MN':
        return 'Manipur';
      case 'ML':
        return 'Meghalaya';
      case 'MZ':
        return 'Mizoram';
      case 'NL':
        return 'Nagaland';
      case 'OR':
        return 'Odisha';
      case 'PB':
        return 'Punjab';
      case 'RJ':
        return 'Rajasthan';
      case 'SK':
        return 'Sikkim';
      case 'TN':
        return 'Tamil Nadu';
      case 'TG':
        return 'Telangana';
      case 'TR':
        return 'Tripura';
      case 'UP':
        return 'Uttar Pradesh';
      case 'UK':
        return 'Uttarakhand';
      case 'WB':
        return 'West Bengal';
      case 'AN':
        return 'Andaman and Nicobar Islands';
      case 'CH':
        return 'Chandigarh';
      case 'DN':
        return 'Dadra and Nagar Haveli';
      case 'DD':
        return 'Daman and Diu';
      case 'DL':
        return 'Delhi';
      case 'JK':
        return 'Jammu and Kashmir';
      case 'LA':
        return 'Ladakh';
      case 'LD':
        return 'Lakshadweep';
      case 'PY':
        return 'Puducherry';
      default:
        return shortName;
    }
  }

  static String _removeDistrict(String text) {
    return text.replaceAll('District', '').trim();
  }
}
