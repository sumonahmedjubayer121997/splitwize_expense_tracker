import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ExitConfirmationBottomSheet extends StatelessWidget {
  final VoidCallback onExit;
  final VoidCallback onStay;

  const ExitConfirmationBottomSheet({
    Key? key,
    required this.onExit,
    required this.onStay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDragHandle(),
            SizedBox(height: 2.h),
            _buildContent(),
            SizedBox(height: 4.h),
            _buildActionButtons(context),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 12.w,
      height: 0.5.h,
      margin: EdgeInsets.only(top: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(2.0),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [_buildHeader(), SizedBox(height: 3.h), _buildDescription()],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary.withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: CustomIconWidget(
            iconName: 'exit_to_app',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 7.w,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exit Budget Tracker?',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Confirm to close the application',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                    alpha: 0.6,
                  ),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      'Your current session state will be lost and you\'ll need to reload your budget data when you return to the app.',
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onStay();
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
                'Stay in App',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                onExit();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.lightTheme.colorScheme.error,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Exit App',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
