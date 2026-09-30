# Custom TFLite Model Directory

Place your custom trained TensorFlow Lite model file here:
- **Model File**: `assets/models/clothing_classifier.tflite`
- **Labels File**: `assets/models/labels.txt`

### Model Expected Specifications
- **Input Tensor**: `[1, 224, 224, 3]` (RGB Image normalized to `[0..1]` or `[-1..1]`)
- **Output Tensor**: `[1, 4]` (Probability distribution over 4 classes)
  - Index 0: `Good Condition` -> Direct NGO & Orphanage distribution
  - Index 1: `Minor Stain` -> Wash & NGO distribution
  - Index 2: `Repair Required` -> Tailoring & Stitching Unit
  - Index 3: `Severely Damaged` -> Upcycling (Bags & Mats)

ClothBridge's `TFLiteMLService` automatically loads `clothing_classifier.tflite` if present, with an automatic fallback to `MockMLService` for demo environments.
