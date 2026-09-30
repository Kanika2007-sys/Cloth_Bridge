import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/sample_data.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Leaderboard')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leaderboard header banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.rewardGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, size: 48, color: Colors.white),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Top Sustainability Champions',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Compete by donating, repairing, and upcycling clothes.',
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: SampleData.leaderboardDonors.length,
                itemBuilder: (context, idx) {
                  final donor = SampleData.leaderboardDonors[idx];
                  final isCurrent = donor['isCurrent'] == true;
                  final rank = donor['rank'] as int;

                  Color rankColor = Colors.grey;
                  if (rank == 1) rankColor = Colors.amber;
                  if (rank == 2) rankColor = Colors.grey.shade400;
                  if (rank == 3) rankColor = Colors.brown.shade300;

                  return Card(
                    color: isCurrent ? AppColors.primaryLight.withOpacity(0.3) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: isCurrent ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: rankColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$rank',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            backgroundImage: NetworkImage(donor['avatar']),
                          ),
                        ],
                      ),
                      title: Text(
                        donor['name'],
                        style: TextStyle(
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                          color: isCurrent ? AppColors.primaryDark : AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text('${donor['donations']} Donations'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${donor['points']} Pts',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900, fontSize: 12),
                        ),
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
