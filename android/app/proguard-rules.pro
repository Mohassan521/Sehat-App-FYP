-keep class **.zego.** { *;}
# Ignore missing Heytap push classes
-dontwarn com.heytap.msp.push.**

# Ignore missing Huawei push classes
-dontwarn com.huawei.hms.**

# Ignore missing Vivo push classes
-dontwarn com.vivo.push.**

# Ignore missing Xiaomi push classes
-dontwarn com.xiaomi.mipush.sdk.**

# Ignore missing classes from ITGSA OpenSDK
-dontwarn com.itgsa.opensdk.**

# Ignore missing Java Beans classes (if not used)
-dontwarn java.beans.**

# Ignore missing DOM implementation classes
-dontwarn org.w3c.dom.bootstrap.DOMImplementationRegistry
