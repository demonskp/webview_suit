
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static SharedPreferences? instance;

  static Future<SharedPreferences> init() async {
    if(instance == null){
      var pref = await SharedPreferences.getInstance();
      instance = pref;
    }

    return instance!;
  }
}
