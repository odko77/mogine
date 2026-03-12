import 'package:latlong2/latlong.dart';
import 'package:mobile/utils/format.dart';

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
  final bool isPinned;
  final String displayDate;

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
    required this.isPinned,
    required this.displayDate,
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
    bool? isPinned,
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
      isPinned: isPinned ?? this.isPinned,
      displayDate: formatDate(lastUpdate ?? this.lastUpdate),
    );
  }

  factory TrackerInfo.fromJson(Map<String, dynamic> json) {
    final lastData = json['last_data'] ?? {};
    final tracker = json['tracker'] ?? {};

    final lat = (lastData['lat'] ?? 0).toDouble();
    final lon = (lastData['lon'] ?? 0).toDouble();

    final lastUpdate = json['lastReceiveDate'] != null
        ? DateTime.parse(json['lastReceiveDate']).toLocal()
        : DateTime.now();

    return TrackerInfo(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'No name',
      animalType: tracker['type']?.toString() ?? 'unknown',
      point: LatLng(lat, lon),
      address: '$lon, $lat',
      battery: ((lastData['batt'] ?? 0) as num).toInt(),
      temperature: ((lastData['temp'] ?? 0) as num).toInt(),
      speed: ((lastData['vel'] ?? 0) as num).toInt(),
      lastUpdate: lastUpdate,

      isPinned: json['isPinned'] ?? false,
      image: json['imageUrl'] ?? "",

      displayDate: formatDate(lastUpdate),
    );
  }
}
