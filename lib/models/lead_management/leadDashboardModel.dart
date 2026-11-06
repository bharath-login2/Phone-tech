// To parse this JSON data, do
//
//     final leadDashboardModel = leadDashboardModelFromJson(jsonString);

import 'dart:convert';

LeadDashboardModel leadDashboardModelFromJson(String str) => LeadDashboardModel.fromJson(json.decode(str));

String leadDashboardModelToJson(LeadDashboardModel data) => json.encode(data.toJson());

class LeadDashboardModel {
    Data data;
    bool status;
    String message;

    LeadDashboardModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory LeadDashboardModel.fromJson(Map<String, dynamic> json) => LeadDashboardModel(
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
    int newLeads;
    int followupLeads;
    int closedLeads;
    int totalCalled;
    int missedLeads;
    int transferLeads;
    LeadsCount currentLeadsCount;
    LeadsCount previousLeadsCount;
    int unreadNotification;
    int? callNotGetting;
    int? planPresented;

    Data({
        required this.newLeads,
        required this.followupLeads,
        required this.closedLeads,
        required this.totalCalled,
        required this.missedLeads,
        required this.transferLeads,
        required this.currentLeadsCount,
        required this.previousLeadsCount,
        required this.unreadNotification,
        this.callNotGetting,
        this.planPresented,
    });

    static int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        newLeads: json["newLeads"] ?? 0,
        followupLeads: json["followupLeads"] ?? 0,
        closedLeads: json["closedLeads"] ?? 0,
        totalCalled: json["totalCalled"] ?? 0,
        missedLeads: json["missedLeads"] ?? 0,
        transferLeads: json["transferLeads"] ?? 0,
        currentLeadsCount: LeadsCount.fromJson(json["current_leads_count"] ?? {}),
        previousLeadsCount: LeadsCount.fromJson(json["previous_leads_count"] ?? {}),
        unreadNotification: json["unread_notification"] ?? 0,
        callNotGetting: _parseInt(json["callNotGetting"] ?? json["call_not_getting"] ?? json["cng"] ?? json["CNG"] ?? json["cngLeads"]),
        planPresented: _parseInt(json["planPresented"] ?? json["plan_presented"] ?? json["planPresentedLeads"]),
    );

    Map<String, dynamic> toJson() => {
        "newLeads": newLeads,
        "followupLeads": followupLeads,
        "closedLeads": closedLeads,
        "totalCalled": totalCalled,
        "missedLeads": missedLeads,
        "transferLeads": transferLeads,
        "current_leads_count": currentLeadsCount.toJson(),
        "previous_leads_count": previousLeadsCount.toJson(),
        "unread_notification": unreadNotification,
        "callNotGetting": callNotGetting,
        "planPresented": planPresented,
    };
}

class LeadsCount {
    String total;
    String month;
    String date;

    LeadsCount({
        required this.total,
        required this.month,
        required this.date,
    });

    factory LeadsCount.fromJson(Map<String, dynamic> json) => LeadsCount(
        total: json["total"],
        month: json["month"],
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "month": month,
        "date": date,
    };
}
