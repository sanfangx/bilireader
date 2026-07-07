plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.bilireader.bilireader"
    // 規範 §2.1 runtime 契約以 targetSdk=35 維持；compileSdk 因 image_picker（feature ⑦，
    // 使用者指定加入）之傳遞依賴 androidx.activity:1.12.4 硬性要求，提升至 36。compileSdk
    // 僅為編譯期設定、向後相容，不改變 runtime 行為（targetSdk 仍 35）。
    compileSdk = 36
    // path_provider_android / sqflite_android 需要 NDK 27（向後相容）。
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // 重製 App 使用新的 applicationId（規範 §2.1，允許新 ID 但須明確設定）。
        applicationId = "com.bilireader.app"
        // 規範 §2.1 平台契約：minSdk 27、targetSdk 35。
        minSdk = 27
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
