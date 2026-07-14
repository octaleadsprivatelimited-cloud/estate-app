import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/property_provider.dart';

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  final _routes = ['/home', '/search', '/wishlist', '/chat', '/profile'];

  final _items = [
    {'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.search_outlined, 'activeIcon': Icons.search_rounded, 'label': 'Search'},
    {'icon': Icons.favorite_outline, 'activeIcon': Icons.favorite_rounded, 'label': 'Saved'},
    {'icon': Icons.chat_bubble_outline, 'activeIcon': Icons.chat_bubble_rounded, 'label': 'Chat'},
    {'icon': Icons.person_outline, 'activeIcon': Icons.person_rounded, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    final compareCount = ref.watch(compareListProvider).length;

    return Scaffold(
      body: widget.child,
      floatingActionButton: compareCount > 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/compare'),
              backgroundColor: AppColors.secondary,
              icon: const Icon(Icons.compare_arrows_rounded, color: Colors.white),
              label: Text(
                'Compare ($compareCount)',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          setState(() => _currentIndex = i);
          context.go(_routes[i]);
        },
        destinations: _items.map((item) {
          return NavigationDestination(
            icon: Icon(item['icon'] as IconData),
            selectedIcon: Icon(item['activeIcon'] as IconData, color: AppColors.primary),
            label: item['label'] as String,
          );
        }).toList(),
      ),
    );
  }
}
