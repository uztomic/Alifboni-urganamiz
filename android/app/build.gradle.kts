import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Play Store upload signing (android/key.properties + android/upload-keystore.jks).
// Both files are already git-ignored. Falls back to the debug key if
// key.properties is missing, so `flutter run --release` still works on a
// machine that doesn't have the real signing files (e.g. CI, another dev).
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseSigning = keystorePropertiesFile.exists()
if (hasReleaseSigning) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "uz.uztomic.alifbo"
    // Pinned to a stable Android API level rather than
    // flutter.compileSdkVersion: this dev machine's local Android SDK
    // defaults to an unreleased "canary" preview API, and compiling
    // against it produces a binary that real devices' (stable) Google
    // Play services can't load — it crashes on launch with
    // "Failed to create an instance of androidx.work.impl.WorkDatabase"
    // because of the API-level mismatch. 36 is the current stable release
    // (a plugin also hard-requires >=36 to compile).
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Required by flutter_local_notifications (uses java.time APIs).
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // Must match the package name already registered for this app's
        // Play Console listing — Play Store rejects any upload whose
        // applicationId doesn't match exactly.
        applicationId = "uz.uztomic.alifbo"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // TZ 10: Android minimal version API 21+ (Android 5.0)
        minSdk = maxOf(21, flutter.minSdkVersion)
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = rootProject.file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Real upload-key signing when key.properties is present
            // (required for the Play Store — it rejects debug-signed
            // APKs/AABs); falls back to the debug key otherwise so local
            // release builds still work without the real signing files.
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // Pins a single resolved WorkManager version. The Google Mobile Ads
    // SDK initializes its own WorkManager-backed database at process
    // start (before our Dart code ever runs); when Gradle resolves two
    // different transitive androidx.work versions from different AARs,
    // that database's Room schema can fail to open with "Failed to
    // create an instance of androidx.work.impl.WorkDatabase" — exactly
    // the crash seen on-device. Forcing one version avoids the conflict.
    implementation("androidx.work:work-runtime-ktx:2.9.1")
}
