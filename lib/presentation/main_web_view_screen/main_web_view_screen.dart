import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/app_theme.dart';
import 'widgets/app_exit_dialog_widget.dart';
import 'widgets/connectivity_monitor_widget.dart';
import 'widgets/web_view_container_widget.dart';

class MainWebViewScreen extends StatefulWidget {
  const MainWebViewScreen({super.key});

  @override
  State<MainWebViewScreen> createState() => _MainWebViewScreenState();
}

class _MainWebViewScreenState extends State<MainWebViewScreen> {
  static const String _budgetTrackerUrl = 'http://tracker.sumonahmed.info/';
  bool _canGoBack = false;
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _setupFullScreenMode();
    _initializeWebViewController();
  }

  void _setupFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  void _initializeWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.lightTheme.scaffoldBackgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith(_budgetTrackerUrl)) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(_budgetTrackerUrl));
  }

  Future<bool> _onWillPop() async {
    _canGoBack = await _webViewController.canGoBack();
    if (_canGoBack) {
      await _webViewController.goBack();
      return false;
    } else {
      return await AppExitDialogWidget.show(context);
    }
  }

  void _onConnectionLost() {
    // Handle offline state here
  }

  void _onConnectionRestored() {
    _webViewController.reload();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: ConnectivityMonitorWidget(
          onConnectionLost: _onConnectionLost,
          onConnectionRestored: _onConnectionRestored,
          child: SafeArea(
            child: WebViewContainerWidget(
              url: _budgetTrackerUrl,
              onRefresh: () {},
              onNavigationRequest: (_) {},
              onPageStarted: (_) {},
              onPageFinished: (_) {},
              onWebResourceError: (_) {},
            ),
          ),
        ),
      ),
    );
  }
}
