
## 1.2.5

* 1.2.5 - Fixed iOS crash due to calling private methods.  Updated Android and iOS dependencies.

* 1.2.4 - Dart modules only: Added 'unawaited' to channel invoke per BannerAd and NativeAd.

* 1.2.3 - Android: As a result of end-user feedback, interstitial and rewarded ads that are not
          ready when 'show' is called will result in 'onInterstitialAdDismissed'
          and 'onRewardedAdDismissed' getting called respectively.

* 1.2.2 - Android: As a result of end-user feedback, moved dependencies from android\build.gradle
          to app\build.gradle so as to give publishers more flexibility.

* 1.2.1 - Updated the included example pubspec.yaml to use 1.2.1 of the freestar flutter plugin.

* 1.2.0 - Updated Android SDK dependencies.  Multiple.
          Updated iOS SDK dependencies; added FBAudienceNetwork 6.+

* 1.1.9 - Updated iOS dependencies. Version bump.  iOS 11 deployment target 9 to 11.

* 1.1.8 - Updated Android dependencies.  Android Target Version 33.
          Added android:exported="true" to
          example/android/app/src/main/AndroidManifest.xml

          Added the following to example/android/app/build.gradle:
             packagingOptions {
                        exclude("META-INF/*.kotlin_module")
                    }

* 1.1.7 - Updated Android dependencies.  Added Prebid demand source partner

* 1.1.6 - Updated Android dependencies.  Added Ogury demand source partner

* 1.1.5 - Updated Android dependencies.  Downgraded Nimbus dependencies for Android.

* 1.1.4 - Updated Android dependencies.

* 1.1.3 - Removed Mopub partner. Added AppLovinMAX and Yahoo/Verizon partners for iOS.

* 1.1.2 - Upgraded Android dependencies - added new partners applovinMAX and yahoo/verizon

* 1.1.1 - Upgraded Android dependencies

* 1.1.0 - iOS update - added missing arm64 slice to example app build settings

* 1.0.13 - Internally updated iOS per Facebook advertising id fix

* 1.0.12 - Updated Android gradle dependencies + added hyprmx partner

* 1.0.11 - Updated Android gradle dependencies

* 1.0.10 - Minor removed unnecessary Podfile.lock from example/ios folder

* 1.0.9 - Minor change to iOS podspec

* 1.0.8 - Removed preroll since not used and causing build issue for iOS

* 1.0.7 - Fixed Unity Ads not showing issue

* 1.0.6 - Fixed build.gradle typo

* 1.0.5 - Updated plugin dependencies

* 1.0.4 - Fixed bug on Android where sometimes small banner ads are not center aligned
          iOS fix coming soon

* 1.0.3 - Updated Android Dependencies.
          Added iOS partner chooser for testing

* 1.0.2 - Updated Android Dependencies

* 1.0.1 - Minor documentation touch up

* 1.0.0 - Supports Android and iOS