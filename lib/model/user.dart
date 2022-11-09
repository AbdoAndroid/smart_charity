import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String id;
  late String name;
  late String userName;
  late String mobile;
  late bool normalUser;
  late String password;
  User(
      {required this.id,
      required this.name,
      required this.userName,
      required this.mobile,
      required this.normalUser,
      required this.password});
  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': name,
      'userName': userName,
      'mobile': mobile,
      'normalUser': normalUser,
      'password': password,
    };
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    User u = User.fromJson(snapshot.data() as Map<String, dynamic>);
    u.id = snapshot.id;
    return u;
  }
  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        id: map['Id'],
        name: map['Name'],
        userName: map['userName'],
        mobile: map['mobile'],
        normalUser: map['normalUser'],
        password: map['password']);
  }
}
