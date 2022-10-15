import 'package:flutter/material.dart';
import 'package:webview_suit/modules/app_message.dart';

abstract class PluginInterface {
  bool hasUI = false;
  String name = "";

  Widget buildWidget();

  void onMessageReceived(AppMessage msg);

  void register(String name, bool hasUI) {
    this.name = name;
    this.hasUI = hasUI;
  }
}
