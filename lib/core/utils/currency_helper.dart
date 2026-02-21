/// Döviz dönüşüm yardımcısı.
/// Şu an mock kur kullanılmaktadır.
/// Backend entegrasyonunda [updateRates] ile gerçek API'den kur alınacak.
class CurrencyHelper {
  CurrencyHelper._();

  static const String defaultCurrency = '£';
  static const List<String> supported = ['£', '₺'];

  // Mock kurlar: 1 GBP = X birim
  // TODO: Backend entegrasyonunda exchange rate API'den çekilecek
  static final Map<String, double> _rates = {
    '£': 1.0,
    '₺': 46.5,
  };

  /// Kuru günceller (Backend entegrasyonunda API response ile çağrılacak)
  static void updateRates(Map<String, double> newRates) {
    _rates.addAll(newRates);
  }

  /// [baseAmountGbp] GBP cinsinden temel fiyatı [targetCurrency]'e çevirir ve formatlar.
  static String formatPrice(double baseAmountGbp, String targetCurrency) {
    final rate = _rates[targetCurrency] ?? 1.0;
    final converted = baseAmountGbp * rate;
    return '$targetCurrency${_format(converted)}';
  }

  static String _format(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  static String toggleCurrency(String current) {
    final idx = supported.indexOf(current);
    return supported[(idx + 1) % supported.length];
  }
}
