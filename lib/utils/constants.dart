import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF2E7D32); // Eco Green
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFFA5D6A7);
  static const Color accentGold = Color(0xFFFBC02D); // Rewards/Points
  
  // Earth & Neutral Tones
  static const Color earthBrown = Color(0xFF795548);
  static const Color warmGrey = Color(0xFF8D6E63);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color border = Color(0xFFE0E0E0);
  
  // Category & Status Colors
  static const Color statusGood = Color(0xFF388E3C);
  static const Color statusRepair = Color(0xFFF57C00);
  static const Color statusUpcycle = Color(0xFF7B1FA2);
  static const Color statusPending = Color(0xFF0288D1);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient rewardGradient = LinearGradient(
    colors: [Color(0xFFFF8F00), Color(0xFFFFC107)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class UserRoles {
  static const String donor = 'donor';
  static const String ngo = 'ngo';
  static const String admin = 'admin';
  static const String tailor = 'tailor';

  static String getLabel(String role) {
    switch (role) {
      case donor:
        return 'Clothing Donor';
      case ngo:
        return 'NGO / Orphanage';
      case admin:
        return 'System Administrator';
      case tailor:
        return 'Tailoring & Upcycling Unit Head';
      default:
        return 'User';
    }
  }
}

class ClothingCategory {
  static const String shirts = 'Shirts & Tops';
  static const String trousers = 'Pants & Jeans';
  static const String dresses = 'Dresses & Skirts';
  static const String jackets = 'Jackets & Coats';
  static const String kids = 'Children Clothing';
  static const String uniforms = 'School Uniforms';
  static const String blankets = 'Blankets & Linens';

  static const List<String> all = [
    shirts,
    trousers,
    dresses,
    jackets,
    kids,
    uniforms,
    blankets,
  ];
}

class DonationCondition {
  static const String good = 'Good / Donation Ready';
  static const String minorStain = 'Minor Stain';
  static const String repairRequired = 'Repair Required';
  static const String severelyDamaged = 'Severely Damaged';

  static Color getColor(String condition) {
    if (condition.contains('Good')) return AppColors.statusGood;
    if (condition.contains('Stain')) return Colors.amber.shade800;
    if (condition.contains('Repair')) return AppColors.statusRepair;
    return AppColors.statusUpcycle;
  }
}

class DestinationType {
  static const String ngo = 'NGO / Orphanage';
  static const String tailoring = 'Tailoring Unit';
  static const String upcycling = 'Upcycling Unit';
}

class DonationStatus {
  static const String pending = 'Pending AI Assessment';
  static const String aiClassified = 'AI Classified';
  static const String ngoAssigned = 'NGO Assigned';
  static const String tailoringAssigned = 'Tailoring Assigned';
  static const String pickupScheduled = 'Pickup Scheduled';
  static const String collected = 'Collected';
  static const String inRepair = 'In Repair / Upcycling';
  static const String delivered = 'Delivered to NGO';
  static const String completed = 'Redistributed / Completed';
}
