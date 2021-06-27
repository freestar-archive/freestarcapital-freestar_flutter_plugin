# ProGuard rules for FreeStar Ads Mediation SDK

-dontwarn android.app.Activity

# For communication with AdColony's WebView
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep filenames and line numbers for stack traces
-keepattributes SourceFile,LineNumberTable

# Keep JavascriptInterface for WebView bridge
-keepattributes JavascriptInterface

# Sometimes keepattributes is not enough to keep annotations
-keep class android.webkit.JavascriptInterface {
   *;
}

-keep class androidx.** {*;}
-keep interface androidx.** {*;}
-dontwarn androidx.**

-keep class android.** {*;}
-keep interface android.** {*;}
-dontwarn android.**

-keep class com.adcolony.** { *; }
-keep interface com.iab.omid.** { *; }
-dontwarn com.iab.omid.**
-dontwarn com.adcolony.**

-keep class com.amazon.** {*;}
-keep interface com.amazon.** {*;}

-keep class com.applovin.** {*;}
-keep interface com.applovin.** {*;}

-keep class com.criteo.** {*;}
-keep interface com.criteo.** {*;}

-keep class com.danikula.** {*;}
-keep interface com.danikula.** {*;}

-keep class com.facebook.** {*;}
-keep interface com.facebook.** {*;}

-keep interface com.freestar.** {*;}
-keep class com.freestar.** { *; }

-keep interface com.iab.** {*;}
-keep class com.iab.** { *; }

-keep class com.google.** { *; }
-keep interface com.google.** { *; }
-dontwarn com.google.**

-keep class com.mopub.** {*;}
-keep interface com.mopub.** {*;}

-keep class com.tapjoy.** { *; }
-keep interface com.tapjoy.** { *; }
-keep class com.moat.** { *; }
-keep interface com.moat.** { *; }

-keep class com.squareup.picasso.** {*;}
-dontwarn com.squareup.picasso.**
-dontwarn com.squareup.okhttp.**

-keep class com.unity3d.** {*;}
-keep interface com.unity3d.** {*;}

-keep class com.vungle.** {*;}
-keep interface com.vungle.** {*;}

-keep class okio.** {*;}
-keep interface okio.** {*;}
-dontwarn okio.**

-keep class retrofit2.** {*;}
-keep interface retrofit2.** {*;}
-dontwarn retrofit2.**


#nimbus
-keepattributes Signature, *Annotation*

-keep class com.google.ads.interactivemedia.** { *; }
-keep class com.google.obf.** { *; }
-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}

-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
-dontwarn org.codehaus.mojo.animal_sniffer.*
-dontwarn okhttp3.internal.platform.ConscryptPlatform
-dontwarn sun.misc.**
-dontwarn javax.annotation.**

-keepclassmembers class com.adsbynimbus.openrtb.request.* {
    public *;
}

-keepclassmembers class com.adsbynimbus.openrtb.response.NimbusResponse** {
    public *;
}

-keep class * extends com.adsbynimbus.internal.Component { public *; }
-keepclassmembers class com.adsbynimbus.render.web.MraidBridge { *; }
-keepclassmembers class com.adsbynimbus.render.web.NimbusWebViewClient { *; }

# If using the Nimbus GAM Adapter
-keep class com.adsbynimbus.google.NimbusCustomEventBanner {
    <methods>;
    !static <methods>;
}

# If Using the Nimbus Mopub Adapter
-keep class com.adsbynimbus.mopub.* {
    <methods>;
    !static <methods>;
}
