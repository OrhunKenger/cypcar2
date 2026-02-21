import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  static const _items = [
    _NavItemData(icon: Icons.favorite_border_rounded, activeIcon: Icons.favorite_rounded, label: 'Favoriler'),
    _NavItemData(icon: Icons.search_rounded, activeIcon: Icons.search_rounded, label: 'Arama'),
    _NavItemData(icon: Icons.home_rounded, activeIcon: Icons.home_rounded, label: 'Ana Sayfa', isElevated: true),
    _NavItemData(icon: Icons.warning_amber_rounded, activeIcon: Icons.warning_rounded, label: 'Acil', isElevated: true),
    _NavItemData(icon: Icons.add_box_outlined, activeIcon: Icons.add_box_rounded, label: 'İlan Ver'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: AppConstants.bottomNavHeight + bottomPadding,
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = currentIndex == index;
            return item.isElevated
                ? _buildElevatedItem(item, index, isSelected)
                : _buildNavItem(item, index, isSelected);
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(_NavItemData item, int index, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onItemTapped(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 22,
              color: isSelected ? AppColors.red : AppColors.textMuted,
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: GoogleFonts.raleway(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.red : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatedItem(_NavItemData item, int index, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onItemTapped(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -9),
              child: AnimatedContainer(
                duration: AppConstants.durationFast,
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.red : AppColors.redDark,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.red.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.red.withValues(alpha: isSelected ? 0.55 : 0.25),
                      blurRadius: 16,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -5),
              child: Text(
                item.label,
                style: GoogleFonts.raleway(
                  fontSize: 9,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.red : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isElevated = false,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isElevated;
}
