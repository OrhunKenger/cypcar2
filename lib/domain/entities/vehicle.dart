class Vehicle {
  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    required this.currency,
    required this.photoUrls,
    required this.viewCount,
    required this.isFavorite,
    required this.isPinned,
    this.pinSlot,
    required this.location,
    required this.fuelType,
    required this.transmission,
    required this.mileage,
    required this.postedAt,
    required this.sellerId,
    this.color = 'Belirtilmemiş',
    this.steeringType = 'Sağ Direksiyon',
    this.sellerName = 'Satıcı',
    this.sellerPhone = '+90 548 000 0000',
    this.description = '',
    this.isUrgent = false,
  });

  final String id;
  final String brand;
  final String model;
  final int year;
  final double price;
  final String currency;
  final List<String> photoUrls;
  final int viewCount;
  final bool isFavorite;
  final bool isPinned;
  final int? pinSlot; // 1–12 arası (null = normal ilan)
  final String location;
  final String fuelType;
  final String transmission;
  final int mileage;
  final DateTime postedAt;
  final String sellerId;
  final String color;
  final String steeringType;
  final String sellerName;
  final String sellerPhone;
  final String description;
  final bool isUrgent;

  String get displayPrice =>
      '$currency ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  String get displayTitle => '$brand $model';

  Vehicle copyWith({bool? isFavorite, bool? isUrgent}) {
    return Vehicle(
      id: id,
      brand: brand,
      model: model,
      year: year,
      price: price,
      currency: currency,
      photoUrls: photoUrls,
      viewCount: viewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isPinned: isPinned,
      pinSlot: pinSlot,
      location: location,
      fuelType: fuelType,
      transmission: transmission,
      mileage: mileage,
      postedAt: postedAt,
      sellerId: sellerId,
      color: color,
      steeringType: steeringType,
      sellerName: sellerName,
      sellerPhone: sellerPhone,
      description: description,
      isUrgent: isUrgent ?? this.isUrgent,
    );
  }
}
