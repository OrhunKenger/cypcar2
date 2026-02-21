import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../domain/entities/vehicle.dart';

class UrgentTab extends StatelessWidget {
  const UrgentTab({
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

  List<Vehicle> get _urgent =>
      vehicles.where((v) => v.isUrgent).toList();

  static const _daysLeft = {
    'p4': 1, 'p8': 2, 'n1': 3, 'n5': 1, 'n6': 2, 'n9': 4,
  };

  int _getDaysLeft(String id) => _daysLeft[id] ?? 3;

  @override
  Widget build(BuildContext context) {
    final urgent = _urgent;
    return CustomScrollView(
      key: const PageStorageKey('urgent_scroll'),
      slivers: [
        _buildAppBar(),
        _buildBanner(),
        if (urgent.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
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
                      Icons.timer_off_outlined,
                      color: AppColors.textMuted,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Acil ilan yok',
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Şu an acil satışta araç bulunmuyor\nDaha sonra tekrar kontrol edin',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          )
        else ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _UrgentCard(
                  vehicle: urgent[index],
                  displayCurrency: displayCurrency,
                  daysLeft: _getDaysLeft(urgent[index].id),
                  onTap: () => context.push(AppRouter.carDetail,
                      extra: urgent[index]),
                  onFavoriteTap: () => onFavoriteTap(urgent[index].id),
                ),
                childCount: urgent.length,
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

  // ─── APP BAR ─────────────────────────────────────────────────────────

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      leading: const Icon(Icons.warning_amber_rounded,
          color: AppColors.red, size: 20),
      title: Text(
        'ACİL SATIŞLAR',
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
              borderRadius: BorderRadius.circular(AppConstants.radiusSM),
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

  // ─── BANNER ──────────────────────────────────────────────────────────

  SliverToBoxAdapter _buildBanner() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(
              color: AppColors.red.withValues(alpha: 0.25), width: 0.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded,
                color: AppColors.red, size: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Bu ilanlar acil satış ihtiyacı olan araçlardır. Hızlı hareket edin!',
                style: GoogleFonts.raleway(
                    fontSize: 11,
                    color: AppColors.red,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── URGENT CARD ───────────────────────────────────────────────────────────

class _UrgentCard extends StatelessWidget {
  const _UrgentCard({
    required this.vehicle,
    required this.displayCurrency,
    required this.daysLeft,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final Vehicle vehicle;
  final String displayCurrency;
  final int daysLeft;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(
              color: AppColors.red.withValues(alpha: 0.2), width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            _buildPhoto(),
            Expanded(child: _buildInfo()),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    return Stack(
      children: [
        SizedBox(
          width: 110,
          height: 100,
          child: Image.network(
            vehicle.photoUrls.first,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              color: AppColors.background,
              child: const Center(
                child: Icon(Icons.directions_car_rounded,
                    color: AppColors.textMuted, size: 28),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            color: AppColors.red,
            child: Text(
              'ACİL',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${vehicle.brand} ${vehicle.model}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                CurrencyHelper.formatPrice(vehicle.price, displayCurrency),
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${vehicle.year} · ${vehicle.location} · ${vehicle.fuelType}',
            style: GoogleFonts.raleway(
                fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            '${_formatKm(vehicle.mileage)} · ${vehicle.transmission}',
            style: GoogleFonts.raleway(
                fontSize: 11, color: AppColors.textMuted),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.12),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusSM),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined,
                        size: 10, color: AppColors.red),
                    const SizedBox(width: 3),
                    Text(
                      daysLeft == 1 ? 'SON 1 GÜN' : 'SON $daysLeft GÜN',
                      style: GoogleFonts.raleway(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onFavoriteTap();
                },
                child: Icon(
                  vehicle.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 18,
                  color: vehicle.isFavorite
                      ? AppColors.red
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatKm(int km) {
    if (km >= 1000) {
      return '${(km / 1000).toStringAsFixed(0)}K km';
    }
    return '$km km';
  }
}
