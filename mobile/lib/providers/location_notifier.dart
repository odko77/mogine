import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/models/location_state.dart';

class LocationNotifier extends AsyncNotifier<LocationState?> {
  StreamSubscription<Position>? _sub;

  @override
  Future<LocationState?> build() async {
    ref.onDispose(() {
      _sub?.cancel();
    });

    final ok = await _ensurePermission();
    if (!ok) {
      // ✅ Эрхгүй бол location stream эхлүүлэхгүй
      state = const AsyncData(null);
      return null;
    }

    await _start();
    return null;
  }

  Future<void> _start() async {
    final settings = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 3,
    );

    _sub?.cancel();
    _sub = Geolocator.getPositionStream(locationSettings: settings).listen((
      pos,
    ) {
      final next = LocationState(
        lat: pos.latitude,
        lon: pos.longitude,
        accuracy: pos.accuracy,
        speed: pos.speed,
        ts: DateTime.now(),
      );

      state = AsyncData(next);
    });
  }

  /// ✅ Permission + Service шалгана
  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var perm = await Geolocator.checkPermission();

    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    if (perm == LocationPermission.denied) return false;
    if (perm == LocationPermission.deniedForever) return false;

    // whileInUse / always бол OK
    return true;
  }

  /// UI дээрээс "дахин хүсэх" товч даруулахад ашиглаж болно
  Future<void> requestAgain() async {
    final ok = await _ensurePermission();
    if (!ok) {
      state = const AsyncData(null);
      return;
    }
    await _start();
  }

  /// "Settings" рүү үсрэх хэрэгтэй бол
  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }
}

final myLocationProvider =
    AsyncNotifierProvider<LocationNotifier, LocationState?>(
      LocationNotifier.new,
    );
