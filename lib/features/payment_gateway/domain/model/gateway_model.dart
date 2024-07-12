// ignore_for_file: public_member_api_docs, sort_constructors_first
class GatewayModel {
  String? id;
  String? key;
  GatewayModel({
    this.id,
    this.key,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'key': key,
    };
  }

  factory GatewayModel.fromMap(Map<String, dynamic> map) {
    return GatewayModel(
      id: map['id'] != null ? map['id'] as String : null,
      key: map['key'] != null ? map['key'] as String : null,
    );
  }

  GatewayModel copyWith({
    String? id,
    String? key,
  }) {
    return GatewayModel(
      id: id ?? this.id,
      key: key ?? this.key,
    );
  }
}
