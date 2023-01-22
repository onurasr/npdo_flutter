import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //anahtarlar
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userAdminKey = "USERADMINKEY";

  // SF'ye bilgi kaydetme

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserAdminSf(bool userAdmin) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userAdminKey, userAdmin);
  }

  //  SF'den bilgi getirme

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey) ?? false;
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<bool?> getUserAdminFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userAdminKey) ?? false;
  }
}
