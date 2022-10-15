import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_suit/interface/plugin_interface.dart';
import 'package:webview_suit/modules/app_message.dart';
import 'package:webview_suit/modules/child_app.dart';
import 'package:webview_suit/modules/plugin_controller.dart';

typedef PluginsBuilder = List<PluginInterface> Function(
    PluginController pController);

typedef MainAppBuilder = Future<ChildApp> Function();

class WebViewSuitWidget extends StatefulWidget {
  String name;

  PluginsBuilder? pluginsBuilder;

  MainAppBuilder mainAppBuilder;

  WebViewSuitWidget(this.name, {Key? key, this.pluginsBuilder, required this.mainAppBuilder}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WebViewSuitWidgetState();
  }
}

class WebViewSuitWidgetState extends State<WebViewSuitWidget> {
  WebViewController? _webController;
  List<PluginInterface> plugins = [];

  JavascriptChannel _jsChan(BuildContext context) => JavascriptChannel(
      name: widget.name,
      onMessageReceived: (JavascriptMessage msg) {
        var appMsg = appMessageFromJson(msg.message);
        msgReceived(appMsg);
      });

  void msgReceived(AppMessage msg) {
    debugPrint("debugPrint:");
    debugPrint(msg.toString());
    for (var plugin in plugins) {
      if (msg.package == plugin.name) {
        plugin.onMessageReceived(msg);
      }
    }
  }

  _loadHtmlFromAssets() async {
    var app = await widget.mainAppBuilder();
    // await app.init();
    var indexPath = app.indexPath;
    _webController?.loadFile("file://$indexPath");
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptChannels: <JavascriptChannel>{_jsChan(context)},
      onWebViewCreated: (WebViewController webController) {
        _webController = webController;
        var pController = PluginController(context, webController, widget.name);
        if (widget.pluginsBuilder is! Null) {
          plugins = widget.pluginsBuilder!(pController);
        }
        _loadHtmlFromAssets();
      },
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
