import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/property_provider.dart';
import '../../widgets/ek_button.dart';
import '../property/property_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String initialQuery;
  const SearchScreen({super.key, this.initialQuery = ''});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _searchCtrl;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(propertyFiltersProvider);
    final properties = ref.watch(propertiesProvider(filters));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchCtrl,
          autofocus: widget.initialQuery.isEmpty,
          decoration: const InputDecoration(
            hintText: 'Search city, locality...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (v) => _applySearch(),
        ),
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.tune_rounded),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips row
          if (_showFilters) _buildFilters(filters),

          // Sort bar
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                properties.when(
                  data: (p) => Text('${p.length} results', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                  loading: () => const Text('Searching...', style: TextStyle(fontSize: 13)),
                  error: (_, __) => const Text('0 results', style: TextStyle(fontSize: 13)),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.sort_rounded, size: 16),
                  label: const Text('Sort', style: TextStyle(fontSize: 13)),
                  onPressed: _showSortSheet,
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Results
          Expanded(
            child: properties.when(
              data: (props) => props.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          const Text('No properties found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          const Text('Try adjusting your filters', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 16),
                          EkButton(
                            label: 'Clear Filters',
                            onPressed: () => ref.read(propertyFiltersProvider.notifier).state = const PropertyFilters(),
                            isOutlined: true,
                          ),
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
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(PropertyFilters filters) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Purpose
          const Text('Purpose', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Buy', 'Rent', 'PG/Co-living'].map((p) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: EkChip(
                  label: p,
                  isSelected: filters.purpose == p,
                  onTap: () => ref.read(propertyFiltersProvider.notifier).state =
                      filters.copyWith(purpose: filters.purpose == p ? null : p),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Type
          const Text('Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Apartment', 'Villa', 'Plot', 'Commercial', 'Office'].map((t) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: EkChip(
                  label: t,
                  isSelected: filters.type == t,
                  onTap: () => ref.read(propertyFiltersProvider.notifier).state =
                      filters.copyWith(type: filters.type == t ? null : t),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
          EkButton(
            label: 'Clear All',
            onPressed: () => ref.read(propertyFiltersProvider.notifier).state = const PropertyFilters(),
            isOutlined: true,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  void _applySearch() {
    // Could implement text-based search here
  }

  void _showSortSheet() {
    final filters = ref.read(propertyFiltersProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort By', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...['createdAt', 'price', 'rating'].map((s) {
              final labels = {'createdAt': 'Newest First', 'price': 'Price (Low to High)', 'rating': 'Top Rated'};
              return ListTile(
                title: Text(labels[s]!),
                trailing: filters.sortBy == s ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  ref.read(propertyFiltersProvider.notifier).state = filters.copyWith(sortBy: s);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
