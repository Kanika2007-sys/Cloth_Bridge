import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../providers/app_state.dart';
import '../../models/donation_model.dart';
import '../../utils/constants.dart';
import '../../widgets/common/status_badge.dart';

class AIAssessmentScreen extends StatelessWidget {
  const AIAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('AI Assessment')),
        body: const Center(child: Text('No donation data provided.')),
      );
    }

    final AIPredictionResult prediction = args['aiPrediction'];

    return Scaffold(
      appBar: AppBar(title: const Text('AI Clothing Assessment')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // AI Badge header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.primary, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'AI Assessment Complete',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Model analyzed clothing condition & structural usability.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Classification Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CLASSIFIED CONDITION', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              prediction.category,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusBadge(status: prediction.category),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('AI CONFIDENCE SCORE', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        percent: prediction.confidence,
                        lineHeight: 12,
                        barRadius: const Radius.circular(6),
                        progressColor: AppColors.primary,
                        backgroundColor: Colors.grey.shade200,
                        trailing: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '${(prediction.confidence * 100).toInt()}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Divider(height: 28),
                      const Text('RECOMMENDED DESTINATION', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.pin_drop_rounded, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              prediction.destination,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text('RECOMMENDED ACTION', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(prediction.action, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 14),
                      const Text('EXPLANATION & ANALYSIS', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(prediction.explanation, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Assistive Warning Disclaimer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.info_outline, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Note: AI classification is assistive. Final condition verification will be confirmed by NGO/tailoring staff upon collection.',
                        style: TextStyle(fontSize: 11, color: Colors.brown),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () async {
                  final appState = Provider.of<AppState>(context, listen: false);

                  await appState.submitDonation(
                    category: args['category'],
                    condition: prediction.category,
                    size: args['size'],
                    quantity: args['quantity'],
                    description: args['description'],
                    imageUrls: List<String>.from(args['imageUrls']),
                    pickupAddress: args['pickupAddress'],
                    latitude: args['latitude'],
                    longitude: args['longitude'],
                    pickupDate: args['pickupDate'],
                    pickupTime: args['pickupTime'],
                    aiPrediction: prediction,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Donation Submitted! +50 Points Earned 🎉'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text(
                  'Confirm & Submit Donation',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
