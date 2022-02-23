import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unsplash_demo/animations/animation.dart';
import 'package:unsplash_demo/pages/home_page.dart';


class SplashPage extends StatefulWidget {
  static const String id = "/splash_page";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void openPage() {
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, HomePage.id);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FadeAnimation(
            1,
            Container(
              padding: EdgeInsets.all(30),
              child: Center(
                child:  Text(
                  "Pinterest",
                  style: TextStyle(fontFamily: "Billabong",fontSize: 50),
                ),
              ),
            )));
  }
}
