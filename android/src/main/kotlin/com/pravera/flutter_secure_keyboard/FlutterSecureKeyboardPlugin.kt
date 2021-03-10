package com.pravera.flutter_secure_keyboard

import android.view.WindowManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FlutterSecureKeyboardPlugin */
class FlutterSecureKeyboardPlugin(private val register: Registrar) : MethodCallHandler {
  private lateinit var methodChannel: MethodChannel

  companion object {
    const val TAG = "FlutterSecureKeyboardPlugin"

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val instance = FlutterSecureKeyboardPlugin(registrar)
      instance.setupChannels(registrar.messenger())
    }
  }

  private fun setupChannels(messenger: BinaryMessenger) {
    methodChannel = MethodChannel(messenger, "flutter_secure_keyboard")
    methodChannel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "secureModeOn" -> register.activity().window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
      "secureModeOff" -> register.activity().window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
      else -> result.notImplemented()
    }
  }
}
