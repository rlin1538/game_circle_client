import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:game_circle/common/post.dart';
import 'package:game_circle/common/comment.dart';
import 'package:game_circle/screen/ChangeInfo.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_circle/common/Global.dart';
import 'package:game_circle/common/user_collection.dart';

class InformationPage extends StatefulWidget {
  final refreshParent;
  const InformationPage({Key? key, this.refreshParent}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _InformationPageState();
  }
}

class _InformationPageState extends State<InformationPage> {
  var _tabs = <String>[
    "加入的游戏圈",
    "发送的帖子",
    "发送的评论",
  ];
  List<UserCollection> _gamecircle = [];
  List<Post> _posts = [];
  List<Comment> _comments = [];

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text("我的"),
              centerTitle: true,
              expandedHeight: 280,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Image.asset(
                        "assets/images/login.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.accents[
                                      (Global.localUser!.userName.hashCode *
                                              6) %
                                          Colors.accents.length],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(4.0, 4.0),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 80,
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (e) {
                                      return ChangeInfoPage();
                                    })).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Text(
                                    "修改资料",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  Global.localUser!.userName,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  Global.localUser!.userPhoneNumber,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            top: 4.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  "游戏人生",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () {
                    Global.loginState = false;
                    Global.saveLoginState();
                    widget.refreshParent();
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
            SliverPersistentHeader(
              delegate: _SliverAppbarDelegate(
                TabBar(
                  tabs: _tabs.map((e) {
                    return Tab(
                      text: e,
                    );
                  }).toList(),
                  isScrollable: false,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.black,
                  indicatorColor: Colors.green,
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(children: [
          ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: _gamecircle.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Image.network(
                      _gamecircle[index].gameCircle.gameCirclePicture),
                ),
                title: Text(
                  _gamecircle[index].gameCircle.gameCircleTitle,
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  _gamecircle[index].gameCircle.gameCircleContent,
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
          ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: _posts.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  _posts[index].postTitle,
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _posts[index].postContent,
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
          ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: _comments.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  _comments[index].commentContent,
                  style: TextStyle(color: Colors.black),
                ),
              );
            },
          ),
        ]),
      )),
    );
  }

  _refresh() async {
    final res = await http.get(Uri.parse(Global.serverAddress +
        "/api/user/" +
        Global.localUser!.userID.toString() +
        "/collection"));
    final gamecircle = json.decode(res.body);
    final res2 = await http.get(Uri.parse(Global.serverAddress +
        "/api/user/" +
        Global.localUser!.userName +
        "/post"));
    final posts = json.decode(res2.body);
    final res3 = await http.get(Uri.parse(Global.serverAddress +
        "/api/user/" +
        Global.localUser!.userName +
        "/comment"));
    final comments = json.decode(res3.body);
    setState(() {
      _gamecircle = gamecircle.map<UserCollection>((e) {
        return UserCollection().fromJson(e);
      }).toList();
      _posts = posts.map<Post>((e) {
        return Post().fromJson(e);
      }).toList();
      _comments = comments.map<Comment>((e) {
        return Comment().fromJson(e);
      }).toList();
    });
  }
}

class _SliverAppbarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppbarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => tabBar.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
