import '../models/donation_model.dart';
import 'ml_service.dart';

abstract class TFLiteServicePlatform {
  Future<bool> ensureInitialized();
  Future<AIPredictionResult> predictClothingCondition(
    String imagePath, {
    String? categoryHint,
  });
}

TFLiteServicePlatform getTFLiteService() =>
    throw UnsupportedError('Cannot create TFLiteService without platform implementation');
