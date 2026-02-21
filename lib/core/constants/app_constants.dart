class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'CYPCAR';
  static const String appTagline = 'Kıbrıs\'a Özel Araç Alım-Satım Platformu';
  static const String appVersion = '1.0.0';

  // Padding / Spacing
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border radius
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;

  // Animation durations
  static const Duration durationFast = Duration(milliseconds: 300);
  static const Duration durationMedium = Duration(milliseconds: 600);
  static const Duration durationSlow = Duration(milliseconds: 900);

  // Grid
  static const int pinnedSlotCount = 12;
  static const double gridSpacing = 2.0;
  static const double gridChildAspectRatio = 1.3;

  // Bottom nav
  static const double bottomNavHeight = 64.0;
  static const double bottomNavCenterSize = 52.0;

  // Splash animation durations
  static const Duration splashBgDuration = Duration(milliseconds: 800);
  static const Duration splashLogoDuration = Duration(milliseconds: 1200);
  static const Duration splashTextDuration = Duration(milliseconds: 900);
  static const Duration splashTaglineDuration = Duration(milliseconds: 700);
  static const Duration splashShimmerDuration = Duration(milliseconds: 1600);
  static const Duration splashExitDuration = Duration(milliseconds: 700);
}
