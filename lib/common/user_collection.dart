import 'package:game_circle/generated/json/base/json_convert_content.dart';

class UserCollection with JsonConvert<UserCollection> {
	late double collectionID;
	late double userID;
	late GameCircle gameCircle;
}

class GameCircle with JsonConvert<GameCircle> {
	late double gameCircleID;
	late String gameCircleTitle;
	late String gameCircleContent;
	late String gameCirclePicture;
}
