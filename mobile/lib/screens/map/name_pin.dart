import 'package:flutter/material.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class Pin extends StatelessWidget {
  final Color color;
  final String name;
  const Pin({required this.color, required this.name});

  @override
  Widget build(BuildContext context) {
    final pinSize = SizeConfig.dw(36);
    final dotSize = SizeConfig.dw(10);

    return SizedBox(
      width: pinSize,
      height: pinSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          /// 🏷 NAME LABEL
          Positioned(
            top: -SizeConfig.dh(45),
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
                overflow: TextOverflow.ellipsis, // ✅ урт бол ...
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
            top: -((pinSize / 2) + SizeConfig.dw(5)),
            child: Icon(Icons.location_on, size: pinSize, color: color),
          ),

          // доторх цагаан цэг (icon-ийн төвд)
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
    );
  }
}
