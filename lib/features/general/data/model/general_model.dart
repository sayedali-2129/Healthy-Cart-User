// ignore_for_file: public_member_api_docs, sort_constructors_first

// ignore_for_file: non_constant_identifier_names

class GeneralModel {
  int totalUsers;
  int android_totalUsers;
  int ios_totalUsers;
  String razorpayKey;
  String razorpayKeySecret;
  String minAppstoreVersion;
  String minPlaystoreVersion;
  GeneralModel({
    required this.totalUsers,
    required this.android_totalUsers,
    required this.ios_totalUsers,
    required this.razorpayKey,
    required this.razorpayKeySecret,
    required this.minAppstoreVersion,
    required this.minPlaystoreVersion,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalUsers': totalUsers,
      'android_totalUsers': android_totalUsers,
      'ios_totalUsers': ios_totalUsers,
      'razorpayKey': razorpayKey,
      'razorpayKeySecret': razorpayKeySecret,
      'minAppstoreVersion': minAppstoreVersion,
      'minPlaystoreVersion': minPlaystoreVersion,
    };
  }

  factory GeneralModel.fromMap(Map<String, dynamic> map) {
    return GeneralModel(
      totalUsers: map['totalUsers'] as int? ??0,
      android_totalUsers: map['android_totalUsers'] as int? ??0,
      ios_totalUsers: map['ios_totalUsers'] as int? ??0,
      razorpayKey: map['razorpayKey'] as String? ??'',
      razorpayKeySecret: map['razorpayKeySecret'] as String? ??'',
      minAppstoreVersion: map['minAppstoreVersion'] as String? ??'',
      minPlaystoreVersion: map['minPlaystoreVersion'] as String? ??'',
    );
  }
}
