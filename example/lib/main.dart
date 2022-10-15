import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:webview_suit/webview_suit.dart';
import 'package:webview_suit_example/Plugins/self_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SafeArea(
          child: WebViewSuitWidget(
            "__myJsBridge__",
            mainAppBuilder: () async {
              var byteData = await rootBundle.load("assets/client/client.zip");
              var unit8List = byteData.buffer
                  .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
              var mainApp = ChildApp("main");
              await mainApp.init();
              mainApp.create(unit8List);
              return mainApp;
            },
            pluginsBuilder: (PluginController pController){
              return [SelfPlugin(pController)];
            },
          ),
        ),
      ),
    );
  }
}
