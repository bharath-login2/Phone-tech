// To parse this JSON data, do
//
//     final addLeadCommonDataModel = addLeadCommonDataModelFromJson(jsonString);

import 'dart:convert';

AddLeadCommonDataModel addLeadCommonDataModelFromJson(String str) => AddLeadCommonDataModel.fromJson(json.decode(str));

String addLeadCommonDataModelToJson(AddLeadCommonDataModel data) => json.encode(data.toJson());

class AddLeadCommonDataModel {
    Data data;
    bool status;
   final String? message;

    AddLeadCommonDataModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory AddLeadCommonDataModel.fromJson(Map<String, dynamic> json) => AddLeadCommonDataModel(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class Data {
    List<LeadCategory> leadCategory;
    List<CallResult> callResult;
    List<CallResultNew> callResultNew;
    List<dynamic> branch;
    List<Staff> staff;
    List<ColloctedStaff> colloctedStaff;
    List<TransferStaff> transferStaffs;
    List<Priority> priority;
    List<CallResponseStatus> callResponseStatus;
    List<String> callResponse;
    List<LeadSource> leadSource;
    List<AdditionalField> additionalFields;
    String countryCode;
    bool customerAddPermission;
    bool customerAddInvoicePermission;
    bool isRenewal;
    bool isInstallment;
    List<TargetGroup> targetGroups;

    Data({
        required this.leadCategory,
        required this.callResult,
        required this.callResultNew,
        required this.branch,
        required this.staff,
        required this.colloctedStaff,
        required this.transferStaffs,
        required this.priority,
        required this.callResponseStatus,
        required this.callResponse,
        required this.leadSource,
        required this.additionalFields,
        required this.countryCode,
        required this.customerAddPermission,
        required this.customerAddInvoicePermission,
        required this.isRenewal,
        required this.isInstallment,
        required this.targetGroups,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        leadCategory: List<LeadCategory>.from(json["lead_category"].map((x) => LeadCategory.fromJson(x))),
        callResult: List<CallResult>.from(json["call_result"].map((x) => CallResult.fromJson(x))),
        callResultNew: List<CallResultNew>.from(json["call_result_new"].map((x) => CallResultNew.fromJson(x))),
        branch: (json["branch"] as List? ?? [])
          .map((x) => Branch.fromJson(
                Map<String, dynamic>.from(x as Map),
              ))
          .toList(),
        staff: List<Staff>.from(json["staff"].map((x) => Staff.fromJson(x))),
        colloctedStaff: List<ColloctedStaff>.from(json["collocted_staff"].map((x) => ColloctedStaff.fromJson(x))),
        transferStaffs: List<TransferStaff>.from(json["transfer_staffs"].map((x) => TransferStaff.fromJson(x))),
        priority: List<Priority>.from(json["priority"].map((x) => Priority.fromJson(x))),
        callResponseStatus: List<CallResponseStatus>.from(json["call_response_status"].map((x) => CallResponseStatus.fromJson(x))),
        callResponse: List<String>.from(json["call_response"].map((x) => x)),
        leadSource: List<LeadSource>.from(json["lead_source"].map((x) => LeadSource.fromJson(x))),
        additionalFields: List<AdditionalField>.from(json["additionalFields"].map((x) => AdditionalField.fromJson(x))),
        countryCode: json["country_code"]??"",
        customerAddPermission: json["customerAddPermission"]??"",
        customerAddInvoicePermission: json["customerAddInvoicePermission"]??"",
        isRenewal: json["isRenewal"]??"",
        isInstallment: json["isInstallment"]??"",
        targetGroups: List<TargetGroup>.from(json["target_groups"].map((x) => TargetGroup.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "lead_category": List<dynamic>.from(leadCategory.map((x) => x.toJson())),
        "call_result": List<dynamic>.from(callResult.map((x) => x.toJson())),
        "call_result_new": List<dynamic>.from(callResultNew.map((x) => x.toJson())),
        "branch": List<dynamic>.from(branch.map((x) => x)),
        "staff": List<dynamic>.from(staff.map((x) => x.toJson())),
        "collocted_staff": List<dynamic>.from(colloctedStaff.map((x) => x.toJson())),
        "transfer_staffs": List<dynamic>.from(transferStaffs.map((x) => x.toJson())),
        "priority": List<dynamic>.from(priority.map((x) => x.toJson())),
        "call_response_status": List<dynamic>.from(callResponseStatus.map((x) => x.toJson())),
        "call_response": List<dynamic>.from(callResponse.map((x) => x)),
        "lead_source": List<dynamic>.from(leadSource.map((x) => x.toJson())),
        "additionalFields": List<dynamic>.from(additionalFields.map((x) => x.toJson())),
        "country_code": countryCode,
        "customerAddPermission": customerAddPermission,
        "customerAddInvoicePermission": customerAddInvoicePermission,
        "isRenewal": isRenewal,
        "isInstallment": isInstallment,
    };
}

class AdditionalField {
    String id;
    String fieldName;

    AdditionalField({
        required this.id,
        required this.fieldName,
    });

    factory AdditionalField.fromJson(Map<String, dynamic> json) => AdditionalField(
        id: json["id"]??"",
        fieldName: json["field_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "field_name": fieldName,
    };
}

class CallResponseStatus {
    String callResponseId;
    String callResponse;

    CallResponseStatus({
        required this.callResponseId,
        required this.callResponse,
    });

    factory CallResponseStatus.fromJson(Map<String, dynamic> json) => CallResponseStatus(
        callResponseId: json["call_response_id"]??"",
        callResponse: json["call_response"]??"",
    );

    Map<String, dynamic> toJson() => {
        "call_response_id": callResponseId,
        "call_response": callResponse,
    };
}

class CallResult {
    String callResultId;
    String callResult;

    CallResult({
        required this.callResultId,
        required this.callResult,
    });

    factory CallResult.fromJson(Map<String, dynamic> json) => CallResult(
        callResultId: json["call_result_id"]??"",
        callResult: json["call_result"]??"",
    );

    Map<String, dynamic> toJson() => {
        "call_result_id": callResultId,
        "call_result": callResult,
    };
}

class CallResultNew {
    String callResultIdNew;
    String callResultNew;

    CallResultNew({
        required this.callResultIdNew,
        required this.callResultNew,
    });

    factory CallResultNew.fromJson(Map<String, dynamic> json) => CallResultNew(
        callResultIdNew: json["call_result_id_new"]??"",
        callResultNew: json["call_result_new"]??"",
    );

    Map<String, dynamic> toJson() => {
        "call_result_id_new": callResultIdNew,
        "call_result_new": callResultNew,
    };
}

class ColloctedStaff {
    String accountId;
    String accountName;

    ColloctedStaff({
        required this.accountId,
        required this.accountName,
    });

    factory ColloctedStaff.fromJson(Map<String, dynamic> json) => ColloctedStaff(
        accountId: json["account_id"]??"",
        accountName: json["account_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "account_name": accountName,
    };
}

class LeadCategory {
    String leadCategoryId;
    String leadCategory;

    LeadCategory({
        required this.leadCategoryId,
        required this.leadCategory,
    });

    factory LeadCategory.fromJson(Map<String, dynamic> json) => LeadCategory(
        leadCategoryId: json["lead_category_id"]??"",
        leadCategory: json["lead_category"]??"",
    );

    Map<String, dynamic> toJson() => {
        "lead_category_id": leadCategoryId,
        "lead_category": leadCategory,
    };
}

class LeadSource {
    String leadSourceId;
    String leadSource;
    String isRestricted;

    LeadSource({
        required this.leadSourceId,
        required this.leadSource,
        required this.isRestricted,
    });

    factory LeadSource.fromJson(Map<String, dynamic> json) => LeadSource(
        leadSourceId: json["lead_source_id"]??"",
        leadSource: json["lead_source"]??"",
        isRestricted: json["is_restricted"]??"",
    );

    Map<String, dynamic> toJson() => {
        "lead_source_id": leadSourceId,
        "lead_source": leadSource,
         "is_restricted": isRestricted,
        
    };
}

class Priority {
    String priorityId;
    String priority;

    Priority({
        required this.priorityId,
        required this.priority,
    });

    factory Priority.fromJson(Map<String, dynamic> json) => Priority(
        priorityId: json["priority_id"]??"",
        priority: json["priority"]??"",
    );

    Map<String, dynamic> toJson() => {
        "priority_id": priorityId,
        "priority": priority,
    };
}

class Staff {
    String userId;
    String staffName;

    Staff({
        required this.userId,
        required this.staffName,
    });

    factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        userId: json["user_id"]??"",
        staffName: json["staff_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "staff_name": staffName,
    };
}
class Branch {
    String branchId;
    String branchName;

    Branch({
        required this.branchId,
        required this.branchName,
    });

    factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        branchId: json["branch_id"]??"",
        branchName: json["branch_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "branch_id": branchId,
        "branch_name": branchName,
    };
}
class TransferStaff {
    String tranStaffId;
    String tranStaffName;

    TransferStaff({
        required this.tranStaffId,
        required this.tranStaffName,
    });

    factory TransferStaff.fromJson(Map<String, dynamic> json) => TransferStaff(
        tranStaffId: json["tran_staff_id"]??"",
        tranStaffName: json["tran_staff_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "tran_staff_id": tranStaffId,
        "tran_staff_name": tranStaffName,
    };
}

class TargetGroup {
    String id;
    String groupName;

    TargetGroup({
        required this.id,
        required this.groupName,
    });

    factory TargetGroup.fromJson(Map<String, dynamic> json) => TargetGroup(
        id: json["id"]??"",
        groupName: json["group_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
    };
}
