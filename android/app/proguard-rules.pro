# Chainway DeviceAPI (libs/DeviceAPI_*.aar) is reached through JNI and
# reflection; R8 must not rename or strip it in release builds.
-keep class com.rscja.** { *; }
-keep interface com.rscja.** { *; }
-dontwarn com.rscja.**
