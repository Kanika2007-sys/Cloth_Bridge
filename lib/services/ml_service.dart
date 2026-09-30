import '../models/donation_model.dart';
import '../utils/constants.dart';

abstract class MLService {
  Future<AIPredictionResult> predictClothingCondition(String imagePath, {String? categoryHint});
}

class MockMLService implements MLService {
  @override
  Future<AIPredictionResult> predictClothingCondition(
    String imagePath, {
    String? categoryHint,
  }) async {
    // Simulate real ML inference delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Dynamic fallback logic based on imagePath and categoryHint
    final lowerPath = imagePath.toLowerCase();
    final lowerHint = (categoryHint ?? '').toLowerCase();
    final combined = '$lowerPath $lowerHint';

    if (combined.contains('torn') || combined.contains('repair') || combined.contains('tear') || combined.contains('hole')) {
      return AIPredictionResult(
        category: DonationCondition.repairRequired,
        confidence: 0.92,
        destination: DestinationType.tailoring,
        action: 'Stitching / Button repair needed',
        explanation:
            'AI detected seam tear (approx 3cm). Suitable for redistribution after minor tailoring repair.',
      );
    } else if (combined.contains('damage') || combined.contains('upcycle') || combined.contains('worn')) {
      return AIPredictionResult(
        category: DonationCondition.severelyDamaged,
        confidence: 0.96,
        destination: DestinationType.upcycling,
        action: 'Upcycle into reusable tote bag or floor mat',
        explanation:
            'Fabric heavily worn. Structural integrity insufficient for wear, but 85% high-grade cotton usable for upcycled products.',
      );
    } else if (combined.contains('stain') || combined.contains('dirt') || combined.contains('mark')) {
      return AIPredictionResult(
        category: DonationCondition.minorStain,
        confidence: 0.89,
        destination: DestinationType.ngo,
        action: 'Washable Mark / Stain (Laundering & Direct NGO Distribution)',
        explanation:
            'Minor washable surface mark detected on fabric. Material structure is intact and ready for NGO distribution after laundering.',
      );
    }

    // Default Good Condition Prediction
    return AIPredictionResult(
      category: DonationCondition.good,
      confidence: 0.95,
      destination: DestinationType.ngo,
      action: 'Ready for direct NGO & Orphanage distribution',
      explanation:
          'High quality clothing in great condition with no visible tears or severe stains.',
    );
  }
}
