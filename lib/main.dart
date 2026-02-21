import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_colors.dart';
import 'core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const CypcarApp());
}

class CypcarApp extends StatelessWidget {
  const CypcarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CYPCAR',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.red,
          secondary: AppColors.gold,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        textTheme: GoogleFonts.ralewayTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            letterSpacing: 3,
            color: AppColors.textPrimary,
          ),
        ),
        useMaterial3: true,
      ),
    );
  }
}
