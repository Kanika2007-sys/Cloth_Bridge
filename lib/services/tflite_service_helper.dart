import 'tflite_service_stub.dart'
    if (dart.library.io) 'tflite_service_io.dart'
    if (dart.library.js_interop) 'tflite_service_web.dart';

import 'ml_service.dart';

MLService createPlatformMLService() => getTFLiteService() as MLService;
