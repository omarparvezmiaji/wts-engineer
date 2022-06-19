import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wts_support_engineer/controller/schedule_controller.dart';
import 'package:wts_support_engineer/controller/service_controller.dart';
import 'package:wts_support_engineer/model/login_info_model.dart';
import 'package:wts_support_engineer/model/schedule_info_model.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/static_key.dart';
import 'package:wts_support_engineer/util/status.dart';
import 'package:wts_support_engineer/view/screen/completed_notcompleted_supportengineer_screen.dart';
import 'package:wts_support_engineer/view/screen/make_schedule_reschedule_screen.dart';
import 'package:wts_support_engineer/widget/commons.dart';
import 'package:wts_support_engineer/widget/loading.dart';

import 'complain_details_screen.dart';
import 'make_scheduler_screen.dart';

class ScheduleScreen extends StatefulWidget {
  static const pageId = 'ScheduleScreen';

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ScheduleScreen> {
  TextEditingController searchController = TextEditingController();

  late ServiceController _serviceCon;
  late ScheduleController _scheduleCon;

  late TabController _controller;
  int _selectedIndex = 0;
  Map<String, dynamic> languageMap = Map();
  bool? isSupportEngineer, isTabBarLoading = true, isLoading = true;

  // List<Map<String, dynamic>> evaluationMap = [];
  late UserInfoModel _userInfoModel;
  bool isFromSetSchedule = false,isScheduler=false;
  List<String> serviceType = [
    'Service Type',
    StaticKey.INSTALLATION,
    StaticKey.SUPPORT
  ];

  String? serviceTypeSelectedValue = 'Service Type';

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

  loadAllData() async {
    setState(() {
      isLoading = true;
    });

    isSupportEngineer =
    await MySharedPreference.getBoolean(SharedPrefKey.ISSUPPORT_ENGINEER);
    var userId = await MySharedPreference.getInt(SharedPrefKey.USER_ID);
    var res = await _serviceCon.loadAllSchedull(
        isSupportEngineer == true ? userId.toString() : null,
        searchController.text,
        serviceTypeSelectedValue == StaticKey.INSTALLATION
            ? '1'
            : serviceTypeSelectedValue == StaticKey.SUPPORT
                ? '2'
                : null);

    await setLangueWiseContentInLocalMap();
    setState(() {
      isLoading = false;
    });
  }

  setLangueWiseContentInLocalMap() async {
    setState(() {
      isTabBarLoading = true;
    });
    isSupportEngineer =
        await MySharedPreference.getBoolean(SharedPrefKey.ISSUPPORT_ENGINEER);
    isScheduler = (await MySharedPreference.getBoolean(SharedPrefKey.ISSCHEDULER))!;
    isSupportEngineer != true || isScheduler==true
        ? _controller = TabController(length: 4, vsync: this)
        : _controller = TabController(length: 3, vsync: this);
    _controller.index = _selectedIndex;

    String userInfo =
        (await MySharedPreference.getString(SharedPrefKey.USER_INFO))!;
    _userInfoModel = UserInfoModel.fromJson(
        jsonDecode(userInfo.toString().replaceAll("\n", "")));

    setState(() {
      isTabBarLoading = false;
    });

    String? langCon = await MySharedPreference.getString(
        SharedPrefKey.LANGUAGE_WISE_CONTENT,
        defauleValue: null);
    if (langCon != null) {
      setState(() {
        languageMap = jsonDecode(langCon.toString());
      });
    }

    _selectedIndex = Get
        .find<ScheduleController>()
        .selectedTab;
    _controller.index = _selectedIndex;
    _controller.index = _selectedIndex;

    Get
        .find<ScheduleController>()
        .selectedTab = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
   // setLangueWiseContentInLocalMap();
    super.initState();

    _serviceCon = Get.find<ServiceController>();
    _scheduleCon = Get.find<ScheduleController>();
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

  dynamic _tabBarSupervisor() {
    //isSupportEngineer == true ? tab.removeLast() : tab;

    return isSupportEngineer==false||isScheduler == true
        ? [
            Tab(
              text: languageMap['today'] ?? 'Today',
            ),
            Tab(
              text: languageMap['upcoming'] ?? 'Upcoming',
            ),
            Tab(
              text: languageMap['past'] ?? 'Past',
            ),
            Tab(
              text: languageMap['set_schedule'] ?? 'Set Schedule',
            ),
          ]
        : [
            Tab(
              text: languageMap['today'] ?? 'Today',
            ),
            Tab(
              text: languageMap['upcoming'] ?? 'Upcoming',
            ),
            Tab(
              text: languageMap['past'] ?? 'Past'
            )
          ];
  }

  dynamic _tabBarView() {
    return isSupportEngineer == false||isScheduler == true
        ? [
            _buildTodaySchedule(context),
            _buildUpComingSchedule(context),
            _buildPastSchedule(context),
            _buildSetSchedule(context),
          ]
        : [
            _buildTodaySchedule(context),
            _buildUpComingSchedule(context),
            _buildPastSchedule(context),
            //  _buildTodaySchedule(context),
          ];
  }

  @override
  Widget build(BuildContext context) {
    // return DefaultTabController(
    //   length: 2,
    return Scaffold(
      appBar: isTabBarLoading == false
          ? AppBar(
        backgroundColor: StaticKey.APP_MAINCOLOR,
              // bottom: TabBar(
              //   isScrollable: isSupportEngineer == false ? true : false,
              //   controller: _controller,
              //   indicatorColor: Colors.blue,
              //   indicatorSize: TabBarIndicatorSize.tab,
              //   tabs: _tabBarSupervisor(),
              // ),
              title: Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      languageMap['schedule'] ?? 'Schedule',
                      style: TextStyle(color: white),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: white),
                          borderRadius: BorderRadius.all(Radius.circular(5)),

                      ),
                      margin: EdgeInsets.only(
                          top: 5, left: 0, right: 0, bottom: 5),
                      padding: EdgeInsets.only(
                          top: 0, left: 10, right: 10, bottom: 0),
                      child: DropdownButton<String>(
                        dropdownColor: StaticKey.APP_MAINCOLOR,
                        iconEnabledColor: Colors.white,
                        underline: SizedBox(),
                        value: serviceTypeSelectedValue,
                        onChanged: (newValue) {
                          setState(() {
                            serviceTypeSelectedValue = newValue;
                            loadAllData();
                          });
                        },
                        items: serviceType
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 12,color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              bottomOpacity: 1,
            )
          : AppBar(
          backgroundColor: StaticKey.APP_MAINCOLOR),
      body: isLoading == false
          ? Column(
              children: [

                Container(
                  padding: EdgeInsets.only(top: 10),
                  color: StaticKey.SECONDARY_COLOR,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 0, right: 0),
                        child: TextField(
                            obscureText: false,
                            controller: searchController,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white, width: 1.0),
                              ),
                              border: OutlineInputBorder(),

                              //labelText: 'Densed TextField',
                              isDense: true,
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    loadAllData();
                                  },
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                              contentPadding: EdgeInsets.all(10),
                              // labelText: 'Password',
                           //   hintText: 'customer/item',
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: languageMap['customer_id_mobile_product_code_ticket_id'] ?? 'Customer Id/Mobile/Product Code/Ticket Id',
                            )),
                      ),
                      TabBar(
                        isScrollable: isSupportEngineer == false ? true : false,
                        controller: _controller,
                        indicatorColor: Colors.blue,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: _tabBarSupervisor(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _controller,
                    children: _tabBarView(),
                  ),
                ),
              ],
            )

          // Column(
          //       children: [
          //         SizedBox(height: 10,),
          //
          //         Container(
          //           width: double.infinity,
          //
          //           padding: EdgeInsets.all(10),
          //           margin: EdgeInsets.only(left: 0, right: 0),
          //           child: TextField(
          //               obscureText: false,
          //               controller: searchController,
          //               decoration: InputDecoration(
          //                 border: OutlineInputBorder(),
          //                 //labelText: 'Densed TextField',
          //                 isDense: true,
          //                 contentPadding: EdgeInsets.all(10),
          //                 // labelText: 'Password',
          //                 hintText: 'customer/item',
          //               )),
          //         ),
          //
          //
          //         TabBarView(
          //   controller: _controller,
          //   children: _tabBarView(),
          // ),
          //       ],
          //     )
          : Loading(),
      //  ),
    );
  }

  Widget _buildTodaySchedule(BuildContext context) {
    //   _serviceCon.getTodaySchedule(null, null, null);
    return Obx(() {
      if (_serviceCon.todayScheduleList.value != null &&
          _serviceCon.todayScheduleList.value!.length > 0) {
        return RefreshIndicator(
          onRefresh: () {
            return loadAllData();
          },
          child: ListView.builder(
              // the number of items in the list
              itemCount: _serviceCon.todayScheduleList?.value?.length,
              // display each item of the product list
              itemBuilder: (_, index) {
                return _listItemSchedule(
                    _serviceCon.todayScheduleList.value![index],
                    context,
                    false);
              }),
        );
      } else {
        return Center(
          child: Text(
            languageMap['no_data_found'] ?? "No data found",
            style: TextStyle(color: black, fontSize: 15),
          ),
        );
      }
      // switch (_scheduleCon.status.value) {
      //   case Status.LOADING:
      //     return Loading();
      //   case Status.SUCCESS:
      //     return Container(
      //       // Use ListView.builder
      //       margin: EdgeInsets.all(10),
      //       child: RefreshIndicator(
      //         onRefresh: () {
      //           return _scheduleCon.getTodaySchedule(null, null, null);
      //         },
      //         child: ListView.builder(
      //             // the number of items in the list
      //             itemCount: _scheduleCon.todayScheduleList?.value?.length,
      //             // display each item of the product list
      //             itemBuilder: (_, index) {
      //               if (_scheduleCon.todayScheduleList.value != null) {
      //                 return _listItemSchedule(
      //                     _scheduleCon.todayScheduleList.value![index],
      //                     context);
      //               } else {
      //                 return Container();
      //               }
      //             }),
      //       ),
      //     );
      //
      //   default:
      //     return Center(
      //       child: Text(languageMap['no_data_found'] ?? "No data found"),
      //     );
      // }
    });
  }

  Widget _buildUpComingSchedule(BuildContext context) {
    //  _serviceCon.getUpcomintSchedule(null, null, null);
    return Obx(() {
      if (_serviceCon.upcomingScheduleList.value != null &&
          _serviceCon.upcomingScheduleList.value!.length > 0) {
        return RefreshIndicator(
          onRefresh: () {
            return loadAllData();
          },
          child: ListView.builder(
              // the number of items in the list
              itemCount: _serviceCon.upcomingScheduleList?.value?.length,
              // display each item of the product list
              itemBuilder: (_, index) {
                return _listItemSchedule(
                    _serviceCon.upcomingScheduleList.value![index],
                    context,
                    false);
              }),
        );
      } else {
        return Center(
          child: Text(languageMap['no_data_found'] ?? "No data found"),
        );
      }
      //   switch (_scheduleCon.status.value) {
      //     case Status.LOADING:
      //       return Loading();
      //     case Status.SUCCESS:
      //       return Container(
      //         // Use ListView.builder
      //         margin: EdgeInsets.all(10),
      //         child: RefreshIndicator(
      //           onRefresh: () {
      //             return _scheduleCon.getUpcomintSchedule(null, null, null);
      //           },
      //           child: ListView.builder(
      //               // the number of items in the list
      //               itemCount: _scheduleCon.upcomingScheduleList?.value?.length,
      //               // display each item of the product list
      //               itemBuilder: (_, index) {
      //                 if (_scheduleCon.upcomingScheduleList.value != null) {
      //                   return _listItemSchedule(
      //                       _scheduleCon.upcomingScheduleList.value![index],
      //                       context);
      //                 } else {
      //                   return Container();
      //                 }
      //               }),
      //         ),
      //       );
      //
      //     default:
      //       return Center(
      //         child: Text(languageMap['no_data_found'] ?? "No data found"),
      //       );
      //   }
    });
  }

  Widget _buildPastSchedule(BuildContext context) {
    //_serviceCon.getPastSchedule(null, null, null);
    return Obx(() {
      if (_serviceCon.pastScheduleList.value != null &&
          _serviceCon.pastScheduleList.value!.length > 0) {
        return RefreshIndicator(
          onRefresh: () {
            return loadAllData();
          },
          child: ListView.builder(
              // the number of items in the list
              itemCount: _serviceCon.pastScheduleList?.value?.length,
              // display each item of the product list
              itemBuilder: (_, index) {
                return _listItemSchedule(
                    _serviceCon.pastScheduleList.value![index], context, false);
              }),
        );
      } else {
        return Center(
          child: Text(languageMap['no_data_found'] ?? "No data found"),
        );
      }
      // switch (_scheduleCon.status.value) {
      //   case Status.LOADING:
      //     return Loading();
      //   case Status.SUCCESS:
      //     return Container(
      //       // Use ListView.builder
      //       margin: EdgeInsets.all(10),
      //       child: RefreshIndicator(
      //         onRefresh: () {
      //           return _scheduleCon.getPastSchedule(null, null, null);
      //         },
      //         child: ListView.builder(
      //             // the number of items in the list
      //             itemCount: _scheduleCon.pastScheduleList?.value?.length,
      //             // display each item of the product list
      //             itemBuilder: (_, index) {
      //               if (_scheduleCon.pastScheduleList.value != null) {
      //                 return _listItemSchedule(
      //                     _scheduleCon.pastScheduleList.value![index],
      //                     context);
      //               } else {
      //                 return Container();
      //               }
      //             }),
      //       ),
      //     );
      //
      //   default:
      //     return Center(
      //       child: Text(languageMap['no_data_found'] ?? "No data found"),
      //     );
      // }
    });
  }

  Widget _buildSetSchedule(BuildContext context) {
    //  _serviceCon.getSetSchedule(null, null, null);
    return Obx(() {
      if (_serviceCon.setScheduleList.value != null &&
          _serviceCon.setScheduleList.value!.length > 0) {
        return RefreshIndicator(
          onRefresh: () {
            return loadAllData();
          },
          child: ListView.builder(
              // the number of items in the list
              itemCount: _serviceCon.setScheduleList?.value?.length,
              // display each item of the product list
              itemBuilder: (_, index) {
                return _listItemSchedule(
                    _serviceCon.setScheduleList.value![index], context, true);
              }),
        );
      } else {
        return Center(
          child: Text(languageMap['no_data_found'] ?? "No data found"),
        );
      }
      // switch (_scheduleCon.status.value) {
      //   case Status.LOADING:
      //     return Loading();
      //   case Status.SUCCESS:
      //     return Container(
      //       // Use ListView.builder
      //       margin: EdgeInsets.all(10),
      //       child: RefreshIndicator(
      //         onRefresh: () {
      //           return _scheduleCon.getSetSchedule(null, null, null);
      //         },
      //         child: ListView.builder(
      //             // the number of items in the list
      //             itemCount: _scheduleCon.setScheduleList?.value?.length,
      //             // display each item of the product list
      //             itemBuilder: (_, index) {
      //               if (_scheduleCon.setScheduleList.value != null) {
      //                 return _listItemSchedule(
      //                     _scheduleCon.setScheduleList.value![index],
      //                     context);
      //               } else {
      //                 return Container();
      //               }
      //             }),
      //       ),
      //     );
      //
      //   default:
      //     return Center(
      //       child: Text(languageMap['no_data_found'] ?? "No data found"),
      //     );
      // }
    });
  }

  Widget _listItemSchedule(ScheduleInfoModel scheduleInfoModel,
      BuildContext context, bool isFromSetSchedule) {
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
                  isFromSetSchedule == true
                      ? _setScheduleBottomPart(scheduleInfoModel, context)
                      : _scheduleBottomPart(scheduleInfoModel, context),
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
    print('..........................ontheway ....${scheduleInfoModel.onTheWay}');
    return isSupportEngineer == false
        ? Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                scheduleInfoModel.onTheWay.toString()=='1'?Text(''):  GestureDetector(
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

                    loadAllData();
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
                ? Align(
              alignment: Alignment.center,
                  child: GestureDetector(
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

                        loadAllData();
                      },
                      child: scheduleInfoModel.isGoingNowLoading == true
                          ? Loading()
                          : Text(
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

                         loadAllData();
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
                         await Get.toNamed(
                              '${CompletedNotCompletedSupportEngineerScreen.pageId}?ticketId=${scheduleInfoModel.ticketNo.toString()}'
                              '&service_type=${scheduleInfoModel.serviceType!.toLowerCase() == StaticKey.INSTALLATION.toLowerCase() ? 1 : 2}'
                              '&productId=${scheduleInfoModel.productId.toString()}&isCompleted=${0}');

                          loadAllData();
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

  _setScheduleBottomPart(
      ScheduleInfoModel scheduleInfoModel, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              await Get.toNamed(
                  '${MakeSchedulerRescheduleScreen.pageId}?ticketId=${scheduleInfoModel.ticketNo.toString()}&complainId=${scheduleInfoModel.complainId.toString()}&service_type=${scheduleInfoModel.serviceType!.toLowerCase() == StaticKey.INSTALLATION.toLowerCase() ? 1 : 2}'
                  '&productName=${scheduleInfoModel.product.toString()}');
              loadAllData();
            },
            child: Text(
              '${languageMap['make_a_schedule'] ?? 'Make A Schedule'}',
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

  @override
  bool get wantKeepAlive => true;
}
