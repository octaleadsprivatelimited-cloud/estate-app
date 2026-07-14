import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../property/property_card.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final allProperties = ref.watch(propertiesProvider(const PropertyFilters()));

    final wishlisted = allProperties.whenData(
      (props) => props.where((p) => user?.wishlist.contains(p.id) ?? false).toList(),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Saved (${user?.wishlist.length ?? 0})')),
      body: wishlisted.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (props) => props.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_outline, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    const Text('No saved properties', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const Text('Tap the heart icon on any property to save it', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: props.length,
                itemBuilder: (ctx, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PropertyCard(property: props[i], horizontal: true),
                ),
              ),
      ),
    );
  }
}
