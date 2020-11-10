import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "IS_LOGGED_IN";
  static String sharedPreferenceUserIDLoggedInKey = "IS_USER_LOGGED_IN";
  static String sharedPreferenceUserNameKey = "USER_NAME_KEY";
  static String sharedPreferenceUserEmailKey = "USER_EMAIL_KEY";
  static String sharedPreferenceUserIDKey = "USER_ID_KEY";

  //saving data to SharedPreference

  static Future<bool> setUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> setUserNameSharedPreference(String userName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> setUserIDSharedPreference(String userName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        sharedPreferenceUserIDKey, userName);
  }

  static Future<bool> setUserEmailSharedPreference(String userEmail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        sharedPreferenceUserEmailKey, userEmail);
  }

  //getting data from SharedPreference
  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserIDSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getString(sharedPreferenceUserIDKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getString(sharedPreferenceUserEmailKey);
  }
}
