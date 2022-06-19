import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:wts_support_engineer/controller/auth_controller.dart';
import 'package:wts_support_engineer/controller/schedule_controller.dart';
import 'package:wts_support_engineer/controller/service_controller.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/static_key.dart';
import 'package:wts_support_engineer/util/status.dart';
import 'package:wts_support_engineer/widget/button_common.dart';
import 'package:wts_support_engineer/widget/commons.dart';

import 'change_password_screen.dart';

class OtpScreen extends StatefulWidget {
  String? number = Get.parameters['number'];
  static const pageId = "otpScreen";

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  AuthController auth = Get.find<AuthController>();
  TextEditingController otpmController = TextEditingController();

  ScheduleController _complainController = Get.find();
  ServiceController _serviceController = Get.find();
  Map<String, dynamic> languageMap = Map();
  bool? isSupportEngineer;

  setLangueWiseContentInLocalMap() async {
    isSupportEngineer =
        await MySharedPreference.getBoolean(SharedPrefKey.ISSUPPORT_ENGINEER);

    String? langCon = await MySharedPreference.getString(
        SharedPrefKey.LANGUAGE_WISE_CONTENT,
        defauleValue: null);

    if (langCon != null) {
      setState(() {
        languageMap = jsonDecode(langCon.toString());
      });
    }
  }

  @override
  void initState() {
    setLangueWiseContentInLocalMap();
    Get.find<ServiceController>().isLoading.value = false;
    print(
        '..........................productId...........${widget.number}...................');
    super.initState();
  }

  bool isWrong = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: StaticKey.APP_MAINCOLOR,
          title: Text(
            languageMap['otp'] ?? 'OTP',
            style: TextStyle(color: black),
          ),
        ),
        body: Obx(
          () => LoadingOverlay(
              child: Center(
                  child: Container(
                margin: EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              '${languageMap['otp_has_been_sent_to'] ?? 'OTP has been sent to'} ',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Text('${widget.number} ',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),

                  // Text('${languageMap['otp_has_been_sent_to']??'OTP has been sent to'} ${widget.number}',style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.normal),)),

                  SizedBox(
                    height: 20,
                  ),

                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        languageMap['enter_your_otp_here'] ??
                            'Enter Your OTP Here',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      )),

                  Container(
                    width: 150,
                    child: TextField(
                        //   controller: username,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          counterText: '',
                          //labelText: S.of(context).translate('register_tf_username'),
                          // labelText: '${languageMap['username']??'UserName'} *',

                          // hintText: S.of(context).translate('register_tf_usernameentername'))),
                          hintText: languageMap['otp'] ?? 'otp',
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      width: 150,
                      child: TextButtonCommon(
                        fontSize: 15,
                        text: '${languageMap['submit'] ?? 'Submit'}',
                        callBack: () async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          setState(() {
                            isWrong=false;
                          });
                          var res = await auth.verifyCode(otpmController.text);
                          switch (auth.status.value) {
                            case Status.LOADING:

                              print(
                                  '..............LOADING LOADING..................');
                              break;
                            case Status.SUCCESS:
                              print(
                                  '..............SUCCESS SUCCESS..................');
                                 Navigator.pop(context);
                              Get.toNamed('${ChangePasswordScreen.pageId}');
                              break;
                            case Status.ERROR:
                              setState(() {
                                isWrong=true;
                              });
                              //  Get.back();
                             // Navigator.pop(context);
                              print(
                                  '..............APIERROR APIERROR..................');
                              break;
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),

                  Visibility(
                    visible: isWrong,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          languageMap['wrong_otp'] ?? 'Wrong OTP',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.normal),
                        )),
                  ),
                ]),
              )),
              isLoading: Get.find<AuthController>().isLoading.value),
        ));
  }
}
