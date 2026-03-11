import 'package:latlong2/latlong.dart';

class TrackerInfo {
  final String id;
  final String name;
  final String animalType;
  final LatLng point;
  final String address;
  final int battery;
  final int temperature;
  final int speed;
  final DateTime lastUpdate;
  final String image;

  TrackerInfo({
    required this.id,
    required this.name,
    required this.animalType,
    required this.point,
    required this.address,
    required this.battery,
    required this.temperature,
    required this.speed,
    required this.lastUpdate,
    required this.image,
  });

  TrackerInfo copyWith({
    String? id,
    String? name,
    String? animalType,
    LatLng? point,
    String? address,
    int? battery,
    int? temperature,
    int? speed,
    DateTime? lastUpdate,
    String? image,
  }) {
    return TrackerInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      animalType: animalType ?? this.animalType,
      point: point ?? this.point,
      address: address ?? this.address,
      battery: battery ?? this.battery,
      temperature: temperature ?? this.temperature,
      speed: speed ?? this.speed,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      image: image ?? this.image,
    );
  }
}
