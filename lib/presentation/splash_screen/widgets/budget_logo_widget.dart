import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class BudgetLogoWidget extends StatefulWidget {
  const BudgetLogoWidget({Key? key}) : super(key: key);

  @override
  State<BudgetLogoWidget> createState() => _BudgetLogoWidgetState();
}

class _BudgetLogoWidgetState extends State<BudgetLogoWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(Duration(milliseconds: 200));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _fadeAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary.withValues(
                      alpha: 0.3,
                    ),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'account_balance_wallet',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 12.w,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
