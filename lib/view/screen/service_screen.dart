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
import 'package:wts_support_engineer/view/screen/completed_notcompleted_supportengineer_screen.dart';
import 'package:wts_support_engineer/view/screen/make_scheduler_screen.dart';
import 'package:wts_support_engineer/widget/commons.dart';
import 'package:wts_support_engineer/widget/loading.dart';

import 'complain_details_screen.dart';
import 'make_schedule_reschedule_screen.dart';

class ServiceScreen extends StatefulWidget {
  static const pageId = 'ServiceScreen';

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ServiceScreen> {
  late ScheduleController _scheduleCon;
  ServiceController _serviceCon = Get.find();

  ScrollController? _scrollController;
  double _scrollPosition = 0;

  List<String> supportEngineers = ['Select Support Engineer'];
  int? supportEngineerSelectedId = 0;
  List supportEngineerMapList = [];
  String? supportEngineerSelectedValue = 'Select Support Engineer';

  late TabController _controller;
  int _selectedIndex = 0;
  Map<String, dynamic> languageMap = Map();
  bool? isSupportEngineer,
      isTabBarLoading = true,
      isLoading = true,
      isBackToFollowUpLoading = false;
  String? startDate = null, endDate = null;

  // List<Map<String, dynamic>> evaluationMap = [];
  late UserInfoModel _userInfoModel;
  List<String> serviceType = [
    'Service Type',
    StaticKey.INSTALLATION,
    StaticKey.SUPPORT
  ];

  String? serviceTypeSelectedValue = 'Service Type';
  TextEditingController searchController = TextEditingController();

  supportEngineer() async {
    List se = await _serviceCon.supportEngineer();
    print('...................supportEngineer ${se}................');

    if (se != null && se.length > 0) {
      setState(() {
        //  this.supportEngineers = [];
        supportEngineerSelectedValue = se[0]['name'];
        se.forEach((element) {
          this.supportEngineers.add(element['name']);
        });
        this.supportEngineerMapList = se;
        // supportEngineerSelectedId = supportEngineerMapList[0]['id'];
      });
    }
  }

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
    var userId = await MySharedPreference.getInt(SharedPrefKey.USER_ID);
    var res = await _scheduleCon.loadAllSchedull(
        isSupportEngineer == true
            ? userId.toString()
            : supportEngineerSelectedId != null &&
                    supportEngineerSelectedId! > 0
                ? supportEngineerSelectedId?.toString()
                : null,
        startDate,
        endDate,
        searchController.text,
        serviceTypeSelectedValue == StaticKey.INSTALLATION
            ? '1'
            : serviceTypeSelectedValue == StaticKey.SUPPORT
                ? '2'
                : null);
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

    isSupportEngineer == true
        ? _controller = TabController(length: 3, vsync: this)
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

    _selectedIndex = Get.find<ServiceController>().selectedTab;
    _controller.index = _selectedIndex;
    _controller.index = _selectedIndex;

    Get.find<ServiceController>().selectedTab = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isCompletedNextPageLoaded = false;

  _scrollListener() async {
//    print('...................scroll position....offset...........${_scrollController!.position.maxScrollExtent}');
    if (_scrollController!.offset >=
        _scrollController!.position.maxScrollExtent) {
      //  print('...................scroll position....offset...........${_scrollController!.offset}.......postion ; ${_scrollController!.position.pixels}');

      var userId = await MySharedPreference.getInt(SharedPrefKey.USER_ID);
      if (isCompletedNextPageLoaded == false) {
        isCompletedNextPageLoaded = true;
        var res = await _scheduleCon.fatchNextPageData(
            isSupportEngineer == true
                ? userId.toString()
                : supportEngineerSelectedId != null &&
                        supportEngineerSelectedId! > 0
                    ? supportEngineerSelectedId?.toString()
                    : null,
            startDate,
            endDate,
            searchController.text,
            serviceTypeSelectedValue == StaticKey.INSTALLATION
                ? '1'
                : serviceTypeSelectedValue == StaticKey.SUPPORT
                    ? '2'
                    : null);
        isCompletedNextPageLoaded = false;
      }
    }

    setState(() {
      _scrollPosition = _scrollController!.position.pixels;
    });
  }

  @override
  void initState() {
    //  print('..............._buildCompletedSchedule  ..................');
    MySharedPreference.setString(
        SharedPrefKey.COMPLETED_PAGE_NUMBER, 0.toString());
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    setLangueWiseContentInLocalMap();
    super.initState();
    supportEngineer();
    _scheduleCon = Get.find<ScheduleController>();
    getCurrentDate();
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

    return isSupportEngineer == false
        ? [
            Tab(
              text: languageMap['to_be_completed'] ?? 'To Be Completed',
            ),
            Tab(
              text: languageMap['not_completed'] ?? 'Not Completed',
            ),
            Tab(
              text: languageMap['completed'] ?? 'Completed',
            ),
          ]
        : [
            Tab(
              text: languageMap['to_be_completed'] ?? 'To Be Completed',
            ),
            Tab(
              text: languageMap['not_completed'] ?? 'Not Completed',
            ),
            Tab(
              text: languageMap['completed'] ?? 'Completed',
            ),
          ];
  }

  // ,

  dynamic _tabBarView() {
    return isSupportEngineer == false
        ? [
            _buildToBeSchedule(context),
            _buildNotCompletedSchedule(context),
            _buildCompletedSchedule(context),
          ]
        : [
            _buildToBeSchedule(context),
            _buildNotCompletedSchedule(context),
            _buildCompletedSchedule(context),
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
              title: Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      languageMap['service'] ?? 'Service',
                      style: TextStyle(color: white),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: white),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                         ),
                      margin:
                          EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 5),
                      padding: EdgeInsets.only(
                          top: 0, left: 10, right: 10, bottom: 0),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.green,
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
          : AppBar(),
      body: isLoading == false
          ? Column(
              children: [
                Container(
                  color: StaticKey.SECONDARY_COLOR,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          isSupportEngineer == true
                              ? SizedBox()
                              : Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: SizedBox(
                                    child: DropdownButton<String>(
                                      dropdownColor: StaticKey.SECONDARY_COLOR,
                                      iconEnabledColor: Colors.white,
                                      isDense: true,
                                      underline: SizedBox(),
                                      value: supportEngineerSelectedValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          if (supportEngineers.length > 0) {
                                            int i = supportEngineers
                                                .indexOf(newValue!);
                                            if (i > 0)
                                              supportEngineerSelectedId =
                                                  supportEngineerMapList[i - 1]
                                                      ['id'];
                                            else
                                              supportEngineerSelectedId = 0;
                                            print(
                                                '............supportEngineerSelectedId   ${supportEngineerSelectedId}.................');
                                          } else {
                                            supportEngineerSelectedId = 0;
                                          }

                                          supportEngineerSelectedValue =
                                              newValue;
                                          loadAllData();
                                        });
                                      },
                                      items: supportEngineers
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                          Container(
                            width: double.infinity,
                            height: 60,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 0, right: 0),
                            child: TextField(
                                obscureText: false,
                                controller: searchController,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1.0),
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
                                        size: 30,
                                        color: Colors.white,
                                      )),
                                  contentPadding: EdgeInsets.all(5),
                                  // labelText: 'Password',
                                  //   hintText: 'customer/item',
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: languageMap[
                                          'customer_id_mobile_product_code_ticket_id'] ??
                                      'Customer Id/Mobile/Product Code/Ticket Id',
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectDate(context, 'start');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      width: 1, color: Colors.white)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    startDate ??
                                        languageMap['select_date'] ??
                                        'Select Date',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Icon(Icons.calendar_today,color: white,)
                                ],
                              ),
                            ),
                          ),
                          Text('To'),
                          GestureDetector(
                            onTap: () {
                              _selectDate(context, 'end');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      width: 1, color: Colors.white)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    endDate ??
                                        languageMap['select_date'] ??
                                        'Select Date',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Icon(Icons.calendar_today,color: white,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TabBar(
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
          : Loading(),
      //  ),
    );
  }

  Widget _buildCompletedSchedule(BuildContext context) {
    return Obx(() {
      if (_scheduleCon.completedList.value != null &&
          _scheduleCon.completedList.value!.length > 0) {
        return RefreshIndicator(
          onRefresh: () {
            return loadAllData();
          },
          child: ListView.builder(
              // the number of items in the list
              itemCount: _scheduleCon.completedList?.value?.length,
              // display each item of the product list
              controller: _scrollController,
              itemBuilder: (_, index) {
                return _listItemSchedule(
                    _scheduleCon.completedList.value![index],
                    context,
                    StaticKey.CMPLETED);
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

  Widget _buildNotCompletedSchedule(BuildContext context) {
    return Obx(() {
      if (_scheduleCon.notCompletedList.value != null &&
          _scheduleCon.notCompletedList.value!.length > 0) {
        return RefreshIndicator(
          onRefresh: () {
            return loadAllData();
          },
          child: ListView.builder(
              // the number of items in the list
              itemCount: _scheduleCon.notCompletedList?.value?.length,
              // display each item of the product list
              itemBuilder: (_, index) {
                return _listItemSchedule(
                    _scheduleCon.notCompletedList.value![index],
                    context,
                    StaticKey.NOT_CMPLETED);
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

  Widget _buildToBeSchedule(BuildContext context) {
    return Obx(() {
      if (_scheduleCon.toBeCompletedList.value != null &&
          _scheduleCon.toBeCompletedList.value!.length > 0) {
        return RefreshIndicator(
          onRefresh: () {
            return loadAllData();
          },
          child: ListView.builder(
              // the number of items in the list
              itemCount: _scheduleCon.toBeCompletedList?.value?.length,
              // display each item of the product list
              itemBuilder: (_, index) {
                return _listItemSchedule(
                    _scheduleCon.toBeCompletedList.value![index],
                    context,
                    StaticKey.TO_BE_CMPLETED);
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

  Widget _listItemSchedule(
      ScheduleInfoModel scheduleInfoModel, BuildContext context, int identity) {
    return InkWell(
      onTap: () {
        Get.toNamed(
            '${ComplainDetailsScreen.pageId}?ticketId=${scheduleInfoModel.ticketNo.toString()}&service_type=${scheduleInfoModel.serviceType.toString()}');

        //  Get.toNamed(
        //  '${ComplainDetailsScreen.pageId}?ticketId=${scheduleInfoModel.ticketNo.toString()}');

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
                  scheduleInfoModel.serviceType?.toLowerCase() !=
                          StaticKey.SUPPORT.toLowerCase()
                      ? Text('')
                      : Padding(
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
                  _scheduleBottomPart(scheduleInfoModel, context, identity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _scheduleBottomPart(
      ScheduleInfoModel scheduleInfoModel, BuildContext context, int identity) {
    return isSupportEngineer == false
        ? identity == StaticKey.TO_BE_CMPLETED
            ? Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          scheduleInfoModel.isCompletedBySuppervisorLoading =
                              true;
                        });

                        var res = await _scheduleCon.completedBySupervisor(
                            scheduleInfoModel.ticketNo.toString(),
                            scheduleInfoModel.serviceType!.toLowerCase() ==
                                    StaticKey.INSTALLATION.toLowerCase()
                                ? '1'
                                : '2');
                        Fluttertoast.showToast(msg: res);
                        setState(() {
                          scheduleInfoModel.isCompletedBySuppervisorLoading =
                              false;
                        });
                        loadAllData();
                      },
                      child:
                          scheduleInfoModel.isCompletedBySuppervisorLoading ==
                                  true
                              ? Loading()
                              : Text(
                                  '${languageMap['completed'] ?? 'Completed'}',
                                  //  list![index].invoice_no.toString().toString(),
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                    ),
                    GestureDetector(
                      onTap: () async {
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
              )
            : identity == StaticKey.NOT_CMPLETED
                ? Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              scheduleInfoModel
                                  .isCompletedBySuppervisorLoading = true;
                            });

                            var res = await _scheduleCon.completedBySupervisor(
                                scheduleInfoModel.ticketNo.toString(),
                                scheduleInfoModel.serviceType!.toLowerCase() ==
                                        StaticKey.INSTALLATION.toLowerCase()
                                    ? '1'
                                    : '2');
                            Fluttertoast.showToast(msg: res);
                            setState(() {
                              scheduleInfoModel
                                  .isCompletedBySuppervisorLoading = false;
                            });

                            loadAllData();
                          },
                          child: scheduleInfoModel
                                      .isCompletedBySuppervisorLoading ==
                                  true
                              ? Loading()
                              : Text(
                                  '${languageMap['completed'] ?? 'Completed'}',
                                  //  list![index].invoice_no.toString().toString(),
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                        scheduleInfoModel.serviceType?.toLowerCase() ==
                                    StaticKey.SUPPORT.toLowerCase() &&
                                isSupportEngineer != true
                            ? Text('')
                            : GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    scheduleInfoModel.isBackToFollowUpLoading =
                                        true;
                                  });

                                  var res = await _scheduleCon.backToFollowUp(
                                      scheduleInfoModel.ticketNo.toString());
                                  Fluttertoast.showToast(msg: res);
                                  setState(() {
                                    scheduleInfoModel.isBackToFollowUpLoading =
                                        false;
                                  });
                                  loadAllData();
                                },
                                child:
                                    scheduleInfoModel.isBackToFollowUpLoading ==
                                            true
                                        ? Loading()
                                        : Text(
                                            '${languageMap['back_to_follow_up'] ?? 'Back To Follow up'}',
                                            //  list![index].invoice_no.toString().toString(),
                                            style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                              ),
                        scheduleInfoModel.onTheWay.toString() == '1'
                            ? Text('')
                            : GestureDetector(
                                onTap: () async {
                                  await Get.toNamed(
                                      '${MakeSchedulerRescheduleScreen.pageId}?ticketId=${scheduleInfoModel.ticketNo.toString()}&complainId=${scheduleInfoModel.complainId.toString()}&service_type=${scheduleInfoModel.serviceType!.toLowerCase() == StaticKey.INSTALLATION.toLowerCase() ? 1 : 2}'
                                      '&productName=${scheduleInfoModel.product.toString()}');
                                  loadAllData();
                                  // setState(() {
                                  //   scheduleInfoModel.isRescheduleLoading = true;
                                  // });
                                  //
                                  // var res = await _scheduleCon.reschedule(
                                  //     scheduleInfoModel.serviceType!.toLowerCase() ==
                                  //             StaticKey.INSTALLATION
                                  //         ? '1'
                                  //         : '2',
                                  //     scheduleInfoModel.ticketNo.toString());
                                  // Fluttertoast.showToast(msg: res);
                                  // setState(() {
                                  //   scheduleInfoModel.isRescheduleLoading = false;
                                  // });
                                  //
                                  // loadAllData();
                                },
                                child: scheduleInfoModel.isRescheduleLoading ==
                                        true
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
                : Text('')
        : Text('');
  }

  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, String identity) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        //  dateContainer= DateFormat('dd/MM/yyyy').format(DateTime.parse(pickedDate);
        setState(() {
          if (identity == 'start') {
            startDate = DateFormat('yyyy/MM/dd').format(pickedDate);
            loadAllData();
          } else {
            endDate = DateFormat('yyyy/MM/dd').format(pickedDate);

            loadAllData();
          }
        });

        currentDate = pickedDate;
        print('......................current data ${pickedDate}');
      });
  }

  String getCurrentDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy/MM/dd');
    String formattedDate = formatter.format(now);
    setState(() {
      //   endDate=formattedDate;
      //  startDate=formattedDate;
    });
    return formattedDate;
  }

  @override
  bool get wantKeepAlive => true;
}
