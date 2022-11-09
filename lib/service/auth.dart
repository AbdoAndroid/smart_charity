import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/user.dart';
import '../shared/constants.dart';
import '../shared/progress_dialog.dart';

User? currentUser;

register(User user) async {
  await usersCollection.add(user.toMap());
  return;
}

Future<User> getUserById(String id) async {
  var snapshot = await usersCollection.doc(id).get();
  return User.fromSnapshot(snapshot);
}

Future<String> getPhoneById(String id) async {
  var snapshot = await usersCollection.doc(id).get();
  return (snapshot.data() as Map<String, dynamic>)['mobile'];
}

Future<int> login(String username, String password) async {
  var userData = await usersCollection.where("userName", isEqualTo: username).get();
  if (userData.docs.isEmpty) {
    return 0;
  }
  User user = User.fromSnapshot(userData.docs.first);
  debugPrint(userData.toString());
  if (user.password == password) {
    currentUser = user;
    await Hive.openBox('login').then((box) {
      hideProgress();
      box.put('userID', user.id);
      box.put('normalUser', user.normalUser);
      box.put('userName', user.userName);
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
    box.put('userID', '');
    box.put('normalUser', false);
    box.put('userName', '');
    box.put('name', '');
    box.put('password', '');
    box.put('mobile', '');
  });
}
