import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:wts_support_engineer/widget/loading.dart';

class MakeSchedulerScreen extends StatefulWidget {
  static const pageId = "MakeScheduleScreen";

  // String productId= Get.parameters['productId']!;
  // String product_code= Get.parameters['product_code'].toString()!;
  @override
  _MakeSchedulerScreenState createState() => _MakeSchedulerScreenState();
}

class _MakeSchedulerScreenState extends State<MakeSchedulerScreen> {
  ScheduleController _scheduleController = Get.find();
  Map<String, dynamic> languageMap = Map();


  ServiceController _serviceCon = Get.find();




  List supportEngineerMapList = [];
  List schedulerList = [];
  List<String> supportEngineers = ['Select Support Engineer'];
  int? supportEngineerSelectedId;

  // String? supportActionSelectedValue = 'Action Type1';
  String? supportEngineerSelectedValue = 'Select Support Engineer';




  bool? isSupportEngineer,isLoading=false,isDataLoading=false;
  late UserInfoModel _userInfoModel;
  String? scheduleDate = null;

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



  getSupportEngineer() async {
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



  getSchedulerList() async {
    setState(() {
      isDataLoading=true;
    });
    List schedulerList = await _scheduleController.schedulerList();
    print(
        '...................getSchedulerList ${getSchedulerList}................');

    setState(() {
      this.schedulerList = schedulerList;

    });
    setState(() {
      isDataLoading=false;
    });
  }



  @override
  void initState() {

    setLangueWiseContentInLocalMap();
    getCurrentDate();
    getSupportEngineer();
    getSchedulerList();

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
            languageMap['make_scheduler'] ?? 'Make Scheduler',
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
                            scheduleDate ??languageMap['select_schedule_date'] ?? 'Select Schedule Date',
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
                  Center(
                    child: TextButtonCommon(
                      fontSize: 15,
                      text: '${languageMap['submit'] ?? 'Submit'}',
                      callBack: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        await _scheduleController.setScheduler(
                            supportEngineerSelectedId,
                            scheduleDate);

                        switch (_scheduleController.status.value) {
                          case Status.LOADING:
                            print(
                                '..............LOADING LOADING..................');
                            break;
                          case Status.SUCCESS:
                            print(
                                '..............SUCCESS SUCCESS..................');

                         //   Get.offAndToNamed(ComplainCreationResultScreen.pageId);
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
                    height: 30,
                  ),
                  Container(
                    child: Text(
                      '${languageMap['current_schedulers'] ?? 'Current Schedulers'}',
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
                    child:isDataLoading==true?Center(child: Loading(),): _buildCurrentSchedule(),)

                ]),
              )),
              isLoading: Get.find<ScheduleController>().isLoading.value),
        ));
  }

  _buildCurrentSchedule() {
    return Container(
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                      borderRadius: BorderRadius.circular(0.0),
                      // border: Border.all(width: 1, color: Colors.black)
                  ),
                  child: Text(
                    '${languageMap['se_name'] ?? 'SE Name'}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                      borderRadius: BorderRadius.circular(0.0),
                      // border: Border.all(width: 1, color: Colors.black)

                  ),
                  child: Text(
                    '${languageMap['expiry_date'] ?? 'Expiry Date'}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                      borderRadius: BorderRadius.circular(0.0),
                      // border: Border.all(width: 1, color: Colors.black)
                      //

                  ),
                  child: Text(
                    '${languageMap['remove'] ?? 'Remove'}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.white),
                  ),
                ),
              ),

            ],
          ),

          schedulerList!=null?   Expanded(child: ListView.builder(
              itemCount: schedulerList.length,
              itemBuilder: (_,index){
                return   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0.0),
                            // border: Border.all(width: 1, color: Colors.black)
                        ),
                        child: Text(
                          '${schedulerList[index]['name']}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0.0),
                            // border: Border.all(width: 1, color: Colors.black)

                        ),
                        child: Text(
                          '${schedulerList[index]['date']}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0.0),
                            // border: Border.all(width: 1, color: Colors.black)
                        ),
                        child: GestureDetector(
                            onTap: ()async{
                              setState(() {
                                schedulerList[index]['isLoading'] =
                                true;
                              });

                              var res = await _scheduleController.remove_scheduler(
                                  schedulerList[index]['id'].toString());
                              getSchedulerList();
                              //Fluttertoast.showToast(msg: res);
                              setState(() {
                                schedulerList[index]['isLoading'] =
                                false;
                              });
                            },
                            child: schedulerList[index]['isLoading']!=null&& schedulerList[index]['isLoading']==true?
                            Loading():Icon(Icons.clear,color: Colors.red,))

                        // Text(
                        //   '${languageMap['remove'] ?? 'Remove'}',
                        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black),
                        // ),
                      ),
                    ),

                  ],
                );
              })):SizedBox()
          
        ],
      ),
    );
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
         // scheduleDate = DateFormat('dd/MM/yyyy').format(pickedDate);
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
