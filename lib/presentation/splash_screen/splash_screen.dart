import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/app_title_widget.dart';
import './widgets/budget_logo_widget.dart';
import './widgets/loading_animation_widget.dart';
import 'widgets/app_title_widget.dart';
import 'widgets/budget_logo_widget.dart';
import 'widgets/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showExtendedMessage = false;
  bool _isInitializing = true;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Set full-screen immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Start initialization process
    await _performInitialization();
  }

  Future<void> _performInitialization() async {
    try {
      // Show extended message after 5 seconds
      Future.delayed(Duration(seconds: 5), () {
        if (mounted && _isInitializing) {
          setState(() {
            _showExtendedMessage = true;
          });
        }
      });

      // Check network connectivity
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        _navigateToOfflineScreen();
        return;
      }

      // Initialize WebView components
      await _initializeWebView();

      // Validate target URL accessibility
      await _validateUrlAccessibility();

      // Minimum splash duration for branding
      await Future.delayed(Duration(seconds: 2));

      // Navigate to main WebView screen
      _navigateToMainWebView();
    } catch (e) {
      // Handle initialization errors
      _navigateToOfflineScreen();
    }
  }

  Future<void> _initializeWebView() async {
    try {
      _webViewController =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(AppTheme.lightTheme.scaffoldBackgroundColor)
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Handle loading progress
                },
                onPageStarted: (String url) {
                  // Handle page start
                },
                onPageFinished: (String url) {
                  // Handle page finish
                },
                onWebResourceError: (WebResourceError error) {
                  // Handle web resource errors
                },
                onNavigationRequest: (NavigationRequest request) {
                  return NavigationDecision.navigate;
                },
              ),
            );

      // Enable WebView caching
      await _webViewController.enableZoom(false);
    } catch (e) {
      throw Exception('WebView initialization failed');
    }
  }

  Future<void> _validateUrlAccessibility() async {
    try {
      // Pre-load the target URL to validate accessibility
      await _webViewController.loadRequest(
        Uri.parse('http://tracker.sumonahmed.info/'),
      );
    } catch (e) {
      throw Exception('URL validation failed');
    }
  }

  void _navigateToMainWebView() {
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });

      Navigator.pushReplacementNamed(context, '/main-web-view-screen');
    }
  }

  void _navigateToOfflineScreen() {
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });

      Navigator.pushReplacementNamed(context, '/offline-error-screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.lightTheme.scaffoldBackgroundColor,
                AppTheme.lightTheme.colorScheme.surface,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 2, child: SizedBox()),

              // Budget Logo
              BudgetLogoWidget(),

              SizedBox(height: 6.h),

              // App Title
              AppTitleWidget(),

              Expanded(flex: 2, child: SizedBox()),

              // Loading Animation
              LoadingAnimationWidget(showExtendedMessage: _showExtendedMessage),

              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Restore system UI when leaving splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}
