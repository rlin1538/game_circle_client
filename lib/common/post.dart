import 'package:game_circle/generated/json/base/json_convert_content.dart';

class Post with JsonConvert<Post> {
	late int postID;
	late String postTitle;
	late String poster;
	late String postContent;
	late String postTime;
	late int postCircle;
}
