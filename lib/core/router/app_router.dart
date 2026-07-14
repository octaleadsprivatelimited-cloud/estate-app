import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/shell/main_shell.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/property/property_detail_screen.dart';
import '../../screens/wishlist/wishlist_screen.dart';
import '../../screens/chat/chat_list_screen.dart';
import '../../screens/chat/chat_room_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/dashboard/buyer_dashboard_screen.dart';
import '../../screens/dashboard/seller_dashboard_screen.dart';
import '../../screens/dashboard/admin_dashboard_screen.dart';
import '../../screens/blogs/blogs_screen.dart';
import '../../screens/blogs/blog_detail_screen.dart';
import '../../screens/compare/compare_screen.dart';
import '../../screens/subscription/subscription_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation.startsWith('/onboarding') ||
          state.matchedLocation.startsWith('/splash');

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && (state.matchedLocation == '/login' ||
          state.matchedLocation == '/register')) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

      // Main shell with bottom nav
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/search', builder: (context, state) {
            final query = state.uri.queryParameters['q'] ?? '';
            return SearchScreen(initialQuery: query);
          }),
          GoRoute(path: '/wishlist', builder: (_, __) => const WishlistScreen()),
          GoRoute(path: '/chat', builder: (_, __) => const ChatListScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),

      // Detail screens (no bottom nav)
      GoRoute(
        path: '/property/:id',
        builder: (context, state) => PropertyDetailScreen(
          propertyId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/chat/:chatId',
        builder: (context, state) => ChatRoomScreen(
          chatId: state.pathParameters['chatId']!,
          otherUserName: state.uri.queryParameters['name'] ?? 'User',
        ),
      ),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/compare', builder: (_, __) => const CompareScreen()),
      GoRoute(path: '/blogs', builder: (_, __) => const BlogsScreen()),
      GoRoute(
        path: '/blog/:id',
        builder: (context, state) => BlogDetailScreen(
          blogId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(path: '/buyer-dashboard', builder: (_, __) => const BuyerDashboardScreen()),
      GoRoute(path: '/seller-dashboard', builder: (_, __) => const SellerDashboardScreen()),
      GoRoute(path: '/admin-dashboard', builder: (_, __) => const AdminDashboardScreen()),
      GoRoute(path: '/subscription', builder: (_, __) => const SubscriptionScreen()),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});
