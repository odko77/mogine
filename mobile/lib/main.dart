import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig.init(context);

    final router = ref.watch(routerProvider);
    final themeAsync = ref.watch(themeProvider);

    final themeMode = themeAsync.value ?? ThemeMode.system;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Mongine',
      routerConfig: router,
      theme: MyAppTheme.themeData,
      darkTheme: MyAppTheme.themeData,
      themeMode: themeMode,
    );
  }
}
