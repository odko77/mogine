import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/models/tracker_state.dart';
import 'package:mobile/providers/location_notifier.dart';
import 'package:mobile/providers/point_provider.dart';
import 'package:mobile/screens/map/button/square_button.dart';
import 'package:mobile/screens/map/name_pin.dart';
import 'package:mobile/screens/map/search_tracker.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';
import 'package:mobile/widgets/bottom_sheet/tracker_bottom_sheet.dart';
import 'package:mobile/widgets/map/compass.dart';
import 'package:mobile/widgets/map/pin_info.dart';
import 'package:mobile/widgets/map/user_location.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController mapController = MapController();
  final LatLng _fallbackCenter = const LatLng(47.9186, 106.9177);
  double _zoom = 14;

  // ── Газрын зураг дээр тэмдэглэгдэх цэг ──
  LatLng? _pinTracker;

  late final List<TrackerInfo> _trackers = [
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
      color: MyAppTheme.secondaryColor,
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
      color: const Color(0xFF2ECC71),
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
      color: const Color(0xFF00B8D4),
    ),
  ];

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _moveTo(LatLng p, {double? zoom}) {
    _zoom = zoom ?? _zoom;
    mapController.move(p, _zoom);
    setState(() {});
  }

  void _zoomIn() {
    _zoom = (_zoom + 1).clamp(3, 20).toDouble();
    mapController.move(mapController.camera.center, _zoom);
    setState(() {});
  }

  void _zoomOut() {
    _zoom = (_zoom - 1).clamp(3, 20).toDouble();
    mapController.move(mapController.camera.center, _zoom);
    setState(() {});
  }

  // Газрын зураг дарахад pinTracker-т утга өгч bottomsheet нээнэ
  void _onMapTap(LatLng latLng) {
    setState(() => _pinTracker = latLng);
    _moveTo(latLng);
    _showPinTrackerSheet(latLng);
  }

  void _showPinTrackerSheet(LatLng latLng) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      // Sheet хаагдахад pin-г арилгана
      builder: (_) => PinTrackerSheet(latLng: latLng),
    ).then((_) {
      setState(() => _pinTracker = null);
    });
  }

  void _openTrackerSheet(TrackerInfo t) {
    final sheetCtrl = DraggableScrollableController();
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => DraggableScrollableSheet(
        controller: sheetCtrl,
        initialChildSize: 0.45,
        minChildSize: 0.22,
        maxChildSize: 0.92,
        snap: true,
        snapSizes: const [0.22, 0.45, 0.92],
        builder: (context, scrollCtrl) => TrackerBottomSheet(
          tracker: t,
          scrollCtrl: scrollCtrl,
          sheetCtrl: sheetCtrl,
          minSize: 0.22,
          midSize: 0.45,
          maxSize: 0.92,
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final loc = ref.watch(myLocationProvider).value;
    final initialCenter = loc != null
        ? LatLng(loc.lat, loc.lon)
        : _fallbackCenter;

    final mapPoints = ref.watch(mapPointsProvider);

    return Scaffold(
      backgroundColor: MyAppTheme.bgColor,
      body: Stack(
        children: [
          // ── Газрын зураг ──────────────────────────────────────────────────
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: _zoom,
              maxZoom: 20,
              onPositionChanged: (pos, _) {
                if (!pos.zoom.isNaN) _zoom = pos.zoom;
              },
              onTap: (_, latLng) => _onMapTap(latLng),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}",
                maxZoom: 20,
              ),

              // Tracker markers
              MarkerLayer(markers: _trackers.map(_trackerMarker).toList()),

              // pinTracker marker
              if (_pinTracker != null)
                MarkerLayer(markers: [_pinTrackerMarker(_pinTracker!)]),

              if (mapPoints.isNotEmpty)
                MarkerLayer(
                  markers: mapPoints
                      .map((t) => _pinTrackerMarker(t.position))
                      .toList(),
                ),

              UserLocation(),

              Positioned(
                top: SizeConfig.dh(65),
                left: SizeConfig.dh(16),
                child: CompassWidget(
                  mapController: mapController,
                  size: SizeConfig.dh(60),
                ),
              ),
            ],
          ),

          // ── Search bar ────────────────────────────────────────────────────
          Positioned(
            top: SizeConfig.dh(14),
            left: SizeConfig.dw(16),
            right: SizeConfig.dw(16),
            child: SearchTracker(hint: "Төхөөрөмж хайх ...", onTap: () {}),
          ),

          // ── Zoom + locate товчнууд ─────────────────────────────────────
          Positioned(
            left: SizeConfig.dw(16),
            top: SizeConfig.dh(200),
            child: Column(
              children: [
                SquareIconButton(icon: Icons.add, onTap: _zoomIn),
                SizedBox(height: SizeConfig.dh(5)),
                SquareIconButton(icon: Icons.remove, onTap: _zoomOut),
                SizedBox(height: SizeConfig.dh(5)),
                SquareIconButton(
                  icon: Icons.my_location,
                  onTap: () {
                    final loc = ref.read(myLocationProvider).value;
                    if (loc != null) {
                      _moveTo(LatLng(loc.lat, loc.lon), zoom: 16);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Marker builders ────────────────────────────────────────────────────────
  Marker _trackerMarker(TrackerInfo t) {
    final pinSize = SizeConfig.dw(36);
    return Marker(
      point: t.point,
      width: pinSize,
      height: pinSize,
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: t.color, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: t.color.withOpacity(0.35),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Pin(
          color: t.color,
          name: t.name,
          imageUrl: t.image,
          onTap: () {
            _moveTo(t.point, zoom: 16);
            _openTrackerSheet(t);
          },
        ),
      ),
    );
  }

  Marker _pinTrackerMarker(LatLng point) {
    final pinSize = SizeConfig.dw(36);
    return Marker(
      point: point,
      width: pinSize,
      height: pinSize,
      alignment: Alignment.topCenter,
      child: Icon(
        Icons.location_on,
        color: Colors.redAccent,
        size: pinSize,
        shadows: [
          Shadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
    );
  }
}
