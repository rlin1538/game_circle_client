import 'package:game_circle/common/comment.dart';

commentFromJson(Comment data, Map<String, dynamic> json) {
	if (json['commentID'] != null) {
		data.commentID = json['commentID'] is String
				? int.tryParse(json['commentID'])
				: json['commentID'].toInt();
	}
	if (json['userName'] != null) {
		data.userName = json['userName'].toString();
	}
	if (json['postID'] != null) {
		data.postID = json['postID'] is String
				? int.tryParse(json['postID'])
				: json['postID'].toInt();
	}
	if (json['publishTime'] != null) {
		data.publishTime = json['publishTime'].toString();
	}
	if (json['commentContent'] != null) {
		data.commentContent = json['commentContent'].toString();
	}
	return data;
}

Map<String, dynamic> commentToJson(Comment entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['commentID'] = entity.commentID;
	data['userName'] = entity.userName;
	data['postID'] = entity.postID;
	data['publishTime'] = entity.publishTime;
	data['commentContent'] = entity.commentContent;
	return data;
}