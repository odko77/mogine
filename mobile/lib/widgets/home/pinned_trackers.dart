import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/tracker_provider.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

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

    final trackers = ref.watch(trackersProvider);

    print(trackers.length);

    return SizedBox(
      height: itemH,
      child: SizedBox(
        height: itemH,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: trackers.length,
          separatorBuilder: (_, __) => SizedBox(width: SizeConfig.dw(10)),
          itemBuilder: (_, i) {
            final tracker = trackers[i];

            return ClipRRect(
              borderRadius: BorderRadius.circular(SizeConfig.dw(14)),
              child: SizedBox(
                width: itemW,
                height: itemH,
                child: Stack(
                  children: [
                    Image.asset(
                      tracker.image,
                      width: itemW,
                      height: itemH,
                      fit: BoxFit.cover,
                    ),

                    // доод хэсгийг харлуулах overlay
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
                            SizedBox(height: SizeConfig.dh(2)),
                            Text(
                              "Танаас 45km",
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
            );
          },
        ),
      ),
    );
  }
}
