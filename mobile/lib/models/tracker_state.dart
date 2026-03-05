import 'package:flutter/animation.dart';
import 'package:latlong2/latlong.dart';

class TrackerInfo {
  final String id;
  final String name;
  final String animalType;

  final LatLng point;
  final String address;

  final int battery;
  final double temperature;
  final double speed;

  final DateTime lastUpdate;

  final String image;
  final Color color;

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
    required this.color,
  });
}
