import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class WebViewContainerWidget extends StatefulWidget {
  final String url;
  final VoidCallback? onRefresh;
  final Function(String)? onNavigationRequest;
  final Function(String)? onPageStarted;
  final Function(String)? onPageFinished;
  final Function(WebResourceError)? onWebResourceError;

  const WebViewContainerWidget({
    super.key,
    required this.url,
    this.onRefresh,
    this.onNavigationRequest,
    this.onPageStarted,
    this.onPageFinished,
    this.onWebResourceError,
  });

  @override
  State<WebViewContainerWidget> createState() => _WebViewContainerWidgetState();
}

class _WebViewContainerWidgetState extends State<WebViewContainerWidget> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(AppTheme.lightTheme.scaffoldBackgroundColor)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                if (progress == 100) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                widget.onPageStarted?.call(url);
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
                widget.onPageFinished?.call(url);
              },
              onWebResourceError: (WebResourceError error) {
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                });
                widget.onWebResourceError?.call(error);
              },
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('http://tracker.sumonahmed.info') ||
                    request.url.startsWith('https://tracker.sumonahmed.info')) {
                  return NavigationDecision.navigate;
                }
                widget.onNavigationRequest?.call(request.url);
                return NavigationDecision.prevent;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _refreshWebView() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    await _controller.reload();
    widget.onRefresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshWebView,
      color: AppTheme.lightTheme.primaryColor,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          _isLoading ? _buildLoadingIndicator() : const SizedBox.shrink(),
          _hasError ? _buildErrorWidget() : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.primaryColor,
              ),
              strokeWidth: 3.0,
            ),
            SizedBox(height: 2.h),
            Text(
              'Loading Budget Tracker...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 12.w,
              ),
              SizedBox(height: 2.h),
              Text(
                'Failed to Load',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Unable to load the budget tracker. Please check your connection and try again.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              ElevatedButton.icon(
                onPressed: _refreshWebView,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 5.w,
                ),
                label: Text('Retry'),
                style: AppTheme.lightTheme.elevatedButtonTheme.style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
