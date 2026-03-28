import tensorflow as tf

# Recréer ton modèle (important)
model = tf.keras.models.load_model("model")

# Sauvegarder en format SavedModel propre
model.export("model_saved")

# Convertir en TFLite
converter = tf.lite.TFLiteConverter.from_saved_model("model_saved")
tflite_model = converter.convert()

# Sauvegarder le fichier .tflite
with open("model.tflite", "wb") as f:
    f.write(tflite_model)

print(" FINI : model.tflite créé !")
