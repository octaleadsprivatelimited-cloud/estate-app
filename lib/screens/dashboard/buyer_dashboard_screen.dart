import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../property/property_card.dart';

class BuyerDashboardScreen extends ConsumerWidget {
  const BuyerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final allProperties = ref.watch(propertiesProvider(const PropertyFilters()));

    final wishlistedProps = allProperties.whenData(
      (props) => props.where((p) => user?.wishlist.contains(p.id) ?? false).toList(),
    );
    final recentProps = allProperties.whenData(
      (props) => props.where((p) => user?.recentlyViewed.contains(p.id) ?? false).toList(),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Welcome, ${user?.displayName.split(' ').first ?? ''}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats
          Row(
            children: [
              _statCard('Saved', '${user?.wishlist.length ?? 0}', Icons.favorite_rounded, Colors.red),
              const SizedBox(width: 10),
              _statCard('Viewed', '${user?.recentlyViewed.length ?? 0}', Icons.history_rounded, AppColors.primary),
              const SizedBox(width: 10),
              _statCard('Inquiries', '3', Icons.mail_rounded, AppColors.secondary),
            ],
          ),
          const SizedBox(height: 20),

          // Saved Properties
          _sectionHeader('Saved Properties', () => context.go('/wishlist')),
          const SizedBox(height: 10),
          wishlistedProps.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
            data: (props) => props.isEmpty
                ? _emptyState(Icons.favorite_outline, 'No saved properties yet')
                : SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: props.length,
                      itemBuilder: (ctx, i) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(width: 220, child: PropertyCard(property: props[i])),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 20),

          // Recently Viewed
          _sectionHeader('Recently Viewed', () {}),
          const SizedBox(height: 10),
          recentProps.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
            data: (props) => props.isEmpty
                ? _emptyState(Icons.history_rounded, 'No properties viewed yet')
                : Column(
                    children: props.take(3).map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PropertyCard(property: p, horizontal: true),
                    )).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, VoidCallback onSeeAll) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          TextButton(onPressed: onSeeAll, child: const Text('See All')),
        ],
      );

  Widget _emptyState(IconData icon, String msg) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.grey[300]),
              const SizedBox(height: 8),
              Text(msg, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
      );
}
