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

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({
    super.key,
    required this.brand,
    required this.series,
    required this.model,
  });

  final String brand;
  final String series;
  final String model;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  String _displayCurrency = CurrencyHelper.defaultCurrency;
  late List<Vehicle> _vehicles;

  // Filters
  String _fuel = 'Tümü';
  String _transmission = 'Tümü';
  String _location = 'Tümü';
  String _year = 'Tümü';
  String _price = 'Tümü';
  String _km = 'Tümü';

  static const _fuelOpts = ['Tümü', 'Benzin', 'Dizel', 'Hibrit', 'Elektrik'];
  static const _transOpts = ['Tümü', 'Otomatik', 'Manuel'];
  static const _locationOpts = [
    'Tümü', 'Lefkoşa', 'Girne', 'Mağusa', 'İskele', 'Lefke', 'Güzelyurt'
  ];
  static const _yearOpts = [
    'Tümü', '2019+', '2020+', '2021+', '2022+', '2023+'
  ];
  static const _priceOpts = [
    'Tümü', '0–15K £', '15–30K £', '30–60K £', '60–100K £', '100K+ £'
  ];
  static const _kmOpts = [
    'Tümü', '0–25K', '25–50K', '50–75K', '75K+'
  ];

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

  List<Vehicle> get _filtered {
    return _vehicles.where((v) {
      // brand match (loose)
      final brandMatch =
          v.brand.toLowerCase().contains(widget.brand.toLowerCase());
      if (!brandMatch) return false;

      // fuel
      if (_fuel != 'Tümü' && v.fuelType != _fuel) return false;

      // transmission
      if (_transmission != 'Tümü' && v.transmission != _transmission) {
        return false;
      }

      // location
      if (_location != 'Tümü' && v.location != _location) return false;

      // year
      if (_year != 'Tümü') {
        final minYear = int.parse(_year.replaceAll('+', ''));
        if (v.year < minYear) return false;
      }

      // price
      switch (_price) {
        case '0–15K £':
          if (v.price > 15000) return false;
        case '15–30K £':
          if (v.price <= 15000 || v.price > 30000) return false;
        case '30–60K £':
          if (v.price <= 30000 || v.price > 60000) return false;
        case '60–100K £':
          if (v.price <= 60000 || v.price > 100000) return false;
        case '100K+ £':
          if (v.price <= 100000) return false;
      }

      // km
      switch (_km) {
        case '0–25K':
          if (v.mileage > 25000) return false;
        case '25–50K':
          if (v.mileage <= 25000 || v.mileage > 50000) return false;
        case '50–75K':
          if (v.mileage <= 50000 || v.mileage > 75000) return false;
        case '75K+':
          if (v.mileage <= 75000) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildFilterBar(),
          _buildResultsBar(results.length),
          if (results.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmpty(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.gridSpacing),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final v = results[i];
                    return VehicleCard(
                      vehicle: v,
                      displayCurrency: _displayCurrency,
                      onTap: () =>
                          context.push(AppRouter.carDetail, extra: v),
                      onFavoriteTap: () => _toggleFavorite(v.id),
                    );
                  },
                  childCount: results.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppConstants.gridSpacing,
                  mainAxisSpacing: AppConstants.gridSpacing,
                  childAspectRatio: AppConstants.gridChildAspectRatio,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ─── APP BAR ───────────────────────────────────────────────────────────

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
            widget.series.isEmpty
                ? widget.brand
                : '${widget.brand} · ${widget.series}',
            style: GoogleFonts.raleway(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (widget.model.isNotEmpty)
            Text(
              widget.model,
              style:
                  GoogleFonts.raleway(fontSize: 10, color: AppColors.red),
            )
          else
            Text(
              'Tüm ilanlar',
              style: GoogleFonts.raleway(
                  fontSize: 10, color: AppColors.textMuted),
            ),
        ],
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: _toggleCurrency,
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
              _displayCurrency == '£' ? '£ / ₺' : '₺ / £',
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.gold,
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 0.5, color: AppColors.border),
      ),
    );
  }

  // ─── FILTER BAR ────────────────────────────────────────────────────────

  SliverToBoxAdapter _buildFilterBar() {
    final activeCount = [_fuel, _transmission, _location, _year, _price, _km]
        .where((f) => f != 'Tümü')
        .length;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: GestureDetector(
          onTap: _showFilterSheet,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: activeCount > 0
                  ? AppColors.red.withValues(alpha: 0.07)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusSM),
              border: Border.all(
                color: activeCount > 0
                    ? AppColors.red.withValues(alpha: 0.4)
                    : AppColors.border,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tune_rounded,
                  size: 15,
                  color: activeCount > 0
                      ? AppColors.red
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 7),
                Text(
                  'Filtrele',
                  style: GoogleFonts.raleway(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: activeCount > 0
                        ? AppColors.red
                        : AppColors.textSecondary,
                  ),
                ),
                if (activeCount > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$activeCount',
                      style: GoogleFonts.montserrat(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (activeCount > 0)
                  GestureDetector(
                    onTap: _clearFilters,
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      'Temizle',
                      style: GoogleFonts.raleway(
                        fontSize: 11,
                        color: AppColors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FilterSheet(
        initialFuel: _fuel,
        initialTransmission: _transmission,
        initialLocation: _location,
        initialYear: _year,
        initialPrice: _price,
        initialKm: _km,
        onApply: (fuel, trans, loc, year, price, km) {
          setState(() {
            _fuel = fuel;
            _transmission = trans;
            _location = loc;
            _year = year;
            _price = price;
            _km = km;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  // ─── RESULTS BAR ───────────────────────────────────────────────────────

  SliverToBoxAdapter _buildResultsBar(int count) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
        child: Text(
          '$count ilan bulundu',
          style: GoogleFonts.raleway(fontSize: 11, color: AppColors.textMuted),
        ),
      ),
    );
  }

  void _clearFilters() {
    HapticFeedback.selectionClick();
    setState(() {
      _fuel = 'Tümü';
      _transmission = 'Tümü';
      _location = 'Tümü';
      _year = 'Tümü';
      _price = 'Tümü';
      _km = 'Tümü';
    });
  }

  // ─── EMPTY STATE ───────────────────────────────────────────────────────

  Widget _buildEmpty() {
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
            child: const Icon(Icons.search_off_rounded,
                color: AppColors.textMuted, size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            widget.model.isNotEmpty
                ? '${widget.brand} ${widget.model}'
                : widget.series.isNotEmpty
                    ? '${widget.brand} ${widget.series}'
                    : widget.brand,
            style: GoogleFonts.raleway(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Şu an bu model için ilan bulunamadı\nFiltreleri değiştirmeyi deneyin',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
                fontSize: 12, color: AppColors.textMuted, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// ─── FILTER BOTTOM SHEET ───────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.initialFuel,
    required this.initialTransmission,
    required this.initialLocation,
    required this.initialYear,
    required this.initialPrice,
    required this.initialKm,
    required this.onApply,
  });

  final String initialFuel;
  final String initialTransmission;
  final String initialLocation;
  final String initialYear;
  final String initialPrice;
  final String initialKm;
  final void Function(
          String fuel, String trans, String loc, String year, String price, String km)
      onApply;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String _fuel;
  late String _transmission;
  late String _location;
  late String _year;
  late String _price;
  late String _km;

  static const _fuelOpts = ['Tümü', 'Benzin', 'Dizel', 'Hibrit', 'Elektrik'];
  static const _transOpts = ['Tümü', 'Otomatik', 'Manuel'];
  static const _locationOpts = [
    'Tümü', 'Lefkoşa', 'Girne', 'Mağusa', 'İskele', 'Lefke', 'Güzelyurt'
  ];
  static const _yearOpts = [
    'Tümü', '2019+', '2020+', '2021+', '2022+', '2023+'
  ];
  static const _priceOpts = [
    'Tümü', '0–15K £', '15–30K £', '30–60K £', '60–100K £', '100K+ £'
  ];
  static const _kmOpts = ['Tümü', '0–25K', '25–50K', '50–75K', '75K+'];

  @override
  void initState() {
    super.initState();
    _fuel = widget.initialFuel;
    _transmission = widget.initialTransmission;
    _location = widget.initialLocation;
    _year = widget.initialYear;
    _price = widget.initialPrice;
    _km = widget.initialKm;
  }

  int get _activeCount =>
      [_fuel, _transmission, _location, _year, _price, _km]
          .where((f) => f != 'Tümü')
          .length;

  void _clearAll() {
    HapticFeedback.selectionClick();
    setState(() {
      _fuel = 'Tümü';
      _transmission = 'Tümü';
      _location = 'Tümü';
      _year = 'Tümü';
      _price = 'Tümü';
      _km = 'Tümü';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                Text(
                  'Filtrele',
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (_activeCount > 0)
                  GestureDetector(
                    onTap: _clearAll,
                    child: Text(
                      'Tümünü Temizle',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: AppColors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(height: 0.5, color: AppColors.border),
          // Filter groups
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGroup('YAKIT', _fuelOpts, _fuel,
                      (v) => setState(() => _fuel = v)),
                  _buildGroup('ŞANZIMAN', _transOpts, _transmission,
                      (v) => setState(() => _transmission = v)),
                  _buildGroup('KONUM', _locationOpts, _location,
                      (v) => setState(() => _location = v)),
                  _buildGroup('YIL', _yearOpts, _year,
                      (v) => setState(() => _year = v)),
                  _buildGroup('FİYAT', _priceOpts, _price,
                      (v) => setState(() => _price = v)),
                  _buildGroup('KİLOMETRE', _kmOpts, _km,
                      (v) => setState(() => _km = v)),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          // Apply button
          Container(height: 0.5, color: AppColors.border),
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
            child: SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.redDark, AppColors.red],
                  ),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMD),
                ),
                child: ElevatedButton(
                  onPressed: () => widget.onApply(
                      _fuel, _transmission, _location, _year, _price, _km),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMD),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Sonuçları Gör',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroup(
    String label,
    List<String> opts,
    String selected,
    ValueChanged<String> onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: opts.map((opt) {
            final isSel = opt == selected;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onSelect(opt);
              },
              child: AnimatedContainer(
                duration: AppConstants.durationFast,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isSel ? AppColors.red : AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusSM),
                  border: Border.all(
                    color: isSel ? AppColors.red : AppColors.border,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  opt,
                  style: GoogleFonts.raleway(
                    fontSize: 11,
                    fontWeight:
                        isSel ? FontWeight.w600 : FontWeight.w400,
                    color: isSel
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}
