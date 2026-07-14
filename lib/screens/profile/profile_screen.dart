import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/ek_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final themeMode = ref.watch(themeModeProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          // Profile header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, Color(0xFF1557D0)],
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                  child: user.photoUrl == null
                      ? Text(
                          user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : 'U',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(user.displayName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(user.email, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.role.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),

          // Dashboard shortcuts
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Activity', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _statCard(context, user.wishlist.length.toString(), 'Saved', Icons.favorite_rounded, Colors.red),
                    const SizedBox(width: 10),
                    _statCard(context, user.recentlyViewed.length.toString(), 'Viewed', Icons.history_rounded, AppColors.primary),
                    const SizedBox(width: 10),
                    _statCard(context, user.compareList.length.toString(), 'Compare', Icons.compare_arrows_rounded, AppColors.secondary),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          _sectionTitle('Account'),
          _menuTile(Icons.dashboard_rounded, 'My Dashboard', () {
            if (user.isAdmin) context.push('/admin-dashboard');
            else if (user.isSeller) context.push('/seller-dashboard');
            else context.push('/buyer-dashboard');
          }),
          _menuTile(Icons.favorite_outline, 'Saved Properties', () => context.go('/wishlist')),
          _menuTile(Icons.notifications_outlined, 'Notifications', () => context.push('/notifications')),
          _menuTile(Icons.workspace_premium_rounded, 'Subscription Plans', () => context.push('/subscription')),

          _sectionTitle('Settings'),
          ListTile(
            leading: const Icon(Icons.dark_mode_rounded),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (v) => ref.read(themeModeProvider.notifier).toggle(),
              activeThumbColor: AppColors.primary,
            ),
          ),
          _menuTile(Icons.article_outlined, 'Blogs & Articles', () => context.push('/blogs')),
          _menuTile(Icons.help_outline_rounded, 'Help & Support', () {}),
          _menuTile(Icons.privacy_tip_outlined, 'Privacy Policy', () {}),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: EkButton(
              label: 'Sign Out',
              isFullWidth: true,
              isOutlined: true,
              color: AppColors.error,
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, String count, String label, IconData icon, Color color) {
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
            Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.grey)),
      );

  Widget _menuTile(IconData icon, String label, VoidCallback onTap) => ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
      );
}
