import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  final LatLng _initialCenter = LatLng(47.9186, 106.9177); // УБ

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: MyAppTheme.bgColor,
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _initialCenter,
          initialZoom: 14,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          /// Google Satellite TileLayer
          TileLayer(
            urlTemplate: "https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}",
            userAgentPackageName: 'com.example.mobile',
            maxZoom: 20,
          ),

          /// Example marker
          MarkerLayer(
            markers: [
              Marker(
                point: _initialCenter,
                width: SizeConfig.dw(40),
                height: SizeConfig.dw(40),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 36,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
