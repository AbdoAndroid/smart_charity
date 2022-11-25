import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/user.dart';
import '../shared/constants.dart';
import '../shared/progress_dialog.dart';

User? currentUser;

Future<int> register(User user) async {
  var userData = await usersCollection.doc(user.username).get();
  if (userData.exists) {
    return 0;
  }
  await usersCollection.doc(user.username).set(user.toMap());
  return 1;
}

Future<User> getUserByUsername(String username) async {
  var snapshot = await usersCollection.doc(username).get();
  return User.fromSnapshot(snapshot);
}

Future<String> getNameByUsername(String username) async {
  var snapshot = await usersCollection.doc(username).get();
  String name = (snapshot.data() as Map<String, dynamic>)['name'];
  return name;
}

Future<String> getPhoneByUsername(String username) async {
  var snapshot = await usersCollection.doc(username).get();
  return (snapshot.data() as Map<String, dynamic>)['mobile'];
}

Future<int> login(String username, String password) async {
  var userData = await usersCollection.doc(username).get();
  if (!userData.exists) {
    return 0;
  }
  User user = User.fromSnapshot(userData);
  debugPrint(userData.toString());
  if (user.password == password) {
    currentUser = user;
    await Hive.openBox('login').then((box) {
      hideProgress();
      box.put('isCharity', user.isCharity);
      box.put('username', user.username);
      box.put('name', user.name);
      box.put('password', user.password);
      box.put('mobile', user.mobile);
    });
    return 1;
  } else {
    return 2;
  }
}

logout() async {
  await Hive.openBox('login').then((box) {
    hideProgress();
    box.put('normalUser', false);
    box.put('username', '');
    box.put('name', '');
    box.put('password', '');
    box.put('mobile', '');
  });
}

Future<List<User>> getCharities() async {
  List<User> charities = [];
  var output = await usersCollection.where("isCharity", isEqualTo: true).get();
  output.docs.forEach((element) {
    charities.add(User.fromSnapshot(element));
  });
  return charities;
}
