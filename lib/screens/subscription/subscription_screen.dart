import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/ek_button.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  String _selectedPlan = 'pro';
  bool _loading = false;

  final _plans = [
    _PlanData(
      id: 'basic',
      name: 'Basic',
      price: 0,
      priceStr: 'Free',
      color: Colors.grey,
      features: ['3 active listings', 'Standard visibility', 'Basic analytics', 'Email support'],
      notIncluded: ['Featured listings', 'Priority support', 'Verified badge'],
    ),
    _PlanData(
      id: 'pro',
      name: 'Pro',
      price: 1999,
      priceStr: '₹1,999/mo',
      color: AppColors.primary,
      badge: 'Most Popular',
      features: ['25 active listings', 'Featured placement', 'Advanced analytics', 'Priority support', 'Verified seller badge', 'Lead management'],
      notIncluded: ['Dedicated account manager'],
    ),
    _PlanData(
      id: 'enterprise',
      name: 'Enterprise',
      price: 4999,
      priceStr: '₹4,999/mo',
      color: const Color(0xFF8B5CF6),
      badge: 'Best Value',
      features: ['100 active listings', 'Premium placement', 'Full analytics', '24/7 support', 'Verified badge', 'CRM', 'Account manager', 'Custom branding'],
      notIncluded: [],
    ),
  ];

  Future<void> _subscribe(_PlanData plan) async {
    if (plan.price == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You are already on the Free plan!')));
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _loading = false);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Payment Demo'),
          content: Text('Integrate Razorpay with your key to collect ₹${plan.price}.\n\nAdd razorpay_flutter to pubspec.yaml and your Razorpay Key ID.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Got it'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription Plans')),
      body: Column(
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, Color(0xFF1557D0)],
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text('Upgrade Your Account', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text('Get more listings, leads & visibility', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),

          // Plan cards + button
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ..._plans.asMap().entries.map((entry) {
                  final plan = entry.value;
                  final isSelected = _selectedPlan == plan.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPlan = plan.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? plan.color : Colors.transparent, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected ? plan.color.withOpacity(0.15) : Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: plan.color.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(Icons.star_rounded, color: plan.color, size: 18),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(plan.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: plan.color)),
                                      if (plan.badge != null) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(color: plan.color, borderRadius: BorderRadius.circular(10)),
                                          child: Text(plan.badge!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(plan.priceStr, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: plan.color)),
                                ],
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? plan.color : Colors.transparent,
                                  border: Border.all(color: isSelected ? plan.color : Colors.grey, width: 2),
                                ),
                                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(height: 1),
                          const SizedBox(height: 12),
                          ...plan.features.map((f) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(children: [
                                  Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                                  const SizedBox(width: 8),
                                  Text(f, style: const TextStyle(fontSize: 13)),
                                ]),
                              )),
                          ...plan.notIncluded.map((f) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(children: [
                                  const Icon(Icons.cancel_rounded, size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(f, style: const TextStyle(fontSize: 13, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                                ]),
                              )),
                        ],
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: entry.key * 100)).slideY(begin: 0.1),
                  );
                }),
                // Subscribe button (typed as Widget so it fits the list)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 20),
                  child: EkButton(
                    label: _selectedPlan == 'basic'
                        ? 'Current Plan (Free)'
                        : 'Subscribe to ${_plans.firstWhere((p) => p.id == _selectedPlan).name}',
                    isFullWidth: true,
                    isLoading: _loading,
                    onPressed: () => _subscribe(_plans.firstWhere((p) => p.id == _selectedPlan)),
                  ).animate().fadeIn(delay: 400.ms),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanData {
  final String id, name, priceStr;
  final int price;
  final Color color;
  final String? badge;
  final List<String> features;
  final List<String> notIncluded;

  const _PlanData({
    required this.id,
    required this.name,
    required this.price,
    required this.priceStr,
    required this.color,
    this.badge,
    required this.features,
    required this.notIncluded,
  });
}
