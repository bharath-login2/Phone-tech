class VerificationDashboardModel {
  final bool status;
  final String message;
  final VerificationDashboardData? data;

  VerificationDashboardModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory VerificationDashboardModel.fromJson(Map<String, dynamic> json) {
    return VerificationDashboardModel(
      status: json['status'] == true ||
          json['status'] == 1 ||
          json['status'] == '1' ||
          json['status'] == 'true' ||
          json['status'] == 'success',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? VerificationDashboardData.fromJson(json['data'])
          : (json['data'] != null && json['data'] is Map
              ? VerificationDashboardData.fromJson(
                  Map<String, dynamic>.from(json['data']))
              : (json['calledCount'] != null ||
                      json['verifiedCount'] != null ||
                      json['invalidCount'] != null
                  ? VerificationDashboardData.fromJson(json)
                  : null)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  String toString() {
    return 'VerificationDashboardModel(status: $status, message: $message, data: $data)';
  }
}

class VerificationDashboardData {
  final dynamic calledCount;
  final dynamic calledCountTotal;
  final dynamic callNotGetting;
  final dynamic verifiedCount;
  final dynamic unverifiedCount;
  final dynamic verifiedBoysCount;
  final dynamic verifiedGirlsCount;
  final dynamic invalidCount;

  VerificationDashboardData({
    this.calledCount,
    this.calledCountTotal,
    this.callNotGetting,
    this.verifiedCount,
    this.unverifiedCount,
    this.verifiedBoysCount,
    this.verifiedGirlsCount,
    this.invalidCount,
  });

  factory VerificationDashboardData.fromJson(Map<String, dynamic> json) {
    return VerificationDashboardData(
      calledCount: json['calledCount'] ??
          json['called_count'] ??
          json['todayCalled'] ??
          json['today_called'],
      calledCountTotal: json['calledCountTotal'] ??
          json['called_count_total'] ??
          json['totalCalled'] ??
          json['total_called'],
      callNotGetting: json['callNotGetting'] ??
          json['call_not_getting'] ??
          json['cng'] ??
          json['CNG'],
      verifiedCount: json['verifiedCount'] ??
          json['verified_count'] ??
          json['verified'],
      unverifiedCount: json['unverifiedCount'] ??
          json['unverified_count'] ??
          json['unverified'],
      verifiedBoysCount: json['verifiedBoysCount'] ??
          json['verified_boys_count'] ??
          json['boyData'] ??
          json['boy_data'] ??
          json['boysCount'] ??
          json['boys_count'],
      verifiedGirlsCount: json['verifiedGirlsCount'] ??
          json['verified_girls_count'] ??
          json['girlData'] ??
          json['girl_data'] ??
          json['girlsCount'] ??
          json['girls_count'],
      invalidCount: json['invalidCount'] ??
          json['invalid_count'] ??
          json['invalid'] ??
          json['Invalid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calledCount': calledCount,
      'calledCountTotal': calledCountTotal,
      'callNotGetting': callNotGetting,
      'verifiedCount': verifiedCount,
      'unverifiedCount': unverifiedCount,
      'verifiedBoysCount': verifiedBoysCount,
      'verifiedGirlsCount': verifiedGirlsCount,
      'invalidCount': invalidCount,
    };
  }

  String get todayCalled => _parseCount(calledCount);
  String get totalCalled => _parseCount(calledCountTotal);
  String get cng => _parseCount(callNotGetting);
  String get verified => _parseCount(verifiedCount);
  String get unverified => _parseCount(unverifiedCount);
  String get boyData => _parseCount(verifiedBoysCount);
  String get girlData => _parseCount(verifiedGirlsCount);
  String get invalid => _parseCount(invalidCount);

  static String _parseCount(dynamic val) {
    if (val == null) return '0';
    if (val is num) return val.toInt().toString();
    final str = val.toString().trim();
    if (str.isEmpty || str.toLowerCase() == 'null') return '0';
    final parsed = num.tryParse(str);
    if (parsed != null) {
      return parsed.toInt().toString();
    }
    return str;
  }

  @override
  String toString() {
    return 'VerificationDashboardData(calledCount: $calledCount, calledCountTotal: $calledCountTotal, callNotGetting: $callNotGetting, verifiedCount: $verifiedCount, unverifiedCount: $unverifiedCount, verifiedBoysCount: $verifiedBoysCount, verifiedGirlsCount: $verifiedGirlsCount, invalidCount: $invalidCount)';
  }
}
