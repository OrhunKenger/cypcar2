import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../domain/entities/vehicle.dart';

class CarDetailPage extends StatefulWidget {
  const CarDetailPage({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  State<CarDetailPage> createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  final _scrollController = ScrollController();
  late final PageController _pageController;

  int _currentPage = 0;
  bool _isFavorite = false;
  bool _showTitle = false;
  String _displayCurrency = CurrencyHelper.defaultCurrency;
  double _expandedHeight = 0;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.vehicle.isFavorite;
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) setState(() => _currentPage = page);
  }

  void _onScroll() {
    if (_expandedHeight <= 0) return;
    final threshold = _expandedHeight - kToolbarHeight;
    final shouldShow = _scrollController.offset > threshold;
    if (shouldShow != _showTitle) setState(() => _showTitle = shouldShow);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _scrollController.removeListener(_onScroll);
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchPhone() async {
    final uri = Uri(scheme: 'tel', path: widget.vehicle.sellerPhone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchWhatsApp() async {
    final phone =
        widget.vehicle.sellerPhone.replaceAll(RegExp(r'[^0-9]'), '');
    final message = Uri.encodeComponent(
      '${widget.vehicle.brand} ${widget.vehicle.model} ilanınız hakkında bilgi almak istiyorum.',
    );
    final uri = Uri.parse('https://wa.me/$phone?text=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareVehicle() async {
    final v = widget.vehicle;
    await Share.share(
      '${v.brand} ${v.model} · ${v.year}\n'
      '${CurrencyHelper.formatPrice(v.price, "£")}\n'
      '${v.location} · ${_formatKm(v.mileage)} km\n\n'
      'CYPCAR — Kıbrıs\'a Özel Araç Platformu',
      subject: '${v.brand} ${v.model} İlanı — CYPCAR',
    );
  }

  void _openFullScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, animation, _) => FadeTransition(
          opacity: animation,
          child: _FullScreenGallery(
            photoUrls: widget.vehicle.photoUrls,
            initialIndex: _currentPage,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_expandedHeight <= 0) {
      _expandedHeight = MediaQuery.of(context).size.height * 0.58;
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildPhotoAppBar(),
          SliverToBoxAdapter(child: _buildContent()),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      bottomNavigationBar: _buildContactBar(),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────────────────────────

  Widget _buildPhotoAppBar() {
    final v = widget.vehicle;
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: _expandedHeight,
      pinned: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      title: AnimatedOpacity(
        opacity: _showTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          '${v.brand} ${v.model}',
          style: GoogleFonts.raleway(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      leading: _buildNavButton(
        icon: Icons.arrow_back_rounded,
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        _buildNavButton(
          icon: Icons.share_rounded,
          onPressed: _shareVehicle,
        ),
        _buildNavButton(
          icon: _isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() => _isFavorite = !_isFavorite);
          },
          iconColor: _isFavorite ? AppColors.red : Colors.white,
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _buildPhotoSection(),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor ?? Colors.white, size: 20),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }

  // ─── PHOTO GALLERY ───────────────────────────────────────────────────────

  Widget _buildPhotoSection() {
    final photos = widget.vehicle.photoUrls;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Tap → full screen
        GestureDetector(
          onTap: _openFullScreen,
          child: PageView.builder(
            controller: _pageController,
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final image = Image.network(
                photos[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(color: AppColors.surface);
                },
                errorBuilder: (context, error, stack) => Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: Icon(Icons.directions_car_rounded,
                        color: AppColors.textMuted, size: 48),
                  ),
                ),
              );
              // Hero on first photo: VehicleCard → CarDetailPage transition
              if (index == 0) {
                return Hero(
                  tag: 'vehicle_photo_${widget.vehicle.id}',
                  child: image,
                );
              }
              return image;
            },
          ),
        ),

        // Top gradient for nav button visibility
        Positioned(
          top: 0, left: 0, right: 0, height: 90,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x99000000), Colors.transparent],
              ),
            ),
          ),
        ),

        // Full-screen hint icon
        Positioned(
          top: kToolbarHeight + 8,
          right: 12,
          child: GestureDetector(
            onTap: _openFullScreen,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.open_in_full_rounded,
                  color: Colors.white70, size: 14),
            ),
          ),
        ),

        // Bottom gradient + page dots
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                  ),
                ),
              ),
              Container(
                color: const Color(0xCC000000),
                padding: const EdgeInsets.only(bottom: 14, top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: photos.length > 1
                      ? List.generate(photos.length, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentPage == i ? 22 : 6,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _currentPage == i
                                  ? AppColors.red
                                  : Colors.white30,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        })
                      : [],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── CONTENT ─────────────────────────────────────────────────────────────

  Widget _buildContent() {
    final v = widget.vehicle;
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceRow(v),
          const SizedBox(height: 10),

          // Title
          Text(
            '${v.brand} ${v.model}',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),

          // Location + view count
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(v.location,
                  style: GoogleFonts.raleway(
                      fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(width: 14),
              const Icon(Icons.remove_red_eye_outlined,
                  size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text('${v.viewCount} görüntülenme',
                  style: GoogleFonts.raleway(
                      fontSize: 12, color: AppColors.textMuted)),
            ],
          ),

          const SizedBox(height: 22),
          _buildDivider(),
          const SizedBox(height: 22),

          _buildSpecGrid(v),

          const SizedBox(height: 22),
          _buildDivider(),
          const SizedBox(height: 22),

          if (v.description.isNotEmpty) ...[
            Text(
              'Açıklama',
              style: GoogleFonts.raleway(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              v.description,
              style: GoogleFonts.raleway(
                  fontSize: 13, height: 1.65, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 22),
            _buildDivider(),
            const SizedBox(height: 22),
          ],

          _buildSellerCard(v),
        ],
      ),
    );
  }

  Widget _buildPriceRow(Vehicle v) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _displayCurrency =
                CurrencyHelper.toggleCurrency(_displayCurrency));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                CurrencyHelper.formatPrice(v.price, _displayCurrency),
                style: GoogleFonts.montserrat(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.swap_horiz_rounded,
                  size: 16, color: AppColors.textMuted),
            ],
          ),
        ),
        Text(
          _timeAgo(v.postedAt),
          style:
              GoogleFonts.raleway(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildSpecGrid(Vehicle v) {
    final specs = [
      _SpecData(
          icon: Icons.speed_rounded,
          label: 'Kilometre',
          value: '${_formatKm(v.mileage)} km'),
      _SpecData(
          icon: Icons.local_gas_station_rounded,
          label: 'Yakıt',
          value: v.fuelType),
      _SpecData(
          icon: Icons.settings_rounded,
          label: 'Şanzıman',
          value: v.transmission),
      _SpecData(
          icon: Icons.drive_eta_rounded,
          label: 'Direksiyon',
          value: v.steeringType),
      _SpecData(
          icon: Icons.palette_outlined, label: 'Renk', value: v.color),
      _SpecData(
          icon: Icons.calendar_today_rounded,
          label: 'Model Yılı',
          value: v.year.toString()),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Teknik Bilgiler',
          style: GoogleFonts.raleway(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          itemCount: specs.length,
          itemBuilder: (context, index) => _buildSpecCard(specs[index]),
        ),
      ],
    );
  }

  Widget _buildSpecCard(_SpecData spec) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusSM),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(spec.icon, size: 20, color: AppColors.red),
          const SizedBox(height: 6),
          Text(
            spec.value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.raleway(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            spec.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: GoogleFonts.raleway(
                fontSize: 9, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerCard(Vehicle v) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.redDark,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                v.sellerName.isNotEmpty
                    ? v.sellerName[0].toUpperCase()
                    : 'S',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  v.sellerName,
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'İlan Sahibi',
                  style: GoogleFonts.raleway(
                      fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),

          OutlinedButton(
            onPressed: () {
              // TODO: Navigate to seller profile
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.red,
              side: const BorderSide(color: AppColors.red, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSM),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: GoogleFonts.raleway(
                  fontSize: 11, fontWeight: FontWeight.w600),
            ),
            child: const Text('Tüm İlanlar'),
          ),
        ],
      ),
    );
  }

  // ─── CONTACT BAR ─────────────────────────────────────────────────────────

  Widget _buildContactBar() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 76 + bottomPadding,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + bottomPadding,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border:
            Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildContactButton(
              label: 'WhatsApp',
              icon: Icons.chat_rounded,
              color: const Color(0xFF25D366),
              onTap: _launchWhatsApp,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildContactButton(
              label: 'Ara',
              icon: Icons.phone_rounded,
              color: AppColors.red,
              onTap: _launchPhone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────

  Widget _buildDivider() =>
      const Divider(color: AppColors.border, height: 1);

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays} gün önce';
    if (diff.inHours > 0) return '${diff.inHours} saat önce';
    if (diff.inMinutes > 0) return '${diff.inMinutes} dakika önce';
    return 'Az önce';
  }

  String _formatKm(int km) {
    return km
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}

// ─── SPEC DATA ───────────────────────────────────────────────────────────────

class _SpecData {
  const _SpecData({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

// ─── FULL SCREEN GALLERY ─────────────────────────────────────────────────────

class _FullScreenGallery extends StatefulWidget {
  const _FullScreenGallery({
    required this.photoUrls,
    required this.initialIndex,
  });

  final List<String> photoUrls;
  final int initialIndex;

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) setState(() => _currentPage = page);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Zoomable photo PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photoUrls.length,
            itemBuilder: (context, index) => InteractiveViewer(
              minScale: 0.8,
              maxScale: 5.0,
              child: Center(
                child: Image.network(
                  widget.photoUrls[index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => const Center(
                    child: Icon(Icons.directions_car_rounded,
                        color: Colors.white24, size: 64),
                  ),
                ),
              ),
            ),
          ),

          // Top bar: photo count + close
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentPage + 1} / ${widget.photoUrls.length}',
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom: page dots
          if (widget.photoUrls.length > 1)
            Positioned(
              bottom: bottomPadding + 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.photoUrls.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentPage == i ? 22 : 6,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? AppColors.red
                          : Colors.white30,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
