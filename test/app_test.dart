import 'package:flutter_test/flutter_test.dart';
import 'package:clothbridge/services/ml_service.dart';
import 'package:clothbridge/services/route_service.dart';
import 'package:clothbridge/utils/constants.dart';
import 'package:clothbridge/utils/sample_data.dart';

void main() {
  group('ClothBridge ML & Routing Tests', () {
    final mlService = MockMLService();

    test('ML Service classifies good condition clothes', () async {
      final res = await mlService.predictClothingCondition('clean_shirt.jpg');
      expect(res.category, equals(DonationCondition.good));
      expect(res.destination, equals(DestinationType.ngo));
      expect(res.confidence, greaterThanOrEqualTo(0.9));
    });

    test('ML Service classifies torn clothes for tailoring', () async {
      final res = await mlService.predictClothingCondition('torn_pants.jpg');
      expect(res.category, equals(DonationCondition.repairRequired));
      expect(res.destination, equals(DestinationType.tailoring));
    });

    test('ML Service classifies severely damaged clothes for upcycling', () async {
      final res = await mlService.predictClothingCondition('damage_dress.jpg');
      expect(res.category, equals(DonationCondition.severelyDamaged));
      expect(res.destination, equals(DestinationType.upcycling));
    });

    test('Route Optimization Service generates donor clusters', () {
      final clusters = RouteOptimizationService.generateClusters(SampleData.sampleDonations);
      expect(clusters.isNotEmpty, isTrue);
      expect(clusters.first.donations.isNotEmpty, isTrue);
      expect(clusters.first.totalDistanceSavedKm, greaterThan(0));
    });
  });
}
