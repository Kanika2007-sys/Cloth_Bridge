import tensorflow as tf
import keras
import numpy as np

model_path = r'C:\Users\sreek\Downloads\trained_model\artifacts\model.keras'
target_path = r'c:\Users\sreek\.gemini\antigravity-ide\scratch\clothbridge\assets\models\clothing_classifier.tflite'

full_model = keras.models.load_model(model_path)
eff_net = full_model.get_layer('efficientnetb0')

inputs = tf.keras.Input(shape=(224, 224, 3), dtype=tf.float32)

mean = tf.constant([0.485 * 255.0, 0.456 * 255.0, 0.406 * 255.0], dtype=tf.float32)
std = tf.constant([0.229 * 255.0, 0.224 * 255.0, 0.225 * 255.0], dtype=tf.float32)
x = (inputs - mean) / std

for layer in eff_net.layers[3:]:
    x = layer(x)

x = full_model.get_layer('dropout')(x, training=False)
x = full_model.get_layer('dense')(x)
x = full_model.get_layer('dropout_1')(x, training=False)
outputs = full_model.get_layer('dense_1')(x)

pure_model = tf.keras.Model(inputs=inputs, outputs=outputs)

dummy_input = np.random.uniform(0.0, 255.0, (1, 224, 224, 3)).astype(np.float32)
print("Pure model test prediction:", pure_model.predict(dummy_input))

converter = tf.lite.TFLiteConverter.from_keras_model(pure_model)
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS]
tflite_bytes = converter.convert()

with open(target_path, 'wb') as f:
    f.write(tflite_bytes)

print(f"100% PURE BUILTIN TFLITE MODEL EXPORTED SUCCESSFULLY! Size: {len(tflite_bytes)} bytes")
