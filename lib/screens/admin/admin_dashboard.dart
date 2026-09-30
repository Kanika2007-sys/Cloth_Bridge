import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../providers/app_state.dart';
import '../../utils/constants.dart';
import '../../widgets/common/demo_role_switcher.dart';
import '../../app/routes.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final donations = appState.donations;
    final clusters = appState.routeClusters;

    final totalItems = donations.fold(0, (sum, item) => sum + item.quantity);
    final upcycledCount = donations.where((d) => d.recommendedDestination.contains('Upcycling')).length;
    final totalSales = appState.totalUpcycledSalesRevenue;
    final ngoEarnings = appState.totalNgoUpcycledEarnings;
    final tailorEarnings = appState.totalTailorUpcycledEarnings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Management Console'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.upcycledStore),
            tooltip: 'Upcycled Store',
          ),
          IconButton(
            icon: const Icon(Icons.route),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.routeOptimization),
            tooltip: 'Route Clustering',
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
                  // KPI SUMMARY GRID
                  Text('Ecosystem KPIs', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _adminKpiCard('Total Donors', '142', Icons.people, Colors.blue),
                      _adminKpiCard('NGOs / Orphanages', '18', Icons.domain, Colors.green),
                      _adminKpiCard('Total Clothes', '$totalItems pcs', Icons.checkroom, Colors.purple),
                      _adminKpiCard('Upcycled Sales', '₹${totalSales.toStringAsFixed(0)}', Icons.storefront, Colors.teal),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // FINANCIAL AUDIT CARD - 50/50 SPLIT
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.account_balance_wallet_outlined, color: AppColors.primaryDark, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Upcycled Sales Financial Audit',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Gross Revenue', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text('₹${totalSales.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('50% NGO Payout', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text('₹${ngoEarnings.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('50% Tailor Payout', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text('₹${tailorEarnings.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.upcycledStore),
                              icon: const Icon(Icons.storefront, size: 16, color: AppColors.primary),
                              label: const Text('Manage Marketplace & Orders', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ROUTE OPTIMIZATION PROMPT CARD
                  Card(
                    color: AppColors.primaryDark,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.alt_route, color: Colors.white, size: 28),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'AI Pickup Route Optimization',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Found ${clusters.length} donor pickup clusters. Suggested Common Collection Points save ~${(clusters.length * 3.6).toStringAsFixed(1)} km of transport distance.',
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primaryDark,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.routeOptimization);
                            },
                            icon: const Icon(Icons.map),
                            label: const Text('View & Approve Collection Routes'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // DISTRIBUTION BREAKDOWN
                  Text('Clothing Destination Breakdown', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Direct NGO Distribution (Ready)', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          LinearPercentIndicator(
                            percent: 0.55,
                            lineHeight: 10,
                            barRadius: const Radius.circular(5),
                            progressColor: Colors.green,
                            trailing: const Text('55%'),
                          ),
                          const SizedBox(height: 14),
                          const Text('Tailoring & Stitching Repair', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          LinearPercentIndicator(
                            percent: 0.25,
                            lineHeight: 10,
                            barRadius: const Radius.circular(5),
                            progressColor: Colors.orange,
                            trailing: const Text('25%'),
                          ),
                          const SizedBox(height: 14),
                          const Text('Textile Upcycling (Bags & Mats)', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          LinearPercentIndicator(
                            percent: 0.20,
                            lineHeight: 10,
                            barRadius: const Radius.circular(5),
                            progressColor: Colors.purple,
                            trailing: const Text('20%'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _adminKpiCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Icon(icon, color: color, size: 22),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
