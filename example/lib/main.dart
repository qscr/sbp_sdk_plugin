import 'package:flutter/material.dart';
import 'package:sbp_sdk_plugin/sbp_sdk_plugin.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
              "Библиотека${SbpSdkPlugin.isInit ? '' : ' не'} инициализирована"),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              await SbpSdkPlugin.init();
              setState(() {});
            },
            child: const Text("Инициализировать библиотеку"),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              try {
                await SbpSdkPlugin.showModal(
                    "https://qr.nspk.ru/AS100004BAL7227F9BNP6KNE007J9B3K");
              } catch (e) {
                print(e);
              }
            },
            child: const Text("Показать модалку с оплатой"),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              try {
                final list = await SbpSdkPlugin.getBankList(
                    "https://qr.nspk.ru/AS100004BAL7227F9BNP6KNE007J9B3K");
                if (context.mounted) {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => Material(
                      child: AlertDialog(
                        content: Column(
                          children: list
                              .map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    launchUrlString(e.dboLink);
                                  },
                                  child: Text(
                                    e.name,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        scrollable: true,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Закрыть'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              } catch (e) {
                print(e);
              }
            },
            child: const Text("Получить список банков"),
          ),
        ],
      ),
    );
  }
}
