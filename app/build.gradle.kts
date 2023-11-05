import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    kotlin("kapt")
    id("com.google.dagger.hilt.android")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}
val keystorePropertiesFile = rootProject.file("keystore.properties")
val keystoreProperties = Properties()
keystoreProperties.load(FileInputStream(keystorePropertiesFile))

android {
    signingConfigs {
        create("release") {
            storeFile =  file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
        }
    }
    namespace = "app.anime.wallpapers"
    compileSdk = 34

    defaultConfig {
        applicationId = "app.anime.wallpapers"
        minSdk = 27
        targetSdk = 34
        versionCode = 4
        versionName = "1.0.4"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildFeatures {
        dataBinding = true
        viewBinding = true
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("release")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }

}

dependencies {

    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.10.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.6.2")
    implementation("androidx.databinding:databinding-runtime:8.1.2")
    implementation ("androidx.fragment:fragment-ktx:1.6.1")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.6.2")
    implementation ("androidx.work:work-runtime-ktx:2.8.1")
    implementation("androidx.swiperefreshlayout:swiperefreshlayout:1.1.0")
    implementation("androidx.paging:paging-common-ktx:3.2.1")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("com.google.android.play:app-update:2.1.0")
    implementation("com.google.android.play:app-update-ktx:2.1.0")
    implementation("androidx.hilt:hilt-common:1.0.0")
    implementation("androidx.paging:paging-runtime-ktx:3.2.1")
    implementation("com.google.android.gms:play-services-ads-lite:22.4.0")
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
    implementation("androidx.navigation:navigation-fragment-ktx:2.7.4")
    implementation ("androidx.navigation:navigation-ui-ktx:2.7.4")

    //hilt
    implementation("com.google.dagger:hilt-android:2.48.1")
    kapt("com.google.dagger:hilt-compiler:2.48.1")

    //Retrofit
    implementation("com.google.code.gson:gson:2.9.0")
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation ("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:logging-interceptor:5.0.0-alpha.6")

    //view-model
    implementation("androidx.lifecycle:lifecycle-extensions:2.2.0")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.6.2")

    //ssp-sdp
    implementation("com.intuit.ssp:ssp-android:1.0.6")
    implementation("com.intuit.sdp:sdp-android:1.0.6")

    //glide
    implementation("com.github.bumptech.glide:glide:4.13.1")
    implementation("com.github.bumptech.glide:recyclerview-integration:4.12.0")
    annotationProcessor("com.github.bumptech.glide:compiler:4.13.1")
    implementation("com.nostra13.universalimageloader:universal-image-loader:1.9.5")


    //palette
    implementation("androidx.palette:palette-ktx:1.0.0")

    //lottie
    implementation("com.airbnb.android:lottie:5.0.3")

    //Firebase
    implementation(platform("com.google.firebase:firebase-bom:32.3.1"))
    implementation("com.google.firebase:firebase-crashlytics-ktx")
    implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("com.google.firebase:firebase-messaging-ktx")
    implementation ("com.google.firebase:firebase-dynamic-links-ktx")
    implementation ("com.google.firebase:firebase-analytics-ktx")

    implementation("com.google.android.gms:play-services-ads:22.4.0")

    implementation("androidx.lifecycle:lifecycle-extensions:2.2.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.6.2")
    annotationProcessor("androidx.lifecycle:lifecycle-compiler:2.6.2")

}

kapt {
    correctErrorTypes = true
}