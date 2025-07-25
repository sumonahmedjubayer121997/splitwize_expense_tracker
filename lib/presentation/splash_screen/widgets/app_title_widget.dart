import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AppTitleWidget extends StatefulWidget {
  const AppTitleWidget({Key? key}) : super(key: key);

  @override
  State<AppTitleWidget> createState() => _AppTitleWidgetState();
}

class _AppTitleWidgetState extends State<AppTitleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeIn));

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(Duration(milliseconds: 800));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SplitWize',
                  style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Expense Tracker',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                      alpha: 0.8,
                    ),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
