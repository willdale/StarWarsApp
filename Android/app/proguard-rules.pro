# JNA rules
-keep class com.sun.jna.** { *; }
-keepclassmembers class * extends com.sun.jna.* { public *; }

# UniFFI rules
-keep class uniffi.** { *; }
