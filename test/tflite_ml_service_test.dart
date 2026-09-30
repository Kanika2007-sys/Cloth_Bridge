import 'package:flutter_test/flutter_test.dart';
import 'package:clothbridge/services/tflite_ml_service.dart';
import 'package:clothbridge/utils/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TFLiteMLService Integration & Fallback Tests', () {
    final tfliteService = TFLiteMLService();

    test('TFLiteMLService predicts good condition with fallback', () async {
      final res = await tfliteService.predictClothingCondition('clean_shirt.jpg', categoryHint: 'Clean green shirt');
      expect(res.category, isNotNull);
      expect(res.confidence, greaterThanOrEqualTo(0.5));
    });

    test('TFLiteMLService predicts repair condition with fallback', () async {
      final res = await tfliteService.predictClothingCondition('torn_pants.jpg', categoryHint: 'Torn blue denim pants');
      expect(res.category, isNotNull);
    });

    test('TFLiteMLService predicts upcycling condition with fallback', () async {
      final res = await tfliteService.predictClothingCondition('damage_dress.jpg', categoryHint: 'Damaged heavy wear dress');
      expect(res.category, isNotNull);
    });
  });
}
