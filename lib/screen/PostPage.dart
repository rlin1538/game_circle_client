import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_circle/common/Global.dart';
import 'package:game_circle/common/user_collection.dart';

class PostPage extends StatefulWidget {
  PostPage({Key? key, required this.game}) : super(key: key);
  GameCircle game;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Dio dio=Dio();

  var _titleController = TextEditingController();

  var _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("撰写帖子"),
        actions: [
          IconButton(onPressed: (){
            _sendPost();
            Navigator.pop(context);
          }, icon: Icon(Icons.send),),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "输入帖子主题",
                labelText: "帖子主题",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "输入帖子内容",
                labelText: "帖子内容",
                border: OutlineInputBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }

  _sendPost() async {
    Response response;
    print("发送请求");
    response = await dio.post(
      Global.serverAddress + "/api/post/add",
      data: {
        "postTitle": _titleController.text,
        "poster": Global.localUser!.userName,
        "postContent": _contentController.text,
        "postCircle": widget.game.gameCircleID,
        "postTime": "2021-11-29 22:23:54"
      },
    );
    print(response.data);
    Map<String, dynamic> r = json.decode(response.toString());
    if (r["code"] == 200) {
      Fluttertoast.showToast(msg: "发送成功");
    } else {
      Fluttertoast.showToast(msg: "发送失败");
    }
  }
}