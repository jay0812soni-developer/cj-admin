import 'package:flutter/material.dart';
import '../../../core/constants/app_roles.dart';
import '../../../core/widgets/admin_scaffold.dart';
import '../../rates/views/rates_management_view.dart';
import '../../inventory/views/inventory_management_view.dart';
import '../../orders/views/orders_management_view.dart';
import '../../reviews/views/reviews_moderation_view.dart';

class AdminDashboardView extends StatefulWidget {
  final String displayName;
  const AdminDashboardView({super.key, required this.displayName});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      RatesManagementView(),
      InventoryManagementView(),
      OrdersManagementView(),
      ReviewsModerationView(),
    ];

    return AdminScaffold(
      role: AdminRoles.admin,
      displayName: widget.displayName,
      selectedIndex: _currentIndex,
      onTabSelected: (idx) => setState(() => _currentIndex = idx),
      destinations: const [
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
      ],
      body: tabs[_currentIndex],
    );
  }
}
