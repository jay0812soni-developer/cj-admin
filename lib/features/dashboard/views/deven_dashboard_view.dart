import 'package:flutter/material.dart';
import '../../../core/constants/app_roles.dart';
import '../../../core/widgets/admin_scaffold.dart';
import '../../orders/views/orders_management_view.dart';
import '../../rates/views/rates_management_view.dart';
import '../../inventory/views/inventory_management_view.dart';

class DevenDashboardView extends StatefulWidget {
  final String displayName;
  const DevenDashboardView({super.key, required this.displayName});

  @override
  State<DevenDashboardView> createState() => _DevenDashboardViewState();
}

class _DevenDashboardViewState extends State<DevenDashboardView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      OrdersManagementView(isDevenConsole: true),
      RatesManagementView(),
      InventoryManagementView(),
    ];

    return AdminScaffold(
      role: AdminRoles.deven,
      displayName: widget.displayName,
      selectedIndex: _currentIndex,
      onTabSelected: (idx) => setState(() => _currentIndex = idx),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          selectedIcon: Icon(Icons.chat_bubble_rounded),
          label: Text('Concierge Orders'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.trending_up_rounded),
          selectedIcon: Icon(Icons.trending_up_rounded),
          label: Text('Live Rates'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.search_rounded),
          selectedIcon: Icon(Icons.saved_search_rounded),
          label: Text('Stock Lookup'),
        ),
      ],
      body: tabs[_currentIndex],
    );
  }
}
