class MeModel {
  final String id;
  final String name;
  final String phoneNumber;

  MeModel({required this.id, required this.name, required this.phoneNumber});

  factory MeModel.fromJson(Map<String, dynamic> json) {
    return MeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
    );
  }
}
