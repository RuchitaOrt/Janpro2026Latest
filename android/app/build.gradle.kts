plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
        
    id("com.google.gms.google-services") version "4.4.0"

}

android {
    namespace = "com.ort.janpro"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ort.janpro"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
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
    packaging {
        jniLibs {
            excludes += listOf(
                "lib/armeabi-v7a/libtoolChecker.so",
                "lib/arm64-v8a/libtoolChecker.so",
                "lib/x86/libtoolChecker.so",
                "lib/x86_64/libtoolChecker.so"
            )
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    // Core library desugaring — update version
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    
    // Firebase BOM
    implementation(platform("com.google.firebase:firebase-bom:32.2.2"))

    // Firebase libraries
    // implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("com.google.firebase:firebase-messaging")
}


