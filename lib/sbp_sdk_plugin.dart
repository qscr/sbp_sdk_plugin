import 'package:sbp_sdk_plugin/models/sbp_widget_bank.dart';

import 'sbp_sdk_plugin_platform_interface.dart';

class SbpSdkPlugin {
  static bool _isInit = false;

  static bool get isInit => _isInit;

  static Future<bool> init() async {
    _isInit = await SbpSdkPluginPlatform.instance.init();
    return _isInit;
  }

  static Future<void> showModal(String url) async {
    await SbpSdkPluginPlatform.instance.showModal(url);
  }

  static Future<List<SBPWidgetBank>> getBankList(String url) async {
    return SbpSdkPluginPlatform.instance.getBankList(url);
  }
}
