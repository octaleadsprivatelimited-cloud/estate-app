import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/property_provider.dart';
import '../../widgets/ek_button.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats
          Row(
            children: [
              _statCard('Properties', '248', Icons.home_rounded, AppColors.primary),
              const SizedBox(width: 10),
              _statCard('Users', '1.2K', Icons.people_rounded, AppColors.success),
              const SizedBox(width: 10),
              _statCard('Pending', '12', Icons.pending_actions_rounded, AppColors.warning),
            ],
          ),
          const SizedBox(height: 20),

          // Pending approvals
          const Text('Pending Approvals', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('properties')
                .where('isVerified', isEqualTo: false)
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No pending approvals')));
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (ctx, i) {
                  final data = docs[i].data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(data['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${data['city']} • ${data['sellerName']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle_rounded, color: AppColors.success),
                            onPressed: () => FirebaseFirestore.instance
                                .collection('properties')
                                .doc(docs[i].id)
                                .update({'isVerified': true}),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel_rounded, color: AppColors.error),
                            onPressed: () => FirebaseFirestore.instance
                                .collection('properties')
                                .doc(docs[i].id)
                                .delete(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 20),
          const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5,
            children: [
              _actionTile(Icons.people_rounded, 'Manage Users', AppColors.primary),
              _actionTile(Icons.article_rounded, 'Manage Blogs', AppColors.success),
              _actionTile(Icons.discount_rounded, 'Coupons', AppColors.secondary),
              _actionTile(Icons.settings_rounded, 'Settings', Colors.grey),
            ],
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

  Widget _actionTile(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 13)),
        ],
      ),
    );
  }
}
