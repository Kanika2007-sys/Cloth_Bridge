import tensorflow as tf

tflite_path = r'c:\Users\sreek\.gemini\antigravity-ide\scratch\clothbridge\assets\models\clothing_classifier.tflite'

with open(tflite_path, 'rb') as f:
    buf = f.read()

model = tf.lite.UnstableModel(buf)
print("Model operators:")
for i, op in enumerate(model.operators):
    print(f"[{i}] Opcode index: {op.opcode_index}")

op_codes = [model.operator_codes[i] for i in range(len(model.operator_codes))]
print("Operator Codes:")
for i, code in enumerate(op_codes):
    builtin_code = code.builtin_code
    custom_code = code.custom_code
    print(f"Code {i}: builtin={builtin_code}, custom={custom_code}")
