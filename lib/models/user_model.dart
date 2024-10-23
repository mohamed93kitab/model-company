//Class For Subject
class UserModel {
  var text;
  var author;
  UserModel({
     this.text,
     this.author,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      text: json['text'],
      author: json['author'],
    );
  }
}