import 'package:flutter/material.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';
import 'package:mobile/widgets/map/test_marker.dart';

class Pin extends StatelessWidget {
  final Color color;
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  const Pin({
    super.key,
    required this.color,
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pinSize = SizeConfig.dw(36);
    final dotSize = SizeConfig.dw(10);

    return SizedBox(
      width: pinSize,
      height: pinSize,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onTap();
          // print('marker tapped');
          // энд хүссэн action-аа хийнэ
        },
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            /// 🏷 NAME LABEL
            Positioned(
              top: -SizeConfig.dh(60),
              child: Container(
                constraints: BoxConstraints(maxWidth: SizeConfig.dw(120)),
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.dw(10),
                  vertical: SizeConfig.dh(5),
                ),
                decoration: BoxDecoration(
                  color: MyAppTheme.primaryColor.withOpacity(.9),
                  borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
                ),
                child: Text(
                  name,
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

            /// 📍 PIN ICON
            Positioned(
              top: -((pinSize) + SizeConfig.dw(5)),
              child: CompanyPinMarker(imageUrl: imageUrl, size: pinSize),
            ),

            /// ⚪ CENTER DOT
            Container(
              width: dotSize,
              height: dotSize,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: MyAppTheme.primaryColor, width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
