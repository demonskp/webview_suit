import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_suit/interface/plugin_interface.dart';
import 'package:webview_suit/modules/app_message.dart';
import 'package:webview_suit/modules/child_app.dart';
import 'package:webview_suit/modules/suit_controller.dart';

typedef SuitCreateFun = void Function(SuitController suitController);

typedef PluginsBuilder = List<PluginInterface> Function(
    SuitController suitController);

typedef MainAppBuilder = Future<ChildApp> Function();

class WebViewSuitWidget extends StatefulWidget {
  String name;

  SuitCreateFun? onSuitCreate;

  WebViewSuitWidget(this.name, {Key? key, this.onSuitCreate}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WebViewSuitWidgetState();
  }
}

class WebViewSuitWidgetState extends State<WebViewSuitWidget> {
  // WebViewController? _webController;
  List<PluginInterface> plugins = [];
  List<Widget> pluginWidgets = [];

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

  loadPlugins(List<PluginInterface> plugins) {
    setState(() {
      this.plugins = plugins;
      for (var element in this.plugins) {
        if (element.hasUI) {
          pluginWidgets.add(element);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        WebView(
          javascriptChannels: <JavascriptChannel>{_jsChan(context)},
          onWebViewCreated: (WebViewController webController) {
            _webController = webController;
            var suitController = SuitController(
                context, webController, widget.name, loadPlugins);
            if (widget.onSuitCreate is! Null) {
              widget.onSuitCreate!(suitController);
            }
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
        ...pluginWidgets,
      ],
    );
  }
}
