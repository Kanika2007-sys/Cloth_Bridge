import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:clothbridge/services/tflite_ml_service.dart';
import 'package:clothbridge/utils/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('TFLiteMLService initializes without crashing', () async {
    final service = TFLiteMLService();
    final isInit = await service.ensureInitialized();
    expect(isInit != null, isTrue);
  });

  test('TFLiteMLService predicts clothing condition for stained image', () async {
    final service = TFLiteMLService();

    // Create a test image with stain keywords in path and stain image content
    final testImage = img.Image(width: 224, height: 224);
    img.fill(testImage, color: img.ColorRgb8(240, 240, 240));
    img.fillRect(testImage, x1: 50, y1: 50, x2: 170, y2: 170, color: img.ColorRgb8(40, 20, 10));

    final tempDir = Directory.systemTemp.createTempSync('ml_test');
    final tempImagePath = '${tempDir.path}/stained_tshirt.jpg';
    File(tempImagePath).writeAsBytesSync(img.encodeJpg(testImage));

    final res = await service.predictClothingCondition(tempImagePath, categoryHint: 'stained t-shirt');
    print('Prediction Result -> Category: ${res.category}, Action: ${res.action}, Explanation: ${res.explanation}');

    expect(res.category, equals(DonationCondition.minorStain));
    tempDir.deleteSync(recursive: true);
  });
}
