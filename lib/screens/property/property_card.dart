import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../models/property_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';

class PropertyCard extends ConsumerWidget {
  final PropertyModel property;
  final bool horizontal;

  const PropertyCard({
    super.key,
    required this.property,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final isWishlisted = user?.wishlist.contains(property.id) ?? false;
    final isComparing = ref.watch(compareListProvider).contains(property.id);

    if (horizontal) return _buildHorizontal(context, ref, isWishlisted, isComparing);
    return _buildVertical(context, ref, isWishlisted, isComparing);
  }

  Widget _buildVertical(BuildContext context, WidgetRef ref, bool isWishlisted, bool isComparing) {
    return GestureDetector(
      onTap: () => context.push('/property/${property.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: property.images.isNotEmpty ? property.images.first : '',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(height: 160, color: Colors.grey[200]),
                    errorWidget: (_, __, ___) => Container(
                      height: 160,
                      color: AppColors.primary.withOpacity(0.1),
                      child: const Icon(Icons.home_rounded, size: 48, color: AppColors.primary),
                    ),
                  ),
                  // Badges
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Row(
                      children: [
                        if (property.isFeatured) _badge('Featured', AppColors.secondary),
                        if (property.isVerified) ...[
                          const SizedBox(width: 4),
                          _badge('✓ Verified', AppColors.success),
                        ],
                      ],
                    ),
                  ),
                  // Wishlist
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _iconBtn(
                      isWishlisted ? Icons.favorite_rounded : Icons.favorite_outline,
                      isWishlisted ? Colors.red : Colors.white,
                      () => _toggleWishlist(ref),
                    ),
                  ),
                  // Compare
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: _iconBtn(
                      Icons.compare_arrows_rounded,
                      isComparing ? AppColors.secondary : Colors.white,
                      () => ref.read(compareListProvider.notifier).toggle(property.id),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.formattedPrice,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.grey),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          '${property.locality}, ${property.city}',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (property.bhk != null) _spec('${property.bhk} BHK'),
                      if (property.bhk != null) const SizedBox(width: 6),
                      _spec('${property.area.toInt()} ${property.areaUnit}'),
                      if (property.bathrooms != null) ...[
                        const SizedBox(width: 6),
                        _spec('${property.bathrooms} Bath'),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context, WidgetRef ref, bool isWishlisted, bool isComparing) {
    return GestureDetector(
      onTap: () => context.push('/property/${property.id}'),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: property.images.isNotEmpty ? property.images.first : '',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(width: 90, height: 90, color: Colors.grey[200]),
                errorWidget: (_, __, ___) => Container(
                  width: 90,
                  height: 90,
                  color: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.home_rounded, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.formattedPrice,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    property.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${property.locality}, ${property.city}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (property.bhk != null) _spec('${property.bhk} BHK'),
                      if (property.bhk != null) const SizedBox(width: 6),
                      _spec('${property.area.toInt()} ${property.areaUnit}'),
                      if (property.isVerified) ...[
                        const SizedBox(width: 6),
                        _badge('✓', AppColors.success, small: true),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _iconBtn(
                  isWishlisted ? Icons.favorite_rounded : Icons.favorite_outline,
                  isWishlisted ? Colors.red : Colors.grey,
                  () => _toggleWishlist(ref),
                  small: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color color, {bool small = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 6 : 8, vertical: small ? 2 : 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: small ? 9 : 10, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap, {bool small = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(small ? 4 : 6),
        decoration: BoxDecoration(
          color: small ? Colors.transparent : Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: small ? 18 : 20),
      ),
    );
  }

  Widget _spec(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _toggleWishlist(WidgetRef ref) {
    // Handled in auth provider
  }
}
