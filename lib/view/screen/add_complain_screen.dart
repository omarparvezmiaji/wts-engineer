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
import 'package:wts_support_engineer/widget/button_common.dart';
import 'package:wts_support_engineer/widget/commons.dart';


class AddComplainScreen extends StatefulWidget {
  static const pageId = "addcomplainscreen";

    String customer_id= Get.parameters['customer_id']!;
    String product_id= Get.parameters['product_id']!;
    String product_code= Get.parameters['product_code']!;

  @override
  _AddComplainScreenState createState() => _AddComplainScreenState();
}

class _AddComplainScreenState extends State<AddComplainScreen> {
  TextEditingController textFieldComController = TextEditingController();

  ScheduleController _complainController = Get.find();
  ServiceController _serviceController = Get.find();
  Map<String, dynamic> languageMap = Map();
  bool? isSupportEngineer;

  setLangueWiseContentInLocalMap() async{
    isSupportEngineer =
    await MySharedPreference.getBoolean(SharedPrefKey.ISSUPPORT_ENGINEER);

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
    Get.find<ServiceController>().isLoading.value=false;
    print('..........................productId...........${widget.product_id}...................');
    print('..........................product_code...........${widget.product_code}...................');

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: StaticKey.APP_MAINCOLOR,
          title: Text(
             languageMap['create_a_new_complain']?? 'Create A New Complain',
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
                      child: TextField(
                        maxLines: 6,
                        controller: textFieldComController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: languageMap['write_your_complain_here']??'Write your complain here...',
                        ),
                        onChanged: (text) {
                          setState(() {
                            //fullName = text;
                            //you can access nameController in its scope to get
                            // the value of text entered as shown below
                            //fullName = nameController.text;
                          });
                        },
                      )),
                      SizedBox(
                        height: 10,
                      ),
                Center(
                    child: TextButtonCommon(
                      fontSize: 15,
                      text: '${languageMap['create_complain']??'Create Complain'}',
                      callBack: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        int? uId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
                        print('.............uid.......${uId}');
                        await _serviceController.createComplain(isSupportEngineer == true
                            ? uId.toString()
                            : null,widget.customer_id,
                            widget.product_id,widget.product_code,
                            textFieldComController.text.toString().trim());

                        switch (_serviceController.status.value) {
                          case Status.LOADING:
                            print(
                                '..............LOADING LOADING..................');
                            break;
                          case Status.SUCCESS:
                            print(
                                '..............SUCCESS SUCCESS..................');
                            Navigator.pop(context);
                            break;
                          case Status.ERROR:
                          //  Get.back();
                            Navigator.pop(context);
                            print(
                                '..............APIERROR APIERROR..................');
                            break;
                        }
                      },
                    ),
                )
              ]),
                  )),
              isLoading: Get.find<ServiceController>().isLoading.value),
        ));
  }
}
