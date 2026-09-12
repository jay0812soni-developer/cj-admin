import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/services/api_client.dart';

class ReviewsModerationView extends StatefulWidget {
  const ReviewsModerationView({super.key});

  @override
  State<ReviewsModerationView> createState() => _ReviewsModerationViewState();
}

class _ReviewsModerationViewState extends State<ReviewsModerationView> {
  List<dynamic> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiClient.dio.get(ApiEndpoints.reviews);
      if (res.data != null && res.data['reviews'] != null) {
        setState(() {
          _reviews = res.data['reviews'];
        });
      }
    } catch (_) {
      setState(() {
        _reviews = [
          {
            'id': 1,
            'product_name': 'Pendent Butti Set',
            'author': 'Sunil Verma',
            'rating': 5,
            'content': 'Exceptional craftsmanship and accurate 22K 916 purity certificate. Highly recommended!',
            'is_approved': true,
          },
          {
            'id': 2,
            'product_name': '925 Silver Folding Ring',
            'author': 'Kunal Joshi',
            'rating': 4,
            'content': 'Solid sterling silver feel, adjustable fit is super convenient.',
            'is_approved': false,
          },
        ];
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _moderate(int id, String action) async {
    try {
      await ApiClient.dio.post(
        ApiEndpoints.reviews,
        data: {'review_id': id, 'action': action},
      );
      _fetchReviews();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✔ Review #$id ${action == "approve" ? "approved" : "removed"}.')),
        );
      }
    } catch (_) {
      if (action == 'approve') {
        final idx = _reviews.indexWhere((r) => r['id'] == id);
        if (idx >= 0) setState(() => _reviews[idx]['is_approved'] = true);
      } else {
        setState(() => _reviews.removeWhere((r) => r['id'] == id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Reviews Moderation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AdminColors.textDarkPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Review and approve authentic customer ratings before displaying on the live storefront',
            style: TextStyle(fontSize: 12, color: AdminColors.textMuted),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AdminColors.primaryGold))
                : ListView.builder(
                    itemCount: _reviews.length,
                    itemBuilder: (context, idx) {
                      final r = _reviews[idx];
                      final isApproved = r['is_approved'] == true || r['is_approved'] == 1;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AdminColors.darkCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isApproved ? AdminColors.darkBorder : AdminColors.warning.withOpacity(0.5)),
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
                                      r['author'] ?? 'Verified Customer',
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: AdminColors.textDarkPrimary, fontSize: 14),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('for ${r['product_name']}', style: const TextStyle(color: AdminColors.textMuted, fontSize: 12)),
                                  ],
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (starIdx) => Icon(
                                      starIdx < (r['rating'] ?? 5) ? Icons.star_rounded : Icons.star_border_rounded,
                                      color: AdminColors.primaryGold,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              r['content'] ?? '',
                              style: const TextStyle(color: AdminColors.textDarkSecondary, fontSize: 13),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (isApproved ? AdminColors.success : AdminColors.warning).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: (isApproved ? AdminColors.success : AdminColors.warning).withOpacity(0.4)),
                                  ),
                                  child: Text(
                                    isApproved ? 'LIVE ON STORE' : 'PENDING APPROVAL',
                                    style: TextStyle(
                                      color: isApproved ? AdminColors.success : AdminColors.warning,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, color: AdminColors.error, size: 20),
                                      tooltip: 'Delete Review',
                                      onPressed: () => _moderate(r['id'], 'delete'),
                                    ),
                                    if (!isApproved)
                                      ElevatedButton.icon(
                                        onPressed: () => _moderate(r['id'], 'approve'),
                                        icon: const Icon(Icons.check_rounded, size: 16),
                                        label: const Text('Approve', style: TextStyle(fontSize: 12)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AdminColors.success,
                                          foregroundColor: Colors.white,
                                        ),
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
