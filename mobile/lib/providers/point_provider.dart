import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:latlong2/latlong.dart';

// ── Model ──────────────────────────────────────────────────────────────────
class MapPoint {
  final String id;
  final LatLng position;
  final String label;

  const MapPoint({
    required this.id,
    required this.position,
    required this.label,
  });
}

// ── Points Notifier ────────────────────────────────────────────────────────
class MapPointsNotifier extends Notifier<List<MapPoint>> {
  @override
  List<MapPoint> build() => [];

  void add(LatLng position, String label) {
    state = [
      ...state,
      MapPoint(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        position: position,
        label: label,
      ),
    ];
  }

  void remove(String id) => state = state.where((p) => p.id != id).toList();

  void clear() => state = [];
}

final mapPointsProvider = NotifierProvider<MapPointsNotifier, List<MapPoint>>(
  MapPointsNotifier.new,
);

// ── Add-mode toggle ────────────────────────────────────────────────────────
// true үед газрын зураг дарахад цэг нэмэх горим идэвхтэй
final addModeProvider = StateProvider<bool>((ref) => false);
