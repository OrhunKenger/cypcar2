import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/vehicle.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/auth/auth_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/car_detail/car_detail_page.dart';
import '../../presentation/pages/post_ad/post_ad_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/notifications/notifications_page.dart';
import '../../presentation/pages/search/search_series_page.dart';
import '../../presentation/pages/search/search_models_page.dart';
import '../../presentation/pages/search/search_results_page.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String carDetail = '/car-detail';
  static const String postAd = '/post-ad';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String searchSeries = '/search/series';
  static const String searchModels = '/search/models';
  static const String searchResults = '/search/results';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashPage(),
        ),
      ),
      GoRoute(
        path: auth,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AuthPage(),
          transitionDuration: const Duration(milliseconds: 700),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeIn,
              ),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: home,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeIn,
              ),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: carDetail,
        pageBuilder: (context, state) {
          final vehicle = state.extra as Vehicle;
          return CustomTransitionPage(
            key: state.pageKey,
            child: CarDetailPage(vehicle: vehicle),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, _, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn,
                ),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: postAd,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PostAdPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: profile,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfilePage(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: notifications,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NotificationsPage(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: searchSeries,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: SearchSeriesPage(brand: extra['brand']!),
            transitionDuration: const Duration(milliseconds: 280),
            transitionsBuilder: (context, animation, _, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: searchModels,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: SearchModelsPage(
              brand: extra['brand']!,
              series: extra['series']!,
            ),
            transitionDuration: const Duration(milliseconds: 280),
            transitionsBuilder: (context, animation, _, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: searchResults,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return CustomTransitionPage(
            key: state.pageKey,
            child: SearchResultsPage(
              brand: extra['brand']!,
              series: extra['series']!,
              model: extra['model']!,
            ),
            transitionDuration: const Duration(milliseconds: 280),
            transitionsBuilder: (context, animation, _, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
}
