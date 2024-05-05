package com.example.routemate.routemate // Replace 'your.package.name' with the actual package name of your app

import io.flutter.app.FlutterApplication
import androidx.multidex.MultiDex

class MyApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        MultiDex.install(this)
    }
}
