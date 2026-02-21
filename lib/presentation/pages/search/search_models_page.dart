import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../data/datasources/car_brands_datasource.dart';
import '../../../data/datasources/vehicle_mock_datasource.dart';
import 'search_tab.dart';

class SearchModelsPage extends StatelessWidget {
  const SearchModelsPage({
    super.key,
    required this.brand,
    required this.series,
  });

  final String brand;
  final String series;

  @override
  Widget build(BuildContext context) {
    final models = CarBrandsDatasource.modelsFor(brand, series);
    final seriesCount = VehicleMockDatasource.getAll()
        .where((v) => v.brand.toLowerCase() == brand.toLowerCase())
        .length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),

          // ── Tüm seri ilanları butonu
          SliverToBoxAdapter(
            child: _ShowAllButton(
              label: 'Tüm $brand $series ilanlarını gör',
              count: seriesCount,
              onTap: () {
                HapticFeedback.selectionClick();
                context.push(AppRouter.searchResults, extra: {
                  'brand': brand,
                  'series': series,
                  'model': '',
                });
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
              child: Text(
                'MODEL SEÇİN',
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
                  label: models[index],
                  onTap: () => context.push(
                    AppRouter.searchResults,
                    extra: {
                      'brand': brand,
                      'series': series,
                      'model': models[index],
                    },
                  ),
                ),
                childCount: models.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded,
            color: AppColors.textPrimary, size: 22),
        onPressed: () => context.pop(),
      ),
      title: Column(
        children: [
          Text(
            '$brand · $series',
            style: GoogleFonts.raleway(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'Model seçin',
            style: GoogleFonts.raleway(
                fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 0.5, color: AppColors.border),
      ),
    );
  }
}

// ─── "TÜM İLANLAR" BUTONU ─────────────────────────────────────────────────────

class _ShowAllButton extends StatelessWidget {
  const _ShowAllButton({
    required this.label,
    required this.count,
    required this.onTap,
  });

  final String label;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.red.withValues(alpha: 0.08),
              AppColors.red.withValues(alpha: 0.04),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(
              color: AppColors.red.withValues(alpha: 0.3), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppConstants.radiusSM),
              ),
              child: const Icon(Icons.format_list_bulleted_rounded,
                  color: AppColors.red, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.raleway(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (count > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count ilan',
                  style: GoogleFonts.raleway(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
