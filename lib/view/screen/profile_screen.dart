import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wts_support_engineer/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:wts_support_engineer/model/login_info_model.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/static_key.dart';
import 'package:wts_support_engineer/view/screen/change_password_screen.dart';
import 'package:wts_support_engineer/view/screen/profile_statistics_screen.dart';
import 'package:wts_support_engineer/widget/commons.dart';
import 'package:wts_support_engineer/widget/loading.dart';

import 'login_screen.dart';
import 'make_scheduler_screen.dart';

class MyProfileScreen extends StatefulWidget {
  static const pageId = 'MyProfileScreen';

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  HomeController _homeCon = Get.find();
  late UserInfoModel _userInfoModel;
  bool isDataLoaded = false;
  File? imageFile;
  late String filePath;
  Map<String, dynamic> languageMap = Map();
  bool isProfileSelected = true;
  bool? isSupportEngineer;

  setLangueWiseContentInLocalMap() async {
    var isSupportEngineer =
        await MySharedPreference.getBoolean(SharedPrefKey.ISSUPPORT_ENGINEER);

    setState(() {
      this.isSupportEngineer = isSupportEngineer;
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
    getUserData();
  }

  getUserData() async {
    String userInfo =
        (await MySharedPreference.getString(SharedPrefKey.USER_INFO))!;
    //  Map<String,dynamic> json = jsonDecode(userInfo!);

    print(
        '................................user data ${jsonDecode(userInfo.toString())}........................');
    _userInfoModel = UserInfoModel.fromJson(
        jsonDecode(userInfo.toString().replaceAll("\n", "")));
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StaticKey.APP_MAINCOLOR,
        centerTitle: true,
        title: Text(
          languageMap['my_profile'] ?? 'My Profile',
          style: TextStyle(color: white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              MySharedPreference.clear();
              Get.offAllNamed(LoginScreen.pageId);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  languageMap['logout'] ?? 'Logout',
                  style: TextStyle(color: red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: isDataLoaded == false
              ? Loading()
              : Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: imageFile != null
                          ? Image.file(
                              imageFile!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              _userInfoModel.photo ??
                                  'https://picsum.photos/250?image=9',
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showSelectionDialog(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(width: 1, color: Colors.amber)),
                        child: Text(
                          languageMap['add_your_photo'] ?? 'Add Your Photo',
                          style: TextStyle(
                              fontSize: 20,
                              color: black,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: grey),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      padding: EdgeInsets.only(
                          top: 10, left: 0, right: 0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildProfileItem(
                                    languageMap['name'] ?? 'Name',
                                    '${_userInfoModel.firstName} ${_userInfoModel.lastName}'),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildProfileItem(
                                    languageMap['email'] ?? 'email',
                                    '${_userInfoModel.email}'),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildProfileItem(
                                    languageMap['phone_number'] ??
                                        'phone_number',
                                    '${_userInfoModel.contactNo}'),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: grey),
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isProfileSelected = true;
                                  });

                                  // Get.toNamed(
                                  // '${ComplainDetailsScreen.pageId}?ticketId=${scheduleInfoModel.ticketNo.toString()}&service_type=${scheduleInfoModel.serviceType.toString()}');

                                  Get.toNamed(
                                      '${ProfileeStatisticsScreen.pageId}');
                                },
                                child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          bottomLeft: Radius.circular(25)),
                                      color: isProfileSelected == true
                                          ? Colors.green[600]
                                          : Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${languageMap['profile_statistics'] ?? 'Profile Statistics'}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: isProfileSelected == true
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14),
                                      ),
                                    )),
                              )),
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isProfileSelected = false;
                                  });

                                  Get.toNamed('${ChangePasswordScreen.pageId}');
                                },
                                child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(25),
                                          bottomRight: Radius.circular(25)),
                                      color: isProfileSelected == false
                                          ? Colors.green[600]
                                          : Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${languageMap['change_password'] ?? 'Change Password'}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: isProfileSelected == false
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14),
                                      ),
                                    )),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: isSupportEngineer==true?false:true,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                              '${MakeSchedulerScreen.pageId}?ticketId=${1.toString()}&service_type=${1.toString()}');
                        },
                        child: Container(
                          height: 40,
                          width: 200,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: grey),
                              borderRadius: BorderRadius.all(Radius.circular(2))),
                          child: Center(
                            child: Text(
                              '${languageMap['make_scheduler'] ?? 'Make Scheduler'}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Container(
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
                                      '\n\n${languageMap['for_emergency_contact'] ?? 'For Emergency  Contact'}: ${StaticKey.SUPPORT_NUMBER}',
                                ),
                              ],
                            )),

                        // Text(
                        //   'Copyright © Wood Tech Solution\nPowered By DHAKAapps'
                        //     ,textAlign: TextAlign.center,
                        //   style: TextStyle(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.normal),
                        // ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _onOpen(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildProfileItem(String title, String value) {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                '${title}: ',
                style: TextStyle(
                    color: black, fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                value ?? '',
                style: TextStyle(
                    color: black, fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ));
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showMaterialModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) => Container(
        height: 160,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: green[900]),
              child: Center(
                  child: Text(
                '${languageMap['choose_option'] ?? 'Choose Option'}',
                style: TextStyle(color: white, fontSize: 15),
              )),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _openCamera(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 35,
                          color: green[900],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${languageMap['from_camera'] ?? 'From Camera'}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _openGallery(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_album,
                          size: 35,
                          color: green[900],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${languageMap['from_gallery'] ?? 'From Gallery'}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);

    print(
        '............................................${picture}.............');
    this.setState(() {
      imageFile = File(picture!.path);
      filePath = picture.path;
      if (imageFile != null) _homeCon.changeProfilePic(filePath!);
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    var picture = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(picture!.path);
      filePath = picture.path;
    });
    Navigator.of(context).pop();
  }

  Widget _setImageView() {
    if (imageFile != null) {
      return Image.file(imageFile!, width: 50, height: 50);
    } else {
      return Text("Please select an image");
    }
  }
}
