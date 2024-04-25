import 'package:flutter_test/flutter_test.dart';
import 'package:sbp_sdk_plugin/models/sbp_widget_bank.dart';
import 'package:sbp_sdk_plugin/sbp_sdk_plugin.dart';
import 'package:sbp_sdk_plugin/sbp_sdk_plugin_platform_interface.dart';
import 'package:sbp_sdk_plugin/sbp_sdk_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSbpSdkPluginPlatform
    with MockPlatformInterfaceMixin
    implements SbpSdkPluginPlatform {
  @override
  Future<bool> init() => Future.value(true);

  @override
  Future<void> showModal(String url) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<List<SBPWidgetBank>> getBankList(String url) {
    throw UnimplementedError();
  }
}

void main() {
  final SbpSdkPluginPlatform initialPlatform = SbpSdkPluginPlatform.instance;

  test('$MethodChannelSbpSdkPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSbpSdkPlugin>());
  });

  test('init', () async {
    MockSbpSdkPluginPlatform fakePlatform = MockSbpSdkPluginPlatform();
    SbpSdkPluginPlatform.instance = fakePlatform;

    expect(await SbpSdkPlugin.init(), true);
  });
}
