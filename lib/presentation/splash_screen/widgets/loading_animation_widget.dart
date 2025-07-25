import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class LoadingAnimationWidget extends StatefulWidget {
  final bool showExtendedMessage;

  const LoadingAnimationWidget({Key? key, this.showExtendedMessage = false})
    : super(key: key);

  @override
  State<LoadingAnimationWidget> createState() => _LoadingAnimationWidgetState();
}

class _LoadingAnimationWidgetState extends State<LoadingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_rotationAnimation, _pulseAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.lightTheme.colorScheme.primary,
                        AppTheme.lightTheme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'account_balance_wallet',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 6.w,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 4.h),
        Text(
          'Loading SplitWize...',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        widget.showExtendedMessage
            ? Column(
              children: [
                SizedBox(height: 2.h),
                Text(
                  'Taking longer than usual...',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            )
            : SizedBox.shrink(),
      ],
    );
  }
}
