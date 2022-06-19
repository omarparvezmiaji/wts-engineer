import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:wts_support_engineer/controller/schedule_controller.dart';
import 'package:wts_support_engineer/controller/service_controller.dart';
import 'package:wts_support_engineer/model/login_info_model.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/static_key.dart';
import 'package:wts_support_engineer/util/status.dart';
import 'package:wts_support_engineer/widget/button_common.dart';
import 'package:wts_support_engineer/widget/commons.dart';

class MakeSchedulerRescheduleScreen extends StatefulWidget {
  static const pageId = "MakeSchedulerRescheduleScreen";

   String complainId= Get.parameters['complainId']!;
   String productName= Get.parameters['productName']!;
   String ticketId= Get.parameters['ticketId']!;
   String serviceType= Get.parameters['service_type']!;
  // String product_code= Get.parameters['product_code'].toString()!;
  @override
  _MakeSchedulerRescheduleScreenState createState() => _MakeSchedulerRescheduleScreenState();
}

class _MakeSchedulerRescheduleScreenState extends State<MakeSchedulerRescheduleScreen> {
  ScheduleController _scheduleController = Get.find();
  ServiceController _serviceCon = Get.find();
  Map<String, dynamic> languageMap = Map();


  bool? isSupportEngineer;
  late UserInfoModel _userInfoModel;
  String? scheduleDate = null;


  List supportEngineerMapList = [];
  List timeSlotMapList = [];
  List<String> supportEngineers = ['Select Support Engineer'];
  List<String> timeSlots = ['Select Time Slot'];
  //String? spirePertsSelectedValue = 'Spire1 parts';
  String? timeSlotSelectedValue = 'Select Time Slot';
  int? supportEngineerSelectedId;
  int? timeSlotSelectedId;

  // String? supportActionSelectedValue = 'Action Type1';
  String? supportEngineerSelectedValue = 'Select Support Engineer';



  supportEngineer() async {
    List se = await _serviceCon.supportEngineer();
    print(
        '...................supportEngineer ${se}................');

    if (se != null && se.length > 0) {
      setState(() {
        this.supportEngineers = [];
        supportEngineerSelectedValue = se[0]['name'];
        se.forEach((element) {
          this.supportEngineers.add(element['name']);
        });
        this.supportEngineerMapList = se;
        supportEngineerSelectedId = supportEngineerMapList[0]['id'];
      });
    }
  }

  timeSlot() async {
    // List spireParts = await _serviceCon.spareParts(widget.productId);
    List tS = await _serviceCon.timeSlot();
    print('...................tS ${tS}................');

    if (tS != null && tS.length > 0) {
      setState(() {
        this.timeSlots = [];
        timeSlotSelectedValue = tS[0]['name'];
        timeSlotMapList = [];
        tS.forEach((element) {
          this.timeSlots.add(element['name']);
        });
        this.timeSlotMapList = tS;
        timeSlotSelectedId = timeSlotMapList[0]['id'];
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
    getCurrentDate();
    supportEngineer();
    timeSlot();
    // print('..........................productId...........${widget.productId}...................');
    // print('..........................product_code...........${widget.product_code}...................');

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: StaticKey.APP_MAINCOLOR,
          title: Text(
            languageMap['schedule_action'] ?? 'Schedule Action',
            style: TextStyle(color: white),
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

                  Container(
                    width: double.infinity,
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                            '${widget?.productName}-   #${widget.ticketId}',
                            style: TextStyle(
                                color: red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: grey),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(top: 10, left: 0, right: 0),
                    padding: EdgeInsets.only(
                        top: 0, left: 10, right: 10, bottom: 0),
                    child: DropdownButton<String>(
                      underline: SizedBox(),
                      value: supportEngineerSelectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          if (supportEngineers.length > 0) {
                            int i = supportEngineers.indexOf(newValue!);
                            supportEngineerSelectedId =
                            supportEngineerMapList[i]['id'];
                            print(
                                '............supportEngineerSelectedId   ${supportEngineerSelectedId}.................');
                          }
                          supportEngineerSelectedValue = newValue;
                        });
                      },
                      items: supportEngineers
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(width: 1, color: Colors.black)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            scheduleDate ?? languageMap['select_schedule_date']?? 'Select Schedule Date',
                            style: TextStyle(
                                fontSize: 15,
                                color: black,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(Icons.calendar_today)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: grey),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(top: 10, left: 0, right: 0),
                    padding:
                    EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
                    child: DropdownButton<String>(
                      underline: SizedBox(),
                      value: timeSlotSelectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          if (timeSlots.length > 0) {
                            int i = timeSlots.indexOf(newValue!);
                            timeSlotSelectedId =
                            timeSlotMapList[i]['id'];
                            print(
                                '............supportEngineerSelectedId   ${timeSlotSelectedId}.................');
                          }
                          timeSlotSelectedValue = newValue;
                        });
                      },
                      items: timeSlots
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: TextButtonCommon(
                      fontSize: 15,
                      text: '${languageMap['submit'] ?? 'Submit'}',
                      callBack: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        await _scheduleController.makeSchedule(
                            widget.serviceType,widget.ticketId,supportEngineerSelectedId!=null?supportEngineerSelectedId.toString():''
                            ,scheduleDate,timeSlotSelectedId!=null?timeSlotSelectedId.toString():'');

                        switch (_scheduleController.status.value) {
                          case Status.LOADING:
                            print(
                                '..............LOADING LOADING..................');
                            break;
                          case Status.SUCCESS:
                            print(
                                '..............SUCCESS SUCCESS..................');
                         //   Get.offAndToNamed(ComplainCreationResultScreen.pageId);
                            Get.back();
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
                    height: 10,
                  ),

                ]),
              )),
              isLoading: Get.find<ScheduleController>().isLoading.value),
        ));
  }


  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        //  dateContainer= DateFormat('dd/MM/yyyy').format(DateTime.parse(pickedDate);
        setState(() {
          scheduleDate = DateFormat('yyyy/MM/dd').format(pickedDate);
        });

        currentDate = pickedDate;
        print('......................current data ${pickedDate}');
      });
  }

  String getCurrentDate(){
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy/MM/dd');
    String formattedDate = formatter.format(now);
    setState(() {
      scheduleDate=formattedDate;
    });

    return formattedDate;
  }

}
