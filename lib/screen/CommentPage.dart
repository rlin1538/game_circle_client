import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_circle/common/Global.dart';

import 'package:game_circle/common/post.dart';
import 'package:game_circle/common/comment.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<Comment> _comments = [];
  var _commentController = TextEditingController();
  Dio dio = Dio();
  var _commentFocusNode = FocusNode();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          widget.post.postTitle,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.accents[
                                (widget.post.poster.hashCode * 6) %
                                    Colors.accents.length],
                          ),
                          child: Icon(
                            Icons.person,
                            size: 40,
                          ),
                        ),
                        title: Text(widget.post.poster),
                        subtitle: Text("1楼 - " + widget.post.postTime),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          widget.post.postContent,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 10,
                width: double.maxFinite,
                color: Colors.black12,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      child: Column(
                        children: [
                          ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.accents[
                                      (_comments[index].userName.hashCode * 6) %
                                          Colors.accents.length],
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                ),
                              ),
                              title: Text(_comments[index].userName),
                              subtitle: Text((index + 2).toString() +
                                  "楼 - " +
                                  _comments[index].publishTime),
                              trailing: Visibility(
                                visible: Global.localUser!.userState || _comments[index].userName==Global.localUser!.userName,
                                  child: IconButton(
                                      onPressed: () {
                                        showDialog(context: context, builder: (context) {
                                          return AlertDialog(
                                            title: Text("删除评论"),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(context), child: Text("取消")),
                                              TextButton(onPressed: () async {
                                                Response response;
                                                response = await dio.post(
                                                  Global.serverAddress+"/api/comment/delete",
                                                  data: {
                                                    "commentID": _comments[index].commentID,
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
                                      },
                                      icon: Icon(Icons.delete)))),
                          Row(
                            children: [
                              SizedBox(
                                width: 70,
                              ),
                              Text(_comments[index].commentContent),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _comments.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "暂无更多评论",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                ],
              ),
            )
          ],
        ),
        // bottomNavigationBar: InkWell(
        //   onTap: () {
        //   },
        //   child: Container(
        //     alignment: Alignment.center,
        //     color: Colors.green,
        //     height: 40,
        //     child: Row(
        //       children: [
        //         SizedBox(
        //           width: 10,
        //         ),
        //         Icon(Icons.edit),
        //         SizedBox(
        //           width: 10,
        //         ),
        //         Text(
        //           "写评论",
        //           style: TextStyle(color: Colors.black, fontSize: 18),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        bottomSheet: Container(
          color: Colors.green[300],
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.edit),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  minLines: 1,
                  maxLines: 3,
                  focusNode: _commentFocusNode,
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "输入评论",
                    //labelText: "写评论",
                    border: UnderlineInputBorder(),
                  ),
                ),
              )),
              IconButton(
                onPressed: () {
                  if (_commentController.text != "") _sendComment();
                  _commentFocusNode.unfocus();
                },
                icon: Icon(Icons.send_rounded),
              ),
            ],
          ),
        ));
  }

  _sendComment() async {
    Response response;
    response = await dio.post(
      Global.serverAddress + "/api/comment/add",
      data: {
        "userName": Global.localUser!.userName,
        "postID": widget.post.postID,
        "commentContent": _commentController.text,
      },
    );
    Map<String, dynamic> r = json.decode(response.toString());
    if (r["code"] == 200) {
      _commentController.text = "";
      _refresh();
      setState(() {});
      Fluttertoast.showToast(msg: "发送成功");
    } else {
      Fluttertoast.showToast(msg: "发送失败");
    }
  }

  _refresh() async {
    String url = Global.serverAddress +
        "/api/post/" +
        widget.post.postID.toString() +
        "/comment";
    final res = await http.get(Uri.parse(url));
    final posts = json.decode(res.body);
    setState(() {
      _comments = posts.map<Comment>((e) {
        return Comment().fromJson(e);
      }).toList();
    });
  }
}
