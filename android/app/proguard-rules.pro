# --------------------------------------------------
# From missing_rules.txt
-dontwarn com.example.missingclass.**
-keep class com.example.missingclass.** { *; }

# Additional common Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }

# Firebase rules
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# GitHub libraries
-keep class com.github.** { *; }
-dontwarn com.github.**

# For Play Core SplitCompat
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.**

# For Stripe Push Provisioning
-keep class com.stripe.android.pushProvisioning.** { *; }
-keep class com.reactnativestripesdk.pushprovisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**
