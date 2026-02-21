import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _fadeController;
  late Animation<double> _fadeIn;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: AppConstants.durationFast,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 100;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          FadeTransition(
            opacity: _fadeIn,
            child: SafeArea(
              child: Column(
                children: [
                  _buildTopBar(keyboardVisible),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: keyboardVisible
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Padding(
                      padding: const EdgeInsets.only(
                        top: AppConstants.paddingLG,
                        bottom: AppConstants.paddingXL,
                      ),
                      child: _buildLogoSection(),
                    ),
                    secondChild: const SizedBox(
                      height: AppConstants.paddingSM,
                      width: double.infinity,
                    ),
                  ),
                  _buildPillToggle(),
                  const SizedBox(height: AppConstants.paddingXS),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) => setState(() => _currentIndex = i),
                      children: const [
                        LoginPage(),
                        RegisterPage(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool keyboardVisible) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSM,
        vertical: AppConstants.paddingXS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!keyboardVisible)
            TextButton(
              onPressed: () => context.go(AppRouter.home),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textMuted,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingSM,
                  vertical: AppConstants.paddingXS,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Misafir Devam Et',
                    style: GoogleFonts.raleway(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.0, -0.4),
          radius: 1.0,
          colors: [Color(0xFF160000), AppColors.background],
          stops: [0.0, 0.65],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (b) => AppColors.goldGradient.createShader(b),
          child: const Icon(
            Icons.directions_car_rounded,
            size: 26,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMD),
        _buildFlankedTitle(),
        const SizedBox(height: AppConstants.paddingSM),
        Text(
          AppConstants.appTagline.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.raleway(
            fontSize: 8.5,
            fontWeight: FontWeight.w300,
            letterSpacing: 2.5,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildFlankedTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 0.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, AppColors.red],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMD,
            ),
            child: Text(
              AppConstants.appName,
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.w200,
                letterSpacing: 8,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 0.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.red, Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLG),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildPillTab('GİRİŞ YAP', 0),
          _buildPillTab('KAYIT OL', 1),
        ],
      ),
    );
  }

  Widget _buildPillTab(String title, int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchTab(index),
        child: AnimatedContainer(
          duration: AppConstants.durationFast,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.red : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.red.withValues(alpha: 0.35),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              letterSpacing: 1.8,
              color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
