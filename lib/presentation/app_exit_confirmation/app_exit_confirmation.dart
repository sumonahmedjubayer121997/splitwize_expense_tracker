import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/exit_confirmation_bottom_sheet.dart';
import './widgets/exit_confirmation_dialog.dart';
import 'widgets/exit_confirmation_bottom_sheet.dart';
import 'widgets/exit_confirmation_dialog.dart';

class AppExitConfirmation extends StatefulWidget {
  const AppExitConfirmation({Key? key}) : super(key: key);

  @override
  State<AppExitConfirmation> createState() => _AppExitConfirmationState();
}

class _AppExitConfirmationState extends State<AppExitConfirmation> {
  Timer? _autoCloseTimer;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _startAutoCloseTimer();
    _triggerHapticFeedback();
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  void _triggerHapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  void _startAutoCloseTimer() {
    _autoCloseTimer = Timer(Duration(seconds: 10), () {
      if (mounted && !_isClosing) {
        _handleStay();
      }
    });
  }

  void _cancelAutoCloseTimer() {
    _autoCloseTimer?.cancel();
  }

  void _handleExit() {
    if (_isClosing) return;

    setState(() {
      _isClosing = true;
    });

    _cancelAutoCloseTimer();
    HapticFeedback.heavyImpact();

    // Close the modal first
    Navigator.of(context).pop();

    // Then exit the app
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  void _handleStay() {
    if (_isClosing) return;

    setState(() {
      _isClosing = true;
    });

    _cancelAutoCloseTimer();
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
  }

  void _showExitConfirmation() {
    if (Platform.isAndroid) {
      _showBottomSheet();
    } else {
      _showDialog();
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder:
          (context) => ExitConfirmationBottomSheet(
            onExit: _handleExit,
            onStay: _handleStay,
          ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) =>
              ExitConfirmationDialog(onExit: _handleExit, onStay: _handleStay),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show the confirmation immediately when this screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isClosing) {
        _showExitConfirmation();
      }
    });

    return WillPopScope(
      onWillPop: () async {
        _handleStay();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        body: GestureDetector(
          onTap: _handleStay,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: 8.w,
                height: 8.w,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                  strokeWidth: 2.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
