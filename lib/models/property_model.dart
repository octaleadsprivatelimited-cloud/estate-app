class PropertyModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String priceUnit; // 'total' | 'per_month' | 'per_sqft'
  final String type; // Apartment, Villa, Plot, Commercial
  final String purpose; // Buy, Rent, PG
  final String status; // ready_to_move, under_construction
  final int? bhk;
  final double area;
  final String areaUnit; // sqft, sqm
  final int? floor;
  final int? totalFloors;
  final int? bathrooms;
  final int? balconies;
  final String city;
  final String locality;
  final String address;
  final double? latitude;
  final double? longitude;
  final List<String> images;
  final List<String> videos;
  final List<String> amenities;
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final String? sellerWhatsApp;
  final bool isVerified;
  final bool isFeatured;
  final bool isPremium;
  final double rating;
  final int reviewCount;
  final int viewCount;
  final String createdAt;
  final String? possessionDate;
  final String? reraId;
  final Map<String, dynamic>? nearbyPlaces;

  const PropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.priceUnit,
    required this.type,
    required this.purpose,
    required this.status,
    this.bhk,
    required this.area,
    required this.areaUnit,
    this.floor,
    this.totalFloors,
    this.bathrooms,
    this.balconies,
    required this.city,
    required this.locality,
    required this.address,
    this.latitude,
    this.longitude,
    required this.images,
    required this.videos,
    required this.amenities,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    this.sellerWhatsApp,
    this.isVerified = false,
    this.isFeatured = false,
    this.isPremium = false,
    this.rating = 0,
    this.reviewCount = 0,
    this.viewCount = 0,
    required this.createdAt,
    this.possessionDate,
    this.reraId,
    this.nearbyPlaces,
  });

  factory PropertyModel.fromMap(Map<String, dynamic> map, String docId) {
    return PropertyModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      priceUnit: map['priceUnit'] ?? 'total',
      type: map['type'] ?? 'Apartment',
      purpose: map['purpose'] ?? 'Buy',
      status: map['status'] ?? 'ready_to_move',
      bhk: map['bhk'],
      area: (map['area'] ?? 0).toDouble(),
      areaUnit: map['areaUnit'] ?? 'sqft',
      floor: map['floor'],
      totalFloors: map['totalFloors'],
      bathrooms: map['bathrooms'],
      balconies: map['balconies'],
      city: map['city'] ?? '',
      locality: map['locality'] ?? '',
      address: map['address'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      images: List<String>.from(map['images'] ?? []),
      videos: List<String>.from(map['videos'] ?? []),
      amenities: List<String>.from(map['amenities'] ?? []),
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      sellerPhone: map['sellerPhone'] ?? '',
      sellerWhatsApp: map['sellerWhatsApp'],
      isVerified: map['isVerified'] ?? false,
      isFeatured: map['isFeatured'] ?? false,
      isPremium: map['isPremium'] ?? false,
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      viewCount: map['viewCount'] ?? 0,
      createdAt: map['createdAt'] ?? DateTime.now().toIso8601String(),
      possessionDate: map['possessionDate'],
      reraId: map['reraId'],
      nearbyPlaces: map['nearbyPlaces'],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'price': price,
        'priceUnit': priceUnit,
        'type': type,
        'purpose': purpose,
        'status': status,
        'bhk': bhk,
        'area': area,
        'areaUnit': areaUnit,
        'floor': floor,
        'totalFloors': totalFloors,
        'bathrooms': bathrooms,
        'balconies': balconies,
        'city': city,
        'locality': locality,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'images': images,
        'videos': videos,
        'amenities': amenities,
        'sellerId': sellerId,
        'sellerName': sellerName,
        'sellerPhone': sellerPhone,
        'sellerWhatsApp': sellerWhatsApp,
        'isVerified': isVerified,
        'isFeatured': isFeatured,
        'isPremium': isPremium,
        'rating': rating,
        'reviewCount': reviewCount,
        'viewCount': viewCount,
        'createdAt': createdAt,
        'possessionDate': possessionDate,
        'reraId': reraId,
        'nearbyPlaces': nearbyPlaces,
      };

  String get formattedPrice {
    if (price >= 10000000) {
      return '₹${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '₹${(price / 100000).toStringAsFixed(2)} L';
    }
    return '₹${price.toStringAsFixed(0)}';
  }

  PropertyModel copyWith({
    bool? isVerified,
    bool? isFeatured,
    bool? isPremium,
    int? viewCount,
    double? rating,
    int? reviewCount,
  }) {
    return PropertyModel(
      id: id, title: title, description: description, price: price,
      priceUnit: priceUnit, type: type, purpose: purpose, status: status,
      bhk: bhk, area: area, areaUnit: areaUnit, floor: floor,
      totalFloors: totalFloors, bathrooms: bathrooms, balconies: balconies,
      city: city, locality: locality, address: address,
      latitude: latitude, longitude: longitude, images: images,
      videos: videos, amenities: amenities, sellerId: sellerId,
      sellerName: sellerName, sellerPhone: sellerPhone,
      sellerWhatsApp: sellerWhatsApp,
      isVerified: isVerified ?? this.isVerified,
      isFeatured: isFeatured ?? this.isFeatured,
      isPremium: isPremium ?? this.isPremium,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt, possessionDate: possessionDate,
      reraId: reraId, nearbyPlaces: nearbyPlaces,
    );
  }
}
