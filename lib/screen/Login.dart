import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_circle/main.dart';
import 'register.dart';

import '../common/Global.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  Dio dio = Dio();

  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/images/login.jpg",
              fit: BoxFit.cover,
            ),
          ),
          ClipRect(
            //高斯模糊
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Opacity(
                opacity: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: 0.7,
              child: Container(
                width: 300.0,
                height: 400.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.purple[100],
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(-6.0, 6.0), //阴影x轴偏移量
                        blurRadius: 10, //阴影模糊程度
                        spreadRadius: 5 //阴影扩散程度
                        )
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 300.0,
              height: 400.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      child: Text(
                        "登录",
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "输入用户名",
                          labelText: "帐号",
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: "输入密码",
                          labelText: "密码",
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (temp) {
                          _login();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _login();
                              },
                              child: Text("登 录"),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new RegisterScreen()),
                                );
                              },
                              child: Text("注 册"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  _login() async {
    print(_usernameController.text);
    print(_passwordController.text);
    Response response;
    response = await dio.post(
      Global.serverAddress + "/api/login",
      data: {
        "userName": _usernameController.text,
        "userPassword": _passwordController.text
      },
    );
    Map<String, dynamic> r = json.decode(response.toString());
    if (r["code"] == 200) {
      setState(() {
        print("登录成功");
        Fluttertoast.showToast(
          msg: "登录成功！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Global.loginState = true;
      });
      Response userInfo;
      userInfo = await dio
          .get(Global.serverAddress + "/api/user/" + _usernameController.text);
      Map<String, dynamic> loginUser = json.decode(userInfo.toString());
      Global.saveUser(loginUser);
      Global.saveLoginState();
    } else {
      print("登陆失败");
      Fluttertoast.showToast(
        msg: "登录失败，请检查帐号或密码",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
