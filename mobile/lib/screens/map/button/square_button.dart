import 'package:flutter/material.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const SquareIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = SizeConfig.dw(44);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
      child: Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          color: MyAppTheme.primaryColor.withOpacity(0.92),
          borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
        ),
        child: Icon(icon, color: MyAppTheme.textColor),
      ),
    );
  }
}
