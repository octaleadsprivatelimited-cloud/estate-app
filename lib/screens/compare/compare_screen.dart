import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/property_provider.dart';
import '../../models/property_model.dart';
import '../../widgets/ek_button.dart';

class CompareScreen extends ConsumerWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareIds = ref.watch(compareListProvider);
    final allProps = ref.watch(propertiesProvider(const PropertyFilters()));

    return Scaffold(
      appBar: AppBar(
        title: Text('Compare (${compareIds.length})'),
        actions: [
          TextButton(
            onPressed: () => ref.read(compareListProvider.notifier).clear(),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: allProps.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (props) {
          final comparing = props.where((p) => compareIds.contains(p.id)).toList();
          if (comparing.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.compare_arrows_rounded, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No properties to compare', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('Tap the compare icon on properties to add them', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  EkButton(label: 'Browse Properties', onPressed: () => context.go('/search')),
                ],
              ),
            );
          }

          final specs = ['Price', 'Type', 'BHK', 'Area', 'City', 'Status', 'Verified', 'Amenities'];

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      _cell('Specs', isHeader: true, width: 100),
                      ...comparing.map((p) => _propertyHeader(p)),
                    ],
                  ),
                  const Divider(),
                  // Spec rows
                  ...specs.map((spec) => Column(
                    children: [
                      Row(
                        children: [
                          _cell(spec, isHeader: true, width: 100),
                          ...comparing.map((p) => _specCell(p, spec)),
                        ],
                      ),
                      const Divider(height: 1),
                    ],
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _propertyHeader(PropertyModel p) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Icon(Icons.home_rounded, color: AppColors.primary, size: 36)),
          ),
          const SizedBox(height: 6),
          Text(p.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
          Text(p.formattedPrice, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _specCell(PropertyModel p, String spec) {
    String value = '';
    switch (spec) {
      case 'Price': value = p.formattedPrice; break;
      case 'Type': value = p.type; break;
      case 'BHK': value = p.bhk != null ? '${p.bhk} BHK' : 'N/A'; break;
      case 'Area': value = '${p.area.toInt()} ${p.areaUnit}'; break;
      case 'City': value = p.city; break;
      case 'Status': value = p.status.replaceAll('_', ' '); break;
      case 'Verified': value = p.isVerified ? '✓ Yes' : '✗ No'; break;
      case 'Amenities': value = '${p.amenities.length} amenities'; break;
    }
    return _cell(value);
  }

  Widget _cell(String text, {bool isHeader = false, double width = 160}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      color: isHeader ? AppColors.primary.withOpacity(0.06) : null,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.w700 : FontWeight.normal,
          fontSize: 12,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
