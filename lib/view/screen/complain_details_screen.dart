import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wts_support_engineer/controller/schedule_controller.dart';
import 'package:wts_support_engineer/model/complain_details_model.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/static_key.dart';
import 'package:wts_support_engineer/widget/commons.dart';
import 'package:wts_support_engineer/widget/loading.dart';

class ComplainDetailsScreen extends StatefulWidget {
  static const pageId = 'complainDetailsScreen';

  // String productId = Get.parameters['productId']!;
  // String complainId = Get.parameters['complainId']!;
  String? ticketId = Get.parameters['ticketId'];
  String? serviceType = Get.parameters['service_type'];

  @override
  _ComplainDetailsScreenState createState() => _ComplainDetailsScreenState();
}

class _ComplainDetailsScreenState extends State<ComplainDetailsScreen> {
  ScheduleController _scheduleCon = Get.find();
  ComplainDetailsModel? _complainDetailsModel;

  Map<String, dynamic> languageMap = Map();
  bool isLoading = false;

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

  @override
  void initState() {
    setLangueWiseContentInLocalMap();
    super.initState();
    //  print(
    //     '........................ticketId.........${widget.ticketId}............');

    getComplainDetailsData();
  }

  getComplainDetailsData() async {
    print(
        '........................ticketId.........${widget.ticketId}  widget.serviceType ${widget.serviceType}............');
    setState(() {
      isLoading = true;
    });
    if (widget.serviceType != null && widget.serviceType!.length > 0)
      _complainDetailsModel = await _scheduleCon.complainDetails(
          widget.serviceType != null
              ? widget.serviceType?.toLowerCase() == StaticKey.INSTALLATION.toLowerCase()
                  ? '1'
                  : '2'
              : null,
          widget.ticketId);
    else
      _complainDetailsModel = await _scheduleCon.complainDetailsBySearch(
          widget.ticketId);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: StaticKey.APP_MAINCOLOR,
          centerTitle: true,
          title: Text(
            languageMap['complain_details'] ?? 'Complain Details',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: isLoading == true
              ? Loading()
              : Container(
                  // Use ListView.builder
                  height: double.infinity,
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  child: _buildMainBody()),

          // Obx(() {
          //   switch (_complainCon.status.value) {
          //     case Status.LOADING:
          //       return Loading();
          //     case Status.SUCCESS:
          //       _complainDetailsModel = _complainCon.complainDetailsModel.value;
          //       return
          //
          //     default:
          //       return Center(
          //         child: Text(languageMap['no_data_found'] ?? "No data found"),
          //       );
          //   }
          // }),
        ));
  }

  Widget _buildMainBody() {
    return SingleChildScrollView(
      child: RefreshIndicator(
        onRefresh: () {
          return getComplainDetailsData();
        },
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Visibility(
                visible: false,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(
                    _complainDetailsModel?.image ??
                        'https://picsum.photos/250?image=9',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Text(
                        '${_complainDetailsModel?.productName}-   #${widget.ticketId}',
                        style: TextStyle(
                            color: red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(5.0),
                //     border: Border.all(width: 1, color: Colors.black)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['product'] ?? 'Product',
                                    _complainDetailsModel?.productName),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['invoice_no'] ?? 'Invoice No',
                                    _complainDetailsModel?.invoiceNo
                                        .toString()),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['product_id'] ?? 'Product Id',
                                    _complainDetailsModel?.productId
                                        .toString()),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: double.infinity,
                              child: _buildtem(
                                  languageMap['product_serial_number'] ??
                                      'Product Serial Number',
                                  _complainDetailsModel?.productSerialNumber
                                      .toString()),
                            )),
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['brand'] ?? 'brand',
                                    _complainDetailsModel?.brand ?? ''),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['model_number'] ??
                                        'Model Number',
                                    _complainDetailsModel?.model),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['voltage'] ?? 'Voltage',
                                    _complainDetailsModel?.voltage),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['warranty_period'] ??
                                        'Warranty Period',
                                    _complainDetailsModel?.warrantyAvailalbe),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['warranty_available'] ??
                                        'Warranty Available',
                                    _complainDetailsModel?.warrantyAvailalbe),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['service_note'] ??
                                        'service_note',
                                    _complainDetailsModel?.serviceNote ?? ''),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['installation_note'] ??
                                        'Installation Note',
                                    _complainDetailsModel?.installationNote ??
                                        ''),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['support_engineer'] ??
                                        'Support Engineer',
                                    _complainDetailsModel?.supportEngineer),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['assigned_date'] ??
                                        'Assigned Date',
                                    _complainDetailsModel?.assignedDate),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(languageMap['slot'] ?? 'slot',
                                    _complainDetailsModel?.slot),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['ticket_status'] ??
                                        'Ticket Status',
                                    _complainDetailsModel?.ticketStatus),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['complete_date'] ??
                                        'Complete Date',
                                    _complainDetailsModel?.completeDate),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                child: _buildtem(
                                    languageMap['support_setup_note'] ??
                                        'Support Setup Note',
                                    _complainDetailsModel?.supportSetupNote),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildtem(String title, String? value) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                        color: black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    value ?? '',
                    style: TextStyle(
                        color: black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: grey,
          )
        ],
      ),
    );
  }
}
