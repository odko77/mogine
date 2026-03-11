import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/location_notifier.dart';
import 'package:mobile/providers/pinned_tracker_provider.dart';
import 'package:mobile/providers/select_tracker_provider.dart';
import 'package:mobile/utils/distance.dart';
import 'package:mobile/utils/size_config.dart';

class AnimalCarousel extends ConsumerStatefulWidget {
  const AnimalCarousel({super.key});

  @override
  ConsumerState<AnimalCarousel> createState() => _AnimalCarouselState();
}

class _AnimalCarouselState extends ConsumerState<AnimalCarousel> {
  @override
  Widget build(BuildContext context) {
    final itemW = SizeConfig.dw(96);
    final itemH = SizeConfig.dh(66);

    final dpr = MediaQuery.of(context).devicePixelRatio;

    final int citemW = (itemW * dpr).toInt();
    final int citemH = (itemH * dpr).toInt();

    final trackers = ref.watch(pinnedTrackerProvider);
    final loc = ref.watch(myLocationProvider).value;

    return SizedBox(
      height: itemH,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trackers.length,
        separatorBuilder: (_, __) => SizedBox(width: SizeConfig.dw(10)),
        itemBuilder: (_, i) {
          final tracker = trackers[i];

          final distanceText = calcText(
            loc,
            tracker.point.latitude,
            tracker.point.longitude,
          );

          return GestureDetector(
            onTap: () {
              ref.read(selectedTrackerProvider.notifier).state = tracker;
              context.go("/map");
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SizeConfig.dw(14)),
              child: SizedBox(
                width: itemW,
                height: itemH,
                child: Stack(
                  children: [
                    RepaintBoundary(
                      child: Image.asset(
                        tracker.image,
                        width: itemW,
                        height: itemH,
                        fit: BoxFit.cover,

                        cacheWidth: citemW,
                        cacheHeight: citemH,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.dw(10),
                          vertical: SizeConfig.dh(8),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.9),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tracker.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.sp(11),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Танаас $distanceText",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: SizeConfig.sp(9),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
