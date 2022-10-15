import 'package:flutter_test/flutter_test.dart';
import 'package:webview_suit/webview_suit.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  final WebViewSuitWidget instance = WebViewSuitWidget("xxx");

  test('$instance is the default instance', () {
    expect(instance, isInstanceOf<WebViewSuitWidget>());
  });

}
