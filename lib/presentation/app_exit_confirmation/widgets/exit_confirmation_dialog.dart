import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ExitConfirmationDialog extends StatelessWidget {
  final VoidCallback onExit;
  final VoidCallback onStay;

  const ExitConfirmationDialog({
    Key? key,
    required this.onExit,
    required this.onStay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8.0,
      child: Container(
        constraints: BoxConstraints(maxWidth: 85.w, maxHeight: 35.h),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            SizedBox(height: 3.h),
            _buildContent(),
            SizedBox(height: 4.h),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary.withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: CustomIconWidget(
            iconName: 'exit_to_app',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            'Exit Budget Tracker?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      'Are you sure you want to exit the app? Your current session state will be lost and you\'ll need to reload your budget data when you return.',
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.4,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onStay();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1.0,
              ),
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'Stay',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              onExit();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'Exit',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
