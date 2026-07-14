// notifications_screen.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _Notif('New inquiry on your listing', 'Rahul is interested in 3 BHK Apartment in Bandra', '2m ago', Icons.person_add_rounded, AppColors.primary),
      _Notif('Price drop alert!', 'A property in your wishlist dropped by ₹5L', '1h ago', Icons.trending_down_rounded, AppColors.success),
      _Notif('Listing approved', 'Your property has been verified by admin', '3h ago', Icons.verified_rounded, AppColors.info),
      _Notif('New message', 'Priya: Is the property still available?', '1d ago', Icons.chat_rounded, AppColors.secondary),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (ctx, i) {
          final n = notifications[i];
          return ListTile(
            leading: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: n.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(n.icon, color: n.color, size: 22),
            ),
            title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            subtitle: Text(n.body, style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: Text(n.time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          );
        },
      ),
    );
  }
}

class _Notif {
  final String title, body, time;
  final IconData icon;
  final Color color;
  const _Notif(this.title, this.body, this.time, this.icon, this.color);
}
