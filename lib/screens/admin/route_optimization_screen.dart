import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../utils/constants.dart';

class RouteOptimizationScreen extends StatelessWidget {
  const RouteOptimizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final clusters = appState.routeClusters;

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Route Optimization')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.alt_route, color: AppColors.primary, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Donor Location Clustering Engine',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Groups nearby pickup locations into single Common Collection Points.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text('Suggested Collection Clusters (${clusters.length})', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: clusters.length,
                itemBuilder: (context, idx) {
                  final cluster = clusters[idx];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  cluster.clusterName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: cluster.isApproved ? Colors.green.shade100 : Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  cluster.isApproved ? 'Approved' : 'Pending Approval',
                                  style: TextStyle(
                                    color: cluster.isApproved ? Colors.green.shade900 : Colors.amber.shade900,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.pin_drop, size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Common Hub: ${cluster.collectionPointAddress}',
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Contains ${cluster.donations.length} Donors • Distance Saved: ~${cluster.totalDistanceSavedKm.toStringAsFixed(1)} km',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const Divider(height: 20),
                          const Text('Grouped Donors:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(height: 4),
                          ...cluster.donations.map((d) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person, size: 14, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text('${d.donorName} (${d.category})', style: const TextStyle(fontSize: 12)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        d.pickupAddress,
                                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 12),
                          if (!cluster.isApproved)
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  appState.approveCluster(cluster.clusterId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${cluster.clusterName} Route Approved!')),
                                  );
                                },
                                icon: const Icon(Icons.check),
                                label: const Text('Approve Route Cluster'),
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
