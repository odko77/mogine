import 'package:flutter/material.dart';
import 'package:mobile/navigation/helper/bottom_bar.dart';
import 'package:mobile/navigation/helper/bottom_header.dart';
import 'package:mobile/utils/theme.dart';
import 'package:mobile/utils/size_config.dart';

import '../screens/home/main.dart';
import '../screens/map/map_screen.dart';
import '../screens/menu/menu_screen.dart';
import '../screens/payment/payment_screen.dart';
import '../screens/profile/profile_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MapScreen(),
    MenuScreen(),
    PaymentScreen(),
    ProfileScreen(),
  ];

  final String phone = "88195869";
  final String name = "Т. Одхүү";
  final int badge = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyAppTheme.bgColor,

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.dh(72)),
          child: MongineHeader(
            logoAsset: 'assets/logo.png',
            phone: phone,
            name: name,
            badge: badge,
            onAvatarTap: () => setState(() => _currentIndex = 4),
          ),
        ),

        body: IndexedStack(index: _currentIndex, children: _screens),

        bottomNavigationBar: MongineBottomNav(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          onCenterTap: () => setState(() => _currentIndex = 2),
        ),
      ),
    );
  }
}
