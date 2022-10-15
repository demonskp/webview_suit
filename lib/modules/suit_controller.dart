import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_suit/modules/app_message.dart';
import 'package:webview_suit/modules/child_app.dart';
import 'package:webview_suit/utils/path_util.dart';

import '../interface/plugin_interface.dart';

typedef LoadPluginsFun = Function(List<PluginInterface> plugins);

class SuitController {
  WebViewController webController;
  String bridgeName;
  BuildContext context;
  LoadPluginsFun onLoadPlugins;

  SuitController(
      this.context, this.webController, this.bridgeName, this.onLoadPlugins);

  void success(AppMessage msg, Map<String, String>? data) {
    var executeStr = _jsStrBuild(msg, "success", data);
    debugPrint(executeStr);
    webController.runJavascriptReturningResult(executeStr);
  }

  void err(AppMessage msg, Map<String, String>? data) {
    var executeStr = _jsStrBuild(msg, "err", data);
    webController.runJavascriptReturningResult(executeStr);
  }

  String _jsStrBuild(AppMessage msg, String funName,
      Map<String, String>? data) {
    String jsStr =
        "${bridgeName}['${msg.funid}'].${funName}(${jsonEncode(data)})";
    return jsStr;
  }

  BuildContext getAppBuildContext() {
    return context;
  }

  Future<Directory> getTemplateDir() async {
    var dir = await PathUtil.getTempDir();
    return dir;
  }

  void loadPlugins(List<PluginInterface> plugins) {
    onLoadPlugins(plugins);
  }

  Future<void> loadApp(ChildApp childApp) async {
    var indexPath = childApp.indexPath;
    await webController.loadFile("file://$indexPath");
  }

  Future<void> loadUrl(
    String url,
    Map<String, String>? headers,
  ) async {
    await webController.loadUrl(url, headers: headers);
  }
}
