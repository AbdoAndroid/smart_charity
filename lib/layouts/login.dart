import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_charity/layouts/charity_home.dart';
import 'package:smart_charity/layouts/donor_home.dart';
import 'package:smart_charity/layouts/register.dart';
import 'package:smart_charity/model/user.dart';
import 'package:smart_charity/service/auth.dart';
import 'package:smart_charity/shared/alert_dialog.dart';
import 'package:smart_charity/shared/login_background.dart';
import 'package:smart_charity/shared/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passIsVisible = false;
  Future<User> getUserLogin() async {
    User user = await Hive.openBox('login').then((value) {
      return User(
          isCharity: value.get('isCharity', defaultValue: true) as bool,
          username: value.get('username', defaultValue: ' ') as String,
          name: value.get('name', defaultValue: ' ') as String,
          password: value.get('password', defaultValue: ' ') as String,
          mobile: value.get('mobile', defaultValue: ' ') as String);
    });
    setState(() {
      currentUser = user;
    });
    return user;
  }

  _login() async {
    showProgress(context, "Loading ...", true);
    int loginRes =
        await login(userNameController.text, passwordController.text);
    if (loginRes == 0) {
      await hideProgress();
      showAlertDialog(context, "Invalid username!!");
    } else if (loginRes == 2) {
      await hideProgress();
      showAlertDialog(context, "Invalid password!!");
    } else {
      await hideProgress();
      debugPrint(currentUser.toString());
      if (currentUser!.isCharity) {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CharityHome()));
      } else {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NormalUserHome()));
      }
    }
  }

  Future<void> saveCrrntUser() async {}
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //ToastContext().init(context);
    return Scaffold(
      body: LoginBackground(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA),
                      fontSize: 30),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: userNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required !';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "User name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xFF2661FA),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xFF2661FA),
                    ),
                    suffixIcon: IconButton(
                      icon: passIsVisible
                          ? const Icon(
                              Icons.visibility_off,
                              color: Color(0xFF2661FA),
                            )
                          : const Icon(
                              Icons.visibility,
                              color: Color(0xFF2661FA),
                            ),
                      onPressed: () {
                        setState(() {
                          passIsVisible = !passIsVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required !';
                    }
                    return null;
                  },
                  obscureText: !passIsVisible,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Color(0xFF2661FA)),
                    padding: const EdgeInsets.all(0),
                    child: const Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.1),
              Container(
                padding: EdgeInsets.only(left: size.width * 0.25),
                child: GestureDetector(
                  child: const Text(
                    'Don\'t have an account ? Register Now !',
                    style: TextStyle(color: Color(0xFF2661FA)),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
