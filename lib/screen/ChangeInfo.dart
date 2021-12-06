import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_circle/common/Entity.dart';
import 'package:game_circle/common/Global.dart';

class ChangeInfoPage extends StatefulWidget {
  @override
  _ChangeInfoPageState createState() => _ChangeInfoPageState();
}

class _ChangeInfoPageState extends State<ChangeInfoPage> {
  Dio dio=Dio();
  var _phoneController = TextEditingController();
  var _oldPasswordController = TextEditingController();
  var _passwordController = TextEditingController();
  var _password2Controller = TextEditingController();
  String? _passwordError;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("修改信息"),
      ),
      body: Center(
        child: ListView(
          children: [
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
                controller: _oldPasswordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  fillColor: Colors.white,
                  hintText: "输入旧密码",
                  labelText: "旧密码",
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
                  labelText: "新密码",
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
                    _changeInfo();
                  },
                  style: ButtonStyle(),
                  child: Text("修改信息",style: TextStyle(fontSize: 20),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _changeInfo() async {
    if ((_passwordController.text == _password2Controller.text) && (_oldPasswordController.text == Global.localUser!.userPassword)){
      Response response;
      response = await dio.post(
        Global.serverAddress+"/api/change",
        data: {"userID": Global.localUser!.userID,"userName": Global.localUser!.userName,"userPassword": _passwordController.text,"userPhoneNumber": _phoneController.text},
      );
      Map<String, dynamic> r = json.decode(response.toString());
      if (r["code"] == 200) {
        print("修改成功");
        Fluttertoast.showToast(
          msg: "修改成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,);
        Navigator.pop(context);
        User user = User(userID: Global.localUser!.userID, userName: Global.localUser!.userName, userPassword: _passwordController.text, userPhoneNumber: _phoneController.text, userState: Global.localUser!.userState);
        Global.localUser = user;
        await Global.save();
      } else{
        print("修改失败");
        Fluttertoast.showToast(
          msg: "修改失败",
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
