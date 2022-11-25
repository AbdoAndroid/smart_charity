import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String name;
  late String username;
  late String mobile;
  late bool isCharity;
  late String password;
  String? charityNumber;
  User(
      {required this.name,
      required this.username,
      required this.mobile,
      required this.isCharity,
      this.charityNumber,
      required this.password});
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'mobile': mobile,
      'isCharity': isCharity,
      'password': password,
      'charityNumber': charityNumber
    };
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    return User.fromJson(snapshot.data() as Map<String, dynamic>);
  }
  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        name: map['name'],
        username: map['username'],
        mobile: map['mobile'],
        isCharity: map['isCharity'],
        charityNumber: map['charityNumber'],
        password: map['password']);
  }
}
