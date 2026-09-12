import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/audio_chime_service.dart';

class OrdersManagementView extends StatefulWidget {
  final bool isDevenConsole;
  const OrdersManagementView({super.key, this.isDevenConsole = false});

  @override
  State<OrdersManagementView> createState() => _OrdersManagementViewState();
}

class _OrdersManagementViewState extends State<OrdersManagementView> {
  List<dynamic> _orders = [];
  String _selectedFilter = 'all';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiClient.dio.get('${ApiEndpoints.orders}?status=$_selectedFilter');
      if (res.data != null && res.data['orders'] != null) {
        setState(() {
          _orders = res.data['orders'];
        });
      }
    } catch (_) {
      // Fallback demo orders
      setState(() {
        _orders = [
          {
            'id': 1001,
            'order_number': 'ORD-202609-1001',
            'customer_name': 'Pooja Patel',
            'customer_phone': '+919876543210',
            'total_amount': 224977.92,
            'status': 'reserved',
            'created_at': '1 hour ago',
            'items': [
              {'item_name': 'Pendent Butti Set', 'weight': 11.64, 'metal_type': 'gold'},
            ],
          },
          {
            'id': 1002,
            'order_number': 'ORD-202609-1002',
            'customer_name': 'Rajesh Soni',
            'customer_phone': '+919427080359',
            'total_amount': 3920.40,
            'status': 'confirmed',
            'created_at': 'Yesterday',
            'items': [
              {'item_name': '925 Silver Folding Ring', 'weight': 5.40, 'metal_type': 'silver_925'},
            ],
          },
        ];
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateOrderStatus(int orderId, String action) async {
    try {
      await ApiClient.dio.patch(
        ApiEndpoints.orders,
        data: {'order_id': orderId, 'action': action},
      );
      AudioChimeService.playOrderChime();
      _fetchOrders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: action == 'confirm' ? AdminColors.success : AdminColors.error,
            content: Text('? Order #$orderId has been ${action}ed!'),
          ),
        );
      }
    } catch (_) {
      final idx = _orders.indexWhere((o) => o['id'] == orderId);
      if (idx >= 0) {
        setState(() {
          _orders[idx]['status'] = action == 'confirm' ? 'confirmed' : 'cancelled';
        });
      }
      AudioChimeService.playOrderChime();
    }
  }

  void _launchWhatsApp(String phone, String customerName, int orderId) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final msg = Uri.encodeComponent(
      'Namaste $customerName! This is ChandraKala Jewellers, Khedbrahma regarding your jewellery order #$orderId. How may we assist you?',
    );
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$msg');
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    widget.isDevenConsole ? 'Operator Reservation Queue' : 'Customer Orders & Stock Reservations',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AdminColors.textDarkPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '24-Hour Stock Hold Desk � Direct WhatsApp Concierge Verification',
                    style: TextStyle(fontSize: 12, color: AdminColors.textMuted),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AdminColors.primaryGold),
                tooltip: 'Refresh Orders',
                onPressed: _fetchOrders,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filter Chips
          Wrap(
            spacing: 8,
            children: ['all', 'reserved', 'confirmed', 'cancelled'].map((f) {
              final isSel = _selectedFilter == f;
              return ChoiceChip(
                label: Text(f.toUpperCase(), style: TextStyle(fontSize: 11, color: isSel ? Colors.black : AdminColors.textDarkSecondary)),
                selected: isSel,
                selectedColor: AdminColors.primaryGold,
                backgroundColor: AdminColors.darkSurface,
                side: BorderSide(color: isSel ? AdminColors.primaryGold : AdminColors.darkBorder),
                onSelected: (val) {
                  if (val) {
                    setState(() => _selectedFilter = f);
                    _fetchOrders();
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Orders List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AdminColors.primaryGold))
                : _orders.isEmpty
                    ? const Center(
                        child: Text('No orders in this category', style: TextStyle(color: AdminColors.textMuted)),
                      )
                    : ListView.builder(
                        itemCount: _orders.length,
                        itemBuilder: (context, idx) {
                          final o = _orders[idx];
                          final isReserved = o['status'] == 'reserved';
                          final isConfirmed = o['status'] == 'confirmed';
                          final statusColor = isReserved
                              ? AdminColors.warning
                              : (isConfirmed ? AdminColors.success : AdminColors.error);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AdminColors.darkCard,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isReserved ? AdminColors.primaryGold.withOpacity(0.4) : AdminColors.darkBorder,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          o['order_number'] ?? 'ORD-#${o['id']}',
                                          style: const TextStyle(
                                            color: AdminColors.textDarkPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: statusColor.withOpacity(0.5)),
                                          ),
                                          child: Text(
                                            (o['status'] ?? '').toString().toUpperCase(),
                                            style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '? ${(o['total_amount'] ?? 0).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AdminColors.primaryGold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Customer: ${o['customer_name']} � Phone: ${o['customer_phone'] ?? "Store Walk-in"}',
                                  style: const TextStyle(color: AdminColors.textDarkSecondary, fontSize: 13),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // WhatsApp Concierge Button
                                    OutlinedButton.icon(
                                      onPressed: () => _launchWhatsApp(
                                        o['customer_phone'] ?? '9427080359',
                                        o['customer_name'] ?? 'Customer',
                                        o['id'],
                                      ),
                                      icon: const Icon(Icons.chat_rounded, color: Color(0xFF25D366), size: 16),
                                      label: const Text('WhatsApp Customer', style: TextStyle(color: Color(0xFF25D366), fontSize: 12)),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFF25D366)),
                                      ),
                                    ),
                                    // Action Buttons
                                    if (isReserved)
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () => _updateOrderStatus(o['id'], 'cancel'),
                                            child: const Text('Cancel & Release', style: TextStyle(color: AdminColors.error, fontSize: 12)),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () => _updateOrderStatus(o['id'], 'confirm'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AdminColors.success,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Confirm Sold', style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                  ],
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
