import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/api/endpoints/trackers.dart';
import 'package:mobile/models/tracker_state.dart';

class TrackerNotifier extends StateNotifier<List<TrackerInfo>> {
  TrackerNotifier() : super([]);

  bool _loading = false;
  bool get isLoading => _loading;

  void addTracker(TrackerInfo tracker) {
    state = [...state, tracker];
  }

  Future<void> fetchTrackers() async {
    try {
      _loading = true;

      final trackers = await TrackerApi.getLatestRecievedTrackers();
      state = trackers;
    } catch (e) {
      print('fetchLatestTrackers error: $e');
    } finally {
      _loading = false;
    }
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

final trackersProvider =
    StateNotifierProvider<TrackerNotifier, List<TrackerInfo>>((ref) {
      return TrackerNotifier();
    });

final latestTrackersProvider = Provider<List<TrackerInfo>>((ref) {
  final trackers = ref.watch(trackersProvider);

  final sorted = [...trackers]
    ..sort((a, b) => b.lastUpdate.compareTo(a.lastUpdate));

  return sorted.take(5).toList();
});

final pinnedTrackersProvider = Provider<List<TrackerInfo>>((ref) {
  final trackers = ref.watch(trackersProvider);

  final pinned = trackers.where((t) => t.isPinned).toList();

  final sorted = [...pinned]
    ..sort((a, b) => b.lastUpdate.compareTo(a.lastUpdate));

  return sorted.toList();
});
