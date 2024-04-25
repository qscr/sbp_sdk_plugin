import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sbp_sdk_plugin/sbp_sdk_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSbpSdkPlugin platform = MethodChannelSbpSdkPlugin();
  const MethodChannel channel = MethodChannel('sbp_sdk_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return true;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('init', () async {
    expect(await platform.init(), true);
  });
}
