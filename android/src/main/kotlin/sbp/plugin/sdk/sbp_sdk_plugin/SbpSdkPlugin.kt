package sbp.plugin.sdk.sbp_sdk_plugin

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterFragmentActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import sbp.payments.sdk.SBP
import sbp.payments.sdk.exception.InvalidUrlStringException
import sbp.payments.sdk.exception.BanksCacheIsEmptyException
import sbp.payments.sdk.exception.SbpLibraryNotInitializedException
import java.lang.Exception

import kotlinx.coroutines.*
import kotlinx.coroutines.flow.first
import sbp.payments.sdk.entity.BankDictionary

/** SbpSdkPlugin */
class SbpSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private var activity: FlutterFragmentActivity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sbp_sdk_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "init" -> {
        SBP.init(context)
        result.success(true)
      }

      "showModal" -> {
        val paymentUrl = call.arguments as String
        if (activity == null) {
          result.error("ActivityIsNull", null, null)
          return
        }
        try {
          val frManager = activity!!.supportFragmentManager
          SBP.showBankSelectorBottomSheetDialog(frManager, paymentUrl)
          result.success(true)
        } catch (error: InvalidUrlStringException) {
          result.error("InvalidUrlStringException", "Передана некорректная url", null)
        } catch (error: BanksCacheIsEmptyException) {
          result.error("BanksCacheIsEmptyException", "Кэш банков пуст", null)
        } catch (error: SbpLibraryNotInitializedException) {
          result.error("SbpLibraryNotInitializedException", "Библиотека не была инициализирована", null)
        } catch (e: Exception) {
          result.error("UnexpectedException", e.localizedMessage, e.message)
        }
      }

      "getBankList" -> {
        val paymentUrl = call.arguments as String
        try {
          val banks: List<BankDictionary>
          runBlocking(Dispatchers.IO) {
            banks = SBP.getBankList(paymentUrl).first()
          }
          val banksJSON = Gson().toJson(banks)
          result.success(banksJSON)
        } catch (error: InvalidUrlStringException) {
          result.error("InvalidUrlStringException", "Передана некорректная url", null)
        } catch (error: BanksCacheIsEmptyException) {
          result.error("BanksCacheIsEmptyException", "Кэш банков пуст", null)
        } catch (error: SbpLibraryNotInitializedException) {
          result.error("SbpLibraryNotInitializedException", "Библиотека не была инициализирована", null)
        } catch (e: Exception) {
          result.error("UnexpectedException", e.localizedMessage, e.message)
        }
      }

      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity as FlutterFragmentActivity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity as FlutterFragmentActivity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }
}
