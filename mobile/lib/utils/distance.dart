import 'dart:math';

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
  if (bearing >= 337.5 || bearing < 22.5) return "North";
  if (bearing < 67.5) return "North-East";
  if (bearing < 112.5) return "East";
  if (bearing < 157.5) return "South-East";
  if (bearing < 202.5) return "South";
  if (bearing < 247.5) return "South-West";
  if (bearing < 292.5) return "West";
  return "North-West";
}
