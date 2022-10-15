import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathUtil {
  static Future<Directory> getMainDir() async {
    Directory docDir = await getApplicationDocumentsDirectory();

    return docDir;
  }

  static Future<Directory> getTempDir() async {
    Directory tempDir = await getTemporaryDirectory();

    return tempDir;
  }
}
