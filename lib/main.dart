import 'dart:convert';
import 'dart:ui';
import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_circle/screen/Discover.dart';
import 'package:game_circle/screen/Home.dart';
import 'package:game_circle/screen/Information.dart';
import 'screen/register.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'common/Global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  realRunApp();
}
void realRunApp() async {
  await Global.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Circle',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: '我的游戏圈'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Dio dio = Dio();

  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _buttonFocus = FocusNode();

  //页面索引
  int CurrentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Global.loginState
        ? Scaffold(
                body: IndexedStack(
                  index: CurrentIndex,
                  children: [
                    HomePage(),
                    DiscoverPage(),
                    InformationPage(refreshParent: () {
                      _refreshParent();
                    }),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.green,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white70,
                  currentIndex: CurrentIndex,
                  onTap: (index) => setState(() => CurrentIndex = index),
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.gamepad_outlined),
                      label: "游戏圈",
                    ),
                    BottomNavigationBarItem(
                      label: "发现",
                      icon: Icon(Icons.search),
                    ),
                    BottomNavigationBarItem(
                      label: "我的",
                      icon: Icon(Icons.person),
                    ),
                  ],
                ), // This trailing comma makes auto-formatting nicer for build methods.
              )
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            //点击空白处收起键盘
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
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
                          color: Colors.green[100],
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
                                      focusNode: _buttonFocus,
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(_buttonFocus);
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
            )),
          );
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
      Response userInfo;
      userInfo = await dio
          .get(Global.serverAddress + "/api/user/" + _usernameController.text);
      Map<String, dynamic> loginUser = json.decode(userInfo.toString());
      await Global.saveUser(loginUser);
      setState(() {
        Global.loginState = true;
      });
      await Global.saveLoginState();
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

  _refreshParent() {
    setState(() {});
  }
}
