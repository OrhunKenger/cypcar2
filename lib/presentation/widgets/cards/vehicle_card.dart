import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../domain/entities/vehicle.dart';
import 'pinned_badge.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onTap,
    required this.onFavoriteTap,
    this.displayCurrency = CurrencyHelper.defaultCurrency,
  });

  final Vehicle vehicle;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final String displayCurrency;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildPhoto(),
            _buildBottomOverlay(),
            _buildTopActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    final url = vehicle.photoUrls.isNotEmpty ? vehicle.photoUrls.first : '';
    return Hero(
      tag: 'vehicle_photo_${vehicle.id}',
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(color: AppColors.surface)
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                duration: 1200.ms,
                color: AppColors.surfaceLight,
              );
        },
        errorBuilder: (context, error, stack) => Container(
          color: AppColors.surface,
          child: const Center(
            child: Icon(
              Icons.directions_car_rounded,
              color: AppColors.textMuted,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 32, 8, 8),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Color(0xBB000000),
              Color(0xEE000000),
            ],
            stops: [0.0, 0.25, 0.7, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              CurrencyHelper.formatPrice(vehicle.price, displayCurrency),
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${vehicle.brand} ${vehicle.model} · ${vehicle.year}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.raleway(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 9,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    vehicle.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.raleway(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopActions() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sol: Pinned badge
          if (vehicle.isPinned) const PinnedBadge() else const SizedBox.shrink(),

          // Sağ: Görüntüleme sayısı + Favori
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildViewCountBadge(),
              const SizedBox(width: 4),
              _buildFavoriteButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewCountBadge() {
    return Container(
      margin: const EdgeInsets.only(top: 7),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.remove_red_eye_outlined,
            size: 9,
            color: Colors.white70,
          ),
          const SizedBox(width: 2),
          Text(
            _formatViewCount(vehicle.viewCount),
            style: GoogleFonts.raleway(
              fontSize: 9,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onFavoriteTap();
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(
          vehicle.isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          size: 15,
          color: vehicle.isFavorite ? AppColors.red : Colors.white,
        ),
      ),
    );
  }

  String _formatViewCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}B';
    return count.toString();
  }
}
