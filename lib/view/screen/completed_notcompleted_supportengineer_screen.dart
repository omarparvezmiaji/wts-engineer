import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

class CompletedNotCompletedSupportEngineerScreen extends StatefulWidget {
  static const pageId = "CompletedNotCompletedSupportEngineerScreen";

  String ticket_no = Get.parameters['ticketId']!;
  String productId = Get.parameters['productId']!;
  String service_type = Get.parameters['service_type']!;
  String isCompleted = Get.parameters['isCompleted']??'0';

  // String product_code= Get.parameters['product_code'].toString()!;
  @override
  _CompletedNotCompletedSupportEngineerScreenState createState() =>
      _CompletedNotCompletedSupportEngineerScreenState();
}

class _CompletedNotCompletedSupportEngineerScreenState
    extends State<CompletedNotCompletedSupportEngineerScreen> {
  TextEditingController textFieldComController = TextEditingController();

  ScheduleController _scheduleController = Get.find();
  ServiceController _serviceCon = Get.find();
  Map<String, dynamic> languageMap = Map();

  // List<String> spareparts = ['Spire1 parts', 'Spire2 parts'];
  List<String> spareparts = ['Select Spare Parts'];

  // List<String> actionTypes = ['Action Type1', ' Action Type2'];

  bool? isSupportEngineer;
  bool isVideoSelected = true,isInitial=true;
  late UserInfoModel _userInfoModel;
  File? imageFile, videoFile;
  String? imageFilePath = null;
  String? videoFilePath = null;
  List spirePartsMapList = [];
  List actionTypesMapList = [];
  List<String> actionTypes = ['Select Alteration Type'];

  //String? spirePertsSelectedValue = 'Spire1 parts';
  String? spirePertsSelectedValue = 'Select Spare Parts';
  int? supportActionSelectedId=0;
  List sparePartsSelectedMapList = [];

  // String? supportActionSelectedValue = 'Action Type1';
  String? supportActionSelectedValue = 'Select Alteration Type';

  getSupport_action() async {
    List actionTypes = await _serviceCon.support_action();
    print(
        '...................getServiceTypeList ${actionTypes}................');

    if (actionTypes != null && actionTypes.length > 0) {
      setState(() {
      //  this.actionTypes = [];
       // supportActionSelectedValue = actionTypes[0]['name'];
        actionTypes.forEach((element) {
          this.actionTypes.add(element['name']);
        });
        this.actionTypesMapList = actionTypes;
      //  supportActionSelectedId = actionTypesMapList[0]['id'];
      });
    }
  }

  spareParts() async {
   List spireParts = await _serviceCon.spareParts(widget.productId);
    //List spireParts = await _serviceCon.support_action();
    print('...................spareParts ${spireParts}................');

    if (spireParts != null && spireParts.length > 0) {
      setState(() {
     //   this.spareparts = [];
        //spirePertsSelectedValue = spireParts[0]['name'];
        sparePartsSelectedMapList = [];
        spireParts.forEach((element) {
          this.spareparts.add(element['name']);
        });
        this.spirePartsMapList = spireParts;
       // sparePartsSelectedMapList.add(spireParts[0]);
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
    getSupport_action();
    spareParts();
    print(
        '................................product id  ${widget.productId}........................');

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
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                          child: TextField(
                        maxLines: 6,
                        controller: textFieldComController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: languageMap['note'] ?? 'note...',
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
                        height: 20,
                      ),
                      Visibility(

                       visible: false,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(languageMap['select_spare_parts'] ?? 'Select Spare Parts',style: TextStyle(fontWeight: FontWeight.bold),)),
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
                          value: spirePertsSelectedValue,
                          onChanged: (newValue) {
                            setState(() {
                              if (spirePartsMapList.length > 0) {
                                int i = spareparts.indexOf(newValue!);


                                if(i>0) {
                                  sparePartsSelectedMapList
                                      .remove(spirePartsMapList[i-1]);
                                  sparePartsSelectedMapList
                                      .add(spirePartsMapList[i-1]);
                                }else{

                                }
                                print(
                                    '............actionTypeSelectedId   ${sparePartsSelectedMapList}.................');
                              }
                              spirePertsSelectedValue = newValue;
                            });
                          },
                          items: spareparts
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Visibility(
                        visible: sparePartsSelectedMapList.length>0,
                        child: Container(
                          height: 35,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sparePartsSelectedMapList.length,
                              itemBuilder: (_, i) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  margin: EdgeInsets.only(right: 5,top: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: grey),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Text(
                                            '${sparePartsSelectedMapList[i]['name']}'),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            sparePartsSelectedMapList.removeAt(i);
                                          });
                                        },
                                        child: Positioned(
                                            right: 1,
                                            top: 1,
                                            child: Icon(
                                              Icons.cancel,
                                              size: 20,
                                              color: Colors.red,
                                            )),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: false,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(languageMap['select_alteration_type'] ?? 'Select Alteration Type',style: TextStyle(fontWeight: FontWeight.bold),)),
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
                          value: supportActionSelectedValue,
                          onChanged: (newValue) {
                            setState(() {
                              if (actionTypesMapList.length > 0) {
                                int i = actionTypes.indexOf(newValue!);
                                if(i>0)
                                supportActionSelectedId =
                                    actionTypesMapList[i-1]['id'];
                                else
                                  supportActionSelectedId=0;
                                print(
                                    '............actionTypeSelectedId   ${supportActionSelectedId}.................');
                              }
                              supportActionSelectedValue = newValue;
                            });
                          },
                          items: actionTypes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),

                      isSupportEngineer == true
                          ? Container(
                        margin: EdgeInsets.only(top: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    margin: EdgeInsets.only(
                                        top: 10, left: 0, right: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                _openGalleryForImage(context);
                                                setState(() {
                                                  isVideoSelected = false;
                                                  isInitial = false;
                                                });
                                              },
                                              child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    25),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    25)),
                                                    color:
                                                        isVideoSelected == false&& isInitial==false
                                                            ? Colors.green[600]
                                                            : Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${languageMap['upload_image'] ?? 'Upload Image'}',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              isVideoSelected ==
                                                                      false&& isInitial==false
                                                                  ? Colors.white
                                                                  : Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  )),
                                            )),
                                        SizedBox(width: 1,child: Divider(color: Colors.black,),),
                                        Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                _openGalleryForVideo(context);
                                                setState(() {
                                                  isVideoSelected = true;
                                                  isInitial = false;

                                                });
                                              },
                                              child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    25),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    25)),
                                                    color: isVideoSelected == true && isInitial==false
                                                        ? Colors.green[600]
                                                        : Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${languageMap['upload_video'] ?? 'Upload Video'}',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              isVideoSelected ==
                                                                      true&& isInitial==false
                                                                  ? Colors.white
                                                                  : Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  )),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${imageFilePath == null ? videoFilePath == null ? '' : videoFilePath : imageFilePath}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  )
                                ],
                              ),
                          )
                          : Text(''),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: TextButtonCommon(
                          fontSize: 15,
                          text:
                              '${languageMap['submit'] ?? 'Submit'}',
                          callBack: () async {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            String id = '';

                            // List idList = sparePartsSelectedMapList
                            //     .map((e) => e['id'])
                            //     .toList();

                            sparePartsSelectedMapList.forEach((element) {
                              id +=  '${element['id']},';
                            });
                           print('........................sparePartsSelectedMapList.....${id}........................');
                            await _scheduleController
                                .submitCompleteOrNotComplete(
                                    widget.ticket_no,
                                    widget.service_type,
                                   int.parse( widget.isCompleted),
                                    id,
                                    textFieldComController.text,
                                    supportActionSelectedId != 0
                                        ? supportActionSelectedId.toString()
                                        : '',
                                    imageFilePath,
                                    videoFilePath);

                            switch (_scheduleController.status.value) {
                              case Status.LOADING:
                                print(
                                    '..............LOADING LOADING..................');
                                break;
                              case Status.SUCCESS:
                                print(
                                    '..............SUCCESS SUCCESS..................');
                                //    Get.offAndToNamed(ComplainCreationResultScreen.pageId);
                                Get.back();
                                break;
                              case Status.ERROR:
                                print(
                                    '..............APIERROR APIERROR..................');
                                break;
                            }
                          },
                        ),
                      )
                    ]),
                  ),
                ),
              ),
              isLoading: Get.find<ScheduleController>().isLoading.value),
        ));
  }

  void _openGalleryForVideo(BuildContext context) async {
    var picture = await ImagePicker().pickVideo(source: ImageSource.gallery);

    print(
        '............................................${picture}.............');
    this.setState(() {
      videoFile = File(picture!.path);
      videoFilePath = picture.path;
      imageFile = null;
      imageFilePath = null;
      //   if (imageFile != null)
      //_homeCon.changeProfilePic(imageFilePath!);
    });
//    Navigator.of(context).pop();
  }

  void _openGalleryForImage(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);

    print(
        '............................................${picture}.............');
    this.setState(() {
      imageFile = File(picture!.path);
      imageFilePath = picture.path;
      videoFilePath = null;
      videoFile = null;
      //   if (imageFile != null)
      //_homeCon.changeProfilePic(imageFilePath!);
    });
    // Navigator.of(context).pop();
  }
}
