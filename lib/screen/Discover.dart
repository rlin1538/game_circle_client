import 'dart:convert' as convert;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_circle/common/Global.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_circle/common/user_collection.dart';

import 'GameCirclePage.dart';

class DiscoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DiscoverPageState();
  }
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<GameCircle> _gamecircles = [];
  var _searchController = TextEditingController();
  var _gameNameController = TextEditingController();
  var _gameContentController = TextEditingController();
  var _gamePictureController = TextEditingController();
  Dio dio = Dio();
  var _searchFocusNode = FocusNode();

  @override
  void initState() {
    _refresh(Global.serverAddress + "/api/gamecircle");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("发现游戏圈"),
          actions: [
            Global.localUser!.userState
                ? IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text("添加游戏圈"),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "输入游戏名",
                                      labelText: "游戏名",
                                      border: OutlineInputBorder(),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    controller: _gameNameController,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "输入游戏简介",
                                      labelText: "游戏简介",
                                      border: OutlineInputBorder(),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    controller: _gameContentController,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "输入游戏封面Url",
                                      labelText: "游戏封面",
                                      border: OutlineInputBorder(),
                                    ),
                                    textInputAction: TextInputAction.done,
                                    controller: _gamePictureController,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            print(_gameNameController
                                                .text.hashCode);
                                            Navigator.pop(context);
                                          },
                                          child: Text("取消")),
                                      TextButton(
                                          onPressed: () async {
                                            Response response;
                                            response = await dio.post(
                                              Global.serverAddress+"/api/gamecircle/add",
                                              data: {
                                                "gameCircleID":
                                                    _gameNameController
                                                        .text.hashCode,
                                                "gameCircleTitle":
                                                    _gameNameController.text,
                                                "gameCircleContent":
                                                    _gameContentController.text,
                                                "gameCirclePicture":
                                                    _gamePictureController.text
                                              },
                                            );
                                            Map<String, dynamic> r = json
                                                .decode(response.toString());
                                            if (r["code"] == 200) {
                                              Fluttertoast.showToast(
                                                msg: "添加成功",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } else
                                              Fluttertoast.showToast(
                                                msg: "添加失败",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            setState(() { _refresh(Global.serverAddress + "/api/gamecircle");});
                                            Navigator.pop(context);
                                          },
                                          child: Text("确认")),
                                    ],
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.add),
                  )
                : Container(),
          ],
        ),
        body: Scrollbar(
          child: RefreshIndicator(
            onRefresh: () async {
              _refresh(Global.serverAddress + "/api/gamecircle");
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 8,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (s) {
                          if ("" == s) {
                            _refresh(Global.serverAddress + "/api/gamecircle/");
                          } else {
                            _refresh(
                                Global.serverAddress + "/api/gamecircle/" + s);
                          }
                        },
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: "输入游戏名",
                          labelText: "点此搜索",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(8),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 10,
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              print("进入" + _gamecircles[index].gameCircleTitle);
                              _enterCircle(_gamecircles[index]);
                              _searchFocusNode.unfocus();
                            },
                            onLongPress: () {
                              if (Global.localUser!.userState)
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("删除游戏圈"),
                                      content: Text("是否要删除该游戏圈？"),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("取消")),
                                        TextButton(
                                            onPressed: () async {
                                              Response response;
                                              response = await dio.post(
                                                Global.serverAddress+"/api/gamecircle/delete",
                                                data: {
                                                  "gameCircleID":
                                                      _gamecircles[index]
                                                          .gameCircleID,
                                                  "gameCircleTitle":
                                                      _gamecircles[index]
                                                          .gameCircleTitle,
                                                  "gameCircleContent":
                                                      _gamecircles[index]
                                                          .gameCircleContent,
                                                  "gameCirclePicture":
                                                      _gamecircles[index]
                                                          .gameCirclePicture
                                                },
                                              );
                                              Map<String, dynamic> r = json
                                                  .decode(response.toString());
                                              if (r["code"] == 200) {
                                                Fluttertoast.showToast(
                                                  msg: "删除成功",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              } else
                                                Fluttertoast.showToast(
                                                  msg: "删除失败",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              setState(() {_refresh(Global.serverAddress + "/api/gamecircle");});
                                              Navigator.pop(context);
                                            },
                                            child: Text("确认")),
                                      ],
                                    );
                                  });
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Image.network(
                                    _gamecircles[index].gameCirclePicture,
                                    width: double.maxFinite,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5)),
                                          color: Colors.black45),
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(
                                        _gamecircles[index].gameCircleTitle,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: _gamecircles.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 3 / 4),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _enterCircle(GameCircle gameCircle) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return GameCirclePage(game: gameCircle);
    }));
  }

  _refresh(String url) async {
    final res = await http.get(Uri.parse(url));
    final json = convert.jsonDecode(res.body);
    final gamecircle = json.map<GameCircle>((row) {
      return GameCircle().fromJson(row);
    }).toList();

    setState(() {
      _gamecircles = gamecircle;
    });
  }
}
