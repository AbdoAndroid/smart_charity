import 'package:bride_night/layouts/login.dart';
import 'package:bride_night/layouts/normal_user_home.dart';
import 'package:bride_night/layouts/service_provider_home.dart';
import 'package:bride_night/model/user.dart';
import 'package:bride_night/service/auth.dart';
import 'package:bride_night/shared/login_background.dart';
import 'package:bride_night/shared/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool serviceProv = false;
  final _formKey = GlobalKey<FormState>();
  bool passIsVisible = false;

  _register() async {
    showProgress(context, "Loading ...", true);
    User user = User(
        name: fullNameController.text,
        id: '',
        normalUser: !serviceProv,
        userName: userNameController.text,
        mobile: mobileController.text,
        password: passwordController
            .text); /*await login(context, userNameController.text, passwordController.text);*/
    register(user);
    if (user != null) {
      if (user.id != '') {
        await Hive.openBox('login').then((box) {
          hideProgress();
          box.put('userID', user.id);
          box.put('normalUser', user.normalUser);
          box.put('userName', user.userName);
          box.put('name', user.name);
          box.put('mobile', user.mobile);
        });
        if (currentUser!.normalUser) {
          await Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => NormalUserHome()));
        } else {
          await Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ServiceProviderHome()));
        }
      } else {
        await hideProgress();
        //Toast.show("خطأ باسم المستخدم او كلمة المرور", duration: Toast.lengthLong, gravity: Toast.center);
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
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  "Create new account",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF2661FA), fontSize: 30),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              //full name
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required !';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Full name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xFF2661FA),
                    ),
                  ),
                ),
              ),
              //username
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
              //phone
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required !';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Phone number",
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color(0xFF2661FA),
                    ),
                  ),
                ),
              ),
              //password
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
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Checkbox(
                      value: serviceProv,
                      onChanged: (bool? value) {
                        setState(() {
                          serviceProv = value!;
                        });
                      },
                    ),
                    Text(
                      'Register as service provider',
                      style: TextStyle(color: Color(0xFF2661FA)),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _register();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(60.0)),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(255, 109, 148, 250),
                          Color.fromARGB(255, 188, 205, 250)
                        ])),
                    padding: const EdgeInsets.all(0),
                    child: const Text(
                      "Create",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                padding: EdgeInsets.only(left: size.width * 0.25),
                child: GestureDetector(
                  child: const Text(
                    'Already have an account? Login Now!',
                    style: TextStyle(color: Color(0xFF2661FA)),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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
