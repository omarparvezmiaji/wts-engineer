import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:wts_support_engineer/controller/service_controller.dart';
import 'package:wts_support_engineer/model/login_info_model.dart';
import 'package:wts_support_engineer/model/schedule_info_model.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/static_key.dart';
import 'package:wts_support_engineer/view/screen/completed_notcompleted_supportengineer_screen.dart';
import 'package:wts_support_engineer/view/screen/make_scheduler_screen.dart';
import 'package:wts_support_engineer/widget/commons.dart';
import 'package:wts_support_engineer/widget/loading.dart';

import 'complain_details_screen.dart';

class ProfileeStatisticsScreen extends StatefulWidget {
  static const pageId = 'ProfileeStatisticsScreen';

  @override
  _ProfileeStatisticsScreenState createState() =>
      _ProfileeStatisticsScreenState();
}

class _ProfileeStatisticsScreenState extends State<ProfileeStatisticsScreen> {
  late ServiceController _serviceCon;

  late TabController _controller;
  int _selectedIndex = 0;
  Map<String, dynamic> languageMap = Map();
  bool? isSupportEngineer, isTabBarLoading = true, isLoading = true;

  // List<Map<String, dynamic>> evaluationMap = [];
  late UserInfoModel _userInfoModel;
  bool isFromSetSchedule = false;
  List<String> duration = ['15 Days', '1 Month', '2 Months'];
  String? selectedDuration = '15 Days';
  String? selectedDurationValue = '0.5';
  List itemWiseServiceList = [];
  Map statisticsList = {};
  bool isItemWiseServiceLoadin = false, isStatistics = false;




  getUserData() async {
    String userInfo =
        (await MySharedPreference.getString(SharedPrefKey.USER_INFO))!;
    //  Map<String,dynamic> json = jsonDecode(userInfo!);

    String lang = (await MySharedPreference.getLanguage())!;

    print(
        '................................user data ${jsonDecode(userInfo.toString())}........................');
    _userInfoModel = UserInfoModel.fromJson(
        jsonDecode(userInfo.toString().replaceAll("\n", "")));
  }

  itemWiseService() async {
    setState(() {
      isItemWiseServiceLoadin = true;
    });
    List item_wise_services = await _serviceCon.item_wise_services(
        isSupportEngineer == true
            ? MySharedPreference.getString(SharedPrefKey.USER_ID).toString()
            : null,selectedDurationValue);
    print(
        '...................itemWiseService ${item_wise_services}................');

    setState(() {
      if (item_wise_services != null && item_wise_services.length > 0) {
        itemWiseServiceList = item_wise_services;
      }
    });
    setState(() {
      isItemWiseServiceLoadin = false;
    });
  }

  int assigned = 0;
  int complete = 0;
  int not_completed = 0;
  int installed_Products = 0;
  int support_Products = 0;

  statisticsData() async {
    setState(() {
      isStatistics = true;
    });
    Map statistics = await _serviceCon.statistics(isSupportEngineer == true
        ? MySharedPreference.getString(SharedPrefKey.USER_ID).toString()
        : null,selectedDurationValue);

    print(
        '...........statistics........statistics ${statistics['assigned']}................');
    if (statistics != null && statistics.length > 0) {
      setState(() {
        statisticsList = statistics;
        complete=statisticsList['completed'];
        support_Products=statisticsList['support_Products'];
        installed_Products=statisticsList['installed_Products'];
        not_completed=statisticsList['not_completed'];
        assigned=statisticsList['assigned'];
        dataMap = {
          "assigned": assigned.toDouble(),
          "completed":complete.toDouble(),
          "Not Complete": not_completed.toDouble(),
          // "Xamarin": 2
          // "Ionic": 2,
        };
        dataMap2 = {
          "Installed Products": installed_Products.toDouble(),
          "Support Products": support_Products.toDouble(),
          // "Xamarin": 2
          // "Ionic": 2,
        };
      });
    }
    setState(() {
      isStatistics = false;
    });
  }

  loadAllData() async {
    // setState(() {
    //   isLoading = true;
    // });
    //
    itemWiseService();
    statisticsData();

    // setState(() {
    //   isLoading = false;
    // });
  }

  setLangueWiseContentInLocalMap() async {
    isSupportEngineer =
        await MySharedPreference.getBoolean(SharedPrefKey.ISSUPPORT_ENGINEER);

    String userInfo =
        (await MySharedPreference.getString(SharedPrefKey.USER_INFO))!;
    _userInfoModel = UserInfoModel.fromJson(
        jsonDecode(userInfo.toString().replaceAll("\n", "")));

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, double> dataMap = {
    "assigned": 3,
    "completed": 3,
    "Not Complete": 3,
  };
  Map<String, double> dataMap2 = {
    "Installed Products": 5,
    "Support Products": 5,
  };

  @override
  void initState() {
    setLangueWiseContentInLocalMap();
    super.initState();

    _serviceCon = Get.find<ServiceController>();
    loadAllData();
    //  _controller.index = _selectedIndex;
    // _controller.addListener(() {
    //   setState(() {
    //     if(Get.find<ComplainController>().selectedTab==1) {
    //
    //       _selectedIndex = _controller.index;
    //       _controller.animateTo(_selectedIndex += 1);
    //     }
    //   });
    //   print("Selected Index: " + _controller.index.toString());
    // });
  }

  @override
  Widget build(BuildContext context) {
    // return DefaultTabController(
    //   length: 2,
    return Scaffold(
        appBar: AppBar(
          backgroundColor: StaticKey.APP_MAINCOLOR,
          title: Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  languageMap['my_statistics'] ?? 'My Statistics',
                  style: TextStyle(color: white),
                ),
                Container(
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: white,
                      border: Border.all(width: 1, color: white),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  margin: EdgeInsets.only(top: 10, left: 0, right: 0),
                  padding:
                      EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
                  child: DropdownButton<String>(
                    underline: SizedBox(),
                    value: selectedDuration,
                    onChanged: (newValue) {
                      setState(() {
                        switch(newValue){
                          case '15 Days' :
                             selectedDurationValue='0.5';
                            break;

                          case '1 Month' :
                             selectedDurationValue='1';
                            break;

                          case '2 Months' :
                             selectedDurationValue='2';
                            break;
                        }
                        selectedDuration = newValue;
                        loadAllData();
                      });
                    },
                    items: duration
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          bottomOpacity: 1,
        ),
        body: _builView()
        //  ),
        );
  }

  List<Color> colorList = [
    Colors.red,
    Colors.green,
     Colors.blue,
    // Colors.yellow,
  ];

  List<Color> colorList2 = [
    Colors.red,
    Colors.green,
    // Colors.blue,
    // Colors.yellow,
  ];

  Widget _builView() {
    return isItemWiseServiceLoadin == true
        ? Loading()
        : InkWell(
            onTap: () {
              // Get.toNamed(
              // '${ComplainDetailsScreen.pageId}?ticketId=${scheduleInfoModel.ticketNo.toString()}&service_type=${scheduleInfoModel.serviceType.toString()}');

              //'${ComplainDetailsScreen.pageId}?productId=${14}&complainId=${complainModel.complainId}');
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey, width: 1),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.2),
              //         spreadRadius: 5,
              //         blurRadius: 17,
              //         offset: Offset(0, 3), // changes position of shadow
              //       ),
              //     ],
              //     borderRadius: BorderRadius.circular(8),
              //     gradient: LinearGradient(
              //       begin: Alignment.topRight,
              //       end: Alignment.bottomLeft,
              //       colors: [
              //         Colors.white,
              //         Colors.white,
              //       ],
              //     )),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      '${languageMap['statistics_for_this_month'] ?? 'Statistics for this month'}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                            width: double.infinity,
                            height: 250,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                color: Colors.lightGreen[100]),
                            child: PieChart(
                              dataMap: dataMap,
                              animationDuration: Duration(milliseconds: 800),
                              chartLegendSpacing: 32,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.2,
                              colorList: colorList,
                              initialAngleInDegree: 0,
                              chartType: ChartType.disc,
                              ringStrokeWidth: 32,
                              // centerText: "HYBRID",
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.bottom,
                                showLegends: true,
                                legendShape: BoxShape.circle,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 1,
                              ),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            width: double.infinity,
                            height: 250,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                color: Colors.lightGreen[100]),
                            child: PieChart(
                              dataMap: dataMap2,
                              animationDuration: Duration(milliseconds: 800),
                              chartLegendSpacing: 32,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.2,
                              colorList: colorList2,
                              initialAngleInDegree: 0,
                              chartType: ChartType.disc,
                              ringStrokeWidth: 32,
                              // centerText: "HYBRID",
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.bottom,
                                showLegends: true,
                                legendShape: BoxShape.circle,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 1,
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      '${languageMap['item_wise_service'] ?? 'Item Wise Service'}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildItemeWiseService(),
                  )
                ],
              ),
            ),
          );
  }

  _buildItemeWiseService() {
    return isItemWiseServiceLoadin == true
        ? Loading()
        : Container(
            width: double.infinity,
            child: Column(
              children: [
                //   Divider(height: 1,color: Colors.black,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(0.0),
                            border: Border.symmetric(
                              vertical: BorderSide.none,
                              horizontal: BorderSide.none,
                            )),
                        child: Text(
                          '${languageMap['srl'] ?? 'SrL'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(0.0),
                            border: Border.symmetric(
                              vertical: BorderSide.none,
                              horizontal: BorderSide.none,
                            )),
                        child: Text(
                          '${languageMap['item_name'] ?? 'Item Name'}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(0.0),
                            border: Border.symmetric(
                              vertical: BorderSide.none,
                              horizontal: BorderSide.none,
                            )),
                        child: Text(
                          '${languageMap['installation'] ?? 'Installation'}',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(0.0),
                            border: Border.symmetric(
                              vertical: BorderSide.none,
                              horizontal: BorderSide.none,
                            )),
                        child: Text(
                          '${languageMap['support'] ?? 'Support'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(
                    child: ListView.builder(
                        itemCount: itemWiseServiceList.length,
                        itemBuilder: (_, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0.0),
                                      border: Border.symmetric(
                                        vertical: BorderSide.none,
                                        horizontal: BorderSide.none,
                                      )),
                                  child: Text(
                                    '${index + 1}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0.0),
                                      border: Border.symmetric(
                                        vertical: BorderSide.none,
                                        horizontal: BorderSide.none,
                                      )),
                                  child: Text(
                                    // '${languageMap['item_name'] ?? 'Item Name'}',
                                    '${itemWiseServiceList[index]['name']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0.0),
                                      border: Border.symmetric(
                                        vertical: BorderSide.none,
                                        horizontal: BorderSide.none,
                                      )),
                                  child: Text(
                                    // '${languageMap['installation'] ?? 'Installation'}',
                                    '${itemWiseServiceList[index]['installed_Products']}',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0.0),
                                      border: Border.symmetric(
                                        vertical: BorderSide.none,
                                        horizontal: BorderSide.none,
                                      )),
                                  child: Text(
                                    // '${languageMap['support'] ?? 'Support'}',
                                    '${itemWiseServiceList[index]['support_Products']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }))
              ],
            ),
          );
  }
}
