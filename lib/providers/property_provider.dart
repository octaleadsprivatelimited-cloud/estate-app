import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property_model.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/demo_data.dart';
import 'auth_provider.dart';

// Search filters state
class PropertyFilters {
  final String? purpose;
  final String? type;
  final String? city;
  final double? minPrice;
  final double? maxPrice;
  final int? bhk;
  final String? status;
  final String sortBy;

  const PropertyFilters({
    this.purpose,
    this.type,
    this.city,
    this.minPrice,
    this.maxPrice,
    this.bhk,
    this.status,
    this.sortBy = 'createdAt',
  });

  PropertyFilters copyWith({
    String? purpose, String? type, String? city,
    double? minPrice, double? maxPrice, int? bhk,
    String? status, String? sortBy,
  }) {
    return PropertyFilters(
      purpose: purpose ?? this.purpose,
      type: type ?? this.type,
      city: city ?? this.city,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      bhk: bhk ?? this.bhk,
      status: status ?? this.status,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  PropertyFilters clear() => const PropertyFilters();
}

final propertyFiltersProvider =
    StateProvider<PropertyFilters>((ref) => const PropertyFilters());

// Featured properties
final featuredPropertiesProvider = StreamProvider<List<PropertyModel>>((ref) {
  final isDemo = ref.watch(isDemoModeProvider);
  if (isDemo) {
    return Stream.value(DemoData.properties.where((p) => p.isFeatured).toList());
  }

  return FirebaseFirestore.instance
      .collection(AppConstants.colProperties)
      .where('isFeatured', isEqualTo: true)
      .limit(10)
      .snapshots()
      .map((snap) => snap.docs
          .map((d) => PropertyModel.fromMap(d.data(), d.id))
          .toList());
});

// All properties with filters
final propertiesProvider =
    StreamProvider.family<List<PropertyModel>, PropertyFilters>((ref, filters) {
  final isDemo = ref.watch(isDemoModeProvider);
  if (isDemo) {
    var props = DemoData.properties;
    if (filters.purpose != null) props = props.where((p) => p.purpose == filters.purpose).toList();
    if (filters.type != null) props = props.where((p) => p.type == filters.type).toList();
    return Stream.value(props);
  }

  Query query = FirebaseFirestore.instance
      .collection(AppConstants.colProperties);

  if (filters.purpose != null) {
    query = query.where('purpose', isEqualTo: filters.purpose);
  }
  if (filters.type != null) {
    query = query.where('type', isEqualTo: filters.type);
  }
  if (filters.city != null) {
    query = query.where('city', isEqualTo: filters.city);
  }
  if (filters.bhk != null) {
    query = query.where('bhk', isEqualTo: filters.bhk);
  }
  if (filters.status != null) {
    query = query.where('status', isEqualTo: filters.status);
  }

  query = query.orderBy(filters.sortBy, descending: true).limit(AppConstants.pageSize);

  return query.snapshots().map((snap) => snap.docs
      .map((d) => PropertyModel.fromMap(d.data() as Map<String, dynamic>, d.id))
      .toList());
});

// Single property
final propertyByIdProvider =
    StreamProvider.family<PropertyModel?, String>((ref, id) {
  final isDemo = ref.watch(isDemoModeProvider);
  if (isDemo) {
    return Stream.value(DemoData.properties.firstWhere((p) => p.id == id, orElse: () => DemoData.properties.first));
  }

  return FirebaseFirestore.instance
      .collection(AppConstants.colProperties)
      .doc(id)
      .snapshots()
      .map((doc) => doc.exists
          ? PropertyModel.fromMap(doc.data()!, doc.id)
          : null);
});

// Seller's own listings
final sellerPropertiesProvider =
    StreamProvider.family<List<PropertyModel>, String>((ref, sellerId) {
  final isDemo = ref.watch(isDemoModeProvider);
  if (isDemo) {
    return Stream.value(DemoData.properties.where((p) => p.sellerId == 'seller_1').toList());
  }

  return FirebaseFirestore.instance
      .collection(AppConstants.colProperties)
      .where('sellerId', isEqualTo: sellerId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs
          .map((d) => PropertyModel.fromMap(d.data(), d.id))
          .toList());
});

// Compare list state (up to 3)
final compareListProvider =
    StateNotifierProvider<CompareNotifier, List<String>>(
  (ref) => CompareNotifier(),
);

class CompareNotifier extends StateNotifier<List<String>> {
  CompareNotifier() : super([]);

  void toggle(String propertyId) {
    if (state.contains(propertyId)) {
      state = state.where((id) => id != propertyId).toList();
    } else if (state.length < 3) {
      state = [...state, propertyId];
    }
  }

  void clear() => state = [];
}
