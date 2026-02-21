import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/vehicle.dart';
import '../../widgets/cards/vehicle_card.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({
    super.key,
    required this.vehicles,
    required this.displayCurrency,
    required this.onFavoriteTap,
    required this.onCurrencyToggle,
  });

  final List<Vehicle> vehicles;
  final String displayCurrency;
  final ValueChanged<String> onFavoriteTap;
  final VoidCallback onCurrencyToggle;

  List<Vehicle> get _favorites =>
      vehicles.where((v) => v.isFavorite).toList();

  @override
  Widget build(BuildContext context) {
    final favs = _favorites;
    return CustomScrollView(
      key: const PageStorageKey('favorites_scroll'),
      slivers: [
        _buildAppBar(),
        if (favs.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyState(),
          )
        else ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.gridSpacing),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final vehicle = favs[index];
                  return VehicleCard(
                    vehicle: vehicle,
                    displayCurrency: displayCurrency,
                    onTap: () =>
                        context.push(AppRouter.carDetail, extra: vehicle),
                    onFavoriteTap: () => onFavoriteTap(vehicle.id),
                  );
                },
                childCount: favs.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppConstants.gridSpacing,
                mainAxisSpacing: AppConstants.gridSpacing,
                childAspectRatio: AppConstants.gridChildAspectRatio,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.bottomNavHeight + 24),
          ),
        ],
      ],
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      floating: false,
      title: Text(
        'FAVORİLERİM',
        style: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: onCurrencyToggle,
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.circular(AppConstants.radiusSM),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              displayCurrency == '£' ? '£ / ₺' : '₺ / £',
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.gold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.textMuted,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Henüz favori yok',
            style: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'İlginizi çeken ilanlardaki ♡ simgesine\ndokunarak favorilere ekleyebilirsiniz',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
