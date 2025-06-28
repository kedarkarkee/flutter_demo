package com.example.demo

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.time.Instant
import java.util.Date
import java.util.Locale
import java.util.TimeZone

class MainActivity : FlutterActivity() {
    private val CHANNEL = "demo"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel =  MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("native_button",
                NativeViewFactory(onClick = {
                    val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                    val batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                    channel.invokeMethod("onNativeButtonClicked", batteryLevel)
                }))
        channel.setMethodCallHandler { call, result ->
            if (call.method == "getSystemInformation") {
                val info = getSystemInformation()

                result.success(info)

            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSystemInformation(): Map<String, *> {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        val batteryStatus = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_STATUS)
        } else {
            batteryStatusLegacy()
        }
        val isCharging = batteryStatus ==  BatteryManager.BATTERY_STATUS_CHARGING
        return mapOf(
            Pair("batteryLevel", batteryLevel),
            Pair("deviceModel", Build.MODEL),
            Pair("isCharging", isCharging),
            Pair("systemTime", getSystemTime())
        )
    }

    private fun batteryStatusLegacy(): Int {
        val batteryStatus: Intent? = IntentFilter(Intent.ACTION_BATTERY_CHANGED).let {
            context.registerReceiver(null, it)
        }
        if (batteryStatus == null) {
            return -1
        }

        return batteryStatus.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
    }

    private fun getSystemTime(): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Instant.now().toString()
        } else {
            val currentTimeMillis = System.currentTimeMillis()
            val date = Date(currentTimeMillis)

            val formatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US)
            formatter.timeZone = TimeZone.getTimeZone("UTC")

            val formattedTime = formatter.format(date)
            return formattedTime + "Z"
        }
    }
}