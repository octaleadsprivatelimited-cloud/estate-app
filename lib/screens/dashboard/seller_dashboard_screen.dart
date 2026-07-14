import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../../widgets/ek_button.dart';
import '../property/property_card.dart';

class SellerDashboardScreen extends ConsumerWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final myListings = user != null
        ? ref.watch(sellerPropertiesProvider(user.uid))
        : const AsyncValue.data(<dynamic>[]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () => _showAddListingSheet(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats row
          Row(
            children: [
              _statCard('My Listings', myListings.whenData((p) => '${(p as List).length}').valueOrNull ?? '0', Icons.home_rounded, AppColors.primary),
              const SizedBox(width: 10),
              _statCard('Total Views', '1.2K', Icons.visibility_rounded, AppColors.success),
              const SizedBox(width: 10),
              _statCard('Leads', '24', Icons.people_rounded, AppColors.secondary),
            ],
          ),
          const SizedBox(height: 20),

          // Chart placeholder
          Container(
            height: 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Views This Week', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 12),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      barGroups: List.generate(7, (i) {
                        final values = [45, 78, 56, 90, 120, 88, 100];
                        return BarChartGroupData(
                          x: i,
                          barRods: [BarChartRodData(toY: values[i].toDouble(), color: AppColors.primary, width: 16, borderRadius: BorderRadius.circular(4))],
                        );
                      }),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) => Text(
                              ['M', 'T', 'W', 'T', 'F', 'S', 'S'][v.toInt()],
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // My listings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Listings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              EkButton(
                label: '+ Add',
                onPressed: () => _showAddListingSheet(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          myListings.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (props) => props.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(Icons.home_work_outlined, size: 48, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('No listings yet', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          Text('Add your first property', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (props as List).length,
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PropertyCard(property: props[i], horizontal: true),
                    ),
                  ),
          ),
          const SizedBox(height: 20),

          // Subscription
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF1557D0)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Upgrade to Pro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('Get featured listings & 25 slots', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                EkButton(
                  label: 'Upgrade',
                  color: Colors.white,
                  onPressed: () => context.push('/subscription'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
            Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _showAddListingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New Listing', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              const Center(child: Text('Listing form coming soon...\nConnect Firebase to enable full CRUD.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
            ],
          ),
        ),
      ),
    );
  }
}
