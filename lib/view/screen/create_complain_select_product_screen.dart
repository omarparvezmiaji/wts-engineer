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
import 'package:wts_support_engineer/view/screen/add_complain_screen.dart';
import 'package:wts_support_engineer/widget/button_common.dart';
import 'package:wts_support_engineer/widget/commons.dart';
import 'package:wts_support_engineer/widget/loading.dart';

class CreateComplainSelectProductScreen extends StatefulWidget {
  static const pageId = "createComplainSelectProductScreen";
  String custoemrId= Get.parameters['custoemrId']!;


  @override
  _CreateComplainSelectProductScreenState createState() =>
      _CreateComplainSelectProductScreenState();
}

class _CreateComplainSelectProductScreenState
    extends State<CreateComplainSelectProductScreen> {
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

  getProductList() async {
    setState(() {
      isLoading = true;
    });
    List se = await _serviceCon.customerWisePorducts(widget.custoemrId);
    print('...................getProductList ${se}................');
    if (se != null && se.length > 0) {
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
    getProductList();

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
            languageMap['select_Item'] ??
                'Select Item',
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
                          return getProductList();
                        },

                        child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                          // SizedBox(
                          //   height: 10,
                          // ),

                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Center(
                              child: customerList!=null&&customerList.length>0?
                              buildCustomerWiseProductList():Center(child: Text(languageMap['no_data_found'] ?? 'No Data Found '),),
                            ),
                          )
                        ]),
                    ),
                      )),
              isLoading: Get.find<ScheduleController>().isLoading.value),
        ));
  }

  Widget buildCustomerWiseProductList() {
    return ListView.builder(
        itemCount: customerList.length,
        itemBuilder: (_, index) {
          return GestureDetector(

              onTap: (){
              Get.toNamed(
                  '${AddComplainScreen.pageId}?customer_id=${widget.custoemrId}'
                      '&product_id=${customerList[index]['product_id']}&product_code=${customerList[index]['product_code']}');
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              margin: EdgeInsets.symmetric(vertical: 5,),
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
                    '${languageMap['product_code'] ?? 'Product Code'}: ${customerList[index]['product_code']}',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${languageMap['model'] ?? 'Model: '}${customerList[index]['model']}',
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        '${languageMap['warranty_available'] ?? 'Warranty Available: '}: '
                            '${customerList[index]['warranty_available']!=null&& customerList[index]['warranty_available']=='1'?
                      languageMap['yes'] ?? 'Yes':languageMap['no'] ?? 'No'}',
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
