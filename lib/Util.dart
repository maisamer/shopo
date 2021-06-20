import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopo/model/Product.dart';

class Util{
  static void saveTOSharedPreferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }


}