import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class PinnedBadge extends StatelessWidget {
  const PinnedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: const BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
      ),
      child: Text(
        'ÖNE ÇIKARILDI',
        style: GoogleFonts.raleway(
          fontSize: 8,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: AppColors.background,
        ),
      ),
    );
  }
}
