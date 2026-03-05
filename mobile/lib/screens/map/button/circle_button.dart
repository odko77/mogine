import 'package:flutter/material.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = SizeConfig.dw(44);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          color: MyAppTheme.primaryColor.withOpacity(0.92),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: MyAppTheme.textColor),
      ),
    );
  }
}
