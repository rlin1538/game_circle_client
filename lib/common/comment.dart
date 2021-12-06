import 'package:game_circle/generated/json/base/json_convert_content.dart';

class Comment with JsonConvert<Comment> {
	late int commentID;
	late String userName;
	late int postID;
	late String publishTime;
	late String commentContent;
}
