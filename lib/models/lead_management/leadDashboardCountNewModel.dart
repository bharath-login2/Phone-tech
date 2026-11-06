class DashboardLeadCounts {
  final Data data;
  final bool status;
  final String message;

  DashboardLeadCounts({
    required this.data,
    required this.status,
    required this.message,
  });

  factory DashboardLeadCounts.fromJson(Map<String, dynamic> json) {
    return DashboardLeadCounts(
      data: Data.fromJson(json['data']),
      status: json['status'],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'status': status,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'DashboardLeadCounts(data: $data, status: $status, message: $message)';
  }
}

class Data {
  final Leads leads;

  Data({
    required this.leads,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      leads: Leads.fromJson(json['leads']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leads': leads.toJson(),
    };
  }

  @override
  String toString() {
    return 'Data(leads: $leads)';
  }
}

class Leads {
  final int newLeads;
  final int missedLeads;
  final int followupLeads;
  final int closedLeads;
  final int calledCount;
  final int transferLeads;
  final int callNotGetting;
  final int planPresented;

  Leads({
    required this.newLeads,
    required this.missedLeads,
    required this.followupLeads,
    required this.closedLeads,
    required this.calledCount,
    required this.transferLeads,
    required this.callNotGetting,
    required this.planPresented,
  });

    static int _parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    factory Leads.fromJson(Map<String, dynamic> json) {
      return Leads(
        newLeads: _parseInt(json['newLeads']),
        missedLeads: _parseInt(json['missedLeads']),
        followupLeads: _parseInt(json['followupLeads']),
        closedLeads: _parseInt(json['closedLeads']),
        calledCount: _parseInt(json['calledCount']),
        transferLeads: _parseInt(json['transferLeads']),
        callNotGetting: _parseInt(json['callNotGetting'] ?? json['call_not_getting'] ?? json['cng'] ?? json['CNG']),
        planPresented: _parseInt(json['planPresented'] ?? json['plan_presented']),
      );
    }

  Map<String, dynamic> toJson() {
    return {
      'newLeads': newLeads,
      'missedLeads': missedLeads,
      'followupLeads': followupLeads,
      'closedLeads': closedLeads,
      'calledCount': calledCount,
      'transferLeads': transferLeads,
      'callNotGetting': callNotGetting,
      'planPresented': planPresented,
    };
  }

  @override
  String toString() {
    return 'Leads(newLeads: $newLeads, missedLeads: $missedLeads, followupLeads: $followupLeads, closedLeads: $closedLeads, calledCount: $calledCount, transferLeads: $transferLeads),callNotGetting: $callNotGetting),planPresented: $planPresented),';
  }
}
