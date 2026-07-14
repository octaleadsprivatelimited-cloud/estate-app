import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/property_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/ek_button.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  ConsumerState<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentImage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final propertyAsync = ref.watch(propertyByIdProvider(widget.propertyId));
    final user = ref.watch(currentUserProvider).valueOrNull;

    return propertyAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (property) {
        if (property == null) {
          return const Scaffold(body: Center(child: Text('Property not found')));
        }

        final isWishlisted = user?.wishlist.contains(property.id) ?? false;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Image gallery app bar
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    onPressed: () => Share.share(
                      'Check out this property: ${property.title}\n${property.formattedPrice}\n${property.address}',
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isWishlisted ? Icons.favorite_rounded : Icons.favorite_outline,
                      color: isWishlisted ? Colors.red : Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      PageView.builder(
                        itemCount: property.images.isEmpty ? 1 : property.images.length,
                        onPageChanged: (i) => setState(() => _currentImage = i),
                        itemBuilder: (_, i) => property.images.isEmpty
                            ? Container(
                                color: AppColors.primary.withOpacity(0.1),
                                child: const Icon(Icons.home_rounded, size: 80, color: AppColors.primary),
                              )
                            : CachedNetworkImage(
                                imageUrl: property.images[i],
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(color: Colors.grey[200]),
                                errorWidget: (_, __, ___) => Container(
                                  color: AppColors.primary.withOpacity(0.1),
                                  child: const Icon(Icons.home_rounded, size: 80, color: AppColors.primary),
                                ),
                              ),
                      ),
                      // Image counter
                      if (property.images.length > 1)
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_currentImage + 1}/${property.images.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      // Badges
                      Positioned(
                        top: 16,
                        left: 60,
                        child: Row(
                          children: [
                            if (property.isFeatured) _badge('Featured', AppColors.secondary),
                            if (property.isVerified) ...[
                              const SizedBox(width: 4),
                              _badge('✓ Verified', AppColors.success),
                            ],
                            if (property.isPremium) ...[
                              const SizedBox(width: 4),
                              _badge('⭐ Premium', AppColors.accent),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Price & title
                          Text(
                            property.formattedPrice,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(property.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  property.address,
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Key specs
                          Row(
                            children: [
                              if (property.bhk != null) _specTile(Icons.king_bed_rounded, '${property.bhk} BHK'),
                              if (property.bathrooms != null) _specTile(Icons.bathtub_rounded, '${property.bathrooms} Bath'),
                              _specTile(Icons.straighten_rounded, '${property.area.toInt()} ${property.areaUnit}'),
                              if (property.floor != null) _specTile(Icons.layers_rounded, 'Floor ${property.floor}'),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Rating
                          if (property.reviewCount > 0)
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: property.rating,
                                  itemSize: 16,
                                  itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: AppColors.warning),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${property.rating.toStringAsFixed(1)} (${property.reviewCount} reviews)',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // Tabs
                    TabBar(
                      controller: _tabController,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      tabs: const [
                        Tab(text: 'Details'),
                        Tab(text: 'Amenities'),
                        Tab(text: 'Location'),
                        Tab(text: 'Reviews'),
                      ],
                    ),
                    SizedBox(
                      height: 320,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Details tab
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Description', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                const SizedBox(height: 8),
                                Text(property.description, style: const TextStyle(height: 1.6, fontSize: 14)),
                                const SizedBox(height: 16),
                                if (property.reraId != null) _infoRow('RERA ID', property.reraId!),
                                if (property.possessionDate != null) _infoRow('Possession', property.possessionDate!),
                                _infoRow('Status', property.status.replaceAll('_', ' ').toUpperCase()),
                                _infoRow('Type', property.type),
                                _infoRow('Purpose', property.purpose),
                              ],
                            ),
                          ),

                          // Amenities tab
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: property.amenities.map((a) => Chip(
                                label: Text(a, style: const TextStyle(fontSize: 12)),
                                avatar: const Icon(Icons.check_circle_outline, size: 14, color: AppColors.success),
                              )).toList(),
                            ),
                          ),

                          // Location tab
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Location', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                const SizedBox(height: 8),
                                Text(property.address, style: const TextStyle(fontSize: 14, height: 1.5)),
                                const SizedBox(height: 16),
                                if (property.latitude != null && property.longitude != null)
                                  EkButton(
                                    label: 'Open in Maps',
                                    icon: Icons.map_rounded,
                                    onPressed: () => _openMaps(property.latitude!, property.longitude!),
                                  ),
                              ],
                            ),
                          ),

                          // Reviews tab
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: Text('No reviews yet')),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // Bottom contact bar
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: EkButton(
                    label: 'Call Seller',
                    icon: Icons.phone_rounded,
                    onPressed: () => launchUrl(Uri.parse('tel:${property.sellerPhone}')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: EkButton(
                    label: 'WhatsApp',
                    icon: Icons.chat_rounded,
                    color: const Color(0xFF25D366),
                    onPressed: () => launchUrl(Uri.parse(
                      'https://wa.me/${(property.sellerWhatsApp ?? property.sellerPhone).replaceAll('+', '').replaceAll(' ', '')}?text=Hi, I am interested in ${property.title}',
                    )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _badge(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
      );

  Widget _specTile(IconData icon, String label) => Expanded(
        child: Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
        ),
      );

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
            Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
          ],
        ),
      );

  Future<void> _openMaps(double lat, double lng) async {
    final uri = Uri.parse('https://maps.google.com/?q=$lat,$lng');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
