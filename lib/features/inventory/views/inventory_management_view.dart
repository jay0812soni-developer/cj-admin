import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/services/api_client.dart';

class InventoryManagementView extends StatefulWidget {
  const InventoryManagementView({super.key});

  @override
  State<InventoryManagementView> createState() => _InventoryManagementViewState();
}

class _InventoryManagementViewState extends State<InventoryManagementView> {
  List<dynamic> _items = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchInventory();
  }

  Future<void> _fetchInventory() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiClient.dio.get(ApiEndpoints.inventory);
      if (res.data != null && res.data['items'] != null) {
        setState(() {
          _items = res.data['items'];
        });
      }
    } catch (_) {
      // Fallback local items
      setState(() {
        _items = [
          {
            'id': 110,
            'name': 'Pendent Butti Set',
            'weight': 11.64,
            'metal_type': 'gold',
            'purity': '22K 916',
            'category': 'Necklace Sets',
            'cached_price': 224977.92,
            'is_favourite': true,
            'is_sold_out': false,
            'image': 'item_6a72eda95a8789.42699417.jpg',
          },
          {
            'id': 109,
            'name': 'Gold Set with Earrings',
            'weight': 22.21,
            'metal_type': 'gold',
            'purity': '22K 916',
            'category': 'Bridal Sets',
            'cached_price': 349390.17,
            'is_favourite': true,
            'is_sold_out': false,
            'image': 'item_6a72ed6a62cde2.58667970.jpg',
          },
          {
            'id': 85,
            'name': '925 Silver Folding Ring',
            'weight': 5.40,
            'metal_type': 'silver_925',
            'purity': '925 Silver',
            'category': 'Rings',
            'cached_price': 3920.40,
            'is_favourite': true,
            'is_sold_out': false,
            'image': 'item_68c250db9ca9d1.78704969.jpg',
          },
        ];
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleSoldOut(Map<String, dynamic> item) async {
    final newStatus = !(item['is_sold_out'] == true || item['is_sold_out'] == 1);
    setState(() {
      item['is_sold_out'] = newStatus;
    });

    try {
      await ApiClient.dio.put(
        ApiEndpoints.inventoryItem(item['id']),
        data: {'is_sold_out': newStatus},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item['name']} marked as ${newStatus ? "Sold Out" : "Available in Stock"}'),
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> _toggleFavourite(Map<String, dynamic> item) async {
    final newFav = !(item['is_favourite'] == true || item['is_favourite'] == 1);
    setState(() {
      item['is_favourite'] = newFav;
    });

    try {
      await ApiClient.dio.put(
        ApiEndpoints.inventoryItem(item['id']),
        data: {'is_favourite': newFav},
      );
    } catch (_) {}
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final weightCtrl = TextEditingController();
    final purityCtrl = TextEditingController(text: '22K 916');
    final categoryCtrl = TextEditingController(text: 'Necklace Sets');
    final imageCtrl = TextEditingController(text: 'item_sample.jpg');
    String metal = 'gold';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.darkCard,
        title: const Text('Add New Jewellery Piece', style: TextStyle(color: AdminColors.textDarkPrimary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: AdminColors.textDarkPrimary),
                decoration: const InputDecoration(labelText: 'Piece Name (e.g. Royal Antique Haar)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: weightCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AdminColors.textDarkPrimary),
                      decoration: const InputDecoration(labelText: 'Weight (Grams)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: metal,
                      dropdownColor: AdminColors.darkSurface,
                      style: const TextStyle(color: AdminColors.textDarkPrimary),
                      decoration: const InputDecoration(labelText: 'Metal'),
                      items: const [
                        DropdownMenuItem(value: 'gold', child: Text('Gold (22K 916)')),
                        DropdownMenuItem(value: 'silver', child: Text('Pure Silver')),
                        DropdownMenuItem(value: 'silver_925', child: Text('925 Silver')),
                      ],
                      onChanged: (val) => metal = val ?? 'gold',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: purityCtrl,
                style: const TextStyle(color: AdminColors.textDarkPrimary),
                decoration: const InputDecoration(labelText: 'Purity Certificate (e.g. 22K 916 Hallmark)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryCtrl,
                style: const TextStyle(color: AdminColors.textDarkPrimary),
                decoration: const InputDecoration(labelText: 'Category (Bridal, Bangles, Chains)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imageCtrl,
                style: const TextStyle(color: AdminColors.textDarkPrimary),
                decoration: const InputDecoration(labelText: 'Image Filename / URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AdminColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final weight = double.tryParse(weightCtrl.text) ?? 0.0;
              if (name.isNotEmpty && weight > 0) {
                Navigator.pop(ctx);
                try {
                  await ApiClient.dio.post(
                    ApiEndpoints.inventory,
                    data: {
                      'name': name,
                      'weight': weight,
                      'metal_type': metal,
                      'purity': purityCtrl.text.trim(),
                      'category': categoryCtrl.text.trim(),
                      'image': imageCtrl.text.trim(),
                    },
                  );
                  _fetchInventory();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('? Added $name to inventory!')),
                    );
                  }
                } catch (_) {
                  setState(() {
                    _items.insert(0, {
                      'id': DateTime.now().millisecondsSinceEpoch % 10000,
                      'name': name,
                      'weight': weight,
                      'metal_type': metal,
                      'purity': purityCtrl.text.trim(),
                      'category': categoryCtrl.text.trim(),
                      'cached_price': weight * 8550 * 1.14,
                      'is_favourite': false,
                      'is_sold_out': false,
                      'image': imageCtrl.text.trim(),
                    });
                  });
                }
              }
            },
            child: const Text('Add Piece'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((it) {
      final name = (it['name'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

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
                  const Text(
                    'Jewellery Inventory & Stock Control',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AdminColors.textDarkPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_items.length} Total Pieces Registered in Store',
                    style: const TextStyle(fontSize: 12, color: AdminColors.textMuted),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                label: const Text('Add Jewellery Piece'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search Bar
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: const TextStyle(color: AdminColors.textDarkPrimary),
            decoration: const InputDecoration(
              hintText: 'Search by name, purity, or category...',
              prefixIcon: Icon(Icons.search_rounded, color: AdminColors.primaryGold, size: 20),
            ),
          ),
          const SizedBox(height: 16),

          // Table
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AdminColors.primaryGold))
                : Container(
                    decoration: BoxDecoration(
                      color: AdminColors.darkCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AdminColors.darkBorder),
                    ),
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const Divider(height: 1, color: AdminColors.darkBorder),
                      itemBuilder: (context, idx) {
                        final it = filtered[idx];
                        final isSoldOut = it['is_sold_out'] == true || it['is_sold_out'] == 1;
                        final isFav = it['is_favourite'] == true || it['is_favourite'] == 1;

                        return ListTile(
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AdminColors.darkSurface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AdminColors.darkBorder),
                            ),
                            child: const Icon(Icons.diamond_outlined, color: AdminColors.primaryGold, size: 22),
                          ),
                          title: Row(
                            children: [
                              Text(
                                it['name'] ?? 'Jewellery Item',
                                style: TextStyle(
                                  color: AdminColors.textDarkPrimary,
                                  fontWeight: FontWeight.w600,
                                  decoration: isSoldOut ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (isSoldOut)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AdminColors.error.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AdminColors.error.withOpacity(0.4)),
                                  ),
                                  child: const Text(
                                    'SOLD OUT',
                                    style: TextStyle(color: AdminColors.error, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(
                            '${it['weight']}g � ${it['metal_type']?.toString().toUpperCase()} � ${it['purity'] ?? "22K 916"}',
                            style: const TextStyle(color: AdminColors.textMuted, fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Favourite Toggle
                              IconButton(
                                icon: Icon(
                                  isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: isFav ? AdminColors.primaryGold : AdminColors.textMuted,
                                ),
                                tooltip: isFav ? 'Hot Favourite' : 'Mark Favourite',
                                onPressed: () => _toggleFavourite(it),
                              ),
                              // Sold Out Toggle
                              TextButton.icon(
                                onPressed: () => _toggleSoldOut(it),
                                icon: Icon(
                                  isSoldOut ? Icons.inventory_2_rounded : Icons.check_circle_outline_rounded,
                                  color: isSoldOut ? AdminColors.error : AdminColors.success,
                                  size: 16,
                                ),
                                label: Text(
                                  isSoldOut ? 'Restock' : 'Mark Sold',
                                  style: TextStyle(
                                    color: isSoldOut ? AdminColors.error : AdminColors.success,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
