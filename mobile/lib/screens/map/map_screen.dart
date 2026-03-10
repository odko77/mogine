import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/models/location_state.dart';
import 'package:mobile/models/tracker_state.dart';
import 'package:mobile/providers/location_notifier.dart';
import 'package:mobile/screens/map/button/circle_button.dart';
import 'package:mobile/screens/map/button/square_button.dart';
import 'package:mobile/screens/map/name_pin.dart';
import 'package:mobile/screens/map/search_tracker.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';
import 'package:mobile/widgets/bottom_sheet/tracker_bottom_sheet.dart';
import 'package:mobile/widgets/map/compass.dart';
import 'package:mobile/widgets/map/test_marker.dart';
import 'package:mobile/widgets/map/user_location.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController mapController = MapController();

  // user location байхгшй үед
  final LatLng _fallbackCenter = const LatLng(47.9186, 106.9177); // УБ
  double _zoom = 14;

  // ✅ Demo tracker data
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

  void _moveTo(LatLng p, {double? zoom}) {
    _zoom = zoom ?? _zoom;
    mapController.move(p, _zoom);
    setState(() {});
  }

  void _openTrackerSheet(TrackerInfo t) {
    final sheetCtrl = DraggableScrollableController();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) {
        return DraggableScrollableSheet(
          controller: sheetCtrl,
          initialChildSize: 0.45,
          minChildSize: 0.22,
          maxChildSize: 0.92, // ✅ зураг шиг бараг full
          snap: true,
          snapSizes: const [0.22, 0.45, 0.92],
          builder: (context, scrollCtrl) {
            return TrackerBottomSheet(
              tracker: t,
              scrollCtrl: scrollCtrl,
              sheetCtrl: sheetCtrl, // ✅ нэмэв
              minSize: 0.22,
              midSize: 0.45,
              maxSize: 0.92,
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
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

  // Marker buildFactoryMarker({
  //   required double lat,
  //   required double lng,
  //   required String imageUrl,
  //   required String name,
  //   VoidCallback? onTap,
  // }) {
  //   const double pinSize = 60;
  //   final double stemHeight = pinSize * 0.56;
  //   final double dotSize = pinSize * 0.15;
  //   final double totalHeight = pinSize + stemHeight + dotSize / 2;

  //   return Marker(
  //     point: LatLng(lat, lng),
  //     width: pinSize,
  //     height: totalHeight,
  //     alignment: Alignment.topCenter,
  //     child: Align(
  //       alignment: Alignment.topCenter,
  //       child: CompanyPinMarker(imageUrl: imageUrl, size: pinSize),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // ✅ provider-аас center авах (байхгүй бол fallback)
    final loc = ref.watch(myLocationProvider).value;
    final initialCenter = (loc != null)
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
              onPositionChanged: (pos, _) {
                if (pos.zoom.isNaN) _zoom = pos.zoom;
              },
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              /// Google Satellite (labels)
              TileLayer(
                urlTemplate:
                    "https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}",
                maxZoom: 20,
              ),

              /// demo markers
              MarkerLayer(
                markers: _trackers.map((t) => _trackerMarker(t)).toList(),
              ),

              // MarkerLayer(
              //   markers: _trackers
              //       .map(
              //         (t) => buildFactoryMarker(
              //           lat: t.point.latitude,
              //           lng: t.point.longitude,
              //           name: t.name,
              //           imageUrl: "assets/horse.jpg",
              //           onTap: () {},
              //         ),
              //       )
              //       .toList(),
              // ),

              /// your existing location widget/layer
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
          // ✅ Top search bar
          Positioned(
            top: SizeConfig.dh(14),
            left: SizeConfig.dw(16),
            right: SizeConfig.dw(16),
            child: SearchTracker(
              hint: "Төхөөрөмж хайх ...",
              onTap: () {
                // TODO: open search modal
              },
            ),
          ),

          // ✅ Right top compass button (demo)
          Positioned(
            top: SizeConfig.dh(90),
            right: SizeConfig.dw(16),
            child: CircleIconButton(
              icon: Icons.explore, // compass-like
              onTap: () {
                // TODO: if you have bearing/rotation feature
              },
            ),
          ),

          // ✅ Right card placeholder (like screenshot)
          // Positioned(
          //   top: SizeConfig.dh(145),
          //   right: SizeConfig.dw(16),
          //   child: Container(
          //     width: SizeConfig.dw(78),
          //     height: SizeConfig.dw(78),
          //     decoration: BoxDecoration(
          //       color: MyAppTheme.primaryColor.withOpacity(0.9),
          //       borderRadius: BorderRadius.circular(SizeConfig.dw(14)),
          //     ),
          //   ),
          // ),

          // ✅ Left zoom & locate buttons (like screenshot)
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

  Marker _trackerMarker(TrackerInfo t) {
    final pinSize = SizeConfig.dw(36);

    return Marker(
      point: t.point,
      width: pinSize,
      height: pinSize,

      // ✅ координат = marker-ийн доод төв (pin-ийн үзүүр)
      alignment: Alignment.center,

      child: GestureDetector(
        onTap: () {
          _moveTo(t.point, zoom: 16);
          _openTrackerSheet(t); // 👈
        },
        child: Pin(color: t.color, name: t.name, imageUrl: t.image),
      ),
    );
  }
}
