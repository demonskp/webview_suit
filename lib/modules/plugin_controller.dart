import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_suit/modules/app_message.dart';
import 'package:webview_suit/utils/path_util.dart';

class PluginController {
  WebViewController webController;
  String bridgeName;
  BuildContext context;

  PluginController(this.context, this.webController, this.bridgeName);

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
}
