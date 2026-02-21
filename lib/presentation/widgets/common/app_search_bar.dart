import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({super.key, this.onTap, this.onFilterTap});

  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMD),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
            const SizedBox(width: AppConstants.paddingSM),
            Expanded(
              child: Text(
                'Marka, model veya ilan ara...',
                style: GoogleFonts.raleway(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: AppColors.border,
              margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingSM),
            ),
            GestureDetector(
              onTap: onFilterTap,
              child: const Icon(Icons.tune_rounded, color: AppColors.textMuted, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
