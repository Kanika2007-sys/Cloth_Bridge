import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../providers/app_state.dart';
import '../../utils/constants.dart';

class DonationTrackingScreen extends StatelessWidget {
  const DonationTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final donations = appState.donations;

    if (donations.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Donation Status Tracking')),
        body: const Center(child: Text('No active donations found.')),
      );
    }

    final item = donations.first;

    final steps = [
      {'title': 'Donation Submitted', 'subtitle': 'Details & photos uploaded', 'isDone': true},
      {'title': 'AI Classified', 'subtitle': '${item.condition} (${item.recommendedDestination})', 'isDone': true},
      {'title': 'NGO / Tailor Review', 'subtitle': item.ngoName ?? 'Assigned to destination unit', 'isDone': true},
      {'title': 'Pickup Scheduled', 'subtitle': '${item.pickupDate} at ${item.pickupTime}', 'isDone': item.status.contains('Scheduled') || item.status.contains('Collected') || item.status.contains('Completed')},
      {'title': 'Item Collected', 'subtitle': 'Pickup partner on site', 'isDone': item.status.contains('Collected') || item.status.contains('Completed')},
      {'title': 'Delivered / Repaired', 'subtitle': 'Undergoing distribution or upcycling', 'isDone': item.status.contains('Delivered') || item.status.contains('Completed')},
      {'title': 'Redistributed & Completed', 'subtitle': 'Impact verified + Certificate awarded', 'isDone': item.status.contains('Completed')},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Tracking ID: ${item.donationId}')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrls.first,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.checkroom, size: 40),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Quantity: ${item.quantity} pcs • Size ${item.size}'),
                            const SizedBox(height: 4),
                            Text('Destination: ${item.recommendedDestination}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text('Live Status Timeline', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: steps.length,
                itemBuilder: (context, idx) {
                  final step = steps[idx];
                  final isDone = step['isDone'] as bool;
                  final isFirst = idx == 0;
                  final isLast = idx == steps.length - 1;

                  return TimelineTile(
                    isFirst: isFirst,
                    isLast: isLast,
                    beforeLineStyle: LineStyle(
                      color: isDone ? AppColors.primary : Colors.grey.shade300,
                      thickness: 3,
                    ),
                    indicatorStyle: IndicatorStyle(
                      width: 28,
                      height: 28,
                      indicator: CircleAvatar(
                        backgroundColor: isDone ? AppColors.primary : Colors.grey.shade300,
                        child: Icon(
                          isDone ? Icons.check : Icons.circle,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    endChild: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDone ? AppColors.textPrimary : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            step['subtitle'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDone ? AppColors.textSecondary : Colors.grey.shade400,
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
    );
  }
}
