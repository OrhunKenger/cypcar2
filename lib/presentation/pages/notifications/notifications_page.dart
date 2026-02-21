import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late List<_NotifItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(_mockNotifications);
  }

  void _markAllRead() {
    setState(() {
      _notifications =
          _notifications.map((n) => n.copyRead()).toList();
    });
  }

  void _markRead(int index) {
    if (!_notifications[index].isRead) {
      setState(() {
        final updated = List<_NotifItem>.from(_notifications);
        updated[index] = updated[index].copyRead();
        _notifications = updated;
      });
    }
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) =>
                  _buildNotifItem(index),
            ),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded,
            color: AppColors.textPrimary, size: 22),
        onPressed: () => context.pop(),
      ),
      title: Column(
        children: [
          Text(
            'BİLDİRİMLER',
            style: GoogleFonts.raleway(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: AppColors.textPrimary,
            ),
          ),
          if (_unreadCount > 0)
            Text(
              '$_unreadCount okunmamış',
              style: GoogleFonts.raleway(
                  fontSize: 10, color: AppColors.red),
            ),
        ],
      ),
      centerTitle: true,
      actions: [
        if (_unreadCount > 0)
          TextButton(
            onPressed: _markAllRead,
            child: Text(
              'Tümünü oku',
              style: GoogleFonts.raleway(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  // ─── NOTIFICATION ITEM ───────────────────────────────────────────────

  Widget _buildNotifItem(int index) {
    final notif = _notifications[index];
    return GestureDetector(
      onTap: () => _markRead(index),
      child: AnimatedContainer(
        duration: AppConstants.durationFast,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead
              ? AppColors.surface
              : AppColors.red.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(
            color: notif.isRead
                ? AppColors.border
                : AppColors.red.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notif.iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(notif.icon, color: notif.iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            fontWeight: notif.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.body,
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notif.time,
                    style: GoogleFonts.raleway(
                        fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── EMPTY STATE ─────────────────────────────────────────────────────

  Widget _buildEmptyState() {
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
            child: const Icon(Icons.notifications_none_rounded,
                color: AppColors.textMuted, size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            'Bildirim yok',
            style: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni ilanlar ve fiyat değişimlerinde\nburada bildirim alacaksınız',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
                fontSize: 12, color: AppColors.textMuted, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// ─── MOCK DATA ─────────────────────────────────────────────────────────────

class _NotifItem {
  const _NotifItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  final bool isRead;

  _NotifItem copyRead() => _NotifItem(
        icon: icon,
        iconColor: iconColor,
        title: title,
        body: body,
        time: time,
        isRead: true,
      );
}

const _mockNotifications = [
  _NotifItem(
    icon: Icons.directions_car_rounded,
    iconColor: AppColors.red,
    title: 'Yeni İlan Eşleşmesi',
    body: 'BMW 5 Serisi aramanızla eşleşen 2 yeni ilan Lefkoşa\'da yayınlandı',
    time: '2 saat önce',
    isRead: false,
  ),
  _NotifItem(
    icon: Icons.trending_down_rounded,
    iconColor: Color(0xFF66BB6A),
    title: 'Fiyat Düştü',
    body: 'Favorilere eklediğiniz Honda Civic\'in fiyatı £500 düşürüldü',
    time: '4 saat önce',
    isRead: false,
  ),
  _NotifItem(
    icon: Icons.warning_amber_rounded,
    iconColor: AppColors.gold,
    title: 'Acil İlan Uyarısı',
    body: 'Ford Mustang fiyatı £2,000 düşürüldü — son 2 gün kaldı',
    time: '7 saat önce',
    isRead: false,
  ),
  _NotifItem(
    icon: Icons.search_rounded,
    iconColor: Color(0xFF4FC3F7),
    title: 'Kayıtlı Aramanız',
    body: 'Girne\'deki dizel SUV aramanız için 3 yeni ilan bulundu',
    time: 'Dün, 14:30',
    isRead: true,
  ),
  _NotifItem(
    icon: Icons.remove_red_eye_outlined,
    iconColor: Color(0xFF66BB6A),
    title: 'İlanınız Popüler',
    body: 'Mercedes C200 ilanınız bugün 124 kez görüntülendi',
    time: 'Dün, 09:15',
    isRead: true,
  ),
  _NotifItem(
    icon: Icons.favorite_rounded,
    iconColor: AppColors.red,
    title: 'Favori İlan Güncellendi',
    body: 'Range Rover ilanı güncellendi — 8 yeni fotoğraf eklendi',
    time: '2 gün önce',
    isRead: true,
  ),
  _NotifItem(
    icon: Icons.local_offer_rounded,
    iconColor: AppColors.gold,
    title: 'Özel Fırsat',
    body: 'Kayıtlı aramanızla eşleşen Porsche Cayenne %8 indirimle yeniden listelendi',
    time: '3 gün önce',
    isRead: true,
  ),
  _NotifItem(
    icon: Icons.verified_rounded,
    iconColor: Color(0xFF4FC3F7),
    title: 'İlanınız Yayında',
    body: 'BMW 5 Serisi ilanınız başarıyla yayınlandı ve aktif',
    time: '5 gün önce',
    isRead: true,
  ),
];
