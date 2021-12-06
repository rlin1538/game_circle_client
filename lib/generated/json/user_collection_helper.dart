import 'package:game_circle/common/user_collection.dart';

userCollectionFromJson(UserCollection data, Map<String, dynamic> json) {
	if (json['collectionID'] != null) {
		data.collectionID = json['collectionID'] is String
				? double.tryParse(json['collectionID'])
				: json['collectionID'].toDouble();
	}
	if (json['userID'] != null) {
		data.userID = json['userID'] is String
				? double.tryParse(json['userID'])
				: json['userID'].toDouble();
	}
	if (json['gameCircle'] != null) {
		data.gameCircle = GameCircle().fromJson(json['gameCircle']);
	}
	return data;
}

Map<String, dynamic> userCollectionToJson(UserCollection entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['collectionID'] = entity.collectionID;
	data['userID'] = entity.userID;
	data['gameCircle'] = entity.gameCircle.toJson();
	return data;
}

gameCircleFromJson(GameCircle data, Map<String, dynamic> json) {
	if (json['gameCircleID'] != null) {
		data.gameCircleID = json['gameCircleID'] is String
				? double.tryParse(json['gameCircleID'])
				: json['gameCircleID'].toDouble();
	}
	if (json['gameCircleTitle'] != null) {
		data.gameCircleTitle = json['gameCircleTitle'].toString();
	}
	if (json['gameCircleContent'] != null) {
		data.gameCircleContent = json['gameCircleContent'].toString();
	}
	if (json['gameCirclePicture'] != null) {
		data.gameCirclePicture = json['gameCirclePicture'].toString();
	}
	return data;
}

Map<String, dynamic> gameCircleToJson(GameCircle entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['gameCircleID'] = entity.gameCircleID;
	data['gameCircleTitle'] = entity.gameCircleTitle;
	data['gameCircleContent'] = entity.gameCircleContent;
	data['gameCirclePicture'] = entity.gameCirclePicture;
	return data;
}