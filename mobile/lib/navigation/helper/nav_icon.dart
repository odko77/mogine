import 'package:flutter/material.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onPressed;

  const NavIcon({
    required this.icon,
    required this.active,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: SizeConfig.dw(26),
        color: active ? MyAppTheme.secondaryColor : MyAppTheme.grayColor,
      ),
    );
  }
}
