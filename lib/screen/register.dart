import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_circle/common/Global.dart';
import 'package:game_circle/main.dart';

class RegisterScreen extends StatefulWidget {

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Dio dio = Dio();

  var _usernameController = TextEditingController();

  var _phoneController = TextEditingController();

  var _passwordController = TextEditingController();

  var _password2Controller = TextEditingController();

  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
              child: Text(
                "注册游戏圈",
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _usernameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  //icon: Icon(Icons.person),
                  prefixIcon: Icon(Icons.person),
                  fillColor: Colors.white,
                  hintText: "输入用户名",
                  labelText: "用户名",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _phoneController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  fillColor: Colors.white,
                  hintText: "输入手机号",
                  labelText: "手机号",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  fillColor: Colors.white,
                  hintText: "设置密码，不少于八位",
                  labelText: "密码",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _password2Controller,
                obscureText: true,
                onChanged: (t) {
                  print("输入框为："+t);
                  if (t != _passwordController.text){
                    setState(() {
                      _passwordError = "两次密码输入不一致";
                    });
                  }
                  else setState(() {
                    _passwordError = null;
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: "重复上诉密码",
                  labelText: "重复密码",
                  border: OutlineInputBorder(),
                  errorText: _passwordError,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0,left: 32,right: 32),
              child: Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _register();
                  },
                  style: ButtonStyle(),
                  child: Text("注 册",style: TextStyle(fontSize: 20),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _register() async {
    if (_passwordController.text ==_password2Controller.text) {
      Response response;
      response = await dio.post(
        Global.serverAddress+"/api/register",
        data: {"userName": _usernameController.text,"userPassword": _passwordController.text,"userPhoneNumber": _phoneController.text},
      );
      Map<String, dynamic> r = json.decode(response.toString());
      if (r["code"] == 200) {
        print("注册成功");
        Fluttertoast.showToast(
          msg: "注册成功，返回登录",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,);
        Navigator.pop(context);
      } else{
        print("注册失败");
        Fluttertoast.showToast(
          msg: "注册失败，此用户名可能已存在",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,);
      }
    }
  }
}
