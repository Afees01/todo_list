# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Keep Supabase classes
-keep class com.supabase.** { *; }
-keep class io.supabase.** { *; }

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep JSON serialization
-keepattributes *Annotation*
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep network related classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }

# Keep Kotlin classes
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }

# Keep reflection
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

