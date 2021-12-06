class User {
  final int userID;

  final String userName;
  final String userPassword;
  final String userPhoneNumber;
  final bool userState;

  User({
    required this.userID,
    required this.userName,
    required this.userPassword,
    required this.userPhoneNumber,
    required this.userState,
  });

}

//规定200为真，400为假
class Result {
  final int code;

  Result({
    required this.code,
});
}