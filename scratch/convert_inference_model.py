import tensorflow as tf
import keras

model_path = r'C:\Users\sreek\Downloads\trained_model\artifacts\model.keras'
target_path = r'c:\Users\sreek\.gemini\antigravity-ide\scratch\clothbridge\assets\models\clothing_classifier.tflite'

full_model = keras.models.load_model(model_path)

inputs = tf.keras.Input(shape=(224, 224, 3), dtype=tf.float32)

x = inputs * 0.00392156862745098  # 1/255.0 constant multiply
x = full_model.get_layer('efficientnetb0')(x)
x = full_model.get_layer('dropout')(x, training=False)
x = full_model.get_layer('dense')(x)
x = full_model.get_layer('dropout_1')(x, training=False)
outputs = full_model.get_layer('dense_1')(x)

inference_model = tf.keras.Model(inputs=inputs, outputs=outputs)
print("Inference model constructed successfully!")

converter = tf.lite.TFLiteConverter.from_keras_model(inference_model)
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS]
tflite_bytes = converter.convert()

with open(target_path, 'wb') as f:
    f.write(tflite_bytes)

print(f"SUCCESSFULLY EXPORTED PURE INFERENCE TFLITE MODEL! File size: {len(tflite_bytes)} bytes")
