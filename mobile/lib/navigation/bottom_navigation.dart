import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/navigation/helper/bottom_bar.dart';
import 'package:mobile/navigation/helper/bottom_header.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class BottomNavigation extends ConsumerWidget {
  final Widget child;

  const BottomNavigation({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/map')) return 1;
    if (location.startsWith('/menu')) return 2;
    if (location.startsWith('/payment')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTabTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/map');
        break;
      case 2:
        context.go('/menu');
        break;
      case 3:
        context.go('/payment');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig.init(context);

    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);

    final session = ref.watch(authProvider).value;
    final me = session?.me;

    final phone = me?['phone_number']?.toString() ?? '---';
    final name = me?['name']?.toString() ?? '---';
    const int badge = 0;

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
            onAvatarTap: () => _onTabTap(context, 4),
          ),
        ),
        body: child,
        bottomNavigationBar: MongineBottomNav(
          currentIndex: currentIndex,
          onTap: (i) => _onTabTap(context, i),
          onCenterTap: () => _onTabTap(context, 2),
        ),
      ),
    );
  }
}
