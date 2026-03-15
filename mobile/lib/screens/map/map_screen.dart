import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/models/place_state.dart';
import 'package:mobile/models/tracker_state.dart';
import 'package:mobile/providers/location_notifier.dart';
import 'package:mobile/providers/point_provider.dart';
import 'package:mobile/providers/select_tracker_provider.dart';
import 'package:mobile/providers/tracker_provider.dart';
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

class _MapScreenState extends ConsumerState<MapScreen>
    with AutomaticKeepAliveClientMixin {
  final MapController mapController = MapController();
  final LatLng _fallbackCenter = const LatLng(47.9186, 106.9177);

  double _zoom = 14;
  LatLng? _pinTracker;
  bool _sheetOpened = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedTracker = ref.read(selectedTrackerProvider);
      if (selectedTracker != null) {
        _moveTo(selectedTracker.point, zoom: 16);
        _openTrackerSheet(selectedTracker);
      }
    });

    ref.listenManual<TrackerInfo?>(selectedTrackerProvider, (prev, next) {
      if (next != null && mounted && !_sheetOpened) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _moveTo(next.point, zoom: 16);
          _openTrackerSheet(next);
        });
      }
    });

    Future.microtask(() {
      ref.read(placePointsProvider.notifier).fetchPlaces();
    });
  }

  void _moveTo(LatLng p, {double? zoom}) {
    _zoom = zoom ?? _zoom;
    mapController.move(p, _zoom);
    if (mounted) setState(() {});
  }

  void _zoomIn() {
    _zoom = (_zoom + 1).clamp(3, 20).toDouble();
    mapController.move(mapController.camera.center, _zoom);
    if (mounted) setState(() {});
  }

  void _zoomOut() {
    _zoom = (_zoom - 1).clamp(3, 20).toDouble();
    mapController.move(mapController.camera.center, _zoom);
    if (mounted) setState(() {});
  }

  void _onMapTap(LatLng latLng) {
    setState(() => _pinTracker = latLng);
    _moveTo(latLng);
    _showPinTrackerSheet(latLng: latLng);
  }

  void _showPinTrackerSheet({required LatLng latLng, PlacePoint? place}) {
    print("show bototm ${place?.name}");
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) => PinTrackerSheet(latLng: latLng, place: place),
    ).then((_) {
      if (mounted) {
        setState(() => _pinTracker = null);
      }
    });
  }

  void _openTrackerSheet(TrackerInfo t) {
    if (_sheetOpened) return;
    _sheetOpened = true;

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
    ).then((_) {
      _sheetOpened = false;
      ref.read(selectedTrackerProvider.notifier).state = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final loc = ref.watch(myLocationProvider).value;
    final initialCenter = loc != null
        ? LatLng(loc.lat, loc.lon)
        : _fallbackCenter;

    return Scaffold(
      backgroundColor: MyAppTheme.bgColor,
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: _zoom,
              maxZoom: 20,
              onTap: (_, latLng) => _onMapTap(latLng),
              onPositionChanged: (pos, _) {
                if (!pos.zoom.isNaN) _zoom = pos.zoom;
              },
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
                userAgentPackageName: 'com.example.app',
                maxZoom: 20,
                keepBuffer: 1,
                panBuffer: 0,
                tileUpdateTransformer: TileUpdateTransformers.throttle(
                  const Duration(milliseconds: 80),
                ),
                evictErrorTileStrategy: EvictErrorTileStrategy.dispose,
              ),

              const TrackerMarkerLayer(),

              if (_pinTracker != null)
                MarkerLayer(markers: [_pinTrackerMarker(_pinTracker!)]),

              MapPointsLayer(
                onTap: (latLng, [place]) =>
                    _showPinTrackerSheet(latLng: latLng, place: place),
              ),

              const UserLocation(),

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

          Positioned(
            top: SizeConfig.dh(14),
            left: SizeConfig.dw(16),
            right: SizeConfig.dw(16),
            child: SearchTracker(hint: "Төхөөрөмж хайх ...", onTap: () {}),
          ),

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
        shadows: const [
          Shadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
    );
  }
}

class TrackerMarkerLayer extends ConsumerWidget {
  const TrackerMarkerLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackers = ref.watch(mapTrackersProvider);

    return MarkerLayer(
      markers: trackers.map((t) {
        final pinSize = SizeConfig.dw(36);

        return Marker(
          point: t.point,
          width: pinSize,
          height: pinSize,
          alignment: Alignment.center,
          child: RepaintBoundary(
            child: Pin(
              color: Colors.blue,
              name: t.name,
              imageUrl: t.image,
              onTap: () {
                ref.read(selectedTrackerProvider.notifier).state = t;
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

class MapPointsLayer extends ConsumerWidget {
  final void Function(LatLng latLng, [PlacePoint? place]) onTap;

  const MapPointsLayer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapPoints = ref.watch(placePointsProvider);

    if (mapPoints.isEmpty) return const SizedBox.shrink();

    final pinSize = SizeConfig.dw(36);

    return MarkerLayer(
      markers: mapPoints.map((t) {
        return Marker(
          point: t.point,
          width: pinSize,
          height: pinSize,
          alignment: Alignment.center,
          child: RepaintBoundary(
            child: SizedBox(
              width: pinSize,
              height: pinSize,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  final latLng = t.point;
                  onTap(latLng, t); // place null
                },
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: pinSize,
                      height: pinSize,
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MyAppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),

                    Positioned(
                      top: -0,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: SizeConfig.dw(120),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.dw(10),
                          vertical: SizeConfig.dh(5),
                        ),
                        decoration: BoxDecoration(
                          color: MyAppTheme.primaryColor.withOpacity(.9),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.dw(12),
                          ),
                        ),
                        child: Text(
                          t.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: MyAppTheme.textColor,
                            fontSize: SizeConfig.sp(11),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
