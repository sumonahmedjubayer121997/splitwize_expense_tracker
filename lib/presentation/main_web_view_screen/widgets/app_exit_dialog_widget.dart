import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class AppExitDialogWidget extends StatelessWidget {
  const AppExitDialogWidget({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const AppExitDialogWidget(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8.0,
      contentPadding: EdgeInsets.all(6.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'exit_to_app',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Exit SplitWize?',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Are you sure you want to exit the budget tracker app?',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: AppTheme.lightTheme.outlinedButtonTheme.style
                      ?.copyWith(
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                  },
                  style: AppTheme.lightTheme.elevatedButtonTheme.style
                      ?.copyWith(
                        backgroundColor: WidgetStateProperty.all(
                          AppTheme.lightTheme.colorScheme.error,
                        ),
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                  child: Text(
                    'Exit',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onError,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
