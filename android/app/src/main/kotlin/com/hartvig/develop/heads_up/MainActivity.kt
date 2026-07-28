package com.hartvig.develop.heads_up

import com.google.android.gms.ads.MobileAds
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.hartvigsolutions.hintmaster/privacy",
        ).setMethodCallHandler { call, result ->
            if (call.method == "disablePublisherFirstPartyId") {
                MobileAds.putPublisherFirstPartyIdEnabled(false)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
