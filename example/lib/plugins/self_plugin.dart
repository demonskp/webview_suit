

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webview_suit/modules/suit_controller.dart';
import 'package:webview_suit/webview_suit.dart';

class SelfPlugin extends PluginInterface {

  SuitController suitController;

  SelfPlugin(this.suitController) {
    register("self", false);
  }

  @override
  Widget buildWidget() {
    return Text("self plugins");
  }

  @override
  void onMessageReceived(AppMessage msg) {
    switch(msg.method) {
      case 'print':
        debugPrint(msg.data);
        break;
    }
  }

}