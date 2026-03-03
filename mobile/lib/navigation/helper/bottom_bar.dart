import 'package:flutter/material.dart';
import 'package:mobile/navigation/helper/nav_icon.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class MongineBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;

  const MongineBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    final barH = SizeConfig.dh(60);
    final fabSize = SizeConfig.dw(70);

    return SizedBox(
      height: barH, // ✅ зөвхөн навын өндөр
      child: Stack(
        clipBehavior: Clip.none, // ✅ overflow зөвшөөрнө
        alignment: Alignment.bottomCenter,
        children: [
          // bottom bar
          Container(
            height: barH,
            decoration: BoxDecoration(
              color: MyAppTheme.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.dw(20)),
                topRight: Radius.circular(SizeConfig.dw(20)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: SizeConfig.dw(14),
                  offset: Offset(0, -SizeConfig.dh(2)),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavIcon(
                  icon: Icons.home_outlined,
                  active: currentIndex == 0,
                  onPressed: () => onTap(0),
                ),
                NavIcon(
                  icon: Icons.devices_outlined,
                  active: currentIndex == 1,
                  onPressed: () => onTap(1),
                ),

                SizedBox(width: fabSize * 0.9), // center gap

                NavIcon(
                  icon: Icons.map_outlined,
                  active: currentIndex == 3,
                  onPressed: () => onTap(3),
                ),
                NavIcon(
                  icon: Icons.person_outline,
                  active: currentIndex == 4,
                  onPressed: () => onTap(4),
                ),
              ],
            ),
          ),

          Positioned(
            top: -(fabSize * 0.35),
            child: GestureDetector(
              onTap: onCenterTap,
              child: Container(
                width: fabSize + SizeConfig.dw(10), // 👈 гадна хүрээний хэмжээ
                height: fabSize + SizeConfig.dw(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyAppTheme.secondaryColor.withAlpha(
                    180,
                  ), // 👈 хүрээний өнгө (зураг шиг dark)
                ),
                alignment: Alignment.center,
                child: Container(
                  width: fabSize,
                  height: fabSize,
                  decoration: BoxDecoration(
                    color: MyAppTheme.secondaryColor, // 👈 дотор шар
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu,
                    size: SizeConfig.dw(28),
                    color: MyAppTheme.textColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
