

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webview_suit/modules/suit_controller.dart';
import 'package:webview_suit/webview_suit.dart';
import 'package:event_bus/event_bus.dart';

class SelfPlugin extends PluginInterface {

  SuitController suitController;
  EventBus eventBus = EventBus();

  SelfPlugin(this.suitController) {
    register("self", true);
  }

  @override
  void onMessageReceived(AppMessage msg) {
    eventBus.fire(msg);
  }

  @override
  State<StatefulWidget> createState() {
    return SelfPluginState(eventBus);
  }
}

class SelfPluginState extends State<SelfPlugin> {
  String text = 'SelfPluginState';
  EventBus eventBus;

  SelfPluginState(this.eventBus) {
    eventBus.on<AppMessage>().listen((msg) {
      switch (msg.method) {
        case 'print':
          debugPrint(msg.data);
          setState(() {
            text = msg.data ?? '';
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Text(this.text),
      bottom: 0,
      right: 20,
    );
  }
}