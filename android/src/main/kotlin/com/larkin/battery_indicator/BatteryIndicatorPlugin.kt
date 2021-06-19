package com.larkin.battery_indicator

import android.content.*
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** BatteryIndicatorPlugin */
class BatteryIndicatorPlugin: FlutterPlugin, MethodCallHandler, StreamHandler {
  private lateinit var applicationContext: Context
  private lateinit var channel : MethodChannel
  private lateinit var streamChannel: EventChannel
  private lateinit var filter: IntentFilter
  private lateinit var batteryManager: BatteryManager
  private lateinit var chargingStateChangeReceiver: BroadcastReceiver

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    onAttachedToEngine(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }

  private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
    this.applicationContext = applicationContext

    channel = MethodChannel(messenger, "battery_indicator/channel")
    channel.setMethodCallHandler(this)

    streamChannel = EventChannel(messenger, "battery_indicator/stream")
    streamChannel.setStreamHandler(this)

    filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      batteryManager = applicationContext.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getBatteryCharge") {
      result.success(getBatteryCall())
    } else {
      result.notImplemented()
    }
  }

  /**This call acts as a MethodChannel handler to retrieve battery information*/
  private fun getBatteryCall(): Int {
    val intent: Intent? = applicationContext.registerReceiver(null, filter)
    return intent?.let { getBatteryCharge() }!!
  }

  override fun onListen(arguments: Any?, events: EventSink?) {
    chargingStateChangeReceiver = createChargingStateChangeReceiver(events)
    applicationContext.registerReceiver(
            chargingStateChangeReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
  }

  override fun onCancel(arguments: Any?) {
    applicationContext.unregisterReceiver(chargingStateChangeReceiver)
  }

  /** Creates broadcast receiver object that provides battery information upon subscription to the stream */
  private fun createChargingStateChangeReceiver(events: EventSink?): BroadcastReceiver {
    return object : BroadcastReceiver() {
      override fun onReceive(contxt: Context?, intent: Intent?) {
        events?.success(intent?.let { getBatteryCharge() })
      }
    }
  }

  ///
  private fun getBatteryCharge() : Int {
    var remainingEnergy = -1

    remainingEnergy = if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      val batteryManager = applicationContext.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    } else {
      val intent = ContextWrapper(applicationContext)
              .registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
      (intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100
              / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1))
    }

    return remainingEnergy
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    streamChannel.setStreamHandler(null)
  }
}
