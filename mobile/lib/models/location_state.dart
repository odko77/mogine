class LocationState {
  final double lat;
  final double lon;
  final double? accuracy;
  final double? speed;
  final DateTime ts;

  const LocationState({
    required this.lat,
    required this.lon,
    required this.ts,
    this.accuracy,
    this.speed,
  });

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lon": lon,
    "accuracy": accuracy,
    "speed": speed,
    "ts": ts.toIso8601String(),
  };

  factory LocationState.fromJson(Map<String, dynamic> json) => LocationState(
    lat: (json["lat"] as num).toDouble(),
    lon: (json["lon"] as num).toDouble(),
    accuracy: (json["accuracy"] as num?)?.toDouble(),
    speed: (json["speed"] as num?)?.toDouble(),
    ts: DateTime.tryParse(json["ts"]?.toString() ?? "") ?? DateTime.now(),
  );
}
