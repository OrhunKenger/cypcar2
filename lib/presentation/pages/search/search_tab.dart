import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../data/datasources/car_brands_datasource.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = CarBrandsDatasource.brands;
    return CustomScrollView(
      key: const PageStorageKey('search_scroll'),
      slivers: [
        SliverAppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          pinned: true,
          title: Text(
            'ARAÇ ARA',
            style: GoogleFonts.raleway(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 0.5, color: AppColors.border),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
            child: Text(
              'MARKA SEÇİN',
              style: GoogleFonts.raleway(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => SelectionBox(
                label: brands[index],
                onTap: () => context.push(
                  AppRouter.searchSeries,
                  extra: {'brand': brands[index]},
                ),
              ),
              childCount: brands.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppConstants.bottomNavHeight + 24),
        ),
      ],
    );
  }
}

// ─── SHARED SELECTION BOX ──────────────────────────────────────────────────

class SelectionBox extends StatelessWidget {
  const SelectionBox({
    super.key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.subtitle,
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.durationFast,
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.red.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(
            color: isSelected ? AppColors.red : AppColors.border,
            width: isSelected ? 1 : 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.raleway(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? AppColors.red : AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: GoogleFonts.raleway(
                  fontSize: 8,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
