# TensorFlow Lite - keep everything
-keep class org.tensorflow.** { *; }
-dontwarn org.tensorflow.**

# ML Kit
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Google Play Services vision (safety)
-keep class com.google.android.gms.vision.** { *; }
-dontwarn com.google.android.gms.vision.**
