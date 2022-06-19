import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wts_support_engineer/controller/home_controller.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/view/screen/otp_screen.dart';
import 'package:wts_support_engineer/view/screen/profile_screen.dart';
import 'package:wts_support_engineer/view/screen/schedule_screen.dart';
import 'package:wts_support_engineer/view/screen/service_screen.dart';
import 'package:wts_support_engineer/widget/commons.dart';


import 'create_complain_select_customer_screen.dart';
import 'home_screen.dart';


class HomePage extends StatefulWidget {
  static const pageId = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<String, dynamic> languageMap = Map();


  @override
  void initState() {
    super.initState();
    setLangueWiseContentInLocalMap();
    setState(() {});
  }

  setLangueWiseContentInLocalMap() async{
    String? langCon = await MySharedPreference.getString(
        SharedPrefKey.LANGUAGE_WISE_CONTENT,
        defauleValue: null);
    if (langCon != null) {
      setState(() {
        languageMap = jsonDecode(langCon.toString());
      });
    }
  }
  List _list = [
    HomeScreen(),
    ScheduleScreen(),
  // MyProductScreen(),
   // ServiceScreen(),
    ServiceScreen(),
  //  ServiceScreen(),
  //  ServiceScreen(),
    MyProfileScreen(),
  ];




  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: _list[Get.find<HomeController>().pageIndex.value],
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: 20),
          child: SizedBox(
            height: 70,
            width: 70,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () {
                Get.toNamed(
                    '${CreateComplainSelectCustomerScreen.pageId}');
              },
              child: Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 4),
                    shape: BoxShape.circle,
                    color: Colors.red),
                child: Icon(Icons.add, size: 40,color: white,),
              ),
            ),
          ),
        ),
      //  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar: new Container(
        //   height: 80.0,
        //   color: Colors.white,
        //   padding: new EdgeInsets.only(top: 10.0),
        //   child: new Theme(
        //     data: Theme.of(context).copyWith(
        //         // sets the background color of the `BottomNavigationBar`
        //         canvasColor: Colors.white,
        //         // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        //         primaryColor: Colors.red,
        //         bottomAppBarColor: Colors.green,
        //         textTheme: Theme.of(context)
        //             .textTheme
        //             .copyWith(caption: new TextStyle(color: Colors.grey))),
        //     // sets the inactive color of the `BottomNavigationBar`
        //     child: new BottomNavigationBar(
        //         onTap: (int index) {
        //           setState(() {
        //             _currentIndex = index;
        //           });
        //         },
        //         type: BottomNavigationBarType.fixed,
        //         currentIndex: 0,
        //         fixedColor: Colors.red,//Select the color
        //         items: [
        //           BottomNavigationBarItem(
        //               icon: new Icon(Icons.home),
        //               title: new Text('Home'),
        //               backgroundColor: Colors.black),
        //           BottomNavigationBarItem(
        //             icon: new Icon(Icons.search),
        //             title: new Text('Purchase Product'),
        //           ),
        //           BottomNavigationBarItem(
        //               icon: Icon(
        //                 Icons.bookmark_border,
        //              //   color: Colors.transparent,
        //               ),
        //               title: Text('Add Complain')),
        //           BottomNavigationBarItem(
        //               icon: Icon(Icons.perm_identity),
        //               title: Text('Due Installation')),
        //           // BottomNavigationBarItem(
        //           //     icon: Icon(Icons.more_horiz), title: Text('My Profile')),
        //         ]),
        //   ),
        // ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: Get.find<HomeController>().pageIndex.value,
            onTap: (int index) {
              setState(() {
                Get.find<HomeController>().pageIndex.value = index;
              });
            },
            iconSize: 40,
            //icon size
            fixedColor: Colors.cyan,
            //Select the color
            type: BottomNavigationBarType.fixed,
            //There can be multiple tabs at the bottom of the configuration and will not be squeezed
            items: [
              // BottomNavigationBarItem(
              //     icon: new Icon(
              //       Icons.home,
              //       size: 25,
              //     ),
              //     title: new Text('Home'),
              //     backgroundColor: Colors.black),
              // BottomNavigationBarItem(
              //   icon: new Icon(
              //     Icons.bookmark_border,
              //     size: 25,
              //   ),
              //   title: new Text('Purchase\n Product'),
              // ),
              // BottomNavigationBarItem(
              //     icon: Icon(
              //       Icons.bookmark_border, size: 25,
              //       //   color: Colors.transparent,
              //     ),
              //     title: Text('Complain')),
              // BottomNavigationBarItem(
              //   icon: Icon(
              //     Icons.warning,
              //     size: 25,
              //   ),
              //   title: Center(
              //       child: Text(
              //     'Due\n Installation',
              //     style: TextStyle(fontSize: 10),
              //   )),
              // ),
              getNavigationItem(Icons.home, languageMap['home']?? "Home"),
              getNavigationItem(Icons.bookmark_border, languageMap['schedule']??"Schedule"),
              getNavigationItem(Icons.bookmark_border,'${languageMap['service']?? "Service"}'),
              getNavigationItem(Icons.perm_identity,languageMap['my_profile']?? "My Profile"),
            ]),
      );
    });
  }

  BottomNavigationBarItem getNavigationItem(IconData iconData, String text) {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        size: 25,
      ),
      title: Center(
          child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10),
      )),
    );
  }
}
