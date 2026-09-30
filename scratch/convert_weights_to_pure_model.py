import tensorflow as tf
import keras
import numpy as np

keras_path = r'C:\Users\sreek\Downloads\trained_model\artifacts\model.keras'
target_tflite = r'c:\Users\sreek\.gemini\antigravity-ide\scratch\clothbridge\assets\models\clothing_classifier.tflite'

trained_model = keras.models.load_model(keras_path)
print("Loaded trained model successfully.")

inputs = tf.keras.Input(shape=(224, 224, 3), dtype=tf.float32)
outputs = trained_model(inputs)
pure_model = tf.keras.Model(inputs=inputs, outputs=outputs)

tf.saved_model.save(pure_model, r'scratch/pure_saved_model')

converter = tf.lite.TFLiteConverter.from_saved_model(r'scratch/pure_saved_model')
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS]
tflite_bytes = converter.convert()

with open(target_tflite, 'wb') as f:
    f.write(tflite_bytes)

print(f"PURE TFLITE MODEL SAVED! Size: {len(tflite_bytes)} bytes")
