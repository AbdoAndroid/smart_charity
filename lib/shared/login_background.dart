import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  final Widget child;

  const LoginBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset("assets/images/top1.png",
                width: MediaQuery.of(context).size.width),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset("assets/images/top2.png",
                width: MediaQuery.of(context).size.width),
          ),
          Positioned(
            top: 60,
            left: size.width * 0.35,
            child: Image.asset("assets/images/brides.png",
                color: const Color(0xFF2661FA), width: size.width * 0.35),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/bottom1.png",
                width: MediaQuery.of(context).size.width),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/bottom2.png",
                width: MediaQuery.of(context).size.width),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            child: child,
          ),
        ],
      ),
    );
  }
}
