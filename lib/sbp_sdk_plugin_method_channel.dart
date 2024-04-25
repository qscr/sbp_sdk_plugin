import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sbp_sdk_plugin/models/sbp_widget_bank.dart';

import 'sbp_sdk_plugin_platform_interface.dart';

/// An implementation of [SbpSdkPluginPlatform] that uses method channels.
class MethodChannelSbpSdkPlugin extends SbpSdkPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sbp_sdk_plugin');

  @override
  Future<bool> init() async {
    final isInit = await methodChannel.invokeMethod<bool>('init');
    return isInit ?? false;
  }

  @override
  Future<void> showModal(String url) async {
    await methodChannel.invokeMethod('showModal', url);
  }

  @override
  Future<List<SBPWidgetBank>> getBankList(String url) async {
    final response =
        await methodChannel.invokeMethod<String>('getBankList', url);
    if (response?.isEmpty ?? true) {
      return [];
    }
    final responseMap = jsonDecode(response!) as List<dynamic>;
    return responseMap.map((e) => SBPWidgetBank.fromJson(e)).toList();
  }
}
