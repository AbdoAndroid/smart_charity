import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smart_charity/layouts/charity_home.dart';
import 'package:smart_charity/layouts/donor_home.dart';
import 'package:smart_charity/layouts/login.dart';
import 'package:smart_charity/model/user.dart';
import 'package:smart_charity/service/auth.dart';
import 'package:smart_charity/shared/alert_dialog.dart';
import 'package:smart_charity/shared/progress_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController charityNumberController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool isCharity = false;
  final _formKey = GlobalKey<FormState>();
  bool passIsVisible = false;

  _register() async {
    showProgress(context, "Loading ...", true);
    User user = User(
        name: fullNameController.text,
        charityNumber: charityNumberController.text,
        isCharity: isCharity,
        username: userNameController.text,
        mobile: mobileController.text,
        password: passwordController.text);
    int res = await register(user);
    if (res > 0) {
      await Hive.openBox('login').then((box) {
        hideProgress();
        box.put('isCharity', user.isCharity);
        box.put('userName', user.username);
        box.put('name', user.name);
        box.put('mobile', user.mobile);
      });
      setState(() {
        currentUser = user;
      });
      if (currentUser!.isCharity) {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CharityHome()));
      } else {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NormalUserHome()));
      }
    } else {
      hideProgress();
      showAlertDialog(context, 'This username is registered before !');
    }
  }

  Future<void> saveCrrntUser() async {}
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //ToastContext().init(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            Center(
              child: Image.asset("assets/images/charity.png",
                  color: const Color(0xFF2661FA), width: size.width * 0.2),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                "Create new account",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2661FA),
                    fontSize: 26),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  Checkbox(
                    value: isCharity,
                    onChanged: (bool? value) {
                      setState(() {
                        isCharity = value!;
                      });
                    },
                  ),
                  Text(
                    'Charity Account ',
                    style: TextStyle(color: Color(0xFF2661FA)),
                  ),
                ],
              ),
            ),
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
                decoration: InputDecoration(
                  labelText: isCharity ? "Charity name" : "Full name",
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color(0xFF2661FA),
                  ),
                ),
              ),
            ),
            //Charity number
            Visibility(
              visible: isCharity,
              child: Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: charityNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required !';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Charity number",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xFF2661FA),
                    ),
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
            SizedBox(height: size.height * 0.02),
            Container(
              alignment: Alignment.center,
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
                      color: Color(0xFF2661FA)),
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
            SizedBox(height: size.height * 0.02),
            Container(
              padding: EdgeInsets.only(left: size.width * 0.25),
              child: GestureDetector(
                child: const Text(
                  'Already have an account? Login Now!',
                  style: TextStyle(color: Color(0xFF2661FA)),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
