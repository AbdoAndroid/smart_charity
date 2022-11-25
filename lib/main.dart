import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_charity/service/auth.dart';

import 'firebase_options.dart';
import 'layouts/charity_home.dart';
import 'layouts/donor_home.dart';
import 'layouts/login.dart';
import 'model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //notificationApi.initNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('login');
  User _user = await getUserLogin();
  if (_user.username == '' || _user.username == ' ') {
    runApp(const MaterialApp(
        debugShowCheckedModeBanner: false, home: LoginScreen()));
  } else {
    runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _user.isCharity ? CharityHome() : NormalUserHome()));
  }
}

Future<User> getUserLogin() async {
  await Hive.initFlutter();

  currentUser = await Hive.openBox('login').then((value) {
    return User(
        isCharity: value.get('isCharity', defaultValue: false) as bool,
        username: value.get('username', defaultValue: ' ') as String,
        name: value.get('name', defaultValue: ' ') as String,
        password: value.get('password', defaultValue: ' ') as String,
        mobile: value.get('mobile', defaultValue: ' ') as String);
  });
  return currentUser!;
}
