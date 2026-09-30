import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../utils/constants.dart';
import '../../models/donation_model.dart';
import '../../widgets/common/demo_role_switcher.dart';
import '../../widgets/common/status_badge.dart';
import '../../app/routes.dart';

class NgoDashboard extends StatefulWidget {
  const NgoDashboard({super.key});

  @override
  State<NgoDashboard> createState() => _NgoDashboardState();
}

class _NgoDashboardState extends State<NgoDashboard> {
  String _selectedFilter = 'All';

  void _showPickupDialog(BuildContext context, AppState appState, DonationItem item) {
    final dateController = TextEditingController(text: '2026-08-11');
    final timeController = TextEditingController(text: '04:00 PM');
    String partner = 'NGO Staff (Ramesh)';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Schedule Pickup (${item.donationId})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Pickup Date', prefixIcon: Icon(Icons.calendar_today, size: 18)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Pickup Time', prefixIcon: Icon(Icons.access_time, size: 18)),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: partner,
                decoration: const InputDecoration(labelText: 'Pickup Partner'),
                items: const [
                  DropdownMenuItem(value: 'NGO Staff (Ramesh)', child: Text('NGO Staff (Ramesh)', overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: 'Volunteer (Anita)', child: Text('Volunteer (Anita)', overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: 'Delivery Express', child: Text('Delivery Express Partner', overflow: TextOverflow.ellipsis)),
                ],
                onChanged: (val) {
                  if (val != null) partner = val;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              appState.schedulePickup(item.donationId, dateController.text, timeController.text, partner);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pickup scheduled for ${item.donorName}! Notification sent.')),
              );
            },
            child: const Text('Confirm Pickup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final donations = appState.donations;

    final pendingCount = donations.where((d) => d.status.contains('Pending') || d.status.contains('AI Classified')).length;
    final scheduledCount = donations.where((d) => d.status.contains('Scheduled')).length;
    final completedCount = donations.where((d) => d.status.contains('Completed')).length;
    final ngoRevenue = appState.totalNgoUpcycledEarnings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO / Orphanage Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: 'View Marketplace',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.upcycledStore),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.ngoChat),
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
                  // NGO STATS ROW
                  Row(
                    children: [
                      _ngoStatCard('Pending', '$pendingCount', Colors.orange),
                      const SizedBox(width: 6),
                      _ngoStatCard('Scheduled', '$scheduledCount', Colors.blue),
                      const SizedBox(width: 6),
                      _ngoStatCard('Completed', '$completedCount', Colors.green),
                      const SizedBox(width: 6),
                      _ngoStatCard('Sales (50%)', '₹${ngoRevenue.toStringAsFixed(0)}', Colors.deepOrange),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // NGO UPCYCLED REVENUE SHARE BANNER
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.volunteer_activism, color: Colors.deepOrange, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upcycled NGO Profit Fund: ₹${ngoRevenue.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),
                              ),
                              const Text(
                                '50% of all upcycled sales in the app are automatically transferred to Hope Foundation.',
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

                  // FILTER CHIPS
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Pending', 'Scheduled', 'Tailoring', 'Completed']
                          .map((f) => Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: FilterChip(
                                  label: Text(f, style: const TextStyle(fontSize: 11)),
                                  selected: _selectedFilter == f,
                                  selectedColor: AppColors.primaryLight,
                                  onSelected: (val) => setState(() => _selectedFilter = f),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text('Available Clothing Donations', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: donations.length,
                    itemBuilder: (context, idx) {
                      final item = donations[idx];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      item.imageUrls.first,
                                      width: 65,
                                      height: 65,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 65,
                                        height: 65,
                                        color: AppColors.primaryLight,
                                        child: const Icon(Icons.checkroom, color: AppColors.primary),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.category,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            StatusBadge(status: item.condition),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Donor: ${item.donorName} • ${item.quantity} pcs (${item.size})',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '📍 ${item.pickupAddress}',
                                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.primaryLight),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'AI Rec: ${item.recommendedDestination} (${item.aiPrediction?.action ?? ''})',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () => Navigator.pushNamed(context, AppRoutes.ngoChat),
                                      icon: const Icon(Icons.chat, size: 16),
                                      label: const Text('Chat Donor'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => _showPickupDialog(context, appState, item),
                                      icon: const Icon(Icons.schedule, size: 16),
                                      label: const Text('Schedule Pickup'),
                                    ),
                                  ],
                                ),
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

  Widget _ngoStatCard(String title, String count, Color color) {
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
