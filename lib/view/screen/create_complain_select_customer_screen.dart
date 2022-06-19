import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:get/get.dart';
import 'package:wts_support_engineer/controller/schedule_controller.dart';
import 'package:wts_support_engineer/controller/service_controller.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/static_key.dart';
import 'package:wts_support_engineer/util/status.dart';
import 'package:wts_support_engineer/view/screen/create_complain_select_product_screen.dart';
import 'package:wts_support_engineer/widget/button_common.dart';
import 'package:wts_support_engineer/widget/commons.dart';
import 'package:wts_support_engineer/widget/loading.dart';

class CreateComplainSelectCustomerScreen extends StatefulWidget {
  static const pageId = "createComplainSelectCustomerScreen";

  @override
  _CreateComplainSelectCustomerScreenState createState() =>
      _CreateComplainSelectCustomerScreenState();
}

class _CreateComplainSelectCustomerScreenState
    extends State<CreateComplainSelectCustomerScreen> {
  TextEditingController textFieldComController = TextEditingController();

  ScheduleController _complainController = Get.find();
  ServiceController _serviceCon = Get.find();
  Map<String, dynamic> languageMap = Map();
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  List customerList = [];

  setLangueWiseContentInLocalMap() async {
    String? langCon = await MySharedPreference.getString(
        SharedPrefKey.LANGUAGE_WISE_CONTENT,
        defauleValue: null);

    if (langCon != null) {
      setState(() {
        languageMap = jsonDecode(langCon.toString());
      });
    }
  }

  getCustomerList() async {
    setState(() {
      isLoading = true;
    });
    List se = await _serviceCon.customerList(searchController.text);
    print('...................supportEngineer ${se}................');
    if (se != null) {
      setState(() {
        this.customerList = [];
        this.customerList = se;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    setLangueWiseContentInLocalMap();
    getCustomerList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: StaticKey.APP_MAINCOLOR,
          title: Text(
            // languageMap['create_a_complain_select_customer'] ??
            //     'Create a Complain-Select Customer',
            languageMap['select_customer'] ??
                'Select Customer',
            style: TextStyle(color: white,fontSize: 15),
          ),
        ),
        body: Obx(
          () => LoadingOverlay(
              child: isLoading == true
                  ? Center(child: Loading())
                  : Center(
                      child: RefreshIndicator(
                        onRefresh: (){
                        return  getCustomerList();
                        },
                        child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Container(
                            width: double.infinity,
                           // padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 0, right: 0),
                            child: TextField(
                                obscureText: false,
                                controller: searchController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  //labelText: 'Densed TextField',
                                  isDense: true,
                                  suffixIcon: GestureDetector(
                                      onTap: (){
                                        getCustomerList();
                                      },
                                      child: Icon(Icons.search,size: 30,)),
                                  contentPadding: EdgeInsets.all(10),
                                  // labelText: 'Password',
                                  hintText: languageMap[
                                          'search_customer_by_id_name_mobile_num'] ??
                                      'Search Customer by ID,Name,mobile,Num',
                                )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Center(
                              child: buildCustomerList(),
                            ),
                          )
                        ]),
                    ),
                      )),
              isLoading: Get.find<ScheduleController>().isLoading.value),
        ));
  }

  Widget buildCustomerList() {
    return ListView.builder(
        itemCount: customerList.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: (){
              Get.toNamed(
                  '${CreateComplainSelectProductScreen.pageId}?custoemrId=${customerList[index]['id']}');
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              margin: EdgeInsets.symmetric(vertical: 5,),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 17,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                  color: index%2==0?Colors.grey:Colors.grey,
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      index%2==0?Colors.white:Colors.white54 ,
                      index%2==0?Colors.white:Colors.white54,
                    ],
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${customerList[index]['name']}',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${languageMap['customer_id'] ?? 'Customer Id'}: ${customerList[index]['customer_id']}',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${languageMap['mobile_number'] ?? 'Mobile Number'}: ${customerList[index]['phone']}',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
