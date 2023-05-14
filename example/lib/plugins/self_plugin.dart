

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webview_suit/modules/suit_controller.dart';
import 'package:webview_suit/webview_suit.dart';
import 'package:webview_suit_example/Plugins/self_plugin.dart';

class SelfPlugin extends PluginInterface {

  SuitController suitController;

  SelfPlugin(this.suitController) {
    register("self", true);
  }

  @override
  void onMessageReceived(AppMessage msg) {
    switch (msg.method) {
      case 'print':
        debugPrint(msg.data);
        break;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return SelfPluginState();
  }
}

class SelfPluginState extends State<SelfPlugin> {
  String text = 'SelfPluginState';

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Text(this.text),
      bottom: 0,
      right: 20,
    );
  }
}