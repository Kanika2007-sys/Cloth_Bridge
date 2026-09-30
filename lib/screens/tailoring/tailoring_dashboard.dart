import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../app/routes.dart';
import '../../providers/app_state.dart';
import '../../utils/constants.dart';
import '../../models/tailoring_order_model.dart';
import '../../widgets/common/demo_role_switcher.dart';
import '../../widgets/common/status_badge.dart';

class TailoringDashboard extends StatefulWidget {
  const TailoringDashboard({super.key});

  @override
  State<TailoringDashboard> createState() => _TailoringDashboardState();
}

class _TailoringDashboardState extends State<TailoringDashboard> {
  void _showUpdateProgressDialog(BuildContext context, AppState appState, TailoringOrder order) {
    int currentProgress = order.progress;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Update Order ${order.orderId}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Work: ${order.workType}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Progress: $currentProgress%'),
                Slider(
                  value: currentProgress.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 10,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setDialogState(() => currentProgress = val.toInt());
                  },
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final newStatus = currentProgress == 100 ? 'Completed' : 'In Progress';
                  appState.updateTailoringOrder(order.orderId, currentProgress, newStatus);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Order ${order.orderId} updated to $currentProgress%!')),
                  );
                },
                child: const Text('Save Progress'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showListForSaleDialog(BuildContext context, AppState appState, TailoringOrder order) {
    final titleController = TextEditingController(text: 'Upcycled ${order.clothingCategory} Bag');
    final descController = TextEditingController(text: 'Upcycled product crafted from donation #${order.donationId}. High quality & durable design.');
    final priceController = TextEditingController(text: '499');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('List Upcycled Product for Sale 🛍️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sales earnings are automatically split 50% to Partner NGO & 50% to Tailoring Unit.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Product Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price (₹)', prefixText: '₹'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(priceController.text) ?? 499.0;
              appState.addUpcycledProduct(
                title: titleController.text,
                description: descController.text,
                price: price,
                imageUrl: order.resultImageUrl ?? order.clothingImage,
                originalDonationId: order.donationId,
                stockQuantity: 5,
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Listed "${titleController.text}" for sale! (50% NGO / 50% Tailor split)'),
                  backgroundColor: AppColors.primaryDark,
                ),
              );
            },
            child: const Text('Publish to Marketplace'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final orders = appState.tailoringOrders;

    final pendingCount = orders.where((o) => o.status == 'Assigned').length;
    final activeCount = orders.where((o) => o.status == 'In Progress').length;
    final completedCount = orders.where((o) => o.status == 'Completed').length;
    final tailorEarnings = appState.totalTailorUpcycledEarnings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stitching & Upcycling Unit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: 'View Marketplace',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.upcycledStore),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Logout',
            onPressed: () {
              appState.signOutFirebase();
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const DemoRoleSwitcherBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // STATS ROW
                  Row(
                    children: [
                      _tailorStatCard('Assigned', '$pendingCount', Colors.orange),
                      const SizedBox(width: 6),
                      _tailorStatCard('In Repair', '$activeCount', Colors.blue),
                      const SizedBox(width: 6),
                      _tailorStatCard('Completed', '$completedCount', Colors.green),
                      const SizedBox(width: 6),
                      _tailorStatCard('Profit (50%)', '₹${tailorEarnings.toStringAsFixed(0)}', Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // UPCYCLED MARKETPLACE BANNER FOR TAILORS
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.storefront_outlined, color: Colors.purple, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upcycled Sales Earnings: ₹${tailorEarnings.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.purple),
                              ),
                              const Text(
                                '50% of every marketplace purchase goes directly to StitchCraft unit.',
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.upcycledStore),
                          child: const Text('Store 🛍️', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text('Assigned Work Orders', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, idx) {
                      final order = orders[idx];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      order.clothingImage,
                                      width: 65,
                                      height: 65,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.content_cut, size: 40),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${order.clothingCategory} (${order.orderId})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        const SizedBox(height: 4),
                                        Text('Work: ${order.workType}', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 13)),
                                        const SizedBox(height: 2),
                                        Text('Problem: ${order.problem}', style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 2),
                                      ],
                                    ),
                                  ),
                                  StatusBadge(status: order.status),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: LinearPercentIndicator(
                                      percent: order.progress / 100.0,
                                      lineHeight: 8,
                                      barRadius: const Radius.circular(4),
                                      progressColor: order.progress == 100 ? Colors.green : Colors.orange,
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${order.progress}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Text('Deadline: ${order.deadline}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (order.workType.toLowerCase().contains('upcycl') || order.progress == 100)
                                        OutlinedButton.icon(
                                          onPressed: () => _showListForSaleDialog(context, appState, order),
                                          icon: const Icon(Icons.sell_outlined, size: 14, color: AppColors.primary),
                                          label: const Text('Sell (50% Split)', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                                        ),
                                      const SizedBox(width: 6),
                                      ElevatedButton.icon(
                                        onPressed: () => _showUpdateProgressDialog(context, appState, order),
                                        icon: const Icon(Icons.edit_note, size: 16),
                                        label: const Text('Update'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tailorStatCard(String title, String count, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 2),
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
