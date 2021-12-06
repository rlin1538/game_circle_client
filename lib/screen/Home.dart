import 'dart:convert' as convert;
import 'package:game_circle/screen/Discover.dart';
import 'package:game_circle/screen/GameCirclePage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_circle/common/Global.dart';
import 'package:game_circle/common/user_collection.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<UserCollection> _collections = [];

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的游戏圈"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh();
        },
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 3 / 4),
          children: _collections.map<Widget>((e) {
            return Card(
              margin: EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 10,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  _enterCircle(e.gameCircle);
                },
                child: Stack(
                  children: [
                    Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      child: Hero(
                        tag: e.gameCircle.gameCirclePicture,
                        child: Image.network(
                          e.gameCircle.gameCirclePicture,
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
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
                            e.gameCircle.gameCircleTitle,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  _refresh() async {
    // Dio dio = Dio();
    // Response response;
    // response = await dio.get(Global.serverAddress+"/api/user/"+Global.localUser!.userID.toString()+"/collection");
    // 此处用DIO有奇怪的问题，无法解析，因此改用http
    final res = await http.get(Uri.parse(Global.serverAddress +
        "/api/user/" +
        Global.localUser!.userID.toString() +
        "/collection"));
    final json = convert.jsonDecode(res.body);
    final collections = json.map<UserCollection>((row) {
      return UserCollection().fromJson(row);
    }).toList();

    setState(() {
      _collections = collections;
    });
  }

  _enterCircle(GameCircle gameCircle) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return GameCirclePage(game: gameCircle);
    })).then((value) => _refresh());
  }
}
