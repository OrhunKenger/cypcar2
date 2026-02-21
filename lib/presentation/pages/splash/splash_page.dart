import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late AnimationController _shimmerController;
  late AnimationController _exitController;

  late Animation<double> _bgOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoGlow;
  late Animation<double> _textOpacity;
  late Animation<double> _textSpacing;
  late Animation<double> _taglineOpacity;
  late Animation<double> _shimmerPosition;
  late Animation<double> _exitOpacity;
  late Animation<double> _lineWidth;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _initControllers();
    _initAnimations();
    _startSequence();
  }

  void _initControllers() {
    _bgController = AnimationController(
      vsync: this,
      duration: AppConstants.splashBgDuration,
    );
    _logoController = AnimationController(
      vsync: this,
      duration: AppConstants.splashLogoDuration,
    );
    _textController = AnimationController(
      vsync: this,
      duration: AppConstants.splashTextDuration,
    );
    _taglineController = AnimationController(
      vsync: this,
      duration: AppConstants.splashTaglineDuration,
    );
    _shimmerController = AnimationController(
      vsync: this,
      duration: AppConstants.splashShimmerDuration,
    );
    _exitController = AnimationController(
      vsync: this,
      duration: AppConstants.splashExitDuration,
    );
  }

  void _initAnimations() {
    _bgOpacity = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeIn,
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    _logoGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _lineWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSpacing = Tween<double>(begin: 20.0, end: 10.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    _shimmerPosition = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _bgController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _taglineController.forward();
    _shimmerController.forward();

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    _exitController.forward();

    await Future.delayed(AppConstants.splashExitDuration);
    if (!mounted) return;
    context.go(AppRouter.auth);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _shimmerController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _bgController,
          _logoController,
          _textController,
          _taglineController,
          _shimmerController,
          _exitController,
        ]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _exitOpacity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                _buildCinematicBars(),
                _buildContent(),
                _buildBottomBrand(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackground() {
    return FadeTransition(
      opacity: _bgOpacity,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.splashBackgroundGradient,
        ),
      ),
    );
  }

  Widget _buildCinematicBars() {
    return Column(
      children: [
        FadeTransition(
          opacity: _bgOpacity,
          child: Container(height: 40, color: Colors.black),
        ),
        const Spacer(),
        FadeTransition(
          opacity: _bgOpacity,
          child: Container(height: 40, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogo(),
        const SizedBox(height: AppConstants.paddingLG),
        _buildDividerLine(),
        const SizedBox(height: AppConstants.paddingLG),
        _buildBrandName(),
        const SizedBox(height: AppConstants.paddingSM),
        _buildTagline(),
      ],
    );
  }

  Widget _buildLogo() {
    return ScaleTransition(
      scale: _logoScale,
      child: FadeTransition(
        opacity: _logoOpacity,
        child: AnimatedBuilder(
          animation: _logoGlow,
          builder: (context, child) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.red.withValues(alpha: 0.7 * _logoGlow.value),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.red.withValues(alpha: 0.35 * _logoGlow.value),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                  BoxShadow(
                    color: AppColors.red.withValues(alpha: 0.15 * _logoGlow.value),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.goldGradient.createShader(bounds),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    size: 52,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDividerLine() {
    return AnimatedBuilder(
      animation: _lineWidth,
      builder: (context, child) {
        return SizedBox(
          width: 160 * _lineWidth.value,
          height: 1,
          child: ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.primaryGradient.createShader(bounds),
            child: Container(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildBrandName() {
    return AnimatedBuilder(
      animation: _shimmerPosition,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textOpacity,
          child: AnimatedBuilder(
            animation: _textSpacing,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment(_shimmerPosition.value - 0.5, 0),
                    end: Alignment(_shimmerPosition.value + 0.5, 0),
                    colors: const [
                      AppColors.red,
                      AppColors.redBright,
                      Color(0xFFFFFFFF),
                      AppColors.redBright,
                      AppColors.red,
                    ],
                    stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                  ).createShader(bounds);
                },
                child: Text(
                  AppConstants.appName,
                  style: GoogleFonts.montserrat(
                    fontSize: 42,
                    fontWeight: FontWeight.w200,
                    letterSpacing: _textSpacing.value,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    return FadeTransition(
      opacity: _taglineOpacity,
      child: Text(
        AppConstants.appTagline,
        style: GoogleFonts.raleway(
          fontSize: 11,
          fontWeight: FontWeight.w300,
          letterSpacing: 3.5,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildBottomBrand() {
    return Positioned(
      bottom: AppConstants.paddingXXL,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _taglineOpacity,
        child: Text(
          'POWERED BY CYPCAR',
          textAlign: TextAlign.center,
          style: GoogleFonts.raleway(
            fontSize: 9,
            fontWeight: FontWeight.w400,
            letterSpacing: 4,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
