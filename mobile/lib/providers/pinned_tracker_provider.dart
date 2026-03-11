import 'package:flutter_riverpod/legacy.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/models/tracker_state.dart';

class PinnedTrackerNotifier extends StateNotifier<List<TrackerInfo>> {
  PinnedTrackerNotifier()
    : super([
        TrackerInfo(
          id: "T001",
          name: 'Хонгор азарга',
          animalType: "horse",
          point: const LatLng(47.9323, 106.916743),
          address: "106.321321 48.321321",
          battery: 80,
          temperature: -5,
          speed: 12,
          lastUpdate: DateTime.now().subtract(const Duration(minutes: 5)),
          image: "assets/horse.jpg",
        ),
        TrackerInfo(
          id: "T002",
          name: 'Эрлийз үхэр маш урт нэртэй жишээ нэг хоёр гурав дөрөв',
          animalType: "cow",
          point: const LatLng(47.918945, 106.916561),
          address: "106.321321 48.321321",
          battery: 65,
          temperature: -7,
          speed: 0,
          lastUpdate: DateTime.now().subtract(const Duration(minutes: 12)),
          image: "assets/horse.jpg",
        ),
        TrackerInfo(
          id: "T003",
          name: 'Тэмээ',
          animalType: "camel",
          point: const LatLng(47.9108, 106.9054),
          address: "106.321321 48.321321",
          battery: 52,
          temperature: -3,
          speed: 4,
          lastUpdate: DateTime.now().subtract(const Duration(minutes: 2)),
          image: "assets/horse.jpg",
        ),
        TrackerInfo(
          id: "T004",
          name: 'Тэмээ 222',
          animalType: "dsadsa",
          point: const LatLng(47.9201, 106.9054),
          address: "106.321321 48.321321",
          battery: 52,
          temperature: -3,
          speed: 4,
          lastUpdate: DateTime.now().subtract(const Duration(minutes: 2)),
          image: "assets/horse.jpg",
        ),
      ]);

  void addTracker(TrackerInfo tracker) {
    state = [...state, tracker];
  }

  void removeTracker(String id) {
    state = state.where((tracker) => tracker.id != id).toList();
  }

  void updateTracker(TrackerInfo updatedTracker) {
    state = [
      for (final tracker in state)
        if (tracker.id == updatedTracker.id) updatedTracker else tracker,
    ];
  }

  void updateTrackerLocation(String id, LatLng newPoint) {
    state = [
      for (final tracker in state)
        if (tracker.id == id)
          tracker.copyWith(point: newPoint, lastUpdate: DateTime.now())
        else
          tracker,
    ];
  }

  TrackerInfo? getById(String id) {
    try {
      return state.firstWhere((tracker) => tracker.id == id);
    } catch (_) {
      return null;
    }
  }
}

final pinnedTrackerProvider =
    StateNotifierProvider<PinnedTrackerNotifier, List<TrackerInfo>>((ref) {
      return PinnedTrackerNotifier();
    });
