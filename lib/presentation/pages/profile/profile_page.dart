import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../data/datasources/vehicle_mock_datasource.dart';
import '../../../domain/entities/vehicle.dart';
import '../../widgets/cards/vehicle_card.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<Vehicle> _vehicles;
  String _displayCurrency = CurrencyHelper.defaultCurrency;

  // Mock user data
  static const _name = 'Ahmet Çelik';
  static const _location = 'Lefkoşa, KKTC';
  static const _memberSince = 'Ocak 2024';
  static const _adCount = 12;
  static const _totalViews = 12540;
  static const _rating = 4.9;

  @override
  void initState() {
    super.initState();
    _vehicles = VehicleMockDatasource.getAll();
  }

  void _toggleFavorite(String id) {
    setState(() {
      _vehicles = _vehicles.map((v) {
        if (v.id == id) return v.copyWith(isFavorite: !v.isFavorite);
        return v;
      }).toList();
    });
  }

  void _toggleCurrency() {
    HapticFeedback.selectionClick();
    setState(
        () => _displayCurrency = CurrencyHelper.toggleCurrency(_displayCurrency));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildProfileHeader()),
          _buildSectionHeader(),
          _buildVehicleGrid(),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
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
      title: Text(
        _name,
        style: GoogleFonts.raleway(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined,
              color: AppColors.textSecondary, size: 22),
          onPressed: () {},
        ),
      ],
    );
  }

  // ─── PROFILE HEADER ──────────────────────────────────────────────────────

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar row + stats (Instagram layout)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              _buildAvatar(),
              const SizedBox(width: 28),

              // Stats
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat(_adCount.toString(), 'İlan'),
                    _buildStat(_formatViews(_totalViews), 'Görüntülenme'),
                    _buildStat(_rating.toString(), 'Puan'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Name
          Text(
            _name,
            style: GoogleFonts.raleway(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 3),
              Text(
                _location,
                style: GoogleFonts.raleway(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 3),

          // Member since
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                '$_memberSince\'den beri üye',
                style: GoogleFonts.raleway(
                    fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Edit profile button
          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'Profili Düzenle',
                style: GoogleFonts.raleway(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.redDark, AppColors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
            color: AppColors.red.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withValues(alpha: 0.2),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          _name[0].toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.raleway(
              fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // ─── LISTINGS SECTION ────────────────────────────────────────────────────

  Widget _buildSectionHeader() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          const Divider(color: AppColors.border, height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                const Icon(Icons.grid_view_rounded,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'İlanlarım',
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _toggleCurrency,
                  child: Row(
                    children: [
                      Text(
                        _displayCurrency == '£' ? '£ / ₺' : '₺ / £',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.swap_horiz_rounded,
                          size: 13, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleGrid() {
    return SliverPadding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.gridSpacing),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final vehicle = _vehicles[index];
            return VehicleCard(
              vehicle: vehicle,
              displayCurrency: _displayCurrency,
              onTap: () =>
                  context.push(AppRouter.carDetail, extra: vehicle),
              onFavoriteTap: () => _toggleFavorite(vehicle.id),
            );
          },
          childCount: _vehicles.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppConstants.gridSpacing,
          mainAxisSpacing: AppConstants.gridSpacing,
          childAspectRatio: AppConstants.gridChildAspectRatio,
        ),
      ),
    );
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────

  String _formatViews(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
