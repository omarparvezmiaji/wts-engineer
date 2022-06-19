import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wts_support_engineer/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:wts_support_engineer/helping/appStringFile.dart';
import 'package:wts_support_engineer/util/static_key.dart';
import 'package:wts_support_engineer/util/status.dart';
import 'package:wts_support_engineer/view/screen/otp_screen.dart';
import 'package:wts_support_engineer/widget/TextCommon.dart';
import 'package:wts_support_engineer/widget/TextFieldCommon.dart';
import 'package:wts_support_engineer/widget/button_common.dart';
import 'package:wts_support_engineer/widget/commons.dart';
import 'package:wts_support_engineer/widget/loading.dart';

class LoginScreen extends StatefulWidget {
  static const pageId = 'loginScreen';

  const LoginScreen() : super();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => LoadingOverlay(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
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
                    Center(
                        child: AnimatedContainer(
                            duration: Duration(seconds: 2),
                            height: 100,
                            child: Image.asset(
                              "assets/logo.png",
                              fit: BoxFit.cover,
                            ))),
                    SizedBox(
                      height: 50,
                    ),
                    TextCommon(
                      title: AppStringKey.login.tr,
                      fontSize: 20.0,
                      color: black,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFieldCommon(
                        controller: auth.userNameCon,
                        hint: AppStringKey.user_name.tr,
                        icon: Icon(
                          Icons.person,
                          color: green,
                        ),
                        keyboardType: TextInputType.text,
                        errorText: auth.loginError.value),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldCommon(
                        controller: auth.passwordCon,
                        hint: AppStringKey.password.tr,
                        icon: Icon(
                          Icons.security,
                          color: green,
                        ),
                        isSecure: true,
                        keyboardType: TextInputType.visiblePassword,
                        errorText: auth.loginError.value),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: TextButtonCommon(
                        text: AppStringKey.login.tr,
                        callBack: () async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          //  await auth.login('admin@domain.com', '12345678');
                          await auth.login(
                              auth.userNameCon.text.trim().toString(),
                              auth.passwordCon.text.trim().toString());

                          switch (auth.status.value) {
                            case Status.LOADING:
                              print(
                                  '..............LOADING LOADING..................');
                              break;
                            case Status.SUCCESS:
                              print(
                                  '..............SUCCESS SUCCESS..................');
                              break;
                            case Status.ERROR:
                              print(
                                  '..............APIERROR APIERROR..................');
                              break;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Forget Password ? ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.normal)),
                        GestureDetector(
                            onTap: () {
                              forgetPassowrd();
                            },
                            child: Text('Click Here ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.green[600],
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Center(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  text: 'Copyright © Wood Tech Solution\n',
                                ),
                                TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  text: 'Powered By',
                                ),
                                TextSpan(
                                  style: TextStyle(
                                    color: Colors.green[600],
                                  ),
                                  text: '\tDHAKAapps',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final url = StaticKey.WEBSITE_URL;
                                      if (await canLaunch(url)) {
                                        await launch(
                                          url,
                                          forceSafariVC: false,
                                        );
                                      }
                                    },
                                ),
                                TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  text:
                                      '\n\n${'For Emergency  Contact'}: ${StaticKey.SUPPORT_NUMBER}',
                                ),
                              ],
                            )),

                        // Text(
                        //   'Copyright © Wood Tech Solution\nPowered By DHAKAapps',
                        //   style: TextStyle(
                        //       color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                        // ),
                      ),
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



  void forgetPassowrd() {
    bool? isForgetPasswordLoading;
    BuildContext dialogContext;
    showDialog(
      context: context, // <<----
      barrierDismissible: true,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel))),
                SizedBox(
                  height: 50,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Forget Password',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 15,
                ),
             TextFieldCommon(
                        controller: auth.mobileNumberCon,
                        hint: AppStringKey.mobile_number.tr,
                        maxlength: 11,
                        icon: Icon(
                          Icons.phone,
                          color: green,
                        ),
                        keyboardType: TextInputType.number,
                        errorText: auth.loginError.value),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child:    auth.isForgetLoading == true
                      ? Loading()
                      : TextButtonCommon(
                    fontSize: 15,
                    text: 'Submit',
                    callBack: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      setState(() {
                        isForgetPasswordLoading = true;
                      });

                      var  res=  await auth.forgetPassword(auth.mobileNumberCon.text);
                 //      Get.toNamed(
                 //          '${OtpScreen.pageId}?number=${auth.mobileNumberCon.text}');


                      print('..........................res..........${res}...............');
                      if(res!=null && res=='success'){
                        Navigator.pop(context);
                        Get.toNamed(
                            '${OtpScreen.pageId}?number=${auth.mobileNumberCon.text}');
                      }else{
                        Fluttertoast.showToast(msg: res);
                      }



                      // await _serviceController.createComplain(isSupportEngineer == true
                      //     ? MySharedPreference.getString(SharedPrefKey.USER_ID).toString()
                      //     : null,widget.customer_id,
                      //     widget.product_id,widget.product_code,
                      //     textFieldComController.text.toString().trim());
                      setState(() {
                        isForgetPasswordLoading = false;
                      });



                      switch (auth.status.value) {
                        case Status.LOADING:
                          print(
                              '..............LOADING LOADING..................');
                          break;
                        case Status.SUCCESS:
                          print(
                              '..............SUCCESS SUCCESS..................');
                          Navigator.pop(context);
                          Get.toNamed(
                              '${OtpScreen.pageId}?number=${auth.mobileNumberCon.text}');
                          // if(res!=null && res=='success'){
                          //   Get.toNamed(
                          //       '${OtpScreen.pageId}?number=${auth.mobileNumberCon.text}');
                          // }else{
                          //   Fluttertoast.showToast(msg: res);
                          // }
                          // Navigator.pop(context);
                          break;
                        case Status.ERROR:
                          //  Get.back();
                          Fluttertoast.showToast(msg: res);
                          Navigator.pop(context);
                          print(
                              '..............APIERROR APIERROR..................');
                          break;
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
        );
      },
    );

    //
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) => Dialog(
    //           child: Container(
    //             // width: double.infinity,
    //             // height: double.infinity,
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.all(Radius.circular(100))),
    //             child: SingleChildScrollView(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: <Widget>[
    //                   Padding(
    //                     padding:
    //                         EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Align(
    //                           alignment: Alignment.topRight,
    //                           child: GestureDetector(
    //                               onTap: () {
    //                                 Navigator.pop(context);
    //                               },
    //                               child: Icon(Icons.cancel)),
    //                         ),
    //                         Image.network(
    //                           imageUrl != null
    //                               ? Constant.BASE_URL_MEDIA + imageUrl
    //                               : Utills.dummy_article_Url,
    //                           errorBuilder: (BuildContext context,
    //                               Object exception, StackTrace stackTrace) {
    //                             return Image.asset('assets/images/photo.png');
    //                           },
    //                           width:
    //                               MediaQuery.of(context)
    //                                   .size
    //                                   .width,
    //                           height:    MediaQuery.of(context)
    //                               .size
    //                               .height,
    //                           fit: BoxFit.fill
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ));
  }
}
