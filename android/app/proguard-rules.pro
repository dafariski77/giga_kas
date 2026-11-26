# Preserve ONNX Runtime native bindings and JNI entrypoints
-keep class ai.onnxruntime.** { *; }
-keep class com.masicai.flutteronnxruntime.** { *; }

# Preserve Google ML Kit bundled Latin text recognition models
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text_common.** { *; }
