import 'dart:math';

import 'package:latlong2/latlong.dart';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371000; // earth radius (meters)

  final dLat = _degToRad(lat2 - lat1);
  final dLon = _degToRad(lon2 - lon1);

  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(lat1)) *
          cos(_degToRad(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return R * c;
}

double _degToRad(double deg) {
  return deg * pi / 180;
}

double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
  final dLon = _degToRad(lon2 - lon1);

  final y = sin(dLon) * cos(_degToRad(lat2));
  final x =
      cos(_degToRad(lat1)) * sin(_degToRad(lat2)) -
      sin(_degToRad(lat1)) * cos(_degToRad(lat2)) * cos(dLon);

  final bearing = atan2(y, x);

  return (_radToDeg(bearing) + 360) % 360;
}

double _radToDeg(double rad) {
  return rad * 180 / pi;
}

String getDirection(double bearing) {
  if (bearing >= 337.5 || bearing < 22.5) return "хойд";
  if (bearing < 67.5) return "зүүн хойд";
  if (bearing < 112.5) return "зүүн";
  if (bearing < 157.5) return "зүүн урд";
  if (bearing < 202.5) return "урд";
  if (bearing < 247.5) return "баруун урд";
  if (bearing < 292.5) return "баруун";
  return "баруун хойд";
}

String formatDistance(double meters) {
  if (meters < 1000) {
    return "${meters.toStringAsFixed(0)}м";
  }
  return "${(meters / 1000).toStringAsFixed(1)}км";
}

String calcText(myLoc, lat, long) {
  String distanceText = "...";
  final initialCenter = myLoc != null ? LatLng(myLoc.lat, myLoc.lon) : null;

  if (initialCenter != null) {
    final distanceInMeters = calculateDistance(
      initialCenter.latitude,
      initialCenter.longitude,
      lat,
      long,
    );

    distanceText = formatDistance(distanceInMeters);
  }
  return distanceText;
}

String calcFullText(myLoc, lat, long) {
  if (myLoc == null) return "Таны байршил олдсонгүй";

  final initialCenter = LatLng(myLoc.lat, myLoc.lon);

  final distanceInMeters = calculateDistance(
    initialCenter.latitude,
    initialCenter.longitude,
    lat,
    long,
  );

  final bearing = calculateBearing(
    initialCenter.latitude,
    initialCenter.longitude,
    lat,
    long,
  );

  final direction = getDirection(bearing);
  final distanceText = formatDistance(distanceInMeters);

  return "Танаас $direction зүгт $distanceText-н зайд байна";
}
