import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../data/datasources/vehicle_mock_datasource.dart';
import '../../../domain/entities/vehicle.dart';
import '../../widgets/cards/vehicle_card.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../favorites/favorites_tab.dart';
import '../search/search_tab.dart' show SearchTab;
import '../urgent/urgent_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _navIndex = 2;
  String _displayCurrency = CurrencyHelper.defaultCurrency;
  late List<Vehicle> _vehicles;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _vehicles = VehicleMockDatasource.getAll();
    _shimmerController = AnimationController(vsync: this);
    _runShimmerLoop();
  }

  Future<void> _runShimmerLoop() async {
    while (mounted) {
      await _shimmerController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 1400),
        curve: Curves.easeInOut,
      );
      if (!mounted) break;
      _shimmerController.reset();
      await Future.delayed(const Duration(milliseconds: 2200));
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
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
    setState(() {
      _displayCurrency = CurrencyHelper.toggleCurrency(_displayCurrency);
    });
  }

  void _handleNavTap(int index) {
    if (index == 4) {
      context.push(AppRouter.postAd);
      return;
    }
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(
        index: _navIndex,
        children: [
          // 0 — Favoriler
          FavoritesTab(
            vehicles: _vehicles,
            displayCurrency: _displayCurrency,
            onFavoriteTap: _toggleFavorite,
            onCurrencyToggle: _toggleCurrency,
          ),
          // 1 — Arama
          const SearchTab(),
          // 2 — Ana Sayfa
          CustomScrollView(
            key: const PageStorageKey('home_scroll'),
            slivers: [
              _buildSliverAppBar(),
              _buildProfileCard(),
              _buildListingsHeader(),
              _buildVehicleGrid(),
              _buildBottomPadding(),
            ],
          ),
          // 3 — Acil
          UrgentTab(
            vehicles: _vehicles,
            displayCurrency: _displayCurrency,
            onFavoriteTap: _toggleFavorite,
            onCurrencyToggle: _toggleCurrency,
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onItemTapped: _handleNavTap,
      ),
    );
  }

  // ─── APP BAR (Home tab) ───────────────────────────────────────────────

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      floating: true,
      snap: true,
      pinned: false,
      title: _buildShimmerTitle(),
      centerTitle: true,
      actions: [
        _buildCurrencyToggle(),
        _buildNotificationBell(),
      ],
    );
  }

  Widget _buildShimmerTitle() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final t = _shimmerController.value;
        final cx = -0.25 + t * 1.5;
        return ShaderMask(
          shaderCallback: (bounds) {
            if (cx <= 0.25 || cx >= 0.75) {
              return const LinearGradient(
                colors: [AppColors.red, AppColors.redBright, AppColors.red],
              ).createShader(bounds);
            }
            return LinearGradient(
              colors: [
                AppColors.red,
                AppColors.redBright,
                Colors.white,
                AppColors.redBright,
                AppColors.red,
              ],
              stops: [0.0, cx - 0.15, cx, cx + 0.15, 1.0],
            ).createShader(bounds);
          },
          child: child!,
        );
      },
      child: Text(
        AppConstants.appName,
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          letterSpacing: 5,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCurrencyToggle() {
    final isGbp = _displayCurrency == '£';
    return GestureDetector(
      onTap: _toggleCurrency,
      child: AnimatedContainer(
        duration: AppConstants.durationFast,
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusSM),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('£',
                style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isGbp ? AppColors.gold : AppColors.textMuted)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Icon(Icons.swap_horiz_rounded,
                  size: 13, color: AppColors.textMuted),
            ),
            Text('₺',
                style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: !isGbp ? AppColors.gold : AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBell() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () => context.push(AppRouter.notifications),
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textSecondary,
            size: 22,
          ),
        ),
        // Unread dot
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  // ─── PROFILE CARD ─────────────────────────────────────────────────────

  Widget _buildProfileCard() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () => context.push(AppRouter.profile),
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 6, 10, 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.redDark, AppColors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                      color: AppColors.red.withValues(alpha: 0.4),
                      width: 1.5),
                ),
                child: Center(
                  child: Text(
                    'A',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name + location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ahmet Çelik',
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Lefkoşa, KKTC',
                      style: GoogleFonts.raleway(
                          fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),

              // Quick stats
              _buildMiniStat('12', 'İlan'),
              const SizedBox(width: 16),
              _buildMiniStat('12.5K', 'Görüntü'),
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.raleway(
              fontSize: 9, color: AppColors.textMuted),
        ),
      ],
    );
  }

  // ─── LISTINGS ─────────────────────────────────────────────────────────

  Widget _buildListingsHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        child: Row(
          children: [
            Text(
              'Tüm İlanlar',
              style: GoogleFonts.raleway(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              '${_vehicles.length} ilan',
              style: GoogleFonts.raleway(
                  fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
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

  Widget _buildBottomPadding() {
    return SliverToBoxAdapter(
      child: SizedBox(height: AppConstants.bottomNavHeight + 24),
    );
  }
}
