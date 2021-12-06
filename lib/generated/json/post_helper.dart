import 'package:game_circle/common/post.dart';

postFromJson(Post data, Map<String, dynamic> json) {
	if (json['postID'] != null) {
		data.postID = json['postID'] is String
				? int.tryParse(json['postID'])
				: json['postID'].toInt();
	}
	if (json['postTitle'] != null) {
		data.postTitle = json['postTitle'].toString();
	}
	if (json['poster'] != null) {
		data.poster = json['poster'].toString();
	}
	if (json['postContent'] != null) {
		data.postContent = json['postContent'].toString();
	}
	if (json['postTime'] != null) {
		data.postTime = json['postTime'].toString();
	}
	if (json['postCircle'] != null) {
		data.postCircle = json['postCircle'] is String
				? int.tryParse(json['postCircle'])
				: json['postCircle'].toInt();
	}
	return data;
}

Map<String, dynamic> postToJson(Post entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['postID'] = entity.postID;
	data['postTitle'] = entity.postTitle;
	data['poster'] = entity.poster;
	data['postContent'] = entity.postContent;
	data['postTime'] = entity.postTime;
	data['postCircle'] = entity.postCircle;
	return data;
}