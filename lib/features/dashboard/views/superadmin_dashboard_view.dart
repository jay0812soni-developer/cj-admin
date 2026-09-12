import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_roles.dart';
import '../../../core/widgets/admin_scaffold.dart';
import '../../rates/views/rates_management_view.dart';
import '../../inventory/views/inventory_management_view.dart';
import '../../orders/views/orders_management_view.dart';
import '../../reviews/views/reviews_moderation_view.dart';
import '../../notifications/views/push_broadcaster_view.dart';

class SuperadminDashboardView extends StatefulWidget {
  final String displayName;
  const SuperadminDashboardView({super.key, required this.displayName});

  @override
  State<SuperadminDashboardView> createState() => _SuperadminDashboardViewState();
}

class _SuperadminDashboardViewState extends State<SuperadminDashboardView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildOverviewTab(),
      const RatesManagementView(),
      const InventoryManagementView(),
      const OrdersManagementView(),
      const ReviewsModerationView(),
      const PushBroadcasterView(),
      _buildTeamTab(),
    ];

    return AdminScaffold(
      role: AdminRoles.superadmin,
      displayName: widget.displayName,
      selectedIndex: _currentIndex,
      onTabSelected: (idx) => setState(() => _currentIndex = idx),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: Text('Overview'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.trending_up_rounded),
          selectedIcon: Icon(Icons.trending_up_rounded),
          label: Text('Bullion Rates'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.diamond_outlined),
          selectedIcon: Icon(Icons.diamond_rounded),
          label: Text('Inventory'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag_rounded),
          label: Text('Orders'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.rate_review_outlined),
          selectedIcon: Icon(Icons.rate_review_rounded),
          label: Text('Reviews'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.campaign_outlined),
          selectedIcon: Icon(Icons.campaign_rounded),
          label: Text('Broadcast'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.badge_outlined),
          selectedIcon: Icon(Icons.badge_rounded),
          label: Text('Team'),
        ),
      ],
      body: tabs[_currentIndex],
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Executive Command Center',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AdminColors.textDarkPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ChandraKala Jewellers Store & Digital Platform Real-time Metrics',
                    style: TextStyle(fontSize: 12, color: AdminColors.textMuted),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AdminColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AdminColors.success.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, color: AdminColors.success, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'SYSTEM OPERATIONAL',
                      style: TextStyle(color: AdminColors.success, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stat Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 700;
              final width = isWide ? (constraints.maxWidth - 32) / 3 : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildStatCard(
                    title: 'Active Stock Holds',
                    value: '4 Reservations',
                    subtitle: '? 4,82,500 locked in 24h holds',
                    icon: Icons.access_time_filled_rounded,
                    color: AdminColors.warning,
                    width: width,
                  ),
                  _buildStatCard(
                    title: 'Confirmed Orders',
                    value: '28 Orders',
                    subtitle: 'Completed store sales',
                    icon: Icons.verified_rounded,
                    color: AdminColors.success,
                    width: width,
                  ),
                  _buildStatCard(
                    title: 'Registered Pieces',
                    value: '48 Designs',
                    subtitle: '32 Gold � 16 Silver pieces',
                    icon: Icons.diamond_rounded,
                    color: AdminColors.primaryGold,
                    width: width,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),

          // Bullion Rates Quick Action Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AdminColors.darkCard, AdminColors.darkSurface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AdminColors.primaryGold.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Gold 22K 916 Hallmark Rate: ? 8,550.00 / gram',
                      style: TextStyle(color: AdminColors.primaryGold, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Silver: ? 98.50/g � 925 Silver: ? 110.00/g � Making: 14% � GST: 3%',
                      style: TextStyle(color: AdminColors.textDarkSecondary, fontSize: 12),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => setState(() => _currentIndex = 1),
                  child: const Text('Adjust Rates'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Recent Activity Log
          const Text(
            'Recent Audit Log & Platform Events',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AdminColors.textDarkPrimary),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AdminColors.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AdminColors.darkBorder),
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ListTile(
                  leading: Icon(Icons.bolt_rounded, color: AdminColors.primaryGold),
                  title: Text('Bullion rates updated: Gold ?8,550/g, Silver ?98.5/g', style: TextStyle(color: AdminColors.textDarkPrimary, fontSize: 13)),
                  trailing: Text('15m ago', style: TextStyle(color: AdminColors.textMuted, fontSize: 11)),
                ),
                Divider(height: 1, color: AdminColors.darkBorder),
                ListTile(
                  leading: Icon(Icons.shopping_bag_rounded, color: AdminColors.warning),
                  title: Text('Reservation #1001 for Pendent Butti Set (Pooja Patel)', style: TextStyle(color: AdminColors.textDarkPrimary, fontSize: 13)),
                  trailing: Text('1h ago', style: TextStyle(color: AdminColors.textMuted, fontSize: 11)),
                ),
                Divider(height: 1, color: AdminColors.darkBorder),
                ListTile(
                  leading: Icon(Icons.check_circle_rounded, color: AdminColors.success),
                  title: Text('Order #1002 marked as confirmed (Rajesh Soni)', style: TextStyle(color: AdminColors.textDarkPrimary, fontSize: 13)),
                  trailing: Text('3h ago', style: TextStyle(color: AdminColors.textMuted, fontSize: 11)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AdminColors.darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AdminColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AdminColors.textMuted, fontSize: 12)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AdminColors.textDarkSecondary, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildTeamTab() {
    final members = [
      {'name': 'Soni Jaykumar Hasmukh', 'username': 'superadmin', 'role': 'Super Administrator', 'tag': 'FULL ACCESS'},
      {'name': 'Hasmukh Hiralal Soni', 'username': 'admin', 'role': 'Store Admin', 'tag': 'STORE & RATES'},
      {'name': 'Deven Hasmukhbhai Soni', 'username': 'deven', 'role': 'Store Concierge', 'tag': 'OPERATOR & ORDERS'},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Authorized Family Admin Team',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AdminColors.textDarkPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            '3 Distinct Roles configured with individual audit logs and security permissions',
            style: TextStyle(fontSize: 12, color: AdminColors.textMuted),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: members.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final m = members[idx];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AdminColors.darkCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AdminColors.darkBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AdminColors.darkSurface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AdminColors.primaryGold),
                        ),
                        child: const Icon(Icons.person_rounded, color: AdminColors.primaryGold),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m['name']!, style: const TextStyle(color: AdminColors.textDarkPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('User: ${m['username']} � ${m['role']}', style: const TextStyle(color: AdminColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AdminColors.primaryGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AdminColors.primaryGold.withOpacity(0.4)),
                        ),
                        child: Text(
                          m['tag']!,
                          style: const TextStyle(color: AdminColors.primaryGold, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
