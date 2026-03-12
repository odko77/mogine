import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

// ── Model ──────────────────────────────────────────────────────────────────
class PlacePoint {
  final String id;
  final String name;
  final LatLng point;

  const PlacePoint({required this.id, required this.name, required this.point});
}

// ── Points Notifier ────────────────────────────────────────────────────────
class PlacePointNotifier extends Notifier<List<PlacePoint>> {
  @override
  List<PlacePoint> build() => [];

  void add(LatLng position, String label) {
    state = [
      ...state,
      PlacePoint(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        point: position,
        name: label,
      ),
    ];
  }

  void remove(String id) => state = state.where((p) => p.id != id).toList();

  void clear() => state = [];
}

final placePointsProvider =
    NotifierProvider<PlacePointNotifier, List<PlacePoint>>(
      PlacePointNotifier.new,
    );
