import '../models/donation_model.dart';
import 'ml_service.dart';
import 'tflite_service_helper.dart';
import 'tflite_service_stub.dart';

class TFLiteMLService implements MLService {
  final MLService _delegate = createPlatformMLService();

  Future<bool> ensureInitialized() async {
    if (_delegate is TFLiteServicePlatform) {
      return await (_delegate as TFLiteServicePlatform).ensureInitialized();
    }
    return true;
  }

  @override
  Future<AIPredictionResult> predictClothingCondition(
    String imagePath, {
    String? categoryHint,
  }) async {
    return _delegate.predictClothingCondition(
      imagePath,
      categoryHint: categoryHint,
    );
  }
}
