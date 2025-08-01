# ML Kit Text Recognition keep rules
-keep class com.google.mlkit.vision.text.** { *; }
-keep interface com.google.mlkit.** { *; }

# Add these to explicitly ignore the Japanese/Korean classes
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
-dontwarn com.google.mlkit.vision.text.chinese.**