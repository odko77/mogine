import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/models/tracker_state.dart';
import 'package:mobile/providers/location_notifier.dart';
import 'package:mobile/utils/distance.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class TrackerShortHint extends ConsumerWidget {
  final TrackerInfo tracker;

  const TrackerShortHint({super.key, required this.tracker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myLoc = ref.watch(myLocationProvider).value;
    final distanceText = calcFullText(
      myLoc,
      tracker.point.latitude,
      tracker.point.longitude,
    );

    return Container(
      padding: EdgeInsets.all(SizeConfig.dw(12)),
      decoration: BoxDecoration(
        color: MyAppTheme.bgColor,
        borderRadius: BorderRadius.circular(SizeConfig.dw(14)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.directions_walk,
            color: MyAppTheme.grayColor,
            size: SizeConfig.dw(18),
          ),

          SizedBox(width: SizeConfig.dw(8)),

          Expanded(
            child: Text(
              distanceText,
              style: TextStyle(
                color: MyAppTheme.grayColor,
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.sp(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
