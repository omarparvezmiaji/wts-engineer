import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wts_support_engineer/controller/auth_controller.dart';
import 'package:wts_support_engineer/controller/home_controller.dart';
import 'package:wts_support_engineer/controller/schedule_controller.dart';
import 'package:wts_support_engineer/controller/service_controller.dart';
import 'package:wts_support_engineer/helping/appStringFile.dart';
import 'package:wts_support_engineer/model/login_info_model.dart';
import 'package:wts_support_engineer/model/schedule_info_model.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/static_key.dart';
import 'package:wts_support_engineer/util/status.dart';
import 'package:wts_support_engineer/util/utils.dart';
import 'package:wts_support_engineer/view/screen/splash_screen.dart';
import 'package:wts_support_engineer/widget/commons.dart';
import 'package:wts_support_engineer/widget/loading.dart';
import 'package:get/get.dart';

import 'complain_details_screen.dart';
import 'completed_notcompleted_supportengineer_screen.dart';
import 'make_schedule_reschedule_screen.dart';

class HomeScreen extends StatefulWidget {
  static const pageId = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController _homeCon = Get.find();
  ScheduleController _scheduleCon = Get.find();
  late UserInfoModel _userInfoModel;
  late SearchBar searchBar;
  bool isBnSelected = false;
  Map<String, dynamic> languageMap = Map();
  bool? isSupportEngineer;

  @override
  void initState() {
    super.initState();
    setLangueWiseContentInLocalMap();
    getUserData();
    loadData();
  }

  loadData() {
    _homeCon.getDashBoardData();
  }

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
    } else {
      reloadLanguageWiseContent();
    }
  }

  reloadLanguageWiseContent() async {
    _homeCon.status.value = Status.LOADING;
    bool value = await Get.find<AuthController>().getLanguageWiseContents();
    if (value == true) {
      Get.offAllNamed(SplashScreen.pageId);
      //setLangueWiseContentInLocalMap();
      //   _homeCon.getDashBoardData();
      //loadData();
    }
  }

  getUserData() async {
    String userInfo =
        (await MySharedPreference.getString(SharedPrefKey.USER_INFO))!;
    //  Map<String,dynamic> json = jsonDecode(userInfo!);

    String lang = (await MySharedPreference.getLanguage())!;

    setState(() {
      isBnSelected = lang == 'bn' ? true : false;
    });

    print(
        '................................user data ${jsonDecode(userInfo.toString())}........................');
    _userInfoModel = UserInfoModel.fromJson(
        jsonDecode(userInfo.toString().replaceAll("\n", "")));
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
       backgroundColor: StaticKey.APP_MAINCOLOR,
        centerTitle: false,
        title: Text(AppStringKey.app_name.tr, style: TextStyle(color: white)),
        actions: [
          searchBar.getSearchAction(context),
          Center(
              child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.green[900],
              borderRadius: BorderRadius.circular(
                (15),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    MySharedPreference.setString(SharedPrefKey.LANGUAGE, 'bn');

                    setState(() {
                      isBnSelected = true;
                    });
                    reloadLanguageWiseContent();

                   // Get.offAllNamed(SplashScreen.pageId);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isBnSelected == true ? Colors.white : Colors.green[900],
                      borderRadius: BorderRadius.circular(
                        (15),
                      ),
                    ),
                    child: Text('BN',style: TextStyle(color: isBnSelected == true ?Colors.black:white)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    MySharedPreference.setString(SharedPrefKey.LANGUAGE, 'en');
                    setState(() {
                      isBnSelected = false;
                    });
                    reloadLanguageWiseContent();
                   // Get.offAllNamed(SplashScreen.pageId);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isBnSelected != true ? Colors.white : Colors.green[900],
                      borderRadius: BorderRadius.circular(
                        (15),
                      ),
                    ),
                    child: Text('EN',style: TextStyle(color: isBnSelected != true ?Colors.black:white),),
                  ),
                ),
              ],
            ),
          )),
          SizedBox(
            width: 10,
          )
        ]);
  }

  _HomeScreenState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,

        hintText: languageMap['search_by_ticket_id'] ??
            'Search by ticket id',
        onSubmitted: (value) {
          if (value != null && value != '') {
            Get.toNamed(
                '${ComplainDetailsScreen.pageId}?ticketId=${value.toString().trim()}');

            // Get.toNamed(
            //     '${ComplainDetailsScreen.pageId}?ticketId=${value.toString().trim()}');
          }
        },
        buildDefaultAppBar: buildAppBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: Obx(() {
        switch (_homeCon.status.value) {
          case Status.LOADING:
            return Loading();
          case Status.SUCCESS:
            print(
                '........................getTodaySchedule......SUCCESS......${_homeCon.dashBoardInfoModel?.value?.scheduled?.length}...............');
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () {
                  return loadData();
                },
                child: Container(
                  //  height: MediaQuery.of(context).size.height,
                  //  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(0),
                    // gradient: LinearGradient(
                    //   begin: Alignment.topRight,
                    //   end: Alignment.bottomLeft,
                    //   colors: [
                    //     Colors.blue,
                    //     Colors.black45,
                    //   ],
                    // )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Image.network(
                              _userInfoModel.photo ??
                                  'https://picsum.photos/250?image=9',
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 5, top: 5, bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello ${_userInfoModel.firstName} ${_userInfoModel.lastName}',
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  Utils.greetingMessage(languageMap),
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Get.find<ScheduleController>().selectedTab =
                                  0;
                                  Get.find<HomeController>().pageIndex.value =
                                  1;
                                },
                                child: _buildHomeMenu(
                                    languageMap['current_schedule'] ??
                                        'Current Schedule',
                                    _homeCon.dashBoardInfoModel?.value
                                            ?.currentSchedule
                                            .toString() ??
                                        "0",
                                    FontAwesomeIcons.soap),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Get.find<ScheduleController>().selectedTab = 3;
                                  Get.find<HomeController>().pageIndex.value =
                                  1;
                                },
                                child: _buildHomeMenu(
                                    languageMap['service_provider'] ??
                                        'Service Provider',
                                    _homeCon.dashBoardInfoModel?.value
                                            ?.serviceProvided
                                            .toString() ??
                                        "0",
                                    FontAwesomeIcons.hammer),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      isSupportEngineer == false
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                         Get.find<ServiceController>().selectedTab =2;
                                        Get.find<HomeController>().pageIndex.value =
                                        2;
                                      },
                                      child: _buildHomeMenu(
                                          languageMap['schedule_pending'] ??
                                              'Schedule Pending',
                                          _homeCon.dashBoardInfoModel?.value
                                                  ?.schedulePending
                                                  .toString() ??
                                              "0",
                                          FontAwesomeIcons.soap),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.find<ServiceController>().selectedTab = 0;
                                        Get.find<HomeController>().pageIndex.value =
                                        2;
                                      },
                                      child: _buildHomeMenu(
                                          languageMap[
                                                  'waiting_to_be_completed'] ??
                                              'Waiting To Be Completed',
                                          _homeCon.dashBoardInfoModel?.value
                                                  ?.waitingToBeComplete
                                                  .toString() ??
                                              "0",
                                          FontAwesomeIcons.cube),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: 1,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          languageMap['today_schedule'] ?? 'Today\'s Schedule',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Container(
                         // height: 200,

                          child: ListView.builder(
                              // the number of items in the list
                              itemCount: _homeCon
                                  .dashBoardInfoModel?.value?.scheduled?.length,
                              // display each item of the product list
                              itemBuilder: (_, index) {
                                return _listItemSchedule(
                                    _homeCon.dashBoardInfoModel.value!
                                        .scheduled![index],
                                    context);
                              }),

                          // _homeCon.dashBoardInfoModel?.value?.scheduled!=null?   Container(
                          //   child: ListView.builder(
                          //     // the number of items in the list
                          //       itemCount: _homeCon.dashBoardInfoModel?.value?.scheduled?.length,
                          //       // display each item of the product list
                          //       itemBuilder: (_, index) {
                          //         if (_scheduleCon.completedList.value != null) {
                          //           return _listItemSchedule(
                          //               _homeCon.dashBoardInfoModel.value!.scheduled![index], context);
                          //         } else {
                          //           return Container();
                          //         }
                          //       }),
                          // ):Text(''),
                        ),
                      ),

                      // SizedBox(
                      //   height: 20,
                      // ),
                    ],
                  ),
                ),
              ),
            );
          default:
            return Center(
              child: Text(languageMap['no_data_found'] ?? "No data found"),
            );
        }
      }),
    );
  }

  Widget _buildHomeMenu(String title, String value, IconData fontAwesomeIcons) {
    return Container(
      height: 115,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 17,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              Colors.white,
            ],
          )),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.amber),
                child: FaIcon(
                  fontAwesomeIcons,
                  color: Colors.green,
                )),
            SizedBox(
              height: 5,
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listItemSchedule(
      ScheduleInfoModel scheduleInfoModel, BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
            '${ComplainDetailsScreen.pageId}?ticketId=${scheduleInfoModel.ticketNo.toString()}&service_type=${scheduleInfoModel.serviceType.toString()}');

        //'${ComplainDetailsScreen.pageId}?productId=${14}&complainId=${complainModel.complainId}');
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 17,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
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
          children: <Widget>[
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.lightGreen[100]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${scheduleInfoModel.product}',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '#${scheduleInfoModel.ticketNo}',
                          style: TextStyle(
                              color: red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Align(
                  //     alignment: Alignment.center,
                  //     child: FaIcon(FontAwesomeIcons.hammer,size:30,color: Colors.green,)),

                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // '${languageMap['customer_name'] ?? 'Customer Name'} : ${scheduleInfoModel.customerName ?? ''}',
                          '${scheduleInfoModel.customerName ?? ''}',
                          style: TextStyle(
                              color: black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${languageMap['schedule_date'] ?? 'Schedule Date'} : ${scheduleInfoModel.assignedDate ?? ''}',
                          //  list![index].invoice_no.toString().toString(),
                          style: TextStyle(
                              color: black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          //'${languageMap['customer_phone_number'] ?? 'Schedule Date'} : ${scheduleInfoModel.assignedDate ?? ''}',
                          // '${languageMap['customer_phone_number'] ?? 'Customer Phone Number'} : ${scheduleInfoModel.customerPhoneNumber ?? ''}',
                          '${languageMap['phone_number'] ?? 'Phone Number'} : ${scheduleInfoModel.customerPhoneNumber ?? ''}',
                          // '${languageMap['customer_phone_number'] ?? 'Customer Phone Number'}',
                          //  list![index].invoice_no.toString().toString(),
                          style: TextStyle(
                              color: black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${languageMap['schedule_slot'] ?? 'Schedule Slot'} : ${scheduleInfoModel.slot ?? ''}',
                          //  list![index].invoice_no.toString().toString(),
                          style: TextStyle(
                              color: black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          //  '${languageMap['customer_address'] ?? 'Customer Address'} ',
                          // '${languageMap['customer_address'] ?? 'Customer Address'} : ${scheduleInfoModel.customerAddress ?? ''}',
                          '${languageMap['address'] ?? 'Address'} : ${scheduleInfoModel.customerAddress ?? ''}',
                          //  list![index].invoice_no.toString().toString(),
                          style: TextStyle(
                              color: black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          // '${scheduleInfoModel.customerAddress ?? ''}',
                          '${languageMap['service_type'] ?? 'Service Type'} : ${scheduleInfoModel.serviceType ?? ''}',
                          //  list![index].invoice_no.toString().toString(),
                          style: TextStyle(
                              color: black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                scheduleInfoModel.serviceType?.toLowerCase()!=StaticKey.SUPPORT.toLowerCase()? Text(''): Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          //  '${languageMap['customer_address'] ?? 'Customer Address'} ',
                          // '${languageMap['customer_address'] ?? 'Customer Address'} : ${scheduleInfoModel.customerAddress ?? ''}',
                          '${languageMap['installation_date'] ?? 'Installation Date'} : ${scheduleInfoModel.complete_date ?? ''}',
                          //  list![index].invoice_no.toString().toString(),
                          style: TextStyle(
                              color: black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          // '${scheduleInfoModel.customerAddress ?? ''}',
                          '${languageMap['warranty_period'] ?? 'Warranty Period'} : ${scheduleInfoModel.warranty_period ?? ''}',
                          //  list![index].invoice_no.toString().toString(),
                          style: TextStyle(
                              color: black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  _scheduleBottomPart(scheduleInfoModel, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _scheduleBottomPart(
      ScheduleInfoModel scheduleInfoModel, BuildContext context) {
    return isSupportEngineer == false
        ? Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                scheduleInfoModel.onTheWay.toString()=='1'?Text(''):GestureDetector(
                  onTap: () async {
                    // setState(() {
                    //   scheduleInfoModel.isRescheduleLoading = true;
                    // });
                    //
                    // var res = await _scheduleCon.reschedule(
                    //     scheduleInfoModel.serviceType!.toLowerCase() ==
                    //         StaticKey.INSTALLATION
                    //         ? '1'
                    //         : '2',
                    //     scheduleInfoModel.ticketNo.toString());
                    // Fluttertoast.showToast(msg: res);
                    // setState(() {
                    //   scheduleInfoModel.isRescheduleLoading = false;
                    // });
                    //
                    // loadAllData();

                    await Get.toNamed(
                        '${MakeSchedulerRescheduleScreen.pageId}?ticketId=${scheduleInfoModel.ticketNo.toString()}&complainId=${scheduleInfoModel.complainId.toString()}&service_type=${scheduleInfoModel.serviceType!.toLowerCase() == StaticKey.INSTALLATION.toLowerCase() ? 1 : 2}'
                        '&productName=${scheduleInfoModel.product.toString()}');

                    loadData();
                  },
                  child: scheduleInfoModel.isRescheduleLoading == true
                      ? Loading()
                      : Text(
                          '${languageMap['reschedule'] ?? 'Reschedule'}',
                          //  list![index].invoice_no.toString().toString(),
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10),
            child: scheduleInfoModel.onTheWay == 0
                ? GestureDetector(
                    onTap: () async {
                      setState(() {
                        scheduleInfoModel.isGoingNowLoading = true;
                      });

                      var res = await _scheduleCon.goingNow(
                          scheduleInfoModel.serviceType!.toLowerCase() ==
                                  StaticKey.INSTALLATION.toLowerCase()
                              ? '1'
                              : '2',
                          scheduleInfoModel.ticketNo.toString());
                      Fluttertoast.showToast(msg: res);
                      setState(() {
                        scheduleInfoModel.isGoingNowLoading = false;
                      });

                      loadData();
                    },
                    child: scheduleInfoModel.isGoingNowLoading == true
                        ? Loading()
                        : Align(
                      alignment: Alignment.center,
                          child: Text(
                              '${languageMap['going_now'] ?? 'Going Now'}',
                              //  list![index].invoice_no.toString().toString(),
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                        ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async{
                         await Get.toNamed(
                              '${CompletedNotCompletedSupportEngineerScreen.pageId}?ticketId=${scheduleInfoModel.ticketNo.toString()}'
                              '&service_type=${scheduleInfoModel.serviceType!.toLowerCase() == StaticKey.INSTALLATION.toLowerCase() ? 1 : 2}'
                              '&productId=${scheduleInfoModel.productId.toString()}&isCompleted=${1}');

                         loadData();
                        },
                        child: Text(
                          '${languageMap['completed'] ?? 'Completed'}',
                          //  list![index].invoice_no.toString().toString(),
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                        await  Get.toNamed(
                              '${CompletedNotCompletedSupportEngineerScreen.pageId}?ticketId=${scheduleInfoModel.ticketNo.toString()}'
                              '&service_type=${scheduleInfoModel.serviceType!.toLowerCase() == StaticKey.INSTALLATION.toLowerCase() ? 1 : 2}'
                              '&productId=${scheduleInfoModel.productId.toString()}&isCompleted=${0}');

                        loadData();
                        },
                        child: Text(
                          '${languageMap['not_completed'] ?? 'Not Completed'}',
                          //  list![index].invoice_no.toString().toString(),
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
          );
  }
}
