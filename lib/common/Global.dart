import 'package:shared_preferences/shared_preferences.dart';

import 'Entity.dart';

class Global {
  static late SharedPreferences _prefs;
  static var loginState=false;
  static User? localUser;
  static String serverAddress = "http://23.234.201.149:8080";
  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool("loginState") != null) {
      loginState = _prefs.getBool("loginState")!;
    }
    if (loginState == true) {
      localUser = User(
        userID: _prefs.getInt("userID")!,
        userName: _prefs.getString("userName").toString(),
        userPassword: _prefs.getString("userPassword").toString(),
        userPhoneNumber: _prefs.getString("userPhoneNumber").toString(),
        userState: _prefs.getBool("userState").toString()=="true",
      );
    }
    print("登录状态为$loginState");
  }
  static Future<bool> getLoginState() async {
    await init();
    return loginState;
  }

  static Future saveLoginState() async {
    _prefs.setBool("loginState", loginState);
  }

  static saveUser(var u) async {
    localUser = User(
      userID: u["userID"],
      userName: u["userName"],
      userPassword: u["userPassword"],
      userPhoneNumber: u["userPhoneNumber"],
      userState: u["userState"],
    );
    _prefs.setInt("userID", u["userID"]);
    _prefs.setString("userName", u["userName"]);
    _prefs.setString("userPhoneNumber", u["userPhoneNumber"]);
    _prefs.setString("userPassword", u["userPassword"]);
    _prefs.setBool("userState", u["userState"]);
  }
  static save() async {
    _prefs.setInt("userID", localUser!.userID);
    _prefs.setString("userName", localUser!.userName);
    _prefs.setString("userPhoneNumber", localUser!.userPhoneNumber);
    _prefs.setString("userPassword", localUser!.userPassword);
    _prefs.setBool("userState", localUser!.userState);
  }
}
