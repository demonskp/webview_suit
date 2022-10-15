import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:webview_suit/utils/path_util.dart';

class ChildApp {
  String name = "";
  late Directory dir;
  String indexPath = "";

  ChildApp(this.name);

  static Future<ChildApp> autoCreate(String name, String zipAssetPath) async {
    var byteData = await rootBundle.load("assets/client/client.zip");
    var unit8List = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    var app = ChildApp(name);
    await app.init();
    app.create(unit8List);
    return app;
  }

  Future<void> init() async {
    var appDir = await _createDirectory();
    indexPath = '${appDir.path}/index.html';
  }

  Future<Directory> _createDirectory() async {
    Directory mainDir = await PathUtil.getMainDir();
    Directory pathDir = Directory(path.join(mainDir.path, name));

    if (!pathDir.existsSync()) {
      pathDir.create(recursive: true);
    }
    dir = pathDir;
    return dir;
  }

  void create(List<int> bytes) {
    Archive archive = ZipDecoder().decodeBytes(bytes);
    for (ArchiveFile file in archive) {
      if (file.isFile) {
        List<int> tempData = file.content;
        File f = File("${dir.path}/${file.name}")
          ..createSync(recursive: true)
          ..writeAsBytesSync(tempData);

        debugPrint("解压后的文件路径 = ${f.path}");
      } else {
        Directory("${dir.path}/${file.name}").create(recursive: true);
      }
    }
  }
}
