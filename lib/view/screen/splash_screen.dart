import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wts_support_engineer/helping/appStringFile.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/view/screen/login_screen.dart';

import 'home_page.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const pageId = "splashscreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var screenMaxWidth, screenMaxHeight;
  var _height, _width, _imageHeight, _imageWidth, _fontSize;
  Color _backgroundColor = Colors.white, _fontColor = Colors.red;
  var _opacity = 0.0;
  Timer? _timer;
  int _start = 1;

  @override
  void initState() {
    startTimer();
    startTimerForGoingNextScreen();
    _height = 100.0;
    _width = 150.0;
    _imageHeight = 0.0;
    _imageWidth = 0.0;
    _fontSize = 5.0;
  }

  @override
  Widget build(BuildContext context) {
    screenMaxWidth = MediaQuery.of(context).size.width;
    screenMaxHeight = MediaQuery.of(context).size.height;

    //
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 2),
          height: _height,
          width: _width,
          decoration: BoxDecoration(color: _backgroundColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: AnimatedContainer(
                      duration: Duration(seconds: 2),
                      height: _imageHeight,
                      // width: _imageWidth,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.cover,
                      ))),
              SizedBox(
                height: 15,
              ),
              AnimatedOpacity(
                  duration: Duration(seconds: 2),
                  opacity: _opacity,
                  child: Text(
                    AppStringKey.app_name.tr,
                    style: TextStyle(
                        fontSize: _fontSize,
                        color: _fontColor,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          _timer?.cancel();
          setState(() {
            timer.cancel();

            print(
                ".........................................timer..........................................");
            _backgroundColor = Colors.white;
            _height = screenMaxHeight;
            _width = screenMaxWidth;
            _imageHeight = 100.0;
            _imageWidth = 100.0;
            _fontSize = 25.0;
            _fontColor = Colors.black;
            _opacity = 1.0;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void startTimerForGoingNextScreen() {
    var _start = 5;
    const oneSec = const Duration(seconds: 1);
    var _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_start == 0) {
            timer.cancel();
            MySharedPreference.getBoolean(SharedPrefKey.ISONBOARDINGSHOWED)
                .then((value) => {
                      if (value == true)
                        {
                          MySharedPreference.getBoolean(SharedPrefKey.ISLOGIN)
                              .then((value) => {
                                if (value == true) {
                                  Get.offNamed(HomePage.pageId)
                                } else {
                                  Get.offNamed(LoginScreen.pageId)
                                }}),
                          //    Navigator.push(context,  MaterialPageRoute(builder: (_)=>OnBoardingScreen()));
                        }
                      else
                        {Get.offNamed(OnBoardingScreen.pageId)}
                    });
          } else {
            setState(() {
              _start--;
            });
          }
        });
      },
    );
  }
}
