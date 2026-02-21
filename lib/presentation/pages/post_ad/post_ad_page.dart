import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/inputs/custom_text_field.dart';

class PostAdPage extends StatefulWidget {
  const PostAdPage({super.key});

  @override
  State<PostAdPage> createState() => _PostAdPageState();
}

class _PostAdPageState extends State<PostAdPage> {
  int _step = 0;
  bool _goingForward = true;

  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _mileageController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedFuel = 'Benzin';
  String _selectedTransmission = 'Otomatik';
  String _selectedSteering = 'Sağ Direksiyon';
  String _selectedCurrency = '£';
  String _selectedLocation = 'Lefkoşa';
  final Set<int> _addedPhotos = {};

  static const _stepTitles = [
    'Temel Bilgiler',
    'Teknik Detaylar',
    'Fiyat & Konum',
    'Fotoğraflar',
  ];

  void _next() {
    HapticFeedback.selectionClick();
    if (_step < 3) {
      setState(() {
        _goingForward = true;
        _step++;
      });
    }
  }

  void _back() {
    HapticFeedback.selectionClick();
    if (_step > 0) {
      setState(() {
        _goingForward = false;
        _step--;
      });
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              transitionBuilder: (child, animation) {
                final slide = Tween<Offset>(
                  begin: Offset(_goingForward ? 1.0 : -1.0, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeOutCubic));
                final fade = CurvedAnimation(
                    parent: animation, curve: Curves.easeIn);
                return SlideTransition(
                  position: slide,
                  child: FadeTransition(opacity: fade, child: child),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(_step),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: _buildStep(),
                ),
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded,
            color: AppColors.textSecondary, size: 22),
        onPressed: () => Navigator.pop(context),
      ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          _stepTitles[_step],
          key: ValueKey(_step),
          style: GoogleFonts.raleway(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              '${_step + 1} / 4',
              style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted),
            ),
          ),
        ),
      ],
    );
  }

  // ─── PROGRESS BAR ────────────────────────────────────────────────────────

  Widget _buildProgressBar() {
    return Container(
      height: 2,
      color: AppColors.surface,
      alignment: Alignment.centerLeft,
      child: AnimatedFractionallySizedBox(
        duration: AppConstants.durationFast,
        widthFactor: (_step + 1) / 4,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.redDark, AppColors.redBright],
            ),
          ),
        ),
      ),
    );
  }

  // ─── STEP ROUTER ─────────────────────────────────────────────────────────

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      default:
        return const SizedBox.shrink();
    }
  }

  // ─── STEP 1: TEMEL BİLGİLER ──────────────────────────────────────────────

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHero('Aracı Tanımlayın',
            'Ruhsattaki bilgileri kullanın.', Icons.directions_car_rounded),
        const SizedBox(height: 32),
        _buildCard([
          _buildInlineField(
              'Marka', _brandController, Icons.directions_car_outlined),
          _buildFieldDivider(),
          _buildInlineField(
              'Model', _modelController, Icons.model_training_outlined),
          _buildFieldDivider(),
          _buildInlineField('Model Yılı', _yearController,
              Icons.calendar_today_outlined,
              keyboard: TextInputType.number),
        ]),
      ],
    );
  }

  // ─── STEP 2: TEKNİK DETAYLAR ─────────────────────────────────────────────

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHero('Teknik Bilgiler',
            'Aracın donanım detaylarını girin.', Icons.settings_rounded),
        const SizedBox(height: 32),
        _buildCard([
          _buildInlineField('Kilometre (KM)', _mileageController,
              Icons.speed_rounded,
              keyboard: TextInputType.number),
        ]),
        const SizedBox(height: 24),
        _buildPillGroup(
            'YAKIT TÜRÜ',
            ['Benzin', 'Dizel', 'Hibrit', 'Elektrik'],
            _selectedFuel,
            (v) => setState(() => _selectedFuel = v)),
        const SizedBox(height: 20),
        _buildPillGroup(
            'ŞANZIMAN',
            ['Otomatik', 'Manuel'],
            _selectedTransmission,
            (v) => setState(() => _selectedTransmission = v)),
        const SizedBox(height: 20),
        _buildPillGroup(
            'DİREKSİYON',
            ['Sağ Direksiyon', 'Sol Direksiyon'],
            _selectedSteering,
            (v) => setState(() => _selectedSteering = v)),
      ],
    );
  }

  // ─── STEP 3: FİYAT & KONUM ───────────────────────────────────────────────

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHero('Fiyat ve Konum',
            'İlanınızın vitrindeki kısımları.', Icons.payments_rounded),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildCard([
                _buildInlineField('Fiyat', _priceController,
                    Icons.payments_outlined,
                    keyboard: TextInputType.number),
              ]),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PARA BİRİMİ',
                  style: GoogleFonts.raleway(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.textMuted),
                ),
                const SizedBox(height: 10),
                Row(
                  children: ['£', '₺'].map((c) {
                    final isSel = c == _selectedCurrency;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedCurrency = c);
                      },
                      child: AnimatedContainer(
                        duration: AppConstants.durationFast,
                        width: 46,
                        height: 46,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.red : AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusSM),
                          border: Border.all(
                              color: isSel
                                  ? AppColors.red
                                  : AppColors.border,
                              width: 0.5),
                        ),
                        child: Center(
                          child: Text(c,
                              style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: isSel
                                      ? Colors.white
                                      : AppColors.textSecondary)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildPillGroup(
            'KONUM (İLÇE)',
            ['Lefkoşa', 'Girne', 'Mağusa', 'İskele', 'Güzelyurt', 'Lefke'],
            _selectedLocation,
            (v) => setState(() => _selectedLocation = v)),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'Açıklama',
          controller: _descriptionController,
          maxLines: 5,
          hintText:
              'Aracınızın extraları, bakım geçmişi ve özelliklerini yazın...',
        ),
      ],
    );
  }

  // ─── STEP 4: FOTOĞRAFLAR ─────────────────────────────────────────────────

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHero('Fotoğraflar',
            'En az 3, en fazla 10 fotoğraf.', Icons.photo_library_rounded),
        const SizedBox(height: 32),

        // Kapak fotoğrafı
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              if (_addedPhotos.contains(0)) {
                _addedPhotos.remove(0);
              } else {
                _addedPhotos.add(0);
              }
            });
          },
          child: AnimatedContainer(
            duration: AppConstants.durationFast,
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: _addedPhotos.contains(0)
                  ? AppColors.red.withValues(alpha: 0.12)
                  : AppColors.surface,
              borderRadius:
                  BorderRadius.circular(AppConstants.radiusMD),
              border: Border.all(
                  color: _addedPhotos.contains(0)
                      ? AppColors.red
                      : AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _addedPhotos.contains(0)
                      ? Icons.image_rounded
                      : Icons.add_a_photo_outlined,
                  color: _addedPhotos.contains(0)
                      ? AppColors.red
                      : AppColors.textSecondary,
                  size: 36,
                ),
                const SizedBox(height: 10),
                Text(
                  _addedPhotos.contains(0)
                      ? 'Kapak Fotoğrafı Seçildi'
                      : 'Kapak Fotoğrafı Ekle',
                  style: GoogleFonts.raleway(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _addedPhotos.contains(0)
                          ? AppColors.red
                          : AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text('İlanınızın vitrin görseli',
                    style: GoogleFonts.raleway(
                        fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Ek fotoğraflar
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final photoIndex = index + 1;
            final isAdded = _addedPhotos.contains(photoIndex);
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (isAdded) {
                    _addedPhotos.remove(photoIndex);
                  } else {
                    _addedPhotos.add(photoIndex);
                  }
                });
              },
              child: AnimatedContainer(
                duration: AppConstants.durationFast,
                decoration: BoxDecoration(
                  color: isAdded
                      ? AppColors.red.withValues(alpha: 0.12)
                      : AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusSM),
                  border: Border.all(
                      color:
                          isAdded ? AppColors.red : AppColors.border,
                      width: 0.5),
                ),
                child: isAdded
                    ? const Center(
                        child: Icon(Icons.check_circle_rounded,
                            color: AppColors.red, size: 28))
                    : const Center(
                        child: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: AppColors.textMuted,
                            size: 24)),
              ),
            );
          },
        ),

        const SizedBox(height: 12),
        Text(
          '${_addedPhotos.length} fotoğraf seçildi · En az 3 ekleyin',
          style: GoogleFonts.raleway(
              fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }

  // ─── BOTTOM BAR ──────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border:
            Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          if (_step > 0) ...[
            SizedBox(
              height: 52,
              width: 52,
              child: OutlinedButton(
                onPressed: _back,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMD)),
                  padding: EdgeInsets.zero,
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.textSecondary, size: 20),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.redDark,
                    AppColors.red,
                    AppColors.redBright
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusMD),
              ),
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMD)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_step == 3) ...[
                      const Icon(Icons.rocket_launch_rounded,
                          size: 16, color: Colors.white),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      _step == 3 ? 'İLAN YAYINLA' : 'DEVAM ET',
                      style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: Colors.white),
                    ),
                    if (_step < 3) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded,
                          size: 16, color: Colors.white),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────

  Widget _buildStepHero(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.red.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppConstants.radiusSM),
            border: Border.all(
                color: AppColors.red.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: AppColors.red, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.raleway(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 3),
              Text(subtitle,
                  style: GoogleFonts.raleway(
                      fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInlineField(
    String label,
    TextEditingController ctrl,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: ctrl,
              keyboardType: keyboard,
              style: GoogleFonts.raleway(
                  fontSize: 14, color: AppColors.textPrimary),
              cursorColor: AppColors.red,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.raleway(
                    fontSize: 13, color: AppColors.textMuted),
                floatingLabelStyle: GoogleFonts.raleway(
                    fontSize: 11, color: AppColors.red),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldDivider() {
    return const Divider(
        height: 1, color: AppColors.border, indent: 44, endIndent: 0);
  }

  Widget _buildPillGroup(String title, List<String> options,
      String selected, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.raleway(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppColors.textMuted)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSel = opt == selected;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onSelect(opt);
              },
              child: AnimatedContainer(
                duration: AppConstants.durationFast,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSel ? AppColors.red : AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusSM),
                  border: Border.all(
                      color: isSel ? AppColors.red : AppColors.border,
                      width: isSel ? 1 : 0.5),
                ),
                child: Text(opt,
                    style: GoogleFonts.raleway(
                        fontSize: 12,
                        fontWeight: isSel
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSel
                            ? Colors.white
                            : AppColors.textSecondary)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
