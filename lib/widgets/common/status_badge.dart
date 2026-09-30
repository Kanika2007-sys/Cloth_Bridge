import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.primaryLight;
    Color fg = AppColors.primaryDark;

    if (status.contains('Good') || status.contains('Completed') || status.contains('Delivered')) {
      bg = Colors.green.shade100;
      fg = Colors.green.shade900;
    } else if (status.contains('Stain') || status.contains('Scheduled') || status.contains('In Progress')) {
      bg = Colors.amber.shade100;
      fg = Colors.amber.shade900;
    } else if (status.contains('Repair') || status.contains('Tailoring')) {
      bg = Colors.orange.shade100;
      fg = Colors.orange.shade900;
    } else if (status.contains('Damaged') || status.contains('Upcycling')) {
      bg = Colors.purple.shade100;
      fg = Colors.purple.shade900;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
