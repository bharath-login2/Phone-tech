// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login2/models/clients/postalCodeModel.dart';
import 'package:login2/models/lead_management/bulkDeleteLeadModel.dart';
import 'package:login2/models/lead_management/districtModel.dart';
import 'package:login2/models/lead_management/leadSubTypeModel.dart';
import 'package:login2/models/lead_management/stateModel.dart';
import 'package:login2/screens/leadManagement/add_followup.dart';
import 'package:login2/screens/leadManagement/dashboardLeadsNewUpdated2.dart';
import 'package:login2/widgets/allreportFilterWidet.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/common.dart';
import '../../models/commonConfigureModel.dart';
import '../../models/lead_management/addLeadCommonDataModel.dart';
import '../../models/lead_management/cloudCallModel.dart';
import '../../models/lead_management/viewLeadsModel.dart';
import '../../service/service.dart';
import 'dashboard.dart';
import 'leadDetails.dart';

class AllReport extends StatefulWidget {
  String? token;
  bool editLead;
  bool deleteLead;
  bool cloudCall;
  String? pageName;
  int? page;
  int? pageSize;
  List? checkedCategoryItems;
  List? checkedCategoryItemsName;
  List? checkedCallResultItems;
  List? checkedCallResultItemsName;
  List? checkedPriorityItems;
  List? checkedPriorityItemsName;
  List? checkedAssignedStaffItems;
  List? checkedAssignedStaffItemsName;
  List? checkedCreatedStaffItems;
  List? checkedCreatedStaffItemsName;
  List<StateList>? stateDetails;
  AllReport(this.token, this.editLead, this.deleteLead, this.cloudCall,
      {this.pageName,
      this.page,
      this.pageSize,
      this.checkedCategoryItems,
      this.checkedCategoryItemsName,
      this.checkedCallResultItems,
      this.checkedCallResultItemsName,
      this.checkedPriorityItems,
      this.checkedPriorityItemsName,
      this.checkedAssignedStaffItems,
      this.checkedAssignedStaffItemsName,
      this.checkedCreatedStaffItems,
      this.checkedCreatedStaffItemsName,
      super.key});

  @override
  State<AllReport> createState() => _AllReportState();
}

class _AllReportState extends State<AllReport> {
  ViewLeadsModel? viewLeads;
  AddLeadCommonDataModel? commonDetails;
  LeadSubTypeModel? leadSubTypeList;
  Map<String, String?> selectedSubCategories = {};
  bool? result = true;
  bool? result1 = true;
  String fromdate = DateTime.now().toString();
  String todate = DateTime.now().toString();
    String fromdateUpdated = DateTime.now().toString();
  String todateUpdated = DateTime.now().toString();
  String createdDate = DateTime.now().toString();
  String updatedDate = DateTime.now().toString();
  var outputFormat = DateFormat('dd-MM-yyyy');
  bool? isCalled = true;
  List selectedIUsers = [];
  List selectedUserNumbers = [];
  bool isCreatedDateChecked = true;
  bool isUpdatedDateChecked = false;
  bool isFilterApplied = false;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  List<dynamic> _filteredItems = [];
  bool _isSelectAll = false;
  final List<Color> _colors = [
    const Color(0xFF2196F3), // Vibrant Blue (index 0)
    const Color(0xFF2196F3), // Blue at index 1 for "New"
    const Color(0xFFFFC107), // Amber/Yellow for Followup (index 2)
    const Color(0xFFFFC107), // Amber/Yellow at index 3 for Followup
    const Color(0xFF4CAF50), // Green 500 (index 4) - Standardized for Closed
    const Color(0xFFF44336), // Red 500 (index 5) - Standardized for Rejected
    const Color(0xFF9C27B0), // Purple 500 (index 6)
    const Color(0xFF2a86c9), // Primary Blue (index 7)
    const Color(0xFF009688), // Teal (index 8)
    const Color(0xFFFF6F00), // Amber 900 (index 9)
    const Color(0xFFD32F2F), // Red 700 (index 10)
    const Color(0xFF1B5E20), // Green 900 (index 11)
    const Color(0xFF0D47A1), // Blue 900 (index 12)
    const Color(0xFF3F51B5), // Indigo (index 13)
  ];
  CommonConfigureModel? configure;
  bool isSort = true;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  TextEditingController stateVal = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController districtVal = TextEditingController();
  PostalCodeModel? postalCodeModel;
  List<PostOffice> postOffices = [];
  List<DistrictList> districtList = [];
  PostOffice? selectedPostOffice;
  bool isDistrictLoading = false;
  //bool isLoading = false;
  String? StateId;
  String? DistrictId;
  List<dynamic> items = [];
  int page = 1;
  int pageSize = 20;
  bool isLoading = false;
  List checkedCategoryItems = [];
  List checkedCategoryItemsName = [];
  List checkedCallResultItems = [];
  List checkedCallResultItemsName = [];
  List checkedPriorityItems = [];
  List checkedPriorityItemsName = [];
  List checkedAssignedStaffItems = [];
  List checkedAssignedStaffItemsName = [];
  List checkedCreatedStaffItems = [];
  List checkedCreatedStaffItemsName = [];
  List checkedLeadSource = [];
  List checkedLeadSourceName = [];
  String? branch;
  String roleId = '';
  String multiBranch = '';
  StateModel? stateDetails;
  @override
  void initState() {
    super.initState();
    getData();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    itemPositionsListener.itemPositions.addListener(() {
      if (itemPositionsListener.itemPositions.value.last.index ==
          items.length - 1) {
        if (items.length < viewLeads!.data.totalLeads) {
          getData();
        }
      }
    });
  }

  Future<StateList?> selectStateDialog(BuildContext context) async {
    return showDialog<StateList>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select State"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: stateDetails?.data.length ?? 0,
              itemBuilder: (context, index) {
                final stateItem = stateDetails!.data[index];
                return ListTile(
                  title: Text(stateItem.name),
                  onTap: () {
                    Navigator.pop(context, stateItem); // return selected state
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> loadPostOffices(String pin) async {
    PostalCodeModel postalCodeModel =
        await HttpService.fetchPostOffice(pin); // your API call
    setState(() {
      postOffices = postalCodeModel.postOffice ?? [];
      if (postOffices.isNotEmpty) {
        selectedPostOffice = postOffices.first;
      }
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
      _filterItems();
    });
  }

  void _filterItems() {
    if (_searchQuery.isEmpty) {
      _filteredItems = List.from(items);
    } else {
      _filteredItems = items.where((item) {
        final name = item.clientName?.toLowerCase() ?? '';
        final phone = item.contactNumber1?.toLowerCase() ?? '';
        final staffName = item.staffName?.toLowerCase() ?? '';

        return name.contains(_searchQuery) ||
            phone.contains(_searchQuery) ||
            staffName.contains(_searchQuery);
      }).toList();
    }
  }

  void _toggleSelectAll() {
    setState(() {
      _isSelectAll = !_isSelectAll;

      if (_isSelectAll) {
        // Select all visible items (considering search filter)
        final itemsToSelect = _searchQuery.isEmpty ? items : _filteredItems;
        for (var item in itemsToSelect) {
          if (!item.isSelected) {
            item.isSelected = true;
            if (!selectedIUsers.contains(item.callMasterId)) {
              selectedIUsers.add(item.callMasterId);
              selectedUserNumbers.add(item.contactNumber1);
            }
          }
        }
      } else {
        // Deselect all
        for (var item in items) {
          item.isSelected = false;
        }
        selectedIUsers.clear();
        selectedUserNumbers.clear();
      }
    });
  }

  void _handleLongPress(int index) {
    if (index >= items.length) return;

    setState(() {
      items[index].isSelected = !items[index].isSelected;
      if (items[index].isSelected) {
        if (!selectedIUsers.contains(items[index].callMasterId)) {
          selectedIUsers.add(items[index].callMasterId);
          selectedUserNumbers.add(items[index].contactNumber1);
        }
      } else {
        selectedIUsers.remove(items[index].callMasterId);
        selectedUserNumbers.remove(items[index].contactNumber1);
      }
      _updateSelectAllState();
    });
  }

  void _updateSelectAllState() {
    final visibleItems = _searchQuery.isEmpty ? items : _filteredItems;
    if (visibleItems.isEmpty) {
      _isSelectAll = false;
      return;
    }
    final allSelected = visibleItems.every((item) => item.isSelected);
    setState(() {
      _isSelectAll = allSelected;
    });
  }

  List<Widget> _buildSelectionActions() {
    return [
      InkWell(
        onTap: _toggleSelectAll,
        child: Container(
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                _isSelectAll ? Icons.check_box : Icons.check_box_outline_blank,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                'All',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),

      // Selected count
      CircleAvatar(
        radius: 13,
        backgroundColor: Colors.white,
        child: Text(
          selectedIUsers.length.toString(),
          style: const TextStyle(color: Colors.blue, fontSize: 17),
        ),
      ),
      const SizedBox(width: 15),
      InkWell(
        onTap: () {
          if (selectedIUsers.isNotEmpty) {
            _showDeleteConfirmationDialog();
          }
        },
        child: const Icon(Icons.delete, color: Colors.red),
      ),
    ];
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Confirm'),
          content: Text(
              'Are you sure you want to delete ${selectedIUsers.length} selected leads?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _performBulkDelete();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

// Add bulk delete method
  Future<void> _performBulkDelete() async {
    Common.showProgressDialog(context, "Deleting leads...");

    try {
      Map<String, dynamic> body = {
        "token": widget.token,
        'leadMasterIds': selectedIUsers,
      };

      BulkDeleteLeadModel deleteBulk = await HttpService.bulkDeleteLead(body);

      if (context.mounted) {
        Navigator.pop(context);
      }

      if (deleteBulk.data == true) {
        Common.toastMessaage(
            '${selectedIUsers.length} lead(s) deleted successfully',
            Colors.green);
        _refreshListAfterDelete();
      } else {
        Common.toastMessaage(deleteBulk.message, Colors.red);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      Common.toastMessaage("Delete failed: ${e.toString()}", Colors.red);
    }
  }

  void _refreshListAfterDelete() {
    final deletedCount = selectedIUsers.length;

    setState(() {
      selectedIUsers.clear();
      selectedUserNumbers.clear();
      _isSelectAll = false;
      for (var item in items) {
        item.isSelected = false;
      }
    });

    if (viewLeads != null) {
      viewLeads!.data.totalLeads = (viewLeads!.data.totalLeads - deletedCount)
          .clamp(0, double.maxFinite.toInt());
    }

    _reloadCurrentData();
  }

  void _reloadCurrentData() {
    setState(() {
      items.clear();
      page = 1;
      _filteredItems.clear();
      _searchController.clear();
      _searchQuery = '';
    });

    getData();
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: AllReportFilterWidget(
                  pageId: 2,
                  initialFilters: {
                    'created_from': DateTime.now()
                        .subtract(const Duration(days: 7))
                        .toIso8601String(),
                    'created_to': DateTime.now().toIso8601String(),
                    'category_ids': <String>[],
                    'from_account_head_ids': <String>[],
                    'to_account_head_ids': <String>[],
                    'created_by_ids': <String>[],
                  },
                  onApplyFilters: (filters) {
                    debugPrint("Filters applied: $filters");
                    // You can assign to currentFilters or reload a list if needed
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void getData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final connectivityResult = await Connectivity().checkConnectivity();
      // result = connectivityResult == ConnectivityResult.mobile ||
      //     connectivityResult == ConnectivityResult.wifi;
      result = connectivityResult ==
              connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult ==
              connectivityResult.contains(ConnectivityResult.wifi);

      roleId = await Common.getSharedPref("roleId");
      multiBranch = await Common.getSharedPref("multiBranch");
      int createdFlag = 0;
      int updatedFlag = 0;
      if (isFilterApplied) {
        createdFlag = isCreatedDateChecked ? 1 : 0;
        updatedFlag = isUpdatedDateChecked ? 1 : 0;
      }

      Map<String, dynamic> body = {
        "token": widget.token,
        "fromDate":
            fromdate != "" ? outputFormat.format(DateTime.parse(fromdate)) : "",
        "toDate":
            todate != "" ? outputFormat.format(DateTime.parse(todate)) : "",
             "fromDateUpdated":
            fromdateUpdated != "" ? outputFormat.format(DateTime.parse(fromdateUpdated)) : "",
        "toDateUpdated":
            todate != "" ? outputFormat.format(DateTime.parse(todateUpdated)) : "",
        "createdDate": createdFlag,
        "updatedDate": updatedFlag,
        "page": page,
        "pageSize": pageSize,
        "callResultId": checkedCallResultItems,
        "leadCategoryId": checkedCategoryItems,
        "priority": checkedPriorityItems,
        "staffId": checkedAssignedStaffItems,
        "createdBy": checkedCreatedStaffItems,
        "branchId": branch,
        "lead_source_id": checkedLeadSource,
        "state": StateId ?? "",
        "district": DistrictId ?? "",
      };

      viewLeads = await HttpService.allViewLeads(body);
      if (viewLeads != null) setState(() {});

      commonDetails = await HttpService.addLeadCommonData(widget.token);
      if (commonDetails != null) setState(() {});

      configure = await HttpService.configure(widget.token);

      setState(() {
        items.addAll(viewLeads!.data.details as Iterable);
        page++;
        isLoading = false;
      });
    }

    loadStates();
  }

  // void getData() async {
  //   //print('scrollIndex1:${widget.scrollToIndex}');

  //   if (!isLoading) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     // selectedIUsers.clear();
  //     // selectedUserNumbers.clear();
  //     final connectivityResult = await (Connectivity().checkConnectivity());
  //     if (connectivityResult == ConnectivityResult.mobile ||
  //         connectivityResult == ConnectivityResult.wifi) {
  //       setState(() {
  //         result = true;
  //       });
  //     } else {
  //       setState(() {
  //         result = false;
  //       });
  //     }

  //     roleId = await Common.getSharedPref("roleId");
  //     multiBranch = await Common.getSharedPref("multiBranch");
  //     int createdFlag = isCreatedDateChecked ? 1 : 0;
  //     int updatedFlag = isUpdatedDateChecked ? 1 : 0;
  //     Map<String, dynamic> body = {
  //       "token": widget.token,
  //       "fromDate":
  //           fromdate != "" ? outputFormat.format(DateTime.parse(fromdate)) : "",
  //       "toDate":
  //           todate != "" ? outputFormat.format(DateTime.parse(todate)) : "",
  //       "createdDate": createdFlag,
  //       "updatedDate": updatedFlag,
  //       "page": page,
  //       "pageSize": pageSize,
  //       "callResultId": checkedCallResultItems,
  //       "leadCategoryId": checkedCategoryItems,
  //       "priority": checkedPriorityItems,
  //       "staffId": checkedAssignedStaffItems,
  //       "createdBy": checkedCreatedStaffItems,
  //       "branchId": branch,
  //       "lead_source_id": checkedLeadSource,
  //       "state": StateId ?? "",
  //       "district": DistrictId ?? "",
  //       //"pincode": pinCode.text,
  //     };
  //     //print(body);
  //     viewLeads = await HttpService.allViewLeads(body);
  //     if (viewLeads != null) {
  //       setState(() {});
  //     }
  //     commonDetails = await HttpService.addLeadCommonData(widget.token);
  //     if (commonDetails != null) {
  //       setState(() {});
  //     }
  //     configure = await HttpService.configure(widget.token);
  //     setState(() {
  //       items.addAll(viewLeads!.data.details as Iterable);
  //       page++;
  //       isLoading = false;
  //     });
  //   } else {
  //     // Handle error
  //   }
  //   loadStates();
  // }

  Future<void> loadStates() async {
    var result = await HttpService.getState();
    log("States loaded: ${result?.data.length}");
    setState(() {
      stateDetails = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFF2a86c9), Color(0xFF406dbe)]),
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
                    Text(
                      selectedIUsers.isNotEmpty
                          ? '${selectedIUsers.length} selected'
                          : 'All Report',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (selectedIUsers.isEmpty)
                      InkWell(
                        onTap: () {
                          fromdate = "";
                          todate = "";
                          filtrationSheet(context);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: const Color(0xFFd5f5f4),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Image.asset("assets/icons/filter.png",
                                  width: 20)),
                        ),
                      ),
                    if (selectedIUsers.isNotEmpty) ..._buildSelectionActions(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      // appBar: PreferredSize(
      //   preferredSize:
      //       Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
      //   child: Container(
      //     padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      //     decoration: const BoxDecoration(
      //       gradient:
      //           LinearGradient(colors: [Color(0xFF2a86c9), Color(0xFF406dbe)]),
      //     ),
      //     child: Padding(
      //       padding: const EdgeInsets.only(
      //           left: 10.0, top: 10.0, bottom: 10.0, right: 10),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               InkWell(
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //                 child: Container(
      //                   height: 25,
      //                   width: 25,
      //                   decoration: BoxDecoration(
      //                       border: Border.all(color: Colors.white),
      //                       shape: BoxShape.circle),
      //                   child: const Icon(
      //                     Icons.arrow_back_ios_outlined,
      //                     color: Colors.white,
      //                     size: 16,
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(
      //                 width: 25,
      //               ),
      //               const Text(
      //                 'All Report',
      //                 style: TextStyle(color: Colors.white, fontSize: 18),
      //               ),
      //             ],
      //           ),
      //           //  IconButton(
      //           //             icon: Icon(
      //           //               Icons.filter_alt,
      //           //               color: Colors.white,
      //           //             ),
      //           //             onPressed: _showFilters,
      //           //           ),
      //           InkWell(
      //             onTap: () {
      //               fromdate = "";
      //               todate = "";
      //               filtrationSheet(context);
      //             },
      //             child: Container(
      //               width: 30,
      //               height: 30,
      //               decoration: BoxDecoration(
      //                   border: Border.all(color: Colors.grey),
      //                   color: const Color(0xFFd5f5f4),
      //                   borderRadius: BorderRadius.circular(5)),
      //               child: Center(
      //                   child:
      //                       Image.asset("assets/icons/filter.png", width: 20)),
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      body: viewLeads != null && configure != null
          ? Column(
              children: [
                // Header section
                if (fromdate != "" && todate != "")
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Date from ',
                            style: TextStyle(fontSize: 14)),
                        Text(outputFormat.format(DateTime.parse(fromdate)),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        const Text(' to ', style: TextStyle(fontSize: 14)),
                        Text(outputFormat.format(DateTime.parse(todate)),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                Text('Total Leads : ${viewLeads!.data.totalLeads}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),

                // Search field
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 8, bottom: 8),
                  child: FractionallySizedBox(
                    widthFactor: 0.97,
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.toLowerCase();
                          _filterItems();
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search by Customer Name, Phone, or Staff',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                ),

                viewLeads!.data.details.isNotEmpty
                    ? Expanded(
                        child: ScrollablePositionedList.builder(
                          //reverse: true,
                          initialScrollIndex: 0,
                          //you can pass the desired index here//
                          itemCount: (_searchQuery.isEmpty
                                  ? items.length
                                  : _filteredItems.length) +
                              (isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index ==
                                (_searchQuery.isEmpty
                                    ? items.length
                                    : _filteredItems.length)) {
                              // When reaching the end of the list, show a loader
                              return _buildLoaderListItem();
                            }

                            // Use filtered items when searching
                            final itemIndex =
                                _searchQuery.isEmpty ? index : index;
                            final displayItems =
                                _searchQuery.isEmpty ? items : _filteredItems;

                            if (itemIndex >= displayItems.length) {
                              return Container();
                            }

                            return Dismissible(
                              key: Key(
                                  '${displayItems[itemIndex].callMasterId}_${index}_${displayItems[itemIndex].hashCode}'),
                              background: Container(
                                color: Colors.green,
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        " Call",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Colors.blue,
                                child: const Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Add Followup",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  if (displayItems[itemIndex].callResult !=
                                      "Confirmed") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddFollowup(
                                                widget.token,
                                                widget.editLead,
                                                widget.deleteLead,
                                                widget.cloudCall,
                                                displayItems[itemIndex]
                                                    .callMasterId,
                                                pageName: widget.pageName,
                                                leadType:
                                                    displayItems[itemIndex]
                                                        .leadCategory,
                                                leadTypeId:
                                                    displayItems[itemIndex]
                                                        .leadCategoryId,
                                                leadSubType:
                                                    displayItems[itemIndex]
                                                        .leadSubCategory,
                                                leadSubTypeId:
                                                    displayItems[itemIndex]
                                                        .leadSubCategoryId,
                                                priorityId:
                                                    displayItems[itemIndex]
                                                        .priority,
                                                priority:
                                                    displayItems[itemIndex]
                                                        .priorityName,
                                                cost: displayItems[itemIndex]
                                                    .cost,
                                                address: displayItems[itemIndex]
                                                    .address,
                                              )),
                                    ).then((value) {
                                      items.clear();
                                      page = 1;
                                      getData();
                                    });
                                  } else {
                                    Common.toastMessaage(
                                        "You can't follow up on confirmed leads",
                                        Colors.red);
                                  }
                                } else {
                                  if (widget.cloudCall == false) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return AlertDialog(
                                            title: const Text('Alert !!!'),
                                            content: const Text(""),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Close')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LeadDetails(
                                                                widget.token!,
                                                                widget.editLead,
                                                                widget
                                                                    .deleteLead,
                                                                widget
                                                                    .cloudCall,
                                                                displayItems[
                                                                        itemIndex]
                                                                    .callMasterId
                                                                    .toString(),
                                                                pageName: widget
                                                                    .pageName
                                                                    .toString(),
                                                                page: page,
                                                                pageSize: page *
                                                                    pageSize,
                                                                fromDate: fromdate
                                                                    .toString(),
                                                                toDate: todate
                                                                    .toString(),
                                                              )),
                                                    ).then((r) {
                                                      items.clear();
                                                      page = 1;
                                                      getData();
                                                    });
                                                  },
                                                  child:
                                                      const Text('followup')),
                                            ],
                                          );
                                        });
                                  } else {
                                    if (widget.cloudCall == true) {
                                      chooseCallDialog(context, itemIndex);
                                    } else {
                                      Common.dialPad(displayItems[itemIndex]
                                          .contactNumber1);
                                    }
                                  }
                                }
                                return null;
                              },
                              child: InkWell(
                                  onLongPress: () =>
                                      _handleLongPress(itemIndex),
                                  onTap: () {
                                    if (selectedIUsers.isNotEmpty) {
                                      _handleLongPress(itemIndex);
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LeadDetails(
                                                  widget.token!,
                                                  widget.editLead,
                                                  widget.deleteLead,
                                                  widget.cloudCall,
                                                  displayItems[itemIndex]
                                                      .callMasterId
                                                      .toString(),
                                                  pageName: widget.pageName
                                                      .toString(),
                                                  page: page,
                                                  pageSize: page * pageSize,
                                                  fromDate: fromdate.toString(),
                                                  toDate: todate.toString(),
                                                )),
                                      ).then((r) {
                                        items.clear();
                                        page = 1;
                                        getData();
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      decoration: BoxDecoration(
                                        color: displayItems[itemIndex]
                                                    .isSelected ==
                                                false
                                            ? Colors.white
                                            : Colors.blue.shade100,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(2.0, 2.0),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, right: 10, left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (selectedIUsers.isNotEmpty)
                                                  Row(
                                                    children: [
                                                      // Checkbox(
                                                      //   value: displayItems[itemIndex].isSelected,
                                                      //   onChanged: (bool? value) {
                                                      //     _handleLongPress(itemIndex);
                                                      //   },
                                                      // ),
                                                      Expanded(
                                                        child:
                                                            _buildLeadContent(
                                                                displayItems[
                                                                    itemIndex],
                                                                context,
                                                                itemIndex),
                                                      ),
                                                    ],
                                                  )
                                                else
                                                  _buildLeadContent(
                                                      displayItems[itemIndex],
                                                      context,
                                                      itemIndex),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            );
                          },
                          itemScrollController: itemScrollController,
                          itemPositionsListener: itemPositionsListener,
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: Image.asset(
                                "assets/icons/nodatafound.png",
                              ),
                            ),
                            const Text(
                              'Result Not Found',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Whoops... this information is \n not available for a moment',
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DashboardLeadNewUpdatedTwo(
                                              widget.token)),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text('Go Back',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ],
            )
          : Center(
              child: Lottie.asset('assets/main/loading.json', fit: BoxFit.fill),
            ),
      // body: viewLeads != null && configure != null
      //     ? Column(
      //         children: [
      //           if (fromdate != "" && todate != "")
      //             Padding(
      //               padding:
      //                   const EdgeInsets.only(left: 50, right: 50, top: 15),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   const Text('Date from ',
      //                       style: TextStyle(fontSize: 14)),
      //                   Text(outputFormat.format(DateTime.parse(fromdate)),
      //                       style: const TextStyle(
      //                           fontSize: 14, fontWeight: FontWeight.bold)),
      //                   const Text(' to ', style: TextStyle(fontSize: 14)),
      //                   Text(outputFormat.format(DateTime.parse(todate)),
      //                       style: const TextStyle(
      //                           fontSize: 14, fontWeight: FontWeight.bold)),
      //                 ],
      //               ),
      //             ),
      //           Text('Total Leads : ${viewLeads!.data.totalLeads}',
      //               style: const TextStyle(
      //                   fontSize: 16, fontWeight: FontWeight.bold)),
      //           const SizedBox(
      //             height: 10,
      //           ),
      //           viewLeads!.data.details.isNotEmpty
      //               ? Expanded(
      //                   child: ScrollablePositionedList.builder(
      //                     //reverse: true,
      //                     initialScrollIndex: 0,
      //                     //you can pass the desired index here//
      //                     itemCount: items.length + (isLoading ? 1 : 0),
      //                     itemBuilder: (context, index) {
      //                       if (index == items.length) {
      //                         // When reaching the end of the list, show a loader
      //                         return _buildLoaderListItem();
      //                       }
      //                       return Dismissible(
      //                         key: const Key('0'),
      //                         background: Container(
      //                           color: Colors.green,
      //                           child: const Align(
      //                             alignment: Alignment.centerLeft,
      //                             child: Row(
      //                               mainAxisAlignment: MainAxisAlignment.start,
      //                               children: <Widget>[
      //                                 SizedBox(
      //                                   width: 20,
      //                                 ),
      //                                 Icon(
      //                                   Icons.call,
      //                                   color: Colors.white,
      //                                 ),
      //                                 Text(
      //                                   " Call",
      //                                   style: TextStyle(
      //                                     color: Colors.white,
      //                                     fontWeight: FontWeight.w700,
      //                                   ),
      //                                   textAlign: TextAlign.left,
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                         ),
      //                         secondaryBackground: Container(
      //                           color: Colors.blue,
      //                           child: const Align(
      //                             alignment: Alignment.centerRight,
      //                             child: Row(
      //                               mainAxisAlignment: MainAxisAlignment.end,
      //                               children: <Widget>[
      //                                 Icon(
      //                                   Icons.add,
      //                                   color: Colors.white,
      //                                 ),
      //                                 Text(
      //                                   "Add Followup",
      //                                   style: TextStyle(
      //                                     color: Colors.white,
      //                                     fontWeight: FontWeight.w700,
      //                                   ),
      //                                   textAlign: TextAlign.right,
      //                                 ),
      //                                 SizedBox(
      //                                   width: 20,
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                         ),
      //                         confirmDismiss: (direction) async {
      //                           if (direction == DismissDirection.endToStart) {
      //                             if (items[index].callResult != "Confirmed") {
      //                               Navigator.push(
      //                                 context,
      //                                 MaterialPageRoute(
      //                                     builder: (context) => AddFollowup(
      //                                           widget.token,
      //                                           widget.editLead,
      //                                           widget.deleteLead,
      //                                           widget.cloudCall,
      //                                           items[index].callMasterId,
      //                                           pageName: widget.pageName,
      //                                           leadType:
      //                                               items[index].leadCategory,
      //                                           leadTypeId:
      //                                               items[index].leadCategoryId,
      //                                           leadSubType: items[index]
      //                                               .leadSubCategory,
      //                                           leadSubTypeId: items[index]
      //                                               .leadSubCategoryId,
      //                                           priorityId:
      //                                               items[index].priority,
      //                                           priority:
      //                                               items[index].priorityName,
      //                                           cost: items[index].cost,
      //                                           address: items[index].address,
      //                                         )),
      //                               ).then((value) {
      //                                 items.clear();
      //                                 page = 1;
      //                                 getData();
      //                               });
      //                             } else {
      //                               Common.toastMessaage(
      //                                   "You can't follow up on confirmed leads",
      //                                   Colors.red);
      //                             }
      //                           } else {
      //                             if (widget.cloudCall == false) {
      //                               showDialog(
      //                                   context: context,
      //                                   builder: (BuildContext ctx) {
      //                                     return AlertDialog(
      //                                       title: const Text('Alert !!!'),
      //                                       content: const Text(""),
      //                                       actions: [
      //                                         TextButton(
      //                                             onPressed: () {
      //                                               Navigator.of(context).pop();
      //                                             },
      //                                             child: const Text('Close')),
      //                                         TextButton(
      //                                             onPressed: () {
      //                                               Navigator.push(
      //                                                 context,
      //                                                 MaterialPageRoute(
      //                                                     builder: (context) =>
      //                                                         LeadDetails(
      //                                                           widget.token!,
      //                                                           widget.editLead,
      //                                                           widget
      //                                                               .deleteLead,
      //                                                           widget
      //                                                               .cloudCall,
      //                                                           viewLeads!
      //                                                               .data
      //                                                               .details[
      //                                                                   index]
      //                                                               .callMasterId
      //                                                               .toString(),
      //                                                           pageName: widget
      //                                                               .pageName
      //                                                               .toString(),
      //                                                           page: page,
      //                                                           pageSize: page *
      //                                                               pageSize,
      //                                                           fromDate: fromdate
      //                                                               .toString(),
      //                                                           toDate: todate
      //                                                               .toString(),
      //                                                         )),
      //                                               ).then((r) {
      //                                                 items.clear();
      //                                                 page = 1;
      //                                                 getData();
      //                                               });
      //                                             },
      //                                             child:
      //                                                 const Text('followup')),
      //                                       ],
      //                                     );
      //                                   });
      //                             } else {
      //                               if (widget.cloudCall == true) {
      //                                 chooseCallDialog(context, index);
      //                               } else {
      //                                 Common.dialPad(
      //                                     items[index].contactNumber1);
      //                               }
      //                             }
      //                           }
      //                           return null;
      //                         },
      //                         child: InkWell(
      //                             onTap: () {
      //                               Navigator.push(
      //                                 context,
      //                                 MaterialPageRoute(
      //                                     builder: (context) => LeadDetails(
      //                                           widget.token!,
      //                                           widget.editLead,
      //                                           widget.deleteLead,
      //                                           widget.cloudCall,
      //                                           items[index]
      //                                               .callMasterId
      //                                               .toString(),
      //                                           pageName:
      //                                               widget.pageName.toString(),
      //                                           page: page,
      //                                           pageSize: page * pageSize,
      //                                           fromDate: fromdate.toString(),
      //                                           toDate: todate.toString(),
      //                                         )),
      //                               ).then((r) {
      //                                 items.clear();
      //                                 page = 1;
      //                                 getData();
      //                               });
      //                             },
      //                             child: Padding(
      //                               padding: const EdgeInsets.only(
      //                                   left: 10, right: 10, bottom: 10),
      //                               child: Container(
      //                                 width:
      //                                     MediaQuery.of(context).size.width * 1,
      //                                 decoration: BoxDecoration(
      //                                   color: items[index].isSelected == false
      //                                       ? Colors.white
      //                                       : Colors.blue.shade100,
      //                                   boxShadow: const [
      //                                     BoxShadow(
      //                                       color: Colors.grey,
      //                                       offset: Offset(2.0, 2.0),
      //                                     )
      //                                   ],
      //                                   borderRadius: BorderRadius.circular(10),
      //                                 ),
      //                                 child: Column(
      //                                   children: [
      //                                     Padding(
      //                                       padding: const EdgeInsets.only(
      //                                           top: 10, right: 10, left: 10),
      //                                       child: Column(
      //                                         mainAxisAlignment:
      //                                             MainAxisAlignment.start,
      //                                         crossAxisAlignment:
      //                                             CrossAxisAlignment.start,
      //                                         children: [
      //                                           SingleChildScrollView(
      //                                             scrollDirection:
      //                                                 Axis.horizontal,
      //                                             child: SizedBox(
      //                                               width:
      //                                                   MediaQuery.of(context)
      //                                                           .size
      //                                                           .width *
      //                                                       .88,
      //                                               child: Stack(
      //                                                 children: [
      //                                                   Row(
      //                                                     children: [
      //                                                       if (items[index]
      //                                                               .priority ==
      //                                                           '1')
      //                                                         Container(
      //                                                           width: 10.0,
      //                                                           height: 10.0,
      //                                                           decoration:
      //                                                               const BoxDecoration(
      //                                                             color: Colors
      //                                                                 .grey,
      //                                                             shape: BoxShape
      //                                                                 .circle,
      //                                                           ),
      //                                                         ),
      //                                                       if (items[index]
      //                                                               .priority ==
      //                                                           '2')
      //                                                         Container(
      //                                                           width: 10.0,
      //                                                           height: 10.0,
      //                                                           decoration:
      //                                                               const BoxDecoration(
      //                                                             color: Colors
      //                                                                 .green,
      //                                                             shape: BoxShape
      //                                                                 .circle,
      //                                                           ),
      //                                                         ),
      //                                                       if (items[index]
      //                                                               .priority ==
      //                                                           '3')
      //                                                         Container(
      //                                                           width: 10.0,
      //                                                           height: 10.0,
      //                                                           decoration:
      //                                                               const BoxDecoration(
      //                                                             color: Colors
      //                                                                 .red,
      //                                                             shape: BoxShape
      //                                                                 .circle,
      //                                                           ),
      //                                                         ),
      //                                                       if (items[index]
      //                                                               .priority ==
      //                                                           '4')
      //                                                         Container(
      //                                                           width: 10.0,
      //                                                           height: 10.0,
      //                                                           decoration:
      //                                                               const BoxDecoration(
      //                                                             color: Colors
      //                                                                 .black,
      //                                                             shape: BoxShape
      //                                                                 .circle,
      //                                                           ),
      //                                                         ),
      //                                                       const SizedBox(
      //                                                         width: 5,
      //                                                       ),
      //                                                       SizedBox(
      //                                                         width: MediaQuery.of(
      //                                                                     context)
      //                                                                 .size
      //                                                                 .width *
      //                                                             .46,
      //                                                         child: Text(
      //                                                           items[index]
      //                                                               .clientName
      //                                                               .toString(),
      //                                                           // items.length.toString(),
      //                                                           style: TextStyle(
      //                                                               fontSize:
      //                                                                   16,
      //                                                               decoration: items[index].priority ==
      //                                                                       "4"
      //                                                                   ? TextDecoration
      //                                                                       .lineThrough
      //                                                                   : null,
      //                                                               decorationThickness:
      //                                                                   1.5,
      //                                                               decorationColor:
      //                                                                   Colors
      //                                                                       .red,
      //                                                               color: items[index]
      //                                                                       .isCustomer
      //                                                                   ? Colors
      //                                                                       .green
      //                                                                   : Colors
      //                                                                       .black,
      //                                                               fontWeight:
      //                                                                   FontWeight
      //                                                                       .bold),
      //                                                           maxLines: 1,
      //                                                           overflow:
      //                                                               TextOverflow
      //                                                                   .ellipsis,
      //                                                         ),
      //                                                       ),
      //                                                       Align(
      //                                                         alignment:
      //                                                             Alignment
      //                                                                 .topRight,
      //                                                         child: Container(
      //                                                           decoration: BoxDecoration(
      //                                                               color: Colors
      //                                                                   .pink
      //                                                                   .shade100,
      //                                                               borderRadius:
      //                                                                   BorderRadius.circular(
      //                                                                       5)),
      //                                                           child: Padding(
      //                                                             padding: const EdgeInsets
      //                                                                 .only(
      //                                                                 left: 5,
      //                                                                 right: 5,
      //                                                                 top: 2,
      //                                                                 bottom:
      //                                                                     2),
      //                                                             child: Text(
      //                                                               items[index]
      //                                                                   .leadCategory
      //                                                                   .toString(),
      //                                                               style:
      //                                                                   const TextStyle(
      //                                                                 fontSize:
      //                                                                     13,
      //                                                                 color: Colors
      //                                                                     .red,
      //                                                                 fontWeight:
      //                                                                     FontWeight
      //                                                                         .w500,
      //                                                               ),
      //                                                               maxLines: 1,
      //                                                               overflow:
      //                                                                   TextOverflow
      //                                                                       .ellipsis,
      //                                                               softWrap:
      //                                                                   false,
      //                                                             ),
      //                                                           ),
      //                                                         ),
      //                                                       ),
      //                                                     ],
      //                                                   ),
      //                                                   Row(
      //                                                     mainAxisAlignment:
      //                                                         MainAxisAlignment
      //                                                             .end,
      //                                                     children: [
      //                                                       Visibility(
      //                                                         visible: items[index]
      //                                                                     .categoryCount
      //                                                                     .toString() !=
      //                                                                 "1" &&
      //                                                             items[index]
      //                                                                     .categoryCount
      //                                                                     .toString() !=
      //                                                                 "",
      //                                                         child: Container(
      //                                                           height: 20,
      //                                                           width: 20,
      //                                                           decoration: const BoxDecoration(
      //                                                               color: Colors
      //                                                                   .red,
      //                                                               shape: BoxShape
      //                                                                   .circle),
      //                                                           child: Center(
      //                                                             child: Text(
      //                                                               items[index]
      //                                                                   .categoryCount
      //                                                                   .toString(),
      //                                                               // items.length.toString(),
      //                                                               style: const TextStyle(
      //                                                                   fontSize:
      //                                                                       12,
      //                                                                   color: Colors
      //                                                                       .white,
      //                                                                   fontWeight:
      //                                                                       FontWeight.bold),
      //                                                               maxLines: 1,
      //                                                               overflow:
      //                                                                   TextOverflow
      //                                                                       .ellipsis,
      //                                                             ),
      //                                                           ),
      //                                                         ),
      //                                                       ),
      //                                                     ],
      //                                                   ),
      //                                                 ],
      //                                               ),
      //                                             ),
      //                                           ),
      //                                           const SizedBox(
      //                                             height: 3,
      //                                           ),
      //                                           Row(
      //                                             mainAxisAlignment:
      //                                                 MainAxisAlignment
      //                                                     .spaceBetween,
      //                                             crossAxisAlignment:
      //                                                 CrossAxisAlignment.start,
      //                                             children: [
      //                                               Column(
      //                                                 mainAxisAlignment:
      //                                                     MainAxisAlignment
      //                                                         .start,
      //                                                 crossAxisAlignment:
      //                                                     CrossAxisAlignment
      //                                                         .start,
      //                                                 children: [
      //                                                   SizedBox(
      //                                                     width: MediaQuery.of(
      //                                                                 context)
      //                                                             .size
      //                                                             .width *
      //                                                         0.68,
      //                                                     child: Padding(
      //                                                       padding:
      //                                                           const EdgeInsets
      //                                                               .only(
      //                                                               left: 10),
      //                                                       child: Column(
      //                                                         mainAxisAlignment:
      //                                                             MainAxisAlignment
      //                                                                 .start,
      //                                                         crossAxisAlignment:
      //                                                             CrossAxisAlignment
      //                                                                 .start,
      //                                                         children: [
      //                                                           Text(
      //                                                             items[index]
      //                                                                 .contactNumber1
      //                                                                 .toString(),
      //                                                             style: const TextStyle(
      //                                                                 fontSize:
      //                                                                     13,
      //                                                                 color: Colors
      //                                                                     .black54,
      //                                                                 fontWeight:
      //                                                                     FontWeight
      //                                                                         .w500),
      //                                                           ),
      //                                                           Row(
      //                                                             mainAxisAlignment:
      //                                                                 MainAxisAlignment
      //                                                                     .spaceBetween,
      //                                                             children: [
      //                                                               SizedBox(
      //                                                                 width:
      //                                                                     150,
      //                                                                 child:
      //                                                                     Text(
      //                                                                   'Assigned to : ${items[index].staffName}',
      //                                                                   style: const TextStyle(
      //                                                                       fontSize:
      //                                                                           13,
      //                                                                       color:
      //                                                                           Colors.black54,
      //                                                                       fontWeight: FontWeight.w500),
      //                                                                   overflow:
      //                                                                       TextOverflow.ellipsis,
      //                                                                 ),
      //                                                               ),
      //                                                               Container(
      //                                                                 decoration: BoxDecoration(
      //                                                                     // color: _colors[items[index]
      //                                                                     //     .callResultId!],
      //                                                                     color: items[index].callResultId >= 0 && items[index].callResultId < _colors.length ? _colors[items[index].callResultId] : const Color.fromARGB(255, 245, 160, 34),
      //                                                                     borderRadius: BorderRadius.circular(5)),
      //                                                                 child:
      //                                                                     Padding(
      //                                                                   padding: const EdgeInsets
      //                                                                       .only(
      //                                                                       left:
      //                                                                           5,
      //                                                                       right:
      //                                                                           5,
      //                                                                       top:
      //                                                                           2,
      //                                                                       bottom:
      //                                                                           2),
      //                                                                   child:
      //                                                                       Text(
      //                                                                     items[index]
      //                                                                         .callResult
      //                                                                         .toString(),
      //                                                                     style: const TextStyle(
      //                                                                         fontSize: 13,
      //                                                                         color: Colors.white,
      //                                                                         fontWeight: FontWeight.w500),
      //                                                                   ),
      //                                                                 ),
      //                                                               ),
      //                                                             ],
      //                                                           ),
      //                                                           const SizedBox(
      //                                                             height: 2,
      //                                                           ),
      //                                                           items[index].callResultId ==
      //                                                                   1
      //                                                               ? Container(
      //                                                                   decoration: BoxDecoration(
      //                                                                       color:
      //                                                                           const Color(0xFFd5f5f4),
      //                                                                       borderRadius: BorderRadius.circular(5)),
      //                                                                   child:
      //                                                                       Padding(
      //                                                                     padding: const EdgeInsets
      //                                                                         .only(
      //                                                                         left: 5,
      //                                                                         right: 5,
      //                                                                         top: 5,
      //                                                                         bottom: 5),
      //                                                                     child:
      //                                                                         Row(
      //                                                                       mainAxisAlignment:
      //                                                                           MainAxisAlignment.start,
      //                                                                       crossAxisAlignment:
      //                                                                           CrossAxisAlignment.center,
      //                                                                       children: [
      //                                                                         Image.asset("assets/icons/calendar.png", width: 20),
      //                                                                         const SizedBox(
      //                                                                           width: 15,
      //                                                                         ),
      //                                                                         Column(
      //                                                                           mainAxisAlignment: MainAxisAlignment.start,
      //                                                                           crossAxisAlignment: CrossAxisAlignment.start,
      //                                                                           children: [
      //                                                                             const Text(
      //                                                                               'Created Time',
      //                                                                               style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
      //                                                                             ),
      //                                                                             const SizedBox(
      //                                                                               height: 3,
      //                                                                             ),
      //                                                                             Text(
      //                                                                               items[index].createdDate.toString(),
      //                                                                               style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
      //                                                                             ),
      //                                                                           ],
      //                                                                         ),
      //                                                                       ],
      //                                                                     ),
      //                                                                   ),
      //                                                                 )
      //                                                               : Row(
      //                                                                   mainAxisAlignment:
      //                                                                       MainAxisAlignment.spaceBetween,
      //                                                                   children: [
      //                                                                     Container(
      //                                                                       decoration:
      //                                                                           BoxDecoration(color: const Color(0xFFd5f5f4), borderRadius: BorderRadius.circular(5)),
      //                                                                       child:
      //                                                                           Padding(
      //                                                                         padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      //                                                                         child: Row(
      //                                                                           mainAxisAlignment: MainAxisAlignment.start,
      //                                                                           crossAxisAlignment: CrossAxisAlignment.center,
      //                                                                           children: [
      //                                                                             Image.asset("assets/icons/calendar.png", width: 20),
      //                                                                             const SizedBox(
      //                                                                               width: 5,
      //                                                                             ),
      //                                                                             Column(
      //                                                                               children: [
      //                                                                                 const Text(
      //                                                                                   'Called Date',
      //                                                                                   style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
      //                                                                                 ),
      //                                                                                 const SizedBox(
      //                                                                                   height: 3,
      //                                                                                 ),
      //                                                                                 Text(
      //                                                                                   items[index].isCalled == false ? '--' : items[index].calledDate.toString(),
      //                                                                                   style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
      //                                                                                 ),
      //                                                                               ],
      //                                                                             ),
      //                                                                           ],
      //                                                                         ),
      //                                                                       ),
      //                                                                     ),
      //                                                                     Container(
      //                                                                       decoration:
      //                                                                           BoxDecoration(color: const Color(0xFFd5f5f4), borderRadius: BorderRadius.circular(5)),
      //                                                                       child:
      //                                                                           Padding(
      //                                                                         padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      //                                                                         child: Row(
      //                                                                           mainAxisAlignment: MainAxisAlignment.start,
      //                                                                           crossAxisAlignment: CrossAxisAlignment.center,
      //                                                                           children: [
      //                                                                             Image.asset("assets/icons/calendar.png", width: 20),
      //                                                                             const SizedBox(
      //                                                                               width: 5,
      //                                                                             ),
      //                                                                             Column(
      //                                                                               children: [
      //                                                                                 const Text(
      //                                                                                   'Followup Date',
      //                                                                                   style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
      //                                                                                 ),
      //                                                                                 const SizedBox(
      //                                                                                   height: 3,
      //                                                                                 ),
      //                                                                                 Text(
      //                                                                                   items[index].scheduledDate.toString(),
      //                                                                                   style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
      //                                                                                 ),
      //                                                                               ],
      //                                                                             ),
      //                                                                           ],
      //                                                                         ),
      //                                                                       ),
      //                                                                     ),
      //                                                                   ],
      //                                                                 ),
      //                                                         ],
      //                                                       ),
      //                                                     ),
      //                                                   ),
      //                                                 ],
      //                                               ),
      //                                               Column(
      //                                                 children: [
      //                                                   Container(
      //                                                     constraints:
      //                                                         const BoxConstraints(
      //                                                       maxHeight: 60,
      //                                                     ),
      //                                                     child: Container(
      //                                                       constraints:
      //                                                           const BoxConstraints(
      //                                                         minHeight: 20,
      //                                                         minWidth: 20,
      //                                                         maxHeight: 50,
      //                                                         maxWidth: 50,
      //                                                       ),
      //                                                       decoration:
      //                                                           BoxDecoration(
      //                                                         border: Border.all(
      //                                                             color: Colors
      //                                                                 .white,
      //                                                             width: 0),
      //                                                         boxShadow: const [
      //                                                           BoxShadow(
      //                                                               color: Colors
      //                                                                   .grey,
      //                                                               blurRadius:
      //                                                                   5,
      //                                                               offset:
      //                                                                   Offset(
      //                                                                       1,
      //                                                                       1)),
      //                                                         ],
      //                                                         color:
      //                                                             Colors.white,
      //                                                         shape: BoxShape
      //                                                             .circle,
      //                                                         image: DecorationImage(
      //                                                             fit: BoxFit
      //                                                                 .cover,
      //                                                             image: NetworkImage(items[
      //                                                                     index]
      //                                                                 .profilePic
      //                                                                 .toString())),
      //                                                         // image: AssetImage(
      //                                                         //     'assets/images/img.jpeg')),
      //                                                       ),
      //                                                     ),
      //                                                   ),
      //                                                   const SizedBox(
      //                                                     height: 10,
      //                                                   ),
      //                                                   InkWell(
      //                                                     onTap: () async {
      //                                                       if (widget
      //                                                               .cloudCall ==
      //                                                           false) {
      //                                                         showDialog(
      //                                                             context:
      //                                                                 context,
      //                                                             builder:
      //                                                                 (BuildContext
      //                                                                     ctx) {
      //                                                               return AlertDialog(
      //                                                                 title: const Text(
      //                                                                     'Alert !!!'),
      //                                                                 content:
      //                                                                     const Text(
      //                                                                         ""),
      //                                                                 actions: [
      //                                                                   TextButton(
      //                                                                       onPressed:
      //                                                                           () {
      //                                                                         Navigator.of(context).pop();
      //                                                                       },
      //                                                                       child:
      //                                                                           const Text('Close')),
      //                                                                   TextButton(
      //                                                                       onPressed:
      //                                                                           () {
      //                                                                         Navigator.push(
      //                                                                           context,
      //                                                                           MaterialPageRoute(
      //                                                                               builder: (context) => LeadDetails(
      //                                                                                     widget.token!,
      //                                                                                     widget.editLead,
      //                                                                                     widget.deleteLead,
      //                                                                                     widget.cloudCall,
      //                                                                                     viewLeads!.data.details[index].callMasterId.toString(),
      //                                                                                     pageName: widget.pageName.toString(),
      //                                                                                     page: page,
      //                                                                                     pageSize: page * pageSize,
      //                                                                                     fromDate: fromdate.toString(),
      //                                                                                     toDate: todate.toString(),
      //                                                                                   )),
      //                                                                         ).then((r) {
      //                                                                           items.clear();
      //                                                                           page = 1;
      //                                                                           getData();
      //                                                                           itemPositionsListener.itemPositions.addListener(() {
      //                                                                             if (itemPositionsListener.itemPositions.value.last.index == items.length - 1) {
      //                                                                               if (items.length < viewLeads!.data.totalLeads) {
      //                                                                                 getData();
      //                                                                               }
      //                                                                             }
      //                                                                           });
      //                                                                         });
      //                                                                       },
      //                                                                       child:
      //                                                                           const Text('followup')),
      //                                                                 ],
      //                                                               );
      //                                                             });
      //                                                       } else {
      //                                                         if (widget
      //                                                                 .cloudCall ==
      //                                                             true) {
      //                                                           chooseCallDialog(
      //                                                               context,
      //                                                               index);
      //                                                         } else {
      //                                                           Common.dialPad(
      //                                                               items[index]
      //                                                                   .contactNumber1);
      //                                                           Common.dialPad(
      //                                                               items[index]
      //                                                                   .contactNumber1);
      //                                                         }
      //                                                       }
      //                                                     },
      //                                                     child: Container(
      //                                                       width: 65,
      //                                                       height: 30,
      //                                                       decoration:
      //                                                           BoxDecoration(
      //                                                         color:
      //                                                             Colors.green,
      //                                                         border: Border.all(
      //                                                             color: Colors
      //                                                                 .grey
      //                                                                 .shade300),
      //                                                         borderRadius:
      //                                                             BorderRadius
      //                                                                 .circular(
      //                                                                     8),
      //                                                       ),
      //                                                       child: const Center(
      //                                                         child: Row(
      //                                                           mainAxisAlignment:
      //                                                               MainAxisAlignment
      //                                                                   .center,
      //                                                           crossAxisAlignment:
      //                                                               CrossAxisAlignment
      //                                                                   .center,
      //                                                           children: [
      //                                                             Icon(
      //                                                               Icons.call,
      //                                                               color: Colors
      //                                                                   .white,
      //                                                               size: 15,
      //                                                             ),
      //                                                             SizedBox(
      //                                                               width: 5,
      //                                                             ),
      //                                                             Text('Call',
      //                                                                 style: TextStyle(
      //                                                                     fontFamily:
      //                                                                         "MontserratMedium",
      //                                                                     fontSize:
      //                                                                         14,
      //                                                                     color: Colors
      //                                                                         .white,
      //                                                                     fontWeight:
      //                                                                         FontWeight.bold)),
      //                                                           ],
      //                                                         ),
      //                                                       ),
      //                                                     ),
      //                                                   ),
      //                                                 ],
      //                                               ),
      //                                             ],
      //                                           ),
      //                                           const SizedBox(
      //                                             height: 8,
      //                                           ),
      //                                         ],
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                             )),
      //                       );
      //                     },
      //                     itemScrollController: itemScrollController,
      //                     itemPositionsListener: itemPositionsListener,
      //                   ),
      //                 )
      //               : SizedBox(
      //                   height: MediaQuery.of(context).size.height * 0.6,
      //                   width: MediaQuery.of(context).size.width,
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: [
      //                       SizedBox(
      //                         width: 200,
      //                         height: 200,
      //                         child: Image.asset(
      //                           "assets/icons/nodatafound.png",
      //                         ),
      //                       ),
      //                       const Text(
      //                         'Result Not Found',
      //                         style: TextStyle(
      //                             fontSize: 20, fontWeight: FontWeight.bold),
      //                       ),
      //                       const SizedBox(
      //                         height: 10,
      //                       ),
      //                       const Text(
      //                         'Whoops... this information is \n not available for a moment',
      //                         style: TextStyle(fontSize: 15),
      //                       ),
      //                       const SizedBox(
      //                         height: 25,
      //                       ),
      //                       InkWell(
      //                         onTap: () {
      //                           Navigator.of(context).push(
      //                             MaterialPageRoute(
      //                                 builder: (context) =>
      //                                     Dashboard(widget.token)),
      //                           );
      //                         },
      //                         child: Container(
      //                           width: MediaQuery.of(context).size.width * 0.4,
      //                           height: 40,
      //                           decoration: BoxDecoration(
      //                             color: Colors.black,
      //                             borderRadius: BorderRadius.circular(10),
      //                           ),
      //                           child: const Center(
      //                             child: Text('Go Back',
      //                                 style: TextStyle(
      //                                     fontSize: 15,
      //                                     color: Colors.white,
      //                                     fontWeight: FontWeight.w500)),
      //                           ),
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //         ],
      //       )
      //     : Center(
      //         child: Lottie.asset('assets/main/loading.json', fit: BoxFit.fill),
      //       ),
    );
  }

  Future<dynamic> chooseCallDialog(BuildContext context, int index) {
    // Get the correct item based on search
    final item = _searchQuery.isEmpty ? items[index] : _filteredItems[index];

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Choose Call Type'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    Common.showProgressDialog(context, "Loading..");
                    CloudCallModel object1 = await HttpService.addCloudCall(
                        widget.token, item.callMasterId, item.contactNumber1);
                    if (object1.data == true) {
                      if (context.mounted) {
                        Common.toastMessaage(object1.message, Colors.green);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    } else {
                      Common.toastMessaage(object1.message, Colors.red);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Icon(
                            Icons.cloud_circle_rounded,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'Cloud Call',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    // String url =
                    //     'tel:${'+${items[index].contactNumber1}'}';
                    // await launchUrl(Uri.parse(url));
                    Navigator.pop(context);
                    Common.dialPad(item.contactNumber1);
                  },
                  child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Icon(
                              Icons.call,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'Phone Call',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }

  // Future<dynamic> chooseCallDialog(BuildContext context, int index) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           scrollable: true,
  //           title: const Text('Choose Call Type'),
  //           content: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               InkWell(
  //                 onTap: () async {
  //                   Common.showProgressDialog(context, "Loading..");
  //                   CloudCallModel object1 = await HttpService.addCloudCall(
  //                       widget.token,
  //                       items[index].callMasterId,
  //                       items[index].contactNumber1);
  //                   if (object1.data == true) {
  //                     if (context.mounted) {
  //                       Common.toastMessaage(object1.message, Colors.green);
  //                       Navigator.pop(context);
  //                       Navigator.pop(context);
  //                     }
  //                   } else {
  //                     Common.toastMessaage(object1.message, Colors.red);
  //                     if (context.mounted) {
  //                       Navigator.pop(context);
  //                     }
  //                   }
  //                 },
  //                 child: SizedBox(
  //                   height: 50,
  //                   child: Row(
  //                     children: [
  //                       Container(
  //                         height: 30,
  //                         width: 30,
  //                         decoration: BoxDecoration(
  //                             color: Colors.grey.shade300,
  //                             borderRadius: BorderRadius.circular(5)),
  //                         child: const Icon(
  //                           Icons.cloud_circle_rounded,
  //                           color: Colors.black,
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         width: 20,
  //                       ),
  //                       const Text(
  //                         'Cloud Call',
  //                         style: TextStyle(fontSize: 18),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               InkWell(
  //                 onTap: () async {
  //                   // String url =
  //                   //     'tel:${'+${items[index].contactNumber1}'}';
  //                   // await launchUrl(Uri.parse(url));
  //                   Navigator.pop(context);
  //                   Common.dialPad(items[index].contactNumber1);
  //                 },
  //                 child: SizedBox(
  //                     height: 50,
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           height: 30,
  //                           width: 30,
  //                           decoration: BoxDecoration(
  //                               color: Colors.grey.shade300,
  //                               borderRadius: BorderRadius.circular(5)),
  //                           child: const Icon(
  //                             Icons.call,
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           width: 20,
  //                         ),
  //                         const Text(
  //                           'Phone Call',
  //                           style: TextStyle(fontSize: 18),
  //                         ),
  //                       ],
  //                     )),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  Future<dynamic> filtrationSheet(BuildContext context) {
    int selectedDateType = 1;
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: double.maxFinite,
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Material(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Filtration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // const SizedBox(height: 20),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<bool>(
                                value: true,
                                groupValue: isCreatedDateChecked,
                                onChanged: (val) {
                                  setState(() {
                                    isCreatedDateChecked = true;
                                    isUpdatedDateChecked = false;
                                  });
                                },
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Created Date"),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<bool>(
                                value: true,
                                groupValue: isUpdatedDateChecked,
                                onChanged: (val) {
                                  setState(() {
                                    isCreatedDateChecked = false;
                                    isUpdatedDateChecked = true;
                                  });
                                },
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Updated Date"),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('From Date',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    )),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  child: Center(
                                    child: DateTimePicker(
                                      decoration: InputDecoration(
                                          filled: true,
                                          //<-- SEE HERE
                                          fillColor: Colors.white,
                                          prefixIcon: const Icon(
                                            Icons.arrow_right,
                                            color: Colors.grey,
                                          ),
                                          counterText: "",
                                          hintText: 'From Date',
                                          isDense: true,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      Colors.purple.shade100),
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      initialValue: fromdate.toString(),
                                      type: DateTimePickerType.date,

                                      //controller: fromDate,
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
                                            fromdate = DateTime.parse(value)
                                                .toString();
                                          });
                                        }
                                      },
                                      // We can also use onSaved
                                      onSaved: (value) {
                                        if (value!.isNotEmpty) {
                                          fromdate =
                                              DateTime.parse(value).toString();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('To Date',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    )),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  child: Center(
                                    child: DateTimePicker(
                                      decoration: InputDecoration(
                                          filled: true,
                                          //<-- SEE HERE
                                          fillColor: Colors.white,
                                          prefixIcon: const Icon(
                                            Icons.arrow_right,
                                            color: Colors.grey,
                                          ),
                                          counterText: "",
                                          hintText: 'To Date',
                                          isDense: true,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      Colors.purple.shade100),
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      initialValue: todate.toString(),
                                      type: DateTimePickerType.date,

                                      //controller: fromDate,
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
                                            todate = DateTime.parse(value)
                                                .toString();
                                          });
                                        }
                                      },
                                      // We can also use onSaved
                                      onSaved: (value) {
                                        if (value!.isNotEmpty) {
                                          todate =
                                              DateTime.parse(value).toString();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        multiBranch == 'true' && roleId == '2'
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 13),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Branch',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      child: FormField<String>(
                                        builder:
                                            (FormFieldState<String> state) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1),
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5))),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                hint: const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Text('Branch'),
                                                ),
                                                value: branch,
                                                items: commonDetails!
                                                    .data.branch
                                                    .map((data) {
                                                  return DropdownMenuItem(
                                                    value: data.branchId
                                                        .toString(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20),
                                                      child: Text(data
                                                          .branchName
                                                          .toString()),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue1) async {
                                                  setState(() {
                                                    branch = newValue1;
                                                  });
                                                  commonDetails =
                                                      await HttpService
                                                          .addLeadCommonData(
                                                              widget.token,
                                                              branchId: branch);
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        //  Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const Text('Created Date',
                        //         style: TextStyle(
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.w500,
                        //         )),
                        //     const SizedBox(
                        //       height: 5,
                        //     ),
                        //     SizedBox(
                        //       width:
                        //           MediaQuery.of(context).size.width * 1.43,
                        //       child: Center(
                        //         child: DateTimePicker(
                        //           decoration: InputDecoration(
                        //               filled: true,
                        //               //<-- SEE HERE
                        //               fillColor: Colors.white,
                        //               prefixIcon: const Icon(
                        //                 Icons.arrow_right,
                        //                 color: Colors.grey,
                        //               ),
                        //               counterText: "",
                        //               hintText: 'Created Date',
                        //               isDense: true,
                        //               border: OutlineInputBorder(
                        //                   borderSide: BorderSide(
                        //                       color:
                        //                           Colors.purple.shade100),
                        //                   borderRadius:
                        //                       BorderRadius.circular(5))),
                        //           initialValue: createdDate.toString(),
                        //           type: DateTimePickerType.date,

                        //           //controller: fromDate,
                        //           firstDate: DateTime(1995),
                        //           lastDate: DateTime.now()
                        //               .add(const Duration(days: 365)),
                        //           // This will add one year from current date
                        //           validator: (value) {
                        //             return null;
                        //           },
                        //           onChanged: (value) {
                        //             if (value.isNotEmpty) {
                        //               setState(() {
                        //                 createdDate = DateTime.parse(value)
                        //                     .toString();
                        //               });
                        //             }
                        //           },
                        //           // We can also use onSaved
                        //           onSaved: (value) {
                        //             if (value!.isNotEmpty) {
                        //               createdDate =
                        //                   DateTime.parse(value).toString();
                        //             }
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 10,),
                        //   Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const Text('Updated Date',
                        //         style: TextStyle(
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.w500,
                        //         )),
                        //     const SizedBox(
                        //       height: 5,
                        //     ),
                        //     SizedBox(
                        //       width:
                        //           MediaQuery.of(context).size.width * 1.43,
                        //       child: Center(
                        //         child: DateTimePicker(
                        //           decoration: InputDecoration(
                        //               filled: true,
                        //               //<-- SEE HERE
                        //               fillColor: Colors.white,
                        //               prefixIcon: const Icon(
                        //                 Icons.arrow_right,
                        //                 color: Colors.grey,
                        //               ),
                        //               counterText: "",
                        //               hintText: 'Updated Date',
                        //               isDense: true,
                        //               border: OutlineInputBorder(
                        //                   borderSide: BorderSide(
                        //                       color:
                        //                           Colors.purple.shade100),
                        //                   borderRadius:
                        //                       BorderRadius.circular(5))),
                        //           initialValue: updatedDate.toString(),
                        //           type: DateTimePickerType.date,

                        //           //controller: fromDate,
                        //           firstDate: DateTime(1995),
                        //           lastDate: DateTime.now()
                        //               .add(const Duration(days: 365)),
                        //           // This will add one year from current date
                        //           validator: (value) {
                        //             return null;
                        //           },
                        //           onChanged: (value) {
                        //             if (value.isNotEmpty) {
                        //               setState(() {
                        //                 updatedDate = DateTime.parse(value)
                        //                     .toString();
                        //               });
                        //             }
                        //           },
                        //           // We can also use onSaved
                        //           onSaved: (value) {
                        //             if (value!.isNotEmpty) {
                        //               updatedDate =
                        //                   DateTime.parse(value).toString();
                        //             }
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        //  SizedBox(height: 10,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Stream'),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: const Text('Stream'),
                                        content: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .32,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .8,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            // itemCount: commonDetails!
                                            //     .data.leadCategory.length,
                                            itemCount: commonDetails?.data
                                                    ?.leadCategory?.length ??
                                                0,
                                            itemBuilder: (context, ind) {
                                              return CheckboxListTile(
                                                title: SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    commonDetails!
                                                        .data
                                                        .leadCategory[ind]
                                                        .leadCategory
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                value: checkedCategoryItems
                                                        .contains(commonDetails!
                                                            .data
                                                            .leadCategory[ind]
                                                            .leadCategoryId
                                                            .toString())
                                                    ? true
                                                    : false,
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    setState(() {
                                                      checkedCategoryItems.add(
                                                          commonDetails!
                                                              .data
                                                              .leadCategory[ind]
                                                              .leadCategoryId
                                                              .toString());
                                                      checkedCategoryItemsName
                                                          .add(commonDetails!
                                                              .data
                                                              .leadCategory[ind]
                                                              .leadCategory
                                                              .toString());
                                                      selectedSubCategories
                                                          .removeWhere((key,
                                                                  value) =>
                                                              key ==
                                                              commonDetails!
                                                                  .data
                                                                  .leadCategory[
                                                                      ind]
                                                                  .leadCategoryId
                                                                  .toString());
                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      checkedCategoryItems
                                                          .remove(commonDetails!
                                                              .data
                                                              .leadCategory[ind]
                                                              .leadCategoryId
                                                              .toString());
                                                      checkedCategoryItemsName
                                                          .remove(commonDetails!
                                                              .data
                                                              .leadCategory[ind]
                                                              .leadCategory
                                                              .toString());
                                                      selectedSubCategories
                                                          .remove(commonDetails!
                                                              .data
                                                              .leadCategory[ind]
                                                              .leadCategoryId
                                                              .toString());
                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  }
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: checkedCategoryItems.isEmpty
                                        ? const Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 15, bottom: 10),
                                            child: Text('Stream'))
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 40),
                                            child: SizedBox(
                                              height: 35,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    checkedCategoryItemsName
                                                        .length,
                                                itemBuilder: (context, i) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        leadSubTypeList =
                                                            await HttpService
                                                                .leadSubType(
                                                          commonDetails!
                                                              .data
                                                              .leadCategory[i]
                                                              .leadCategoryId
                                                              .toString(),
                                                        );
                                                        setState(() {});
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 35,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 0),
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: const BorderRadius
                                                                    .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            6),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            6))),
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                    child: Text(
                                                                      checkedCategoryItemsName[
                                                                          i],
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          'Please Confirm'),
                                                                      content:
                                                                          const Text(
                                                                              'Are you sure to Remove this Number?'),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text('No')),
                                                                        TextButton(
                                                                            onPressed:
                                                                                () async {
                                                                              setState(() {
                                                                                // Remove the category and its subcategories
                                                                                String categoryId = checkedCategoryItems[i];
                                                                                checkedCategoryItemsName.removeAt(i);
                                                                                checkedCategoryItems.removeAt(i);
                                                                                selectedSubCategories.remove(categoryId);
                                                                              });
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text('Yes')),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            child: Container(
                                                              height: 35,
                                                              width: 30,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 0),
                                                                  color: Colors
                                                                      .grey
                                                                      .shade100,
                                                                  borderRadius: const BorderRadius
                                                                      .only(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              6),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              6))),
                                                              child: const Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                  ),
                                  ...checkedCategoryItems.map((categoryId) {
                                    int index = checkedCategoryItems
                                        .indexOf(categoryId);
                                    String categoryName =
                                        checkedCategoryItemsName[index];

                                    return FutureBuilder(
                                      future:
                                          HttpService.leadSubType(categoryId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          LeadSubTypeModel? subTypeData =
                                              snapshot.data;
                                          if (subTypeData?.data?.isEmpty ??
                                              true) {
                                            return Container();
                                          }

                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('Lead Sub Category'),
                                                DropdownButtonFormField<String>(
                                                  value: selectedSubCategories[
                                                      categoryId],
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                  ),
                                                  items: subTypeData!.data!
                                                      .map((subCategory) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: subCategory
                                                          .leadSubCategoryId,
                                                      child: Text(subCategory
                                                              .leadSubCategory ??
                                                          ''),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedSubCategories[
                                                              categoryId] =
                                                          newValue;
                                                    });
                                                  },
                                                  hint: const Text(
                                                      'Select Subcategory'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Lead Status'),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: const Text('Lead Status'),
                                        content: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .32,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .8,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            // itemCount: commonDetails!
                                            //     .data.callResult.length,
                                            itemCount: commonDetails?.data
                                                    ?.callResult?.length ??
                                                0,
                                            itemBuilder: (context, ind) {
                                              return CheckboxListTile(
                                                title: SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    commonDetails!
                                                        .data
                                                        .callResult[ind]
                                                        .callResult
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                value: checkedCallResultItems
                                                        .contains(commonDetails!
                                                            .data
                                                            .callResult[ind]
                                                            .callResultId
                                                            .toString())
                                                    ? true
                                                    : false,
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    setState(() {
                                                      checkedCallResultItems
                                                          .add(commonDetails!
                                                              .data
                                                              .callResult[ind]
                                                              .callResultId
                                                              .toString());
                                                      checkedCallResultItemsName
                                                          .add(commonDetails!
                                                              .data
                                                              .callResult[ind]
                                                              .callResult
                                                              .toString());

                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      checkedCallResultItems
                                                          .remove(commonDetails!
                                                              .data
                                                              .callResult[ind]
                                                              .callResultId
                                                              .toString());
                                                      checkedCallResultItemsName
                                                          .remove(commonDetails!
                                                              .data
                                                              .callResult[ind]
                                                              .callResult
                                                              .toString());

                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  }
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 1,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: checkedCallResultItems.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, top: 15, bottom: 10),
                                        child: Text('Lead Status'))
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 40),
                                        child: SizedBox(
                                          height: 35,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                checkedCallResultItemsName
                                                    .length,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0),
                                                            color: Colors.white,
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6))),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                child: Text(
                                                                  checkedCallResultItemsName[
                                                                      i],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Please Confirm'),
                                                                  content:
                                                                      const Text(
                                                                          'Are you sure to Remove this Number?'),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'No')),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            checkedCallResultItemsName.remove(checkedCallResultItemsName[i]);
                                                                            checkedCallResultItems.remove(checkedCallResultItems[i]);
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Yes')),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0),
                                                              color: Colors.grey
                                                                  .shade100,
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6))),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Priority'),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: const Text('Priority'),
                                        content: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .3,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .8,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            // itemCount: commonDetails!
                                            //     .data.priority.length,
                                            itemCount: commonDetails
                                                    ?.data?.priority?.length ??
                                                0,
                                            itemBuilder: (context, ind) {
                                              return CheckboxListTile(
                                                title: SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    commonDetails!.data
                                                        .priority[ind].priority
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                value: checkedPriorityItems
                                                        .contains(commonDetails!
                                                            .data
                                                            .priority[ind]
                                                            .priorityId
                                                            .toString())
                                                    ? true
                                                    : false,
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    setState(() {
                                                      checkedPriorityItems.add(
                                                          commonDetails!
                                                              .data
                                                              .priority[ind]
                                                              .priorityId
                                                              .toString());
                                                      checkedPriorityItemsName
                                                          .add(commonDetails!
                                                              .data
                                                              .priority[ind]
                                                              .priority
                                                              .toString());
                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      checkedPriorityItems
                                                          .remove(commonDetails!
                                                              .data
                                                              .priority[ind]
                                                              .priorityId
                                                              .toString());
                                                      checkedPriorityItemsName
                                                          .remove(commonDetails!
                                                              .data
                                                              .priority[ind]
                                                              .priority
                                                              .toString());

                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  }
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 1,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: checkedPriorityItems.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, top: 15, bottom: 10),
                                        child: Text('Priority'))
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 40),
                                        child: SizedBox(
                                          height: 35,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                checkedPriorityItemsName.length,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0),
                                                            color: Colors.white,
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6))),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                child: Text(
                                                                  checkedPriorityItemsName[
                                                                      i],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Please Confirm'),
                                                                  content:
                                                                      const Text(
                                                                          'Are you sure to Remove this Number?'),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'No')),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            checkedPriorityItemsName.remove(checkedPriorityItemsName[i]);
                                                                            checkedPriorityItems.remove(checkedPriorityItems[i]);
                                                                          });

                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Yes')),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0),
                                                              color: Colors.grey
                                                                  .shade100,
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6))),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

// PIN Code
//                         SizedBox(
//                           width: 337,
//                           child: TextFormField(
//                             controller: pinCode,
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               labelText: 'PIN Code',
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                             ),
//                             onChanged: (value) async {
//                               if (value.length == 6) {
//                                 await loadPostOffices(value);
//                               }
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 10),

// // Post Office
//                         if (postOffices.isNotEmpty)
//                           SizedBox(
//                             width: 337,
//                             child: DropdownButtonFormField<PostOffice>(
//                               value: selectedPostOffice,
//                               isExpanded: true,
//                               decoration: const InputDecoration(
//                                 labelText: 'Select Post Office',
//                                 border: OutlineInputBorder(),
//                               ),
//                               items: postOffices.map((postOffice) {
//                                 return DropdownMenuItem<PostOffice>(
//                                   value: postOffice,
//                                   child: Text(postOffice.name ?? ''),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedPostOffice = value;
//                                 });
//                               },
//                             ),
//                           ),
//                         const SizedBox(height: 10),
                        SizedBox(
                          width: 337,
                          child: TextFormField(
                            controller: stateVal,
                            readOnly: true,
                            onTap: () async {
                              // Open dialog and wait for selected state
                              final selectedState =
                                  await selectStateDialog(context);

                              if (selectedState != null) {
                                setState(() {
                                  stateVal.text =
                                      selectedState.name; // show state name
                                  StateId = selectedState.id; // save stateId
                                  districtVal.clear();
                                  districtList = [];
                                  isDistrictLoading = true;
                                });

                                // Fetch districts for the selected state
                                final result =
                                    await HttpService.getDistrict(StateId!);

                                setState(() {
                                  districtList = result?.data ?? [];
                                  isDistrictLoading = false;

                                  // Auto-select first district if available
                                  if (districtList.isNotEmpty) {
                                    DistrictId = districtList.first.id;
                                    districtVal.text = districtList.first.name;
                                  }
                                });
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'State',
                              prefixIcon: Icon(
                                Icons.arrow_drop_down_circle_outlined,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

// District Dropdown
                        if (!isDistrictLoading && districtList.isNotEmpty)
                          SizedBox(
                            width: 337,
                            child: DropdownButtonFormField<DistrictList>(
                              value: districtList.firstWhere(
                                (d) => d.id == DistrictId,
                                orElse: () => districtList.first,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Select District',
                                border: OutlineInputBorder(),
                              ),
                              items: districtList.map((d) {
                                return DropdownMenuItem<DistrictList>(
                                  value: d,
                                  child: Text(d.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  DistrictId = value?.id;
                                  districtVal.text = value?.name ?? '';
                                });
                              },
                            ),
                          ),

                        if (isDistrictLoading)
                          const Center(child: CircularProgressIndicator()),
                        const SizedBox(
                          height: 13,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Assigned Staff'),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: const Text('Assign Staff'),
                                        content: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .32,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .8,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            // itemCount: commonDetails!
                                            //     .data.staff.length,
                                            itemCount: commonDetails
                                                    ?.data?.staff?.length ??
                                                0,
                                            itemBuilder: (context, ind) {
                                              return CheckboxListTile(
                                                title: SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    commonDetails!.data
                                                        .staff[ind].staffName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                value: checkedAssignedStaffItems
                                                        .contains(commonDetails!
                                                            .data
                                                            .staff[ind]
                                                            .userId
                                                            .toString())
                                                    ? true
                                                    : false,
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    setState(() {
                                                      checkedAssignedStaffItems
                                                          .add(commonDetails!
                                                              .data
                                                              .staff[ind]
                                                              .userId
                                                              .toString());
                                                      checkedAssignedStaffItemsName
                                                          .add(commonDetails!
                                                              .data
                                                              .staff[ind]
                                                              .staffName
                                                              .toString());

                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      checkedAssignedStaffItems
                                                          .remove(commonDetails!
                                                              .data
                                                              .staff[ind]
                                                              .userId
                                                              .toString());
                                                      checkedAssignedStaffItemsName
                                                          .remove(commonDetails!
                                                              .data
                                                              .staff[ind]
                                                              .staffName
                                                              .toString());

                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  }
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 1,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: checkedAssignedStaffItems.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, top: 15, bottom: 10),
                                        child: Text('Assigned Staff'))
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 40),
                                        child: SizedBox(
                                          height: 35,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                checkedAssignedStaffItemsName
                                                    .length,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0),
                                                            color: Colors.white,
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6))),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                child: Text(
                                                                  checkedAssignedStaffItemsName[
                                                                      i],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Please Confirm'),
                                                                  content:
                                                                      const Text(
                                                                          'Are you sure to Remove this Number?'),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'No')),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            checkedAssignedStaffItemsName.remove(checkedAssignedStaffItemsName[i]);
                                                                            checkedAssignedStaffItems.remove(checkedAssignedStaffItems[i]);
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Yes')),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0),
                                                              color: Colors.grey
                                                                  .shade100,
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6))),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Created By'),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: const Text('Created By'),
                                        content: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .32,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .8,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            // itemCount: commonDetails!
                                            //     .data.transferStaffs.length,
                                            itemCount: commonDetails?.data
                                                    ?.transferStaffs?.length ??
                                                0,
                                            itemBuilder: (context, ind) {
                                              return CheckboxListTile(
                                                title: SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    commonDetails!
                                                        .data
                                                        .transferStaffs[ind]
                                                        .tranStaffName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                value: checkedCreatedStaffItems
                                                        .contains(commonDetails!
                                                            .data
                                                            .transferStaffs[ind]
                                                            .tranStaffId
                                                            .toString())
                                                    ? true
                                                    : false,
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    setState(() {
                                                      checkedCreatedStaffItems
                                                          .add(commonDetails!
                                                              .data
                                                              .transferStaffs[
                                                                  ind]
                                                              .tranStaffId
                                                              .toString());
                                                      checkedCreatedStaffItemsName
                                                          .add(commonDetails!
                                                              .data
                                                              .transferStaffs[
                                                                  ind]
                                                              .tranStaffName
                                                              .toString());

                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      checkedCreatedStaffItems
                                                          .remove(commonDetails!
                                                              .data
                                                              .transferStaffs[
                                                                  ind]
                                                              .tranStaffId
                                                              .toString());
                                                      checkedCreatedStaffItemsName
                                                          .remove(commonDetails!
                                                              .data
                                                              .transferStaffs[
                                                                  ind]
                                                              .tranStaffName
                                                              .toString());

                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  }
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 1,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: checkedCreatedStaffItems.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, top: 15, bottom: 10),
                                        child: Text('Created By'))
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 40),
                                        child: SizedBox(
                                          height: 35,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                checkedCreatedStaffItemsName
                                                    .length,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0),
                                                            color: Colors.white,
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6))),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                child: Text(
                                                                  checkedCreatedStaffItemsName[
                                                                      i],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Please Confirm'),
                                                                  content:
                                                                      const Text(
                                                                          'Are you sure to Remove this Number?'),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'No')),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            checkedCreatedStaffItemsName.remove(checkedCreatedStaffItemsName[i]);
                                                                            checkedCreatedStaffItems.remove(checkedCreatedStaffItems[i]);
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Yes')),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0),
                                                              color: Colors.grey
                                                                  .shade100,
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6))),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Lead Source'),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: const Text('Lead Source'),
                                        content: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .32,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .8,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            // itemCount: commonDetails!
                                            //     .data.leadSource.length,
                                            itemCount: commonDetails?.data
                                                    ?.leadSource?.length ??
                                                0,
                                            itemBuilder: (context, ind) {
                                              return CheckboxListTile(
                                                title: SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    commonDetails!
                                                        .data
                                                        .leadSource[ind]
                                                        .leadSource
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                value: checkedCallResultItems
                                                        .contains(commonDetails!
                                                            .data
                                                            .leadSource[ind]
                                                            .leadSourceId
                                                            .toString())
                                                    ? true
                                                    : false,
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    setState(() {
                                                      checkedLeadSource.add(
                                                          commonDetails!
                                                              .data
                                                              .leadSource[ind]
                                                              .leadSourceId
                                                              .toString());
                                                      checkedLeadSourceName.add(
                                                          commonDetails!
                                                              .data
                                                              .leadSource[ind]
                                                              .leadSource
                                                              .toString());

                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      checkedLeadSource.remove(
                                                          commonDetails!
                                                              .data
                                                              .leadSource[ind]
                                                              .leadSource
                                                              .toString());
                                                      checkedLeadSourceName
                                                          .remove(commonDetails!
                                                              .data
                                                              .leadSource[ind]
                                                              .leadSourceId
                                                              .toString());

                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  }
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 1,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: checkedLeadSource.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, top: 15, bottom: 10),
                                        child: Text('Lead Source'))
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 40),
                                        child: SizedBox(
                                          height: 35,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                checkedLeadSourceName.length,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0),
                                                            color: Colors.white,
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6))),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                child: Text(
                                                                  checkedLeadSourceName[
                                                                      i],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Please Confirm'),
                                                                  content:
                                                                      const Text(
                                                                          'Are you sure to Remove this Number?'),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'No')),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            checkedLeadSourceName.remove(checkedLeadSourceName[i]);
                                                                            checkedLeadSource.remove(checkedLeadSource[i]);
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Yes')),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0),
                                                              color: Colors.grey
                                                                  .shade100,
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6))),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Container(
                          height: 40,
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3375e0),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                isFilterApplied = true;
                                items.clear();
                                page = 1;
                                getData();
                                Navigator.pop(context);
                              });
                            },
                            child: const Center(
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  Widget _buildLeadContent(dynamic item, BuildContext context, int index) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .88,
            child: Stack(
              children: [
                Row(
                  children: [
                    if (item.priority == '1')
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (item.priority == '2')
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (item.priority == '3')
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (item.priority == '4')
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .46,
                      child: Text(
                        item.clientName.toString(),
                        // items.length.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            decoration: item.priority == "4"
                                ? TextDecoration.lineThrough
                                : null,
                            decorationThickness: 1.5,
                            decorationColor: Colors.red,
                            color:
                                item.isCustomer ? Colors.green : Colors.black,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 2, bottom: 2),
                          child: Text(
                            item.leadCategory.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: item.categoryCount.toString() != "1" &&
                          item.categoryCount.toString() != "",
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            item.categoryCount.toString(),
                            // items.length.toString(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.68,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.contactNumber1.toString(),
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                'Assigned to : ${item.staffName}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  // color: _colors[items[index]
                                  //     .callResultId!],
                                  color: item.callResultId >= 0 &&
                                          item.callResultId < _colors.length
                                      ? _colors[item.callResultId]
                                      : const Color.fromARGB(255, 245, 160, 34),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 2, bottom: 2),
                                child: Text(
                                  item.callResult.toString(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        item.callResultId == 1
                            ? Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFFd5f5f4),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/icons/calendar.png",
                                          width: 20),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Created Time',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            item.createdDate.toString(),
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFd5f5f4),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5, top: 5, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/icons/calendar.png",
                                              width: 20),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            children: [
                                              const Text(
                                                'Called Date',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                item.isCalled == false
                                                    ? '--'
                                                    : item.calledDate
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFd5f5f4),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5, top: 5, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/icons/calendar.png",
                                              width: 20),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            children: [
                                              const Text(
                                                'Followup Date',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                item.scheduledDate.toString(),
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 60,
                  ),
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 20,
                      minWidth: 20,
                      maxHeight: 50,
                      maxWidth: 50,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(1, 1)),
                      ],
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(item.profilePic.toString())),
                      // image: AssetImage(
                      //     'assets/images/img.jpeg')),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    if (widget.cloudCall == false) {
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: const Text('Alert !!!'),
                              content: const Text(""),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LeadDetails(
                                                  widget.token!,
                                                  widget.editLead,
                                                  widget.deleteLead,
                                                  widget.cloudCall,
                                                  item.callMasterId.toString(),
                                                  pageName: widget.pageName
                                                      .toString(),
                                                  page: page,
                                                  pageSize: page * pageSize,
                                                  fromDate: fromdate.toString(),
                                                  toDate: todate.toString(),
                                                )),
                                      ).then((r) {
                                        items.clear();
                                        page = 1;
                                        getData();
                                        itemPositionsListener.itemPositions
                                            .addListener(() {
                                          if (itemPositionsListener
                                                  .itemPositions
                                                  .value
                                                  .last
                                                  .index ==
                                              items.length - 1) {
                                            if (items.length <
                                                viewLeads!.data.totalLeads) {
                                              getData();
                                            }
                                          }
                                        });
                                      });
                                    },
                                    child: const Text('followup')),
                              ],
                            );
                          });
                    } else {
                      if (widget.cloudCall == true) {
                        chooseCallDialog(context, index);
                      } else {
                        Common.dialPad(item.contactNumber1);
                        Common.dialPad(item.contactNumber1);
                      }
                    }
                  },
                  child: Container(
                    width: 65,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Call',
                              style: TextStyle(
                                  fontFamily: "MontserratMedium",
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _buildLoaderListItem() {
    return Shimmer.fromColors(
        enabled: true,
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 12.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      height: 12.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 96.0,
                      height: 72.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 10.0,
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 10.0,
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8.0),
                          ),
                          Container(
                            width: 100.0,
                            height: 10.0,
                            color: Colors.white,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 12.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      height: 12.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 96.0,
                      height: 72.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            height: 10.0,
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 10.0,
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8.0),
                          ),
                          Container(
                            width: 100.0,
                            height: 10.0,
                            color: Colors.white,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      height: 12.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      height: 12.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 96.0,
                      height: 72.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 10.0,
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 10.0,
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8.0),
                          ),
                          Container(
                            width: 100.0,
                            height: 10.0,
                            color: Colors.white,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
