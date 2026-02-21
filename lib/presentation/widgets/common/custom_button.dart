import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    if (isOutlined) return _buildOutlined();
    return _buildFilled();
  }

  Widget _buildFilled() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? null
              : const LinearGradient(
                  colors: [AppColors.redDark, AppColors.red, AppColors.redBright],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: onPressed == null ? AppColors.surface : null,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.textPrimary,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: AppColors.textPrimary,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildOutlined() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.red,
          side: const BorderSide(color: AppColors.red, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: AppColors.red,
          ),
        ),
      ),
    );
  }
}
