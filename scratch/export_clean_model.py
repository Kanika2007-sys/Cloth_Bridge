import tensorflow as tf
import keras

model_path = r'C:\Users\sreek\Downloads\trained_model\artifacts\model.keras'
target_path = r'c:\Users\sreek\.gemini\antigravity-ide\scratch\clothbridge\assets\models\clothing_classifier.tflite'

full_model = keras.models.load_model(model_path)

inputs = tf.keras.Input(shape=(224, 224, 3), dtype=tf.float32)

# Skip augmentation layer [1]
x = full_model.layers[2](inputs)
x = full_model.layers[3](x)
x = full_model.layers[4](x, training=False)
x = full_model.layers[5](x)
x = full_model.layers[6](x, training=False)
outputs = full_model.layers[7](x)

clean_model = tf.keras.Model(inputs=inputs, outputs=outputs)

converter = tf.lite.TFLiteConverter.from_keras_model(clean_model)
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS, tf.lite.OpsSet.SELECT_TF_OPS]
tflite_bytes = converter.convert()

with open(target_path, 'wb') as f:
    f.write(tflite_bytes)

print(f"CLEAN MODEL EXPORTED SUCCESSFULLY WITHOUT AUGMENTATION OPS! Size: {len(tflite_bytes)} bytes")
