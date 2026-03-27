import tensorflow as tf

# Charger le modèle Keras
model = tf.keras.models.load_model("model")
model.save("model_saved")
# Convertir en TFLite
converter = tf.lite.TFLiteConverter.from_saved_model("model_saved")
tflite_model = converter.convert()

# Sauvegarder
with open("model.tflite", "wb") as f:
    f.write(tflite_model)

print("✅ Conversion terminée !")