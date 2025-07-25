import 'package:flutter/material.dart';
import '../presentation/app_exit_confirmation/app_exit_confirmation.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/main_web_view_screen/main_web_view_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String appExitConfirmation = '/app-exit-confirmation';
  static const String splashScreen = '/splash-screen';
  static const String mainWebViewScreen = '/main-web-view-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    appExitConfirmation: (context) => const AppExitConfirmation(),
    splashScreen: (context) => const SplashScreen(),
    mainWebViewScreen: (context) => MainWebViewScreen(), // 🔧 FIXED: removed `const`
  };
}
