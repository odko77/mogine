import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/api/endpoints/place.dart';
import 'package:mobile/models/place_state.dart';

// ── Points Notifier ────────────────────────────────────────────────────────
class PlacePointNotifier extends Notifier<List<PlacePoint>> {
  bool _loading = false;
  bool get isLoading => _loading;

  @override
  List<PlacePoint> build() => [];

  Future<void> fetchPlaces() async {
    try {
      _loading = true;

      final places = await PlaceApi.getPlaces();
      state = places;
    } catch (e) {
      print('fetch places error: $e');
    } finally {
      _loading = false;
    }
  }

  void add(LatLng position, String label) async {
    final place = PlacePoint(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      point: position,
      name: label,
    );
    await PlaceApi.create(place.toJson());
    state = [...state, place];
  }

  void remove(String id) async {
    if (id == "") {
      return;
    }

    await PlaceApi.deletePlace(id);
    state = state.where((p) => p.id != id).toList();
  }

  void clear() => state = [];
}

final placePointsProvider =
    NotifierProvider<PlacePointNotifier, List<PlacePoint>>(
      PlacePointNotifier.new,
    );
