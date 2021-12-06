import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_circle/common/Global.dart';
import 'package:game_circle/screen/CommentPage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_circle/common/user_collection.dart';
import 'package:game_circle/common/post.dart';

import 'PostPage.dart';

class GameCirclePage extends StatefulWidget {
  const GameCirclePage({Key? key, required this.game}) : super(key: key);
  final GameCircle game;

  @override
  State<StatefulWidget> createState() {
    return _GameCirclePageState();
  }
}

class _GameCirclePageState extends State<GameCirclePage> {
  bool _isJoin = false;
  Dio dio = Dio();
  List<Post> _posts = [];

  @override
  void initState() {
    _checkJoin(widget.game);
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () { return _refresh(); },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 10,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.game.gameCircleTitle,
                ),
                background: Hero(
                  tag: widget.game.gameCirclePicture,
                  child: Image.network(
                    widget.game.gameCirclePicture,
                    fit: BoxFit.cover,
                  ),
                ),
                collapseMode: CollapseMode.parallax,
              ),
              expandedHeight: 200,
              floating: false,
              pinned: true,
              snap: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: _isJoin
                        ? Icon(Icons.bookmark_added)
                        : Icon(Icons.bookmark_border),
                    onPressed: () {
                      _joinCircle(widget.game);
                    },
                  ),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 5,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CommentPage(post: _posts[index],);
                        })).then((value) => _refresh());
                      },
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(_posts[index].poster),
                            subtitle: Text(_posts[index].postTime),
                            leading: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.accents[(_posts[index].poster.hashCode * 6) % Colors.accents.length],
                              ),
                              child: Icon(Icons.person,size: 40,),
                            ),
                            trailing: Visibility(
                              visible: (Global.localUser!.userState || _posts[index].poster==Global.localUser!.userName),
                              child: IconButton(onPressed: () async {
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    title: Text("删除帖子"),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context), child: Text("取消")),
                                      TextButton(onPressed: () async {
                                          Response response;
                                          response = await dio.post(
                                            Global.serverAddress+"/api/post/delete",
                                            data: {
                                              "postID": _posts[index].postID,
                                            },
                                          );
                                          Map<String, dynamic> r = json
                                              .decode(response.toString());
                                          if (r["code"] == 200) {
                                            Fluttertoast.showToast(
                                              msg: "删除成功",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          } else
                                            Fluttertoast.showToast(
                                              msg: "删除失败",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          setState(() {
                                            _refresh();
                                          });
                                        Navigator.pop(context);
                                      }, child: Text("确认")),
                                    ],
                                  );
                                });
                              }, icon: Icon(Icons.delete),),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _posts[index].postTitle,
                              style: TextStyle(fontSize: 20),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          //Divider(),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.centerLeft,
                            child: Text(_posts[index].postContent,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _posts.length,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.post_add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PostPage(game: widget.game,);
            })).then((value) => _refresh());
          },
        ),
      ),
    );
  }

  _checkJoin(GameCircle game) async {
    Response response;
    response = await dio.post(
      Global.serverAddress + "/api/user/collection/check",
      data: {
        "userID": Global.localUser!.userID.toString(),
        "gameCircle": game.toJson()
      },
    );
    Map<String, dynamic> r = json.decode(response.toString());
    if (r["code"] == 400) {
      setState(() {
        _isJoin = false;
      });
    } else
      setState(() {
        _isJoin = true;
      });
  }

  _joinCircle(GameCircle game) async {
    if (_isJoin == false) {
      Response response;
      response = await dio.post(
        Global.serverAddress + "/api/user/collection/add",
        data: {
          "userID": Global.localUser!.userID.toString(),
          "gameCircle": game.toJson()
        },
      );
      Map<String, dynamic> r = json.decode(response.toString());
      if (r["code"] == 200) {
        Fluttertoast.showToast(msg: "已加入${game.gameCircleTitle}");
        setState(() {
          _isJoin = !_isJoin;
        });
      } else {
        Fluttertoast.showToast(msg: "加入失败");
      }
    } else {
      Response response;
      response = await dio.post(
        Global.serverAddress + "/api/user/collection/delete",
        data: {
          "userID": Global.localUser!.userID.toString(),
          "gameCircle": game.toJson()
        },
      );
      Map<String, dynamic> r = json.decode(response.toString());
      if (r["code"] == 200) {
        Fluttertoast.showToast(msg: "已退出${game.gameCircleTitle}");
        setState(() {
          _isJoin = !_isJoin;
        });
      } else {
        Fluttertoast.showToast(msg: "退出失败");
      }
    }
  }

  _refresh() async {
    String url = Global.serverAddress +
        "/api/gamecircle/" +
        widget.game.gameCircleID.toInt().toString() +
        "/post";
    final res = await http.get(Uri.parse(url));
    final posts = json.decode(res.body);
    setState(() {
      _posts = posts.map<Post>((e) {
        return Post().fromJson(e);
      }).toList();
    });
  }
}
