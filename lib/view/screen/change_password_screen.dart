import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wts_support_engineer/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:wts_support_engineer/helping/appStringFile.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/static_key.dart';
import 'package:wts_support_engineer/util/status.dart';
import 'package:wts_support_engineer/widget/TextCommon.dart';
import 'package:wts_support_engineer/widget/TextFieldCommon.dart';
import 'package:wts_support_engineer/widget/button_common.dart';
import 'package:wts_support_engineer/widget/commons.dart';


class ChangePasswordScreen extends StatefulWidget {
  static const pageId = 'ChangePasswordScreen';

  const ChangePasswordScreen() : super();

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  AuthController auth = Get.find<AuthController>();

  TextEditingController oldPasswordCon=TextEditingController();
  TextEditingController newPasswordCon=TextEditingController();
  TextEditingController conPasswordCon=TextEditingController();
  Map<String, dynamic> languageMap = Map();

  bool? isSupportEngineer;

  setLangueWiseContentInLocalMap() async {
    var isSupport =
    await MySharedPreference.getBoolean(SharedPrefKey.ISSUPPORT_ENGINEER);

    setState(() {
      isSupportEngineer = isSupport;
    });

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
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StaticKey.APP_MAINCOLOR,
        title: Text(languageMap['change_password'] ?? 'Change Password',style: TextStyle(color: Colors.white,fontSize: 16),),
      ),
      body: Obx(
        () => LoadingOverlay(
            child: SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white,
                        Colors.white,
                      ],
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),

                    Visibility(
                      visible: false,
                      child: TextFieldCommon(
                          controller: oldPasswordCon,
                          hint:  languageMap[''] ?? 'Old Password',
                          icon: null,
                          keyboardType: TextInputType.visiblePassword,
                        //  errorText: auth.loginError.value
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldCommon(
                        controller: newPasswordCon,
                        hint: languageMap['new_password'] ?? 'New Password',
                        icon: null,
                      isSecure: true,
                        keyboardType: TextInputType.visiblePassword,
                      //  errorText: auth.loginError.value
              ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldCommon(
                        controller: conPasswordCon,
                        hint: languageMap['confirm_password'] ?? 'Confirm Password',
                        icon: null,
                      isSecure: true,
                        keyboardType: TextInputType.visiblePassword,
                      //  errorText: auth.loginError.value
              ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: TextButtonCommon(
                        text: languageMap['change_password'] ?? 'Change Password',
                        callBack: () async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }

                       if(newPasswordCon.text!=null && newPasswordCon.text==conPasswordCon.text) {
                         await auth.changePassword(
                             newPasswordCon.text.trim().toString());

                         switch (auth.status.value) {
                           case Status.LOADING:
                             print(
                                 '..............LOADING LOADING..................');
                             break;
                           case Status.SUCCESS:
                             print(
                                 '..............SUCCESS SUCCESS..................');
                             Get.back();
                             break;
                           case Status.ERROR:
                             print(
                                 '..............APIERROR APIERROR..................');
                             break;
                         }
                       }else{
                         Fluttertoast.showToast(msg: languageMap['password_missmatch'] ?? 'Password MissMatch');
                       }
                        },
                      ),
                    ),


                    SizedBox(
                      height: 50,
                    ),

                  ],
                ),
              ),
            ),
            isLoading: Get.find<AuthController>().isLoading.value),
      ),
      // bottomSheet: Container(
      //   color: Colors.white,
      //   padding: EdgeInsets.symmetric(horizontal: 10),
      //   width: double.infinity,
      //   height: 50,
      //   child: Center(
      //     child:  RichText(
      //         textAlign: TextAlign.center,
      //         text: TextSpan(
      //           children: [
      //             TextSpan(
      //               style: TextStyle(color: Colors.grey,),
      //               text: 'Copyright © Wood Tech Solution\n',
      //             ),
      //             TextSpan(
      //               style: TextStyle(color: Colors.grey,),
      //               text: 'Powered By',
      //             ),
      //             TextSpan(
      //               style: TextStyle(color: Colors.green[600],),
      //               text: '\tDHAKAapps',
      //               recognizer: TapGestureRecognizer()
      //                 ..onTap = () async {
      //                   final url = StaticKey.WEBSITE_URL;
      //                   if (await canLaunch(url)) {
      //                     await launch(
      //                       url,
      //                       forceSafariVC: false,
      //                     );
      //                   }
      //                 },
      //             ),
      //
      //             TextSpan(
      //               style: TextStyle(color: Colors.black,),
      //               text: '\n\n${'For Emergency  Contact'}: 01914252536',
      //             ),
      //           ],
      //         )),
      //
      //     // Text(
      //     //   'Copyright © Wood Tech Solution\nPowered By DHAKAapps',
      //     //   style: TextStyle(
      //     //       color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      //     // ),
      //   ),
      // ),
    );
  }
}
