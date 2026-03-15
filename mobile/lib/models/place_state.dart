import 'package:latlong2/latlong.dart';

class PlacePoint {
  final String? id;
  final String name;
  final LatLng point;
  final String? iconName;
  final String? iconColor;

  const PlacePoint({
    this.id,
    required this.name,
    required this.point,
    this.iconName,
    this.iconColor,
  });

  factory PlacePoint.fromJson(Map<String, dynamic> json) {
    return PlacePoint(
      id: json['_id']?.toString(),
      name: json['name'] ?? '',
      point: LatLng(
        (json['location']?["coordinates"]?[1] as num).toDouble(),
        (json['location']?["coordinates"]?[0] as num).toDouble(),
      ),
      iconName: json['icon_name'],
      iconColor: json['icon_color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': {'lat': point.latitude, 'lon': point.longitude},
      'icon_name': iconName,
      'icon_color': iconColor,
    };
  }
}
