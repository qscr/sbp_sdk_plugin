import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sbp_sdk_plugin/models/sbp_widget_bank.dart';

import 'sbp_sdk_plugin_method_channel.dart';

abstract class SbpSdkPluginPlatform extends PlatformInterface {
  /// Constructs a SbpSdkPluginPlatform.
  SbpSdkPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static SbpSdkPluginPlatform _instance = MethodChannelSbpSdkPlugin();

  /// The default instance of [SbpSdkPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelSbpSdkPlugin].
  static SbpSdkPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SbpSdkPluginPlatform] when
  /// they register themselves.
  static set instance(SbpSdkPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> init() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> showModal(String url) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List<SBPWidgetBank>> getBankList(String url) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
