// ignore_for_file: file_names

import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:login2/models/clients/postalCodeModel.dart';
import 'package:login2/models/renewal/renewal_details.dart';
import 'package:login2/screens/product_mannagement/add_products.dart';
import 'package:login2/widgets/addLeadCateoryPopup.dart';
import 'package:lottie/lottie.dart';
import '../../core/common.dart';
import '../../models/lead_management/addLeadCommonDataModel.dart';
import '../../models/lead_management/addLeadFollowupModel.dart';
import '../../models/lead_management/callResultResonModel.dart';
import '../../models/lead_management/leadSubTypeModel.dart';
import '../../screens/leadManagement/leadDetails.dart';
import '../../service/service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AddFollowup extends StatefulWidget {
  String? token;
  bool editLead;
  bool deleteLead;
  bool cloudCall;
  String callMasterId;
  String? fromDate;
  String? toDate;
  String? status;
  String? category;
  String? staff;
  String? pageName;
  bool? isCalled;
  String? callingDate;
  String? callHistoryId;
  int? scrollToIndex;
  String? leadTypeId;
  String? leadType;
  String? leadSubTypeId;
  String? leadSubType;
  String? cost;
  String? address;
  String? searchKey;
  String? priority;
  String? priorityId;
  String? leadType1;
  final DateTime? preservedFromDate;
  final DateTime? preservedToDate;
  final String? preservedSortOrder;
  final bool? preservedSortAscending;
  final List<String>? preservedCategoryItems;
  final List<String>? preservedPriorityItems;
  final List<String>? preservedAssignedStaffItems;
  final List<String>? preservedResponseItems;

  AddFollowup(
    this.token,
    this.editLead,
    this.deleteLead,
    this.cloudCall,
    this.callMasterId, {
    super.key,
    this.fromDate,
    this.toDate,
    this.status,
    this.category,
    this.staff,
    this.pageName,
    this.isCalled,
    this.callingDate,
    this.callHistoryId,
    this.scrollToIndex,
    this.leadTypeId,
    this.leadType,
    this.leadSubTypeId,
    this.leadSubType,
    this.cost,
    this.address,
    this.searchKey,
    this.priority,
    this.priorityId,
    this.leadType1,
    this.preservedFromDate,
    this.preservedToDate,
    this.preservedSortOrder,
    this.preservedSortAscending,
    this.preservedCategoryItems,
    this.preservedPriorityItems,
    this.preservedAssignedStaffItems,
    this.preservedResponseItems,
  });

  @override
  State<AddFollowup> createState() => _AddFollowupState();
}

class _AddFollowupState extends State<AddFollowup> {
  AddLeadCommonDataModel? commonDetails;
  RenewalDetailslModel? detailsResponse;
  LeadSubTypeModel? leadSubTypeList;
  CallResultResonModel? callResultReason;
  List<Template> filteredTemplates = [];
  String templateId = "";
  String callResult = 'Followup';
  String callResultId = '2';
  String callResponse = 'Call Response';
  String callResponseId = '';
  String? nextFollowupDate = '';
  String leadType = 'Lead Category';
  String leadTypeId = '';
  String leadSubType = 'Lead Sub Category';
  String leadSubTypeId = '';
  String callResultReasonName = 'Reason';
  String callResultReasonId = '';
  String invoiceNumber = '';
  String typeDuration = "";
  String? createLeadCategory = '';
  String? addLeadSource = '';
    String? createRenewalPermission = '';
      String? customerAddInvoicePermission = '';
  TextEditingController cost = TextEditingController();
  TextEditingController remarks = TextEditingController();
  TextEditingController calledDate1 = TextEditingController();
  TextEditingController nextFollowupDate1 = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController callResultVal = TextEditingController();
  TextEditingController callResponseVal = TextEditingController();
  TextEditingController leadTypeVal = TextEditingController();
  TextEditingController leadSubTypeVal = TextEditingController();
  TextEditingController priorityVal = TextEditingController();
  TextEditingController timeBefore = TextEditingController(text: "10");
  TextEditingController callReasonVal = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController productRate = TextEditingController();
  TextEditingController productQty = TextEditingController(text: "1");
  TextEditingController productTaxPercent = TextEditingController();
  TextEditingController productTaxAmount = TextEditingController();
  TextEditingController productTotalAmount = TextEditingController();
  TextEditingController productTotalAmountTotal = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController shippingCharge = TextEditingController();
  TextEditingController paidAmount = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController reminderTemplate = TextEditingController();
  TextEditingController renProductRate = TextEditingController();
  TextEditingController renProductQty = TextEditingController(text: "1");
  TextEditingController renProductTaxPercent = TextEditingController();
  TextEditingController renProductTaxAmount = TextEditingController();
  TextEditingController renProductTotalAmount = TextEditingController();
  bool result = true;
  var invoiceDate = DateTime.now();
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> renProducts = [];
  double subTotal = 0.00;
  double subTotalGrand = 0.00;
  double totalTaxAmount = 00;
  double allTotal = 0.00;
  bool isPaying = false;
  dynamic paymentMethod;
  dynamic paymentStatus;
  List<ColloctedStaff> filteredStaff = [];
  String staffId = "";
  String staffName = "Staff";
  List<Product> items = [];
  List<Product> filteredItems = [];
  String productId = "";
  String renProductId = "";
  String productName = "Choose Product";
  String renProductName = "";
  PostalCodeModel? billingPostal;
  PostalCodeModel? shippingPostal;
  bool header = true;
  bool headerContent = false;
  Color paidColor = Colors.black;
  var code = '91';
  bool? result1 = true;
  String? callHistoryId;
  String priority = 'Normal';
  String priorityId = '2';
  bool checked = false;
  bool createOrder = false;
  bool createRenewal = false;
  bool isDifrent = false;
  bool isExpand = false;
  bool isChecked = false;
  bool isMoreDetails = false;
  bool timeOut = false;
  double totalRenAmount = 0;
  String totalProdAmount = "";
  List<TargetGroup> filteredTargets = [];
  List targetGroups = [];
  List targetGroupNames = [];

  void toggleTextFieldVisibility() {
    setState(() {
      checked = !checked;
    });
  }

  void toggleMoreDetails() {
    setState(() {
      isMoreDetails = !isMoreDetails;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void changeRadioValue(int? value) {
    priorityId = value.toString();
    setState(() {});
  }

  /// Common form row widget
  Widget buildFormRow(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RichText(
            text: TextSpan(
              text: label.replaceAll(' *', ''),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              children: [
                if (label.contains('*'))
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 45,
            child: field,
          ),
        ],
      ),
    );
  }

  getData() async {
    startDate.text = DateFormat('dd-MM-yyyy').format(invoiceDate);
    createLeadCategory = await Common.getSharedPref("createLeadCategory");
    addLeadSource = await Common.getSharedPref("addLeadSource");
    createRenewalPermission = await Common.getSharedPref("createRenewalPermission");
    customerAddInvoicePermission = await Common.getSharedPref("customerAddInvoicePermission");
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      // if (connectivityResult == ConnectivityResult.mobile ||
      //     connectivityResult == ConnectivityResult.wifi) {
      //   setState(() {
      //     result = true;
      //   });
      // } else {
      //   setState(() {
      //     result = false;
      //   });
      // }
      if (connectivityResult is List<ConnectivityResult>) {
        if (connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi)) {
          setState(() {
            result = true;
          });
        }
      } else {
        setState(() {
          result = false;
        });
      }
      detailsResponse = await HttpService.getRenewalDetails();
      if (detailsResponse != null) {
        invoiceNumber = detailsResponse!.data.invoiceNumber.toString();
        items = detailsResponse!.data.products;
        filteredTemplates = detailsResponse!.data.template;
        filteredItems.addAll(items);
      }
      commonDetails = await HttpService.addLeadCommonData(widget.token);
      if (commonDetails != null) {
        filteredStaff.addAll(commonDetails!.data.colloctedStaff);
        filteredTargets.addAll(commonDetails!.data.targetGroups);
        callResultReasonList();
        if (widget.leadTypeId != '') {
          leadSubTypeList = await HttpService.leadSubType(widget.leadTypeId);
          if (leadSubTypeList == null) {
            setState(() {
              timeOut = true;
            });
          }
          if (widget.leadType != null) {
            leadType = widget.leadType.toString();
            leadTypeId = widget.leadTypeId.toString();
          }
          if (widget.leadSubType != null) {
            leadSubType = widget.leadSubType.toString();
            leadSubTypeId = widget.leadSubTypeId.toString();
          }
          if (widget.cost != null) {
            cost.text = widget.cost.toString();
          }
          if (widget.address != null) {
            address.text = widget.address.toString();
          }
          if (widget.priority != null) {
            priority = widget.priority.toString();
            priorityId = widget.priorityId.toString();
          }
          setState(() {});
        }
        setState(() {});
      } else {
        setState(() {
          timeOut = true;
        });
      }
    } catch (e) {
      setState(() {
        timeOut = true;
      });
    }
  }

  callResultReasonList() async {
    callResultReason =
        await HttpService.callResultReasonLiat(widget.token, callResultId);
    if (commonDetails != null) {
      setState(() {});
    }
  }

  String getYmdFromDmy(String dmy) {
    if (dmy.isEmpty) return dmy;
    final split = dmy.split("-");
    return "${split[2]}-${split[1]}-${split[0]}";
  }

  @override
  Widget build(BuildContext context) {
    callResultVal.text = callResult;
    callReasonVal.text = callResultReasonName;
    callResponseVal.text = callResponse;
    leadTypeVal.text = leadType;
    leadSubTypeVal.text = leadSubType;
    priorityVal.text = priority;
    if (widget.callHistoryId != null) {
      callHistoryId = widget.callHistoryId.toString();
    } else {
      callHistoryId = '';
    }
    if (widget.callingDate != null) {
      calledDate1.text = DateFormat('dd-MM-yyyy hh:mm a')
          .format(DateTime.parse(widget.callingDate.toString()));
    } else {
      calledDate1.text = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
    }

    return result == true && timeOut == false
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
              child: Container(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF2a86c9), Color(0xFF406dbe)]),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle),
                              child: const Icon(
                                Icons.arrow_back_ios_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          const Text(
                            'Add Followup',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: commonDetails != null && callResultReason != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: const Text('Called Date : ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ))),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  controller: calledDate1,
                                  readOnly: true,
                                  onTap: () async {
                                    await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now())
                                        .then((selectedDate) {
                                      if (selectedDate != null) {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((selectedTime) {
                                          String newDate =
                                              selectedDate.toString();
                                          newDate = newDate.substring(
                                              0, newDate.indexOf(" "));
                                          String convertedNewDate =
                                              getYmdFromDmy(newDate);
                                          if (selectedTime != null) {
                                            calledDate1.text =
                                                "$convertedNewDate ${selectedTime.format(context)}";
                                          } else {}
                                        });
                                      }
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 10, top: 2, bottom: 2),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      labelStyle:
                                          TextStyle(color: Colors.grey)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      title: const Text('Status'),
                                      content: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .18,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                .8,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: commonDetails!
                                              .data.callResultNew.length,
                                          itemBuilder: (context, ind) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  callResult = commonDetails!
                                                      .data
                                                      .callResultNew[ind]
                                                      .callResultNew
                                                      .toString();

                                                  callResultId = commonDetails!
                                                      .data
                                                      .callResultNew[ind]
                                                      .callResultIdNew
                                                      .toString();
                                                  callResultReasonList();

                                                  // Clear tags when status changes
                                                  callResultReasonName =
                                                      'Reason';
                                                  callResultReasonId = '';
                                                  callReasonVal.text = 'Reason';

                                                  if (callResultId != '2') {
                                                    nextFollowupDate = '';
                                                    checked = false;
                                                  }
                                                  Navigator.pop(context, true);
                                                });
                                              },
                                              child: SizedBox(
                                                height: 50,
                                                child: Text(
                                                  commonDetails!
                                                      .data
                                                      .callResultNew[ind]
                                                      .callResultNew
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  });
                            },
                            maxLines: 1,
                            readOnly: true,
                            controller: callResultVal,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 10, top: 2, bottom: 2),
                                label: RichText(
                                  text: const TextSpan(
                                    text: 'Status',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                    children: [
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: const Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Colors.grey),
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          callResultId == "3"
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: TextFormField(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              scrollable: true,
                                              title: const Text('Reason'),
                                              content: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .32,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .8,
                                                child: callResultReason!
                                                        .data!.isEmpty
                                                    ? const Center(
                                                        child: Text(
                                                          "Reason list is Empty...",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      )
                                                    : ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            callResultReason!
                                                                .data!.length,
                                                        itemBuilder:
                                                            (context, ind) {
                                                          return InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                callResultReasonName =
                                                                    callResultReason!
                                                                        .data![
                                                                            ind]
                                                                        .reason
                                                                        .toString();
                                                                callResultReasonId =
                                                                    callResultReason!
                                                                        .data![
                                                                            ind]
                                                                        .id
                                                                        .toString();
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              });
                                                            },
                                                            child: SizedBox(
                                                              height: 50,
                                                              child: Text(
                                                                callResultReason!
                                                                    .data![ind]
                                                                    .reason
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            18),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                              ),
                                            );
                                          });
                                    },
                                    maxLines: 1,
                                    readOnly: true,
                                    controller: callReasonVal,
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, top: 2, bottom: 2),
                                        label: RichText(
                                          text: const TextSpan(
                                            text: 'Reason',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                            children: [
                                              TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        prefixIcon: const Icon(
                                            Icons.reply_all_sharp,
                                            color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        labelStyle:
                                            const TextStyle(color: Colors.grey)),
                                  ),
                                )
                              : const SizedBox(),
                          if (callResultId == '2')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: checked == true
                                      ? MediaQuery.of(context).size.width * 0.55
                                      : MediaQuery.of(context).size.width * 0.8,
                                  child: TextFormField(
                                    controller: nextFollowupDate1,
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? selectedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );

                                      TimeOfDay? selectedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );

                                      if (selectedTime != null) {
                                        final now = DateTime.now();
                                        final selectedDateTime = DateTime(
                                          selectedDate!.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          selectedTime.hour,
                                          selectedTime.minute,
                                        );

                                        if (selectedDateTime.isAfter(now)) {
                                          String convertedNewDate =
                                              getYmdFromDmy(selectedDate
                                                  .toString()
                                                  .split(' ')[0]);
                                          nextFollowupDate1.text =
                                              "$convertedNewDate ${selectedTime.format(context)}";
                                        } else {
                                          Common.toastMessaage(
                                            "You cannot choose a past time for the follow-up date",
                                            Colors.red,
                                          );
                                        }
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 10, top: 2, bottom: 2),
                                        labelText: 'Next Followup Date',
                                        fillColor: Colors.white,
                                        filled: true,
                                        prefixIcon: Icon(
                                            Icons.calendar_month_sharp,
                                            color: Colors.grey),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.grey)),
                                  ),
                                ),
                                Visibility(
                                  visible: checked,
                                  child: SizedBox(
                                    width: 90,
                                    child: Container(
                                      width: 80,
                                      foregroundDecoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                          color: Colors.blueGrey,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.all(8.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              controller: timeBefore,
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                decimal: false,
                                                signed: true,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 38.0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                  child: InkWell(
                                                    child: const Icon(
                                                      Icons.arrow_drop_up,
                                                      size: 18.0,
                                                    ),
                                                    onTap: () {
                                                      int currentValue =
                                                          int.parse(
                                                              timeBefore.text);
                                                      setState(() {
                                                        currentValue++;
                                                        timeBefore.text =
                                                            (currentValue)
                                                                .toString(); // incrementing value
                                                      });
                                                    },
                                                  ),
                                                ),
                                                InkWell(
                                                  child: const Icon(
                                                    Icons.arrow_drop_down,
                                                    size: 18.0,
                                                  ),
                                                  onTap: () {
                                                    int currentValue =
                                                        int.parse(
                                                            timeBefore.text);
                                                    setState(() {
                                                      currentValue--;
                                                      timeBefore
                                                          .text = (currentValue >
                                                                  0
                                                              ? currentValue
                                                              : 0)
                                                          .toString(); // decrementing value
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (callResultId == '2')
                                  InkWell(
                                    onTap: toggleTextFieldVisibility,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: SizedBox(
                                        width: 10,
                                        child: Icon(Icons.notifications,
                                            color: checked == false
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          if (callResultId == '2')
                            const SizedBox(
                              height: 15,
                            ),
                          TextFormField(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  List filteredResponses = List.from(
                                      commonDetails!.data.callResponseStatus);
                                  TextEditingController searchController =
                                      TextEditingController();

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: const Text('Call Response'),
                                        content: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.53,
                                          child: Column(
                                            children: [
                                              // Search Box
                                              TextField(
                                                controller: searchController,
                                                decoration: InputDecoration(
                                                  hintText: "Search...",
                                                  prefixIcon:
                                                      const Icon(Icons.search),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    filteredResponses = commonDetails!
                                                        .data.callResponseStatus
                                                        .where((element) => element
                                                            .callResponse
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(value
                                                                .toLowerCase()))
                                                        .toList();
                                                  });
                                                },
                                              ),
                                              const SizedBox(height: 10),
                                              // List
                                              Expanded(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      filteredResponses.length,
                                                  itemBuilder: (context, ind) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          callResponse =
                                                              filteredResponses[
                                                                      ind]
                                                                  .callResponse
                                                                  .toString();
                                                          callResponseId =
                                                              filteredResponses[
                                                                      ind]
                                                                  .callResponseId
                                                                  .toString();

                                                          /// ✅ Update the TextFormField controller
                                                          callResponseVal.text =
                                                              callResponse;

                                                          Navigator.pop(
                                                              context, true);
                                                        });
                                                      },
                                                      child: SizedBox(
                                                        height: 50,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      5),
                                                          child: Text(
                                                            filteredResponses[
                                                                    ind]
                                                                .callResponse
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            maxLines: 1,
                            readOnly: true,
                            controller: callResponseVal,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 2, bottom: 2),
                                labelText: 'Call Response',
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon:
                                    Icon(Icons.add_call, color: Colors.grey),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      commonDetails!.data.priority.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: Radio(
                                                activeColor: int.parse(
                                                            priorityId) ==
                                                        1
                                                    ? Colors.grey
                                                    : int.parse(priorityId) == 2
                                                        ? Colors.green
                                                        : int.parse(priorityId) ==
                                                                3
                                                            ? Colors.red
                                                            : Colors.purple,
                                                value: int.parse(commonDetails!
                                                    .data.priority[i].priorityId
                                                    .toString()),
                                                groupValue:
                                                    int.parse(priorityId),
                                                onChanged: (int? value) {
                                                  changeRadioValue(value);
                                                }),
                                          ),
                                          Text(commonDetails!
                                              .data.priority[i].priority
                                              .toString()),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: InkWell(
                              onTap: toggleMoreDetails,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(isMoreDetails == false
                                      ? 'More Details'
                                      : 'Less Details'),
                                  Icon(isMoreDetails == false
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up)
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isMoreDetails,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: cost,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 10, top: 2, bottom: 2),
                                      labelText: 'Cost',
                                      fillColor: Colors.white,
                                      filled: true,
                                      prefixIcon: Icon(Icons.currency_rupee,
                                          color: Colors.grey),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.grey)),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: leadTypeVal,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        List filteredCategories = List.from(
                                            commonDetails!.data.leadCategory);
                                        TextEditingController searchController =
                                            TextEditingController();

                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              scrollable: true,
                                              title:
                                                  const Text('Stream'),
                                              content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: Column(
                                                  children: [
                                                    // Search box
                                                    TextField(
                                                      controller:
                                                          searchController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Search...",
                                                        prefixIcon: const Icon(
                                                            Icons.search),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          filteredCategories = commonDetails!
                                                              .data.leadCategory
                                                              .where((element) => element
                                                                  .leadCategory
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(value
                                                                      .toLowerCase()))
                                                              .toList();
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(height: 10),
                                                    // List
                                                    Expanded(
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            filteredCategories
                                                                .length,
                                                        itemBuilder:
                                                            (context, ind) {
                                                          return InkWell(
                                                            onTap: () async {
                                                              leadSubTypeList =
                                                                  await HttpService
                                                                      .leadSubType(
                                                                filteredCategories[
                                                                        ind]
                                                                    .leadCategoryId
                                                                    .toString(),
                                                              );
                                                              setState(() {
                                                                leadSubType =
                                                                    'Lead Sub Category';
                                                                leadSubTypeId =
                                                                    '';
                                                                leadType = filteredCategories[
                                                                        ind]
                                                                    .leadCategory
                                                                    .toString();
                                                                leadTypeId =
                                                                    filteredCategories[
                                                                            ind]
                                                                        .leadCategoryId
                                                                        .toString();
                                                              });
                                                              Navigator.pop(
                                                                  context,
                                                                  true);
                                                            },
                                                            child: SizedBox(
                                                              height: 50,
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        5),
                                                                child: Text(
                                                                  filteredCategories[
                                                                          ind]
                                                                      .leadCategory
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  maxLines: 1,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 10, top: 2, bottom: 2),
                                    labelText: 'Stream',
                                    fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: const Icon(Icons.category,
                                        color: Colors.grey),
                                    suffixIcon: createLeadCategory == 'true'
                                        ? IconButton(
                                            icon: const Icon(Icons.add_circle,
                                                color: Colors.green),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        dialogContext) =>
                                                    AddLeadCategoryDialog(
                                                  onSubmit: (leadName, cost,
                                                      subcategory) async {
                                                    final token = await Common
                                                        .getSharedPref('token');
                                                    final response =
                                                        await HttpService
                                                            .postLeadCategory(
                                                                leadName,
                                                                cost,
                                                                subcategory);

                                                    if (response != null &&
                                                        response.status) {
                                                      final refreshed =
                                                          await HttpService
                                                              .addLeadCommonData(
                                                                  token);
                                                      setState(() {
                                                        commonDetails =
                                                            refreshed;
                                                      });
                                                      Navigator.pop(
                                                          dialogContext);

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                "Stream added successfully")),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                "Failed to add Stream")),
                                                      );
                                                    }
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        : SizedBox(),
                                    border: const OutlineInputBorder(),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    labelStyle:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                leadSubTypeList != null &&
                                        leadSubTypeList!.data!.isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: TextFormField(
                                          controller: leadSubTypeVal,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    scrollable: true,
                                                    title: const Text(
                                                        'Lead Sub Category'),
                                                    content: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .6,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1.2,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            leadSubTypeList!
                                                                .data!.length,
                                                        itemBuilder: (context,
                                                            subIndex) {
                                                          return InkWell(
                                                            onTap: () async {
                                                              setState(() {
                                                                leadSubType = leadSubTypeList!
                                                                    .data![
                                                                        subIndex]
                                                                    .leadSubCategory
                                                                    .toString();
                                                                leadSubTypeId = leadSubTypeList!
                                                                    .data![
                                                                        subIndex]
                                                                    .leadSubCategoryId
                                                                    .toString();
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              });
                                                            },
                                                            child: SizedBox(
                                                              height: 50,
                                                              child: Text(
                                                                leadSubTypeList!
                                                                    .data![
                                                                        subIndex]
                                                                    .leadSubCategory
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            18),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          maxLines: 1,
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 10, top: 2, bottom: 2),
                                              labelText: 'Lead Sub Category',
                                              fillColor: Colors.white,
                                              filled: true,
                                              prefixIcon: Icon(Icons.subtitles,
                                                  color: Colors.grey),
                                              border: OutlineInputBorder(),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              labelStyle: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      )
                                    : const SizedBox(),
                                TextFormField(
                                  controller: address,
                                  maxLines: 2,
                                  decoration: const InputDecoration(
                                      labelText: 'Address',
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.grey)),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height: 30,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        commonDetails!.data.callResponse.length,
                                    itemBuilder: (context, i) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 10),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              remarks.text = commonDetails!
                                                  .data.callResponse[i]
                                                  .toString();
                                            });
                                          },
                                          child: Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0),
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(6))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, right: 8),
                                                  child: Text(
                                                    commonDetails!
                                                        .data.callResponse[i]
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Color(0xFF717171),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: remarks,
                                  maxLines: 2,
                                  decoration: const InputDecoration(
                                      labelText: 'Remarks',
                                      fillColor: Colors.white,
                                      filled: true,
                                      //prefixIcon: Icon(myIcon, color: prefixIconColor),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.grey)),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          if (callResultId == '4' &&
                              customerAddInvoicePermission ==
                                  true)
                            CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Create Order'),
                                value:
                                    createOrder, // initial value of the checkbox
                                onChanged: (bool? value) {
                                  setState(() {
                                    createOrder = value!;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading),
                          Visibility(
                            visible: createOrder &&
                                callResultId == '4' &&
                                customerAddInvoicePermission ==
                                    true,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Invoice Number :',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text(invoiceNumber,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Invoice Date : ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      SizedBox(
                                        width: 100,
                                        height: 50,
                                        child: Center(
                                          child: DateTimePicker(
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            initialValue:
                                                invoiceDate.toString(),
                                            type: DateTimePickerType.date,
                                            firstDate: DateTime(1995),
                                            lastDate: DateTime.now()
                                                .add(const Duration(days: 365)),
                                            // This will add one year from current date
                                            validator: (value) {
                                              return null;
                                            },
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                setState(() {
                                                  invoiceDate =
                                                      DateTime.parse(value);
                                                  startDate.text =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(invoiceDate);
                                                  final endValue =
                                                      invoiceDate.add(Duration(
                                                          days: int.parse(
                                                              typeDuration)));
                                                  endDate.text =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(endValue);
                                                });
                                              }
                                            },
                                            // We can also use onSaved
                                            onSaved: (value) {
                                              if (value!.isNotEmpty) {
                                                invoiceDate = value as DateTime;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () async {
                                        addProductsDialog(context).then((_) {
                                          setState(() {});
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 10,
                                                right: 10),
                                            child: Text(
                                              '+ Add Product',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: Table(
                                        columnWidths: {
                                          0: FixedColumnWidth(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2), // Using 10%
                                          1: FixedColumnWidth(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.16), // Using 30%
                                          2: FixedColumnWidth(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10),
                                          3: FixedColumnWidth(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.16), // Using 20%
                                          4: FixedColumnWidth(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.20),
                                          5: FixedColumnWidth(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10),
                                        },
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                              color: const Color(0xFFece9fd),
                                            ),
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Product',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Rate',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Qty',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Text('Tax',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Amount',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Text(' ',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                products.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          "No Products !",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: products.length,
                                          itemBuilder: (context, index) {
                                            Color color = index % 2 == 0
                                                ? const Color(0xFFF3F3F3)
                                                : const Color(0xFFece9fd);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Table(
                                                columnWidths: {
                                                  0: FixedColumnWidth(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.2), // Using 10%
                                                  1: FixedColumnWidth(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.16), // Using 30%
                                                  2: FixedColumnWidth(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.10),
                                                  3: FixedColumnWidth(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.16), // Using 20%
                                                  4: FixedColumnWidth(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.20),
                                                  5: FixedColumnWidth(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.10),
                                                },
                                                children: [
                                                  // Each TableRow represents a row in the Table
                                                  TableRow(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1),
                                                      color: color,
                                                    ),
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          products[index]
                                                              ['product_name'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          products[index]
                                                              ['product_rate'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          products[index]
                                                              ['quantity'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          products[index][
                                                              'total_tax_amount'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          products[index]
                                                              ['total_amount'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        // In the product deletion onTap handler, replace this:
                                                        onTap: () {
                                                          subTotal = subTotal -
                                                              double.parse(products[
                                                                      index][
                                                                  'total_amount']);
                                                          totalTaxAmount = totalTaxAmount -
                                                              double.parse(products[
                                                                          index]
                                                                      [
                                                                      'total_tax_amount']) *
                                                                  double.parse(products[
                                                                          index]
                                                                      [
                                                                      'quantity']);

                                                          // CORRECTED VERSION:
                                                          subTotalGrand =
                                                              subTotalGrand -
                                                                  double.parse(products[
                                                                          index]
                                                                      [
                                                                      'total_amount']);
                                                          subTotal = subTotal -
                                                              (double.parse(products[
                                                                          index]
                                                                      [
                                                                      'product_rate']) *
                                                                  double.parse(products[
                                                                          index]
                                                                      [
                                                                      'quantity']));
                                                          totalTaxAmount =
                                                              totalTaxAmount -
                                                                  double.parse(products[
                                                                          index]
                                                                      [
                                                                      'total_tax_amount']);

                                                          allTotal = subTotalGrand +
                                                              double.parse(shippingCharge
                                                                          .text ==
                                                                      ''
                                                                  ? '0'
                                                                  : shippingCharge
                                                                      .text) -
                                                              double.parse(
                                                                  discount.text ==
                                                                          ''
                                                                      ? '0'
                                                                      : discount
                                                                          .text);
                                                          paidAmount.text =
                                                              allTotal
                                                                  .toString();

                                                          // Remove the product
                                                          products
                                                              .removeAt(index);
                                                          if (renProducts
                                                              .isNotEmpty) {
                                                            renProducts
                                                                .removeAt(
                                                                    index);
                                                          }
                                                          if (products
                                                              .isEmpty) {
                                                            discount.clear();
                                                            shippingCharge
                                                                .clear();
                                                            subTotal = 0.00;
                                                            subTotalGrand =
                                                                0.00;
                                                            totalTaxAmount =
                                                                0.00;
                                                            allTotal = 0.00;
                                                            paidAmount.text =
                                                                allTotal
                                                                    .toString();
                                                          }

                                                          setState(() {});
                                                        },
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Icon(
                                                            Icons
                                                                .delete_outline,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Text('Total :'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5),
                                                child: Text(subTotal
                                                    .toStringAsFixed(2)),
                                              ))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Text('Tax:'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5),
                                                child: Text(totalTaxAmount
                                                    .toStringAsFixed(2)),
                                              ))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Text('Discount:'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            height: 35,
                                            child: TextFormField(
                                              onChanged: (value) {
                                                if (products.isNotEmpty) {
                                                  if (value == '') {
                                                    value = '0';
                                                  }
                                                  double discountAmount =
                                                      double.tryParse(value) ??
                                                          0.0;
                                                  double shipping =
                                                      double.tryParse(
                                                              shippingCharge
                                                                  .text) ??
                                                          0.0;

                                                  if (discountAmount >
                                                      subTotalGrand) {
                                                    Common.toastMessaage(
                                                        'The discount should not exceed the total amount',
                                                        Colors.red);
                                                    return;
                                                  } else if (discountAmount <
                                                      0) {
                                                    Common.toastMessaage(
                                                        'Please enter valid discount amount',
                                                        Colors.red);
                                                    return;
                                                  }
                                                  allTotal = subTotalGrand +
                                                      shipping -
                                                      discountAmount;
                                                  paidAmount.text = allTotal
                                                      .toStringAsFixed(2);

                                                  setState(() {});
                                                } else {
                                                  discount.clear();
                                                  Common.toastMessaage(
                                                      'choose at least one product',
                                                      Colors.red);
                                                }
                                              },
                                              // onChanged: (value) {
                                              //   if (products.isNotEmpty) {
                                              //     if (value == '') {
                                              //       value = '0';
                                              //     }
                                              //     if (double.parse(
                                              //             discount.text == ""
                                              //                 ? "0"
                                              //                 : discount.text) >
                                              //         subTotal) {
                                              //       Common.toastMessaage(
                                              //           'The discount should not exceed the total amount',
                                              //           Colors.red);
                                              //     } else if (double.parse(
                                              //             discount.text == ""
                                              //                 ? "0"
                                              //                 : discount.text) <
                                              //         0) {
                                              //       Common.toastMessaage(
                                              //           'Please enter valid discount amount',
                                              //           Colors.red);
                                              //     }
                                              //     allTotal = subTotal +
                                              //         double.parse(
                                              //             shippingCharge.text ==
                                              //                     ''
                                              //                 ? '0'
                                              //                 : shippingCharge
                                              //                     .text) -
                                              //         double.parse(value);
                                              //     paidAmount.text =
                                              //         allTotal.toString();

                                              //     paidAmount.text =
                                              //         allTotal.toString();
                                              //     setState(() {});
                                              //   } else {
                                              //     discount.clear();
                                              //     Common.toastMessaage(
                                              //         'choose at least one product',
                                              //         Colors.red);
                                              //   }
                                              //   setState(() {});
                                              // },
                                              controller: discount,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(
                                                    // width: 0.0 produces a thin "hairline" border
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          top: 2,
                                                          bottom: 2),
                                                  //labelText: 'Invoice Number',
                                                  fillColor: Colors.grey[300],
                                                  filled: true,
                                                  // border: const OutlineInputBorder(),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  labelStyle: const TextStyle(
                                                      color: Colors.black)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Text('Shipping Charge:'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            height: 35,
                                            child: TextFormField(
                                              onChanged: (value) {
                                                if (products.isNotEmpty) {
                                                  if (value == '') {
                                                    value = '0';
                                                  }

                                                  allTotal = subTotal +
                                                      double.parse(value) -
                                                      double.parse(
                                                          discount.text == ''
                                                              ? '0'
                                                              : discount.text);
                                                  paidAmount.text =
                                                      allTotal.toString();

                                                  setState(() {});
                                                } else {
                                                  shippingCharge.clear();
                                                  Common.toastMessaage(
                                                      'choose at least one product',
                                                      Colors.red);
                                                }
                                              },
                                              controller: shippingCharge,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          top: 2,
                                                          bottom: 2),
                                                  //labelText: 'Invoice Number',
                                                  fillColor: Colors.grey[300],
                                                  filled: true,
                                                  border:
                                                      const OutlineInputBorder(
                                                    // width: 0.0 produces a thin "hairline" border
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  labelStyle: const TextStyle(
                                                      color: Colors.black)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Divider(),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Grand Total :',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Text(
                                              allTotal.toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(),
                                    buildFormRow(
                                      'Pay Status * :',
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: paymentStatus,
                                            hint: const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 12),
                                              child: Text('Status'),
                                            ),
                                            items: detailsResponse!
                                                .data.paymentStatus
                                                .map((data) {
                                              return DropdownMenuItem(
                                                value: data.paymentStatus
                                                    .toString(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    data.displaySts.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                paymentStatus = newValue;
                                                if (paymentStatus == "paid") {
                                                  paidAmount.text =
                                                      allTotal.toString();
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    if (paymentStatus != "unpaid")
                                      buildFormRow(
                                        'Paid Amount * :',
                                        TextFormField(
                                          controller: paidAmount,
                                          readOnly: paymentStatus == "paid",
                                          style: TextStyle(color: paidColor),
                                          keyboardType: TextInputType.number,
                                          onChanged: (val) {
                                            if (double.tryParse(val) != null &&
                                                double.parse(val) > subTotal) {
                                              Common.toastMessaage(
                                                  'Enter valid amount',
                                                  Colors.red);
                                              paidColor = Colors.red;
                                            } else {
                                              paidColor = Colors.black;
                                            }
                                            setState(() {});
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            filled: true,
                                            fillColor: Colors.grey[300],
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: paymentStatus == "paid" ||
                                          paymentStatus == "partial",
                                      child: Column(
                                        children: [
                                          buildFormRow(
                                            'Payment Method * :',
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  value: paymentMethod,
                                                  hint: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 12),
                                                    child: Text('Method'),
                                                  ),
                                                  items: detailsResponse!
                                                      .data.paymentMethods
                                                      .map((data) {
                                                    return DropdownMenuItem(
                                                      value: data.id.toString(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Text(
                                                          data.name.toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      paymentMethod = newValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          buildFormRow(
                                            'Account Head * :',
                                            GestureDetector(
                                              onTap: () async {
                                                await collectedStaffDialog(
                                                    context);
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        staffName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Icon(Icons.arrow_drop_down,
                                                        color: Colors
                                                            .grey.shade600),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          buildFormRow(
                                            'Target Group :',
                                            GestureDetector(
                                              onTap: () async {
                                                await targetGroupDialog(
                                                    context);
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: targetGroups.isEmpty
                                                    ? const Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            'Target Group'),
                                                      )
                                                    : ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            targetGroupNames
                                                                .length,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 6),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    targetGroupNames[
                                                                        i]),
                                                                const SizedBox(
                                                                    width: 4),
                                                                InkWell(
                                                                  onTap: () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) =>
                                                                              AlertDialog(
                                                                        title: const Text(
                                                                            'Please Confirm'),
                                                                        content:
                                                                            const Text('Are you sure to Remove this Group?'),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.of(context).pop(),
                                                                            child:
                                                                                const Text('No'),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                targetGroupNames.removeAt(i);
                                                                                targetGroups.removeAt(i);
                                                                              });
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text('Yes'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: const Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          if (callResultId == '4' &&
                              createOrder &&
                              createRenewalPermission =="true")
                            CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Create Renewal'),
                                value: createRenewal,
                                onChanged: (bool? value) {
                                  setState(() {
                                    createRenewal = value!;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading),
                          Visibility(
                              visible: createRenewal &&
                                  createOrder &&
                                  createRenewalPermission == "true",
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: startDate,
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime? selectedValue =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            );
                                            setState(() {
                                              startDate.text =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(selectedValue!);
                                              final endValue =
                                                  selectedValue.add(Duration(
                                                      days: int.parse(
                                                          typeDuration)));
                                              endDate.text =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(endValue);
                                            });
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Select Start Date";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.all(8),
                                              labelText: 'Start Date *',
                                              prefixIcon: Icon(
                                                  Icons.calendar_month,
                                                  color: Colors.grey),
                                              border: OutlineInputBorder(),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              labelStyle: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                      const SizedBox(width: 15.0),
                                      Expanded(
                                        child: TextFormField(
                                          onTap: () async {
                                            DateTime? selectedEndDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            );
                                            endDate.text =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(selectedEndDate!);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Select End Date";
                                            }
                                            return null;
                                          },
                                          readOnly: true,
                                          controller: endDate,
                                          decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.all(8),
                                              labelText: 'End Date *',
                                              prefixIcon: Icon(
                                                  Icons.calendar_month,
                                                  color: Colors.grey),
                                              border: OutlineInputBorder(),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              labelStyle: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14.0),
                                  TextFormField(
                                    onTap: () {
                                      dropDialog(context);
                                    },
                                    readOnly: true,
                                    controller: reminderTemplate,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(8),
                                        labelText: 'Remind Template ',
                                        prefixIcon: Icon(Icons.notifications,
                                            color: Colors.grey),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.grey)),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: const Text(
                                          'Is renewal amount is diffrent?'),
                                      value:
                                          isDifrent, // initial value of the checkbox
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isDifrent = value!;
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Visibility(
                                    visible: isDifrent,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: Table(
                                            columnWidths: {
                                              0: FixedColumnWidth(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2), // Using 10%
                                              1: FixedColumnWidth(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.16), // Using 30%
                                              2: FixedColumnWidth(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.10),
                                              3: FixedColumnWidth(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.16), // Using 20%
                                              4: FixedColumnWidth(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20),
                                              5: FixedColumnWidth(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.10),
                                            },
                                            children: [
                                              TableRow(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(1),
                                                  color:
                                                      const Color(0xFFece9fd),
                                                ),
                                                children: const [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('Product',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('Rate',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('Qty',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Text('Tax',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Amount',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Text(' ',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        renProducts.isEmpty
                                            ? const Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Text(
                                                  "No Products !",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              )
                                            : SingleChildScrollView(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemCount: renProducts.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Color color = index % 2 == 0
                                                        ? const Color(
                                                            0xFFF3F3F3)
                                                        : const Color(
                                                            0xFFece9fd);
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: Table(
                                                        columnWidths: {
                                                          0: FixedColumnWidth(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.2), // Using 10%
                                                          1: FixedColumnWidth(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.16), // Using 30%
                                                          2: FixedColumnWidth(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.10),
                                                          3: FixedColumnWidth(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.16), // Using 20%
                                                          4: FixedColumnWidth(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.20),
                                                          5: FixedColumnWidth(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.10),
                                                        },
                                                        children: [
                                                          // Each TableRow represents a row in the Table
                                                          TableRow(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          1),
                                                              color: color,
                                                            ),
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                  renProducts[
                                                                          index]
                                                                      [
                                                                      'product_name'],
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                  renProducts[
                                                                          index]
                                                                      [
                                                                      'product_rate'],
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                  renProducts[
                                                                          index]
                                                                      [
                                                                      'quantity'],
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                  renProducts[
                                                                          index]
                                                                      [
                                                                      'total_tax_amount'],
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                  renProducts[
                                                                          index]
                                                                      [
                                                                      'total_amount'],
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  changeAmount(
                                                                          context,
                                                                          renProducts[index]
                                                                              [
                                                                              'product_name'],
                                                                          renProducts[index]
                                                                              [
                                                                              'product_rate'],
                                                                          renProducts[index]
                                                                              [
                                                                              'quantity'],
                                                                          renProducts[index]
                                                                              [
                                                                              'total_tax_amount'],
                                                                          renProducts[index]
                                                                              [
                                                                              'tax_percent'],
                                                                          renProducts[index]
                                                                              [
                                                                              'total_amount'],
                                                                          renProducts[index]
                                                                              [
                                                                              'product_id'],
                                                                          renProducts[index]
                                                                              [
                                                                              'description'],
                                                                          index)
                                                                      .then(
                                                                          (_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                child:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8.0),
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              if (callResultId == '4' &&
                                  customerAddInvoicePermission ==
                                      true) {
                                // totalProdAmount = amountCalculate(products);
                                if (callResultId == '4' &&
                                    createOrder == false) {
                                  createOrderDialog(context);
                                } else {
                                  if (products.isNotEmpty) {
                                    totalProdAmount = allTotal.toString();
                                    totalRenAmount =
                                        amountCalculate(renProducts);
                                    ConfirmDialog(context);
                                  } else {
                                    Common.toastMessaage(
                                        "Please add product and continue",
                                        Colors.red);
                                  }
                                }
                              } else {
                                postFollowup();
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text('Submit',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Lottie.asset('assets/main/loading.json',
                        fit: BoxFit.fill),
                  ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/noNetwork.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    timeOut == true
                        ? "There seems to be a temporary issue, \n Please retry to continue"
                        : 'No Network Found !',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      getData();
                    },
                    child: SizedBox(
                      width: 120,
                      height: 35,
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              'Try Again',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  amountCalculate(products) {
    double totalAmountConfirm = 0;
    for (int i = 0; i < products.length; i++) {
      totalAmountConfirm =
          totalAmountConfirm + double.parse(products[i]['total_amount']);
    }
    return totalAmountConfirm;
  }

  Future<dynamic> ConfirmDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "CONFIRM",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * .42,
            width: MediaQuery.of(context).size.width * .8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Products :",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            .1 *
                            products.length,
                        width: MediaQuery.of(context).size.width * .8,
                        child: ListView.builder(
                          itemCount: products.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 6.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        child: Text(
                                          (index + 1).toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .35,
                                        child: Text(
                                          products[index]['product_name'],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                        products[index]['total_amount'],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Total Amount : $totalProdAmount /-",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Renewal Products :",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            .1 *
                            renProducts.length,
                        width: MediaQuery.of(context).size.width * .8,
                        child: ListView.builder(
                          itemCount: renProducts.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        child: Text(
                                          (index + 1).toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .35,
                                        child: Text(
                                          renProducts[index]['product_name'],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                        renProducts[index]['total_amount'],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Total Amount : ${totalRenAmount.toString()} /-",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                postFollowup();
                FocusScope.of(context).unfocus();
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> createOrderDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Column(
            children: [
              Text(
                "CONFIRM",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Would you like to proceed without adding a sale?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                postFollowup();
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Object?> addProductsDialog(BuildContext context) {
    return showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return StatefulBuilder(builder: (context, setState) {
          return Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: AlertDialog(
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Product Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddProducts(),
                                )).then((_) {
                              getData();
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xFF2a86c9),
                                Color(0xFF406dbe)
                              ]),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        productDialog(context, "add");
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    productName,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ],
                          ),
                        )),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: SizedBox(
                    //     child: TextFormField(
                    //       controller: productName,
                    //       keyboardType: TextInputType.text,
                    //       decoration: const InputDecoration(
                    //           hintText: 'Product Name',
                    //           contentPadding:
                    //           EdgeInsets.symmetric(
                    //               vertical: 10,
                    //               horizontal: 10),
                    //           border: OutlineInputBorder()),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: TextFormField(
                            onChanged: (value) {
                              productCalculation();
                            },
                            controller: productRate,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 2, bottom: 2),
                                labelText: 'Rate',
                                fillColor: Colors.white,
                                filled: true,
                                // prefixIcon:
                                //     Icon(Icons.arrow_right, color: Colors.grey),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 110,
                          child: TextFormField(
                            onChanged: (value) {
                              productCalculation();
                            },
                            controller: productQty,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 2, bottom: 2),
                                labelText: 'Qty',
                                fillColor: Colors.white,
                                filled: true,
                                // prefixIcon:
                                //     Icon(Icons.arrow_right, color: Colors.grey),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: TextFormField(
                            onChanged: (value) {
                              productCalculation();
                            },
                            controller: productTaxPercent,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 2, bottom: 2),
                                labelText: 'Tax Percent',
                                fillColor: Colors.white,
                                filled: true,
                                // prefixIcon:
                                //     Icon(Icons.arrow_right, color: Colors.grey),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 110,
                          child: TextFormField(
                            controller: productTaxAmount,
                            keyboardType: TextInputType.number,
                            readOnly: true,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 2, bottom: 2),
                                labelText: 'Tax Amount',
                                fillColor: Colors.white,
                                filled: true,
                                // prefixIcon:
                                //     Icon(Icons.arrow_right, color: Colors.grey),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      child: TextFormField(
                        controller: productTotalAmount,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 10, top: 2, bottom: 2),
                            labelText: 'Total Amount',
                            fillColor: Colors.white,
                            filled: true,
                            // prefixIcon:
                            //     Icon(Icons.arrow_right, color: Colors.grey),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 30, right: 30),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (productName == "Choose Product") {
                              Common.toastMessaage('Add a product', Colors.red);
                            } else if (productRate.text.isEmpty) {
                              Common.toastMessaage(
                                  'Enter Product Rate', Colors.red);
                            } else if (productQty.text.isEmpty) {
                              Common.toastMessaage(
                                  'Enter Product Qty', Colors.red);
                            } else if (productTaxPercent.text.isEmpty) {
                              Common.toastMessaage(
                                  'Enter Product Tax Percent', Colors.red);
                            } else if (double.parse(productTaxPercent.text) >
                                    100 ||
                                double.parse(productTaxPercent.text) < 0) {
                              Common.toastMessaage(
                                  'Enter valid tax percentage', Colors.red);
                            } else {
                              products.add({
                                "product_name": productName,
                                "product_id": productId,
                                "description": productDescription.text,
                                "product_rate": productRate.text,
                                "quantity": productQty.text,
                                "tax_percent": productTaxPercent.text,
                                "total_tax_amount": productTaxAmount.text,
                                "total_amount": productTotalAmount.text,
                              });
                              renProducts.add({
                                "product_name": productName,
                                "product_id": productId,
                                "description": productDescription.text,
                                "product_rate": productRate.text,
                                "quantity": productQty.text,
                                "tax_percent": productTaxPercent.text,
                                "total_tax_amount": productTaxAmount.text,
                                "total_amount": productTotalAmount.text,
                              });

                              // subTotal = subTotal +
                              //     double.parse(productTotalAmountTotal.text);
                              subTotal +=
                                  double.parse(productTotalAmountTotal.text) *
                                      double.parse(productQty.text);
// Accumulate subTotalGrand
                              subTotalGrand +=
                                  double.parse(productTotalAmount.text);
// Accumulate totalTaxAmount
                              totalTaxAmount +=
                                  double.parse(productTaxAmount.text) *
                                      double.parse(productQty.text);
                              allTotal = subTotalGrand +
                                  double.parse(shippingCharge.text == ''
                                      ? '0'
                                      : shippingCharge.text) -
                                  double.parse(discount.text == ''
                                      ? '0'
                                      : discount.text);
                              paidAmount.text = allTotal.toString();

                              productName = "Choose Product";
                              productId = "";
                              productDescription.clear();
                              productRate.clear();
                              productQty.clear();
                              productTaxPercent.clear();
                              productTaxAmount.clear();
                              productTotalAmount.clear();
                              final endValue = DateTime.now()
                                  .add(Duration(days: int.parse(typeDuration)));
                              endDate.text =
                                  DateFormat('dd-MM-yyyy').format(endValue);
                              Navigator.of(context).pop();
                              setState(() {});
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 25, right: 25),
                                child: Text(
                                  'Add',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }

  Future<dynamic> productDialog(BuildContext context, String type) {
    return showDialog(
      context: context,
      builder: (context) {
        return Builder(builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                scrollable: true,
                title: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: const Icon(Icons.close)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TextField(
                        autocorrect: false,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {
                          setState(() {
                            filteredItems = items
                                .where((item) => item.productName
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          labelText: 'Search...',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  width: MediaQuery.of(context).size.width * .8,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xFFFCFBFA)),
                          child: ListTile(
                            onTap: () {
                              if (type == "add") {
                                if (productQty.text == "") {
                                  productQty.text = "1";
                                }
                                productName = filteredItems[index].productName;
                                productId = filteredItems[index].id;
                                productRate.text =
                                    filteredItems[index].sellingPrice;
                                productTaxPercent.text =
                                    filteredItems[index].taxPercent;
                                productTaxAmount.text =
                                    filteredItems[index].taxAmount;
                                productTotalAmountTotal.text =
                                    ((double.parse(productRate.text)) *
                                            double.parse(productQty.text))
                                        .toString();
                                productTotalAmount.text =
                                    ((double.parse(productRate.text) +
                                                double.parse(
                                                    productTaxAmount.text)) *
                                            double.parse(productQty.text))
                                        .toString();
                                productTotalAmount.text =
                                    double.parse(productTotalAmount.text)
                                        .toStringAsFixed(2);
                                if (paymentStatus == "paid") {
                                  paidAmount.text = productTotalAmount.text;
                                }
                                typeDuration = filteredItems[index].noOfDays;
                              } else {
                                if (renProductQty.text == "") {
                                  renProductQty.text = "1";
                                }
                                renProductName =
                                    filteredItems[index].productName;
                                renProductId = filteredItems[index].id;
                                renProductRate.text =
                                    filteredItems[index].sellingPrice;
                                renProductTaxPercent.text =
                                    filteredItems[index].taxPercent;
                                renProductTaxAmount.text =
                                    filteredItems[index].taxAmount;
                                renProductTotalAmount.text =
                                    ((double.parse(renProductRate.text) +
                                                double.parse(
                                                    renProductTaxAmount.text)) *
                                            double.parse(renProductQty.text))
                                        .toString();
                                renProductTotalAmount.text =
                                    double.parse(renProductTotalAmount.text)
                                        .toStringAsFixed(2);
                              }
                              setState(() {});
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            title: Text(filteredItems[index].productName),
                            leading: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: Text(filteredItems[index].productName[0]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ));
          });
        });
      },
    );
  }

  Future<Object?> changeAmount(
      BuildContext context,
      String name,
      String rate,
      String qty,
      String tax,
      String taxPerccent,
      String amount,
      String id,
      String des,
      int index) {
    renProductQty.text = qty;
    renProductRate.text = rate;
    renProductTaxPercent.text = taxPerccent;
    renProductTaxAmount.text = tax;
    renProductTotalAmount.text = amount;
    renProductId = id;
    renProductName = name;
    return showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return StatefulBuilder(builder: (context, setState) {
          return Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: AlertDialog(
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Product Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              renProducts.removeAt(index);
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        productDialog(context, "edit");
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    renProductName,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ],
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: TextFormField(
                            onChanged: (value) {
                              renProductCalculation();
                            },
                            controller: renProductRate,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 2, bottom: 2),
                                labelText: 'Rate',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 110,
                          child: TextFormField(
                            onChanged: (value) {
                              renProductCalculation();
                            },
                            controller: renProductQty,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 2, bottom: 2),
                                labelText: 'Qty',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: TextFormField(
                            onChanged: (value) {
                              renProductCalculation();
                            },
                            controller: renProductTaxPercent,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 2, bottom: 2),
                                labelText: 'Tax Percent',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 110,
                          child: TextFormField(
                            controller: renProductTaxAmount,
                            keyboardType: TextInputType.number,
                            readOnly: true,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 2, bottom: 2),
                                labelText: 'Tax Amount',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      child: TextFormField(
                        controller: renProductTotalAmount,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 10, top: 2, bottom: 2),
                            labelText: 'Total Amount',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 30, right: 30),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (renProductRate.text.isEmpty) {
                              Common.toastMessaage(
                                  'Enter Product Rate', Colors.red);
                            } else if (renProductQty.text.isEmpty) {
                              Common.toastMessaage(
                                  'Enter Product Qty', Colors.red);
                            } else if (renProductTaxPercent.text.isEmpty) {
                              Common.toastMessaage(
                                  'Enter Product Tax Percent', Colors.red);
                            } else if (renProductTaxAmount.text.isEmpty) {
                              Common.toastMessaage(
                                  'Enter Product Tax Amount', Colors.red);
                            } else if (renProductTotalAmount.text.isEmpty) {
                              Common.toastMessaage(
                                  'Enter Product Total Amount', Colors.red);
                            } else {
                              renProducts[index] = {
                                "product_name": renProductName,
                                "product_id": renProductId,
                                "description": des,
                                "product_rate": renProductRate.text,
                                "quantity": renProductQty.text,
                                "tax_percent": renProductTaxPercent.text,
                                "total_tax_amount": renProductTaxAmount.text,
                                "total_amount": renProductTotalAmount.text,
                              };
                              Navigator.of(context).pop();
                              setState(() {});
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 25, right: 25),
                                child: Text(
                                  'Change',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }

  Future<dynamic> dropDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Builder(builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                scrollable: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .6,
                      height: 40,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          labelText: 'Search...',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        onChanged: ((value) {
                          setState(() {
                            filterTemplates(value);
                          });
                        }),
                      ),
                    )
                  ],
                ),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  width: MediaQuery.of(context).size.width * .8,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredTemplates.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          reminderTemplate.text =
                              filteredTemplates[index].templateName;
                          templateId = filteredTemplates[index].id;
                          Navigator.pop(context);
                          filterTemplates("");
                        },
                        title: SizedBox(
                          width: 200,
                          child: Text(
                            filteredTemplates[index].templateName.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ));
          });
        });
      },
    );
  }

  void filterTemplates(
    String query,
  ) {
    filteredTemplates = detailsResponse!.data.template
        .where((map) =>
            map.templateName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<dynamic> collectedStaffDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autocorrect: false,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (value) {
                      setState(() {
                        filteredStaff = commonDetails!.data.colloctedStaff
                            .where((item) => item.accountName
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width * .8,
                  child: ListView.builder(
                    itemCount: filteredStaff.length,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            setState(() {
                              staffName = filteredStaff[index].accountName;
                              staffId = filteredStaff[index].accountId;
                              filteredStaff
                                  .addAll(commonDetails!.data.colloctedStaff);
                            });
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          title: Text(filteredStaff[index].accountName));
                    },
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    filteredStaff.addAll(commonDetails!.data.colloctedStaff);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Close")),
            ],
          );
        });
      },
    );
  }

  postFollowup() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      // if (connectivityResult == ConnectivityResult.mobile ||
      //     connectivityResult == ConnectivityResult.wifi) {
      if (connectivityResult is List<ConnectivityResult>) {
        if (connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi)) {
          if (callResultId == '') {
            Common.toastMessaage('Choose any Status', Colors.red);
          } else if (callResponseId == '') {
            Common.toastMessaage('Choose call response', Colors.red);
          } else if (callResultId == '2' && nextFollowupDate1.text.isEmpty) {
            Common.toastMessaage('Choose next followup date', Colors.red);
          } else if (callResultId == '3' &&
              (callResultReasonId.isEmpty ||
                  callResultReasonId == '0' ||
                  callResultReasonId == 'null')) {
            Common.toastMessaage('Choose any Reason', Colors.red);
          } else if (createOrder == true &&
              products.isEmpty &&
              customerAddInvoicePermission == "true" ) {
            Common.toastMessaage(
                'Please add a product to continue', Colors.red);
          } else if (createOrder == true &&
              customerAddInvoicePermission == "true"  &&
              paymentStatus == null) {
            Common.toastMessaage(
                'Payment Status is required to add invoice', Colors.red);
          } else if (createOrder == true &&
              paidAmount.text.isEmpty &&
              customerAddInvoicePermission == "true"  &&
              paymentStatus != "unpaid") {
            Common.toastMessaage(
                'Paid Amount is required to add invoice', Colors.red);
          } else if (createOrder == true &&
              paymentStatus != "unpaid" &&
              customerAddInvoicePermission == "true"  &&
              paymentMethod == null) {
            Common.toastMessaage(
                'Payment Method is required to add invoice', Colors.red);
          } else if (createOrder == true &&
              customerAddInvoicePermission == "true" &&
              paymentStatus != "unpaid" &&
              staffId == "") {
            Common.toastMessaage(
                'Collected Staff is required to add invoice', Colors.red);
          } else if (createRenewal == true &&
              createRenewalPermission == "true" &&
              startDate.text == "") {
            Common.toastMessaage(
                'Start date is required to add renewal', Colors.red);
          } else if (createRenewal == true &&
              createRenewalPermission == "true" &&
              endDate.text == "") {
            Common.toastMessaage(
                'End date is required to add renewal', Colors.red);
          } else if (double.parse(discount.text == "" ? "0.0" : discount.text) >
              subTotal) {
            Common.toastMessaage(
                'The discount should not exceed the total amount', Colors.red);
          } else if (double.parse(discount.text == "" ? "0.0" : discount.text) <
              0) {
            Common.toastMessaage(
                'Please enter valid discount amount', Colors.red);
          } else if (double.parse(
                  shippingCharge.text == "" ? "0.0" : shippingCharge.text) <
              0) {
            Common.toastMessaage(
                'Please enter valid shipping charge', Colors.red);
          } else {
            if (mounted) {
              Common.showProgressDialog(context, "Loading..");
            }
            AddLeadFollowupModel object1 = await HttpService.addLeadsFollowup(
                widget.token,
                callResultId,
                nextFollowupDate1.text,
                cost.text,
                address.text,
                leadTypeId,
                leadSubTypeId,
                remarks.text,
                widget.callMasterId,
                calledDate1.text,
                callHistoryId,
                priorityId,
                checked,
                timeBefore.text,
                callResponseId,
                callResultReasonId,
                createOrder,
                createRenewal ? "renewal" : "invoice",
                detailsResponse!.data.checkId,
                invoiceDate,
                products,
                reminderTemplate.text,
                allTotal,
                startDate.text,
                endDate.text,
                paymentStatus,
                subTotal,
                totalTaxAmount,
                discount.text,
                shippingCharge.text,
                paymentMethod,
                paidAmount.text,
                staffId,
                isDifrent,
                renProducts,
                targetGroups);
            if (object1.status == true) {
              Common.toastMessaage(object1.message, Colors.green);
              if (mounted) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeadDetails(
                            widget.token!,
                            widget.editLead,
                            widget.deleteLead,
                            widget.cloudCall,
                            widget.callMasterId,
                            pageName: widget.pageName.toString(),
                            fromDate: widget.fromDate,
                            toDate: widget.toDate,
                            status: widget.status,
                            category: widget.category,
                            staff: widget.staff,
                            isCalled: widget.isCalled,
                            searchKey: widget.searchKey,
                            scrollToIndex: widget.scrollToIndex,
                            leadType: widget.leadType1,
                          )),
                );
                Navigator.pop(context);
              }
            } else {
              Common.toastMessaage(object1.message, Colors.red);
              if (mounted) {
                Navigator.pop(context);
              }
            }
          }
        }
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No Network Found..Try Again Later..'),
              backgroundColor: Colors.redAccent,
              elevation: 10,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(10),
            ),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        log(e.toString());
        Common.toastMessaage("Failed !", Colors.red);
        Navigator.pop(context);
      }
    }
  }

  Future<dynamic> targetGroupDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) {
                        setState(() {
                          filteredTargets = commonDetails!.data.targetGroups
                              .where((item) => item.groupName
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .32,
                    width: MediaQuery.of(context).size.width * .8,
                    child: ListView.builder(
                      // Remove NeverScrollableScrollPhysics to enable scrolling
                      shrinkWrap: true,
                      itemCount: filteredTargets.length,
                      itemBuilder: (context, ind) {
                        return CheckboxListTile(
                          title: SizedBox(
                            width: 200,
                            child: Text(
                              filteredTargets[ind].groupName.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                          ),
                          value: targetGroups
                                  .contains(filteredTargets[ind].id.toString())
                              ? true
                              : false,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                targetGroups
                                    .add(filteredTargets[ind].id.toString());
                                targetGroupNames.add(
                                    filteredTargets[ind].groupName.toString());
                              } else {
                                targetGroups
                                    .remove(filteredTargets[ind].id.toString());
                                targetGroupNames.remove(
                                    filteredTargets[ind].groupName.toString());
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  filteredTargets.clear();
                  filteredTargets.addAll(commonDetails!.data.targetGroups);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Done"),
              ),
            ],
          );
        });
      },
    );
  }

  productCalculation() {
    productTaxAmount.text =
        ((double.parse(productRate.text == "" ? "0" : productRate.text) *
                    double.parse(productTaxPercent.text == ""
                        ? "0"
                        : productTaxPercent.text) /
                    100) *
                double.parse(productQty.text == "" ? "0" : productQty.text))
            .toString();
    productTotalAmount.text = ((double.parse(
                    productRate.text == "" ? "0" : productRate.text) *
                double.parse(productQty.text == "" ? "0" : productQty.text)) +
            double.parse(productTaxAmount.text))
        .toString();
    productTotalAmount.text =
        double.parse(productTotalAmount.text).toStringAsFixed(2);
    setState(() {});
  }

  renProductCalculation() {
    renProductTaxAmount.text = ((double.parse(
                    renProductRate.text == "" ? "0" : renProductRate.text) *
                double.parse(renProductTaxPercent.text == ""
                    ? "0"
                    : renProductTaxPercent.text) /
                100) *
            double.parse(renProductQty.text == "" ? "0" : renProductQty.text))
        .toString();
    renProductTotalAmount.text =
        ((double.parse(renProductRate.text == "" ? "0" : renProductRate.text) *
                    double.parse(
                        renProductQty.text == "" ? "0" : renProductQty.text)) +
                double.parse(renProductTaxAmount.text))
            .toString();
    renProductTotalAmount.text =
        double.parse(renProductTotalAmount.text).toStringAsFixed(2);
    setState(() {});
  }
}
