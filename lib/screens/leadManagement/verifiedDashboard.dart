import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:login2/core/common.dart';
import 'package:login2/models/lead_management/dashboardLeadsCountsModel.dart';
import 'package:login2/models/lead_management/leadDashboardCountNewModel.dart';
import 'package:login2/models/lead_management/leadDashboardModel.dart' as ld;
import 'package:login2/models/lead_management/leadProgressbarModel.dart' as lp;
import 'package:login2/models/lead_management/verificationDashboardModel.dart';
import 'package:login2/service/service.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class VerifiedDashboard extends StatefulWidget {
  final String? token;
  final VoidCallback? onRefresh;
  final ld.LeadDashboardModel? leadDashboard;
  final DashboardLeadsCountsModel? dashboardCounts;
  final DashboardLeadCounts? dashboardMainCounts;
  final VerificationDashboardData? verificationData;
  final bool isStandalonePage;
  final String? selectedFilter;
  final Widget? listContent;
  final bool Function(ScrollNotification)? onScrollNotification;
  final void Function(
    String title, {
    dynamic type,
    dynamic callResultId,
    int? verifyDashboard,
  })? onTileSelected;

  const VerifiedDashboard({
    super.key,
    this.token,
    this.onRefresh,
    this.leadDashboard,
    this.dashboardCounts,
    this.dashboardMainCounts,
    this.verificationData,
    this.isStandalonePage = false,
    this.selectedFilter,
    this.listContent,
    this.onScrollNotification,
    this.onTileSelected,
  });

  @override
  State<VerifiedDashboard> createState() => _VerifiedDashboardState();
}

class _VerifiedDashboardState extends State<VerifiedDashboard> {
  bool _isFlipSummaryView = false;
  String _selectedFilter = 'Today Called';
  bool _isLoading = false;
  String? _errorMessage;
  VerificationDashboardData? _verificationData;
  final TextEditingController _searchController = TextEditingController();

  static const Color primaryBlue = Color(0xFF2a86c9);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color borderLight = Color(0xFFECF0F1);

  // Palette matching dashboardLeadsNewUpdated2.dart
  final List<Color> _colors = const [
    Color(0xFF2196F3),
    Color(0xFF2196F3), // 1 Blue
    Color(0xFFFFC107), // 2 Amber
    Color(0xFFFF0707), // 3 Red
    Color(0xFF4CAF50), // 4 Green
    Color(0xFFF44336), // 5 Red/Coral
    Color(0xFF9C27B0), // 6 Purple
    Color(0xFF2a84c9), // 7 Blue
    Color(0xFF009688), // 8 Teal
    Color(0xFFFF6F00), // 9 Orange
    Color(0xFFE91E63), // 10 Pink
  ];

  @override
  void initState() {
    super.initState();
    if (widget.selectedFilter != null) {
      _selectedFilter = widget.selectedFilter!;
    }
    _loadPreferences();
    if (widget.verificationData != null) {
      _verificationData = widget.verificationData;
    } else {
      _fetchVerificationDashboard();
    }
  }

  @override
  void didUpdateWidget(covariant VerifiedDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedFilter != null &&
        widget.selectedFilter != oldWidget.selectedFilter) {
      setState(() {
        _selectedFilter = widget.selectedFilter!;
      });
    }
    if (widget.verificationData != null &&
        widget.verificationData != oldWidget.verificationData) {
      setState(() {
        _verificationData = widget.verificationData;
        _errorMessage = null;
      });
    } else if (oldWidget.token != widget.token ||
        oldWidget.leadDashboard != widget.leadDashboard ||
        oldWidget.dashboardMainCounts != widget.dashboardMainCounts) {
      _fetchVerificationDashboard();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    String? flipView = await Common.getSharedPref("isFlipVerifiedSummaryView");
    if (flipView != null && mounted) {
      setState(() {
        _isFlipSummaryView = flipView == "true";
      });
    }
  }

  Future<void> _fetchVerificationDashboard() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final model =
          await HttpService.verificationDashboard(token: widget.token);
      if (!mounted) return;
      if (model != null && model.status) {
        setState(() {
          _verificationData = model.data;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = (model?.message != null && model!.message.isNotEmpty)
              ? model.message
              : "Failed to load verification counts";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Network error: $e";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleTileClick(String label) {
    switch (label) {
      case 'Today Called':
        widget.onTileSelected?.call(
          label,
          type: -1,
          verifyDashboard: 1,
        );
        break;
      case 'Total Called':
        widget.onTileSelected?.call(
          label,
          type: 'total',
          verifyDashboard: 1,
        );
        break;
      case 'Unverified':
        widget.onTileSelected?.call(
          label,
          callResultId: 15,
          verifyDashboard: 1,
        );
        break;
      case 'CNG':
        widget.onTileSelected?.call(
          label,
          callResultId: 9,
          verifyDashboard: 1,
        );
        break;
      case 'Invalid':
        widget.onTileSelected?.call(
          label,
          callResultId: 16,
          verifyDashboard: 1,
        );
        break;
      case 'Boy Data':
        widget.onTileSelected?.call(
          label,
          callResultId: 14,
          type: 'boys',
          verifyDashboard: 1,
        );
        break;
      case 'Girl Data':
        widget.onTileSelected?.call(
          label,
          callResultId: 14,
          type: 'girls',
          verifyDashboard: 1,
        );
        break;
      case 'Verified':
        widget.onTileSelected?.call(
          label,
          callResultId: 14,
          verifyDashboard: 1,
        );
        break;
      default:
        widget.onTileSelected?.call(
          label,
          verifyDashboard: 1,
        );
        break;
    }
  }

  String _getTileCount(String title) {
    if (_verificationData != null) {
      switch (title) {
        case 'Today Called':
          return _verificationData!.todayCalled;
        case 'Total Called':
          return _verificationData!.totalCalled;
        case 'CNG':
          return _verificationData!.cng;
        case 'Invalid':
          return _verificationData!.invalid;
        case 'Verified':
          return _verificationData!.verified;
        case 'Boy Data':
          return _verificationData!.boyData;
        case 'Girl Data':
          return _verificationData!.girlData;
        case 'Unverified':
          return _verificationData!.unverified;
        default:
          return '0';
      }
    }
    return '0';
  }

  Color _getTileColor(String title) {
    switch (title) {
      case 'Today Called':
        return _colors[1]; // Blue
      case 'Total Called':
        return _colors[6]; // Purple
      case 'CNG':
        return _colors[5]; // Coral Red
      case 'Invalid':
        return _colors[3]; // Red
      case 'Verified':
        return _colors[4]; // Green
      case 'Boy Data':
        return _colors[8]; // Teal
      case 'Girl Data':
        return const Color(0xFFE91E63); // Pink
      case 'Unverified':
        return const Color(0xFFFF9800); // Pink
      default:
        return primaryBlue;
    }
  }

  IconData _getTileIcon(String title) {
    switch (title) {
      case 'Today Called':
        return Icons.phone_in_talk_rounded;
      case 'Total Called':
        return Icons.ring_volume_rounded;
      case 'CNG':
        return Icons.phone_missed_rounded;
      case 'Invalid':
        return Icons.cancel_rounded;
      case 'Verified':
        return Icons.verified_rounded;
      case 'Boy Data':
        return Icons.male_rounded;
      case 'Girl Data':
        return Icons.female_rounded;
      case 'Unverified':
        return Icons.gpp_maybe_rounded;
      default:
        return Icons.analytics_rounded;
    }
  }

  Color _getBackgroundColor() {
    return _getTileColor(_selectedFilter).withOpacity(0.08);
  }

  Color _getPrimaryColor() {
    return _getTileColor(_selectedFilter);
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    if (widget.onRefresh != null) {
      widget.onRefresh!();
    }
    await _fetchVerificationDashboard();
  }

  @override
  Widget build(BuildContext context) {
    Widget scrollable = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _buildSummaryRowSection(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: widget.listContent ??
                Column(
                  children: [
                    _buildFilterHeader(),
                    const SizedBox(height: 16),
                    _buildContentSection(),
                    const SizedBox(height: 40),
                  ],
                ),
          ),
        ],
      ),
    );

    if (widget.onScrollNotification != null) {
      scrollable = NotificationListener<ScrollNotification>(
        onNotification: widget.onScrollNotification,
        child: scrollable,
      );
    }

    Widget content = Container(
      color: _getBackgroundColor(),
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        displacement: 40,
        child: scrollable,
      ),
    );

    if (widget.isStandalonePage) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Verified Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: primaryBlue,
          elevation: 0,
        ),
        body: content,
      );
    }

    return content;
  }

  Widget _buildSummaryRowSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Verified Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    _isFlipSummaryView = !_isFlipSummaryView;
                  });
                  await Common.saveSharedPref(
                    "isFlipVerifiedSummaryView",
                    _isFlipSummaryView.toString(),
                  );
                },
                child: const Icon(
                  Icons.flip_camera_android_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _isFlipSummaryView
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8, bottom: 4),
                    child: Row(
                      children: [
                        _buildSummaryItemOld('Today Called'),
                        _buildSummaryItemOld('Total Called'),
                        _buildSummaryItemOld('CNG'),
                        _buildSummaryItemOld('Invalid'),
                        _buildSummaryItemOld('Verified'),
                        _buildSummaryItemOld('Verified Boys'),
                        _buildSummaryItemOld('Verified Girls'),
                        _buildSummaryItemOld('Unverified'),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildSummaryItem('Today Called')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildSummaryItem('Total Called')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildSummaryItem('CNG')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildSummaryItem('Invalid')),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(child: _buildSummaryItem('Verified')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildSummaryItem('Boy Data')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildSummaryItem('Girl Data')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildSummaryItem('Unverified')),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label) {
    bool isSelected = _selectedFilter == label;
    Color color = _getTileColor(label);
    IconData icon = _getTileIcon(label);
    String count = _getTileCount(label);

    return SizedBox(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = label;
                });
                _handleTileClick(label);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [color.withOpacity(0.25), color.withOpacity(0.1)]
                        : [color.withOpacity(0.15), color.withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? color.withOpacity(0.5)
                        : color.withOpacity(0.2),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      count,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? color : textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 0),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? color : textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (label != 'Invalid')
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  _showAnalyticsSheet(label);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryItemOld(String label) {
    bool isSelected = _selectedFilter == label;
    Color color = _getTileColor(label);
    IconData icon = _getTileIcon(label);
    String count = _getTileCount(label);

    return Container(
      width: 72,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _selectedFilter = label;
              });
              _handleTileClick(label);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 72,
              padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.12) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? color.withOpacity(0.4) : borderLight,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 12,
                        color: isSelected ? color : textSecondary,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          count,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? color : textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? color : textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          if (label != 'Invalid')
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: () {
                  _showAnalyticsSheet(label);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getPrimaryColor().withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_selectedFilter Leads',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${_getTileCount(_selectedFilter)} Leads',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: _handleRefresh,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getPrimaryColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _getPrimaryColor().withOpacity(0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.refresh_rounded,
                    color: _getPrimaryColor(),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    String count = _getTileCount(_selectedFilter);
    Color color = _getTileColor(_selectedFilter);
    IconData icon = _getTileIcon(_selectedFilter);

    if (_isLoading && _verificationData == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              const SizedBox(height: 12),
              const Text(
                'Loading verification data...',
                style: TextStyle(color: textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null && _verificationData == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Unable to Load Verification Data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _errorMessage ??
                    'Something went wrong while fetching verification counts.',
                style: const TextStyle(fontSize: 12, color: textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchVerificationDashboard,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 44,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$_selectedFilter Leads',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            count == '0'
                ? 'No leads currently available under $_selectedFilter'
                : '$count leads categorized under $_selectedFilter',
            style: const TextStyle(
              fontSize: 13,
              color: textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _handleRefresh,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Refresh Data'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getAnalyticsParams(String label) {
    switch (label) {
      case 'Today Called':
        return {'status': 0};
      case 'Total Called':
        return {'status': 'total'};
      case 'CNG':
        return {'status': 9};
      case 'Invalid':
        return {'status': 16};
      case 'Unverified':
        return {'status': 15};
      case 'Verified':
        return {'status': 14};
      case 'Boy Data':
      case 'Boys Data':
        return {'status': 14, 'gender': 'boys'};
      case 'Girl Data':
      case 'Girls Data':
        return {'status': 14, 'gender': 'girls'};
      default:
        return {'status': label};
    }
  }

  Color _getStaffColor(dynamic key) {
    if (key is int) return _colors[key % _colors.length];
    if (key is String) {
      return _colors[key.length % _colors.length];
    }
    return primaryBlue;
  }

  Future<void> _showAnalyticsSheet(String label) async {
    final params = _getAnalyticsParams(label);
    final status = params['status'];
    final String? gender = params['gender'] as String?;
    final Color color = _getTileColor(label);
    final String fallbackCount = _getTileCount(label);

    Common.showProgressDialog(context, "Loading Analytics..");

    lp.LeadProgressbarModel? progressModel;
    try {
      progressModel = await HttpService.verifyProgressbar(
        token: widget.token,
        status: status,
        gender: gender,
      );
    } catch (e) {
      log("Error fetching verify progressbar: $e");
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(sheetContext).size.height * 0.9,
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.analytics_rounded,
                      color: primaryBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$label Leads",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          "Detailed analytics and distribution",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(sheetContext),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                child: _buildAnalyticsModalContent(
                  label: label,
                  color: color,
                  fallbackCount: fallbackCount,
                  model: progressModel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsModalContent({
    required String label,
    required Color color,
    required String fallbackCount,
    required lp.LeadProgressbarModel? model,
  }) {
    final String rawTotal = model?.data?.totalCount?.toString() ?? "";
    final String displayCount = (rawTotal.isNotEmpty && rawTotal != "0")
        ? rawTotal
        : (fallbackCount.isNotEmpty ? fallbackCount : "0");

    double total = double.tryParse(displayCount) ?? 0;
    final staffLeads = model?.data?.staffLeads ?? [];
    if (total == 0 && staffLeads.isNotEmpty) {
      total = staffLeads.fold<double>(
        0,
        (sum, item) => sum + (double.tryParse(item.staffCount ?? "0") ?? 0),
      );
    }

    final categoryLeads = model?.data?.categoryLeads ?? [];
    final statusLeads = model?.data?.statusLeads ?? [];
    final missedLeads = model?.data?.missedLeads ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, const Color(0xFF1D4ED8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.trending_up_rounded,
                  size: 100,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Generated $label',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        displayCount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Leads",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        if (staffLeads.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Staff Contribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '${staffLeads.length} Agents',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: staffLeads.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              final staff = staffLeads[i];
              double count = double.tryParse(staff.staffCount ?? "0") ?? 0;
              final double percentage = total > 0 ? count / total : 0;
              final itemColor = _getStaffColor(i);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                itemColor.withOpacity(0.2),
                                itemColor.withOpacity(0.1),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (staff.staffName?.isNotEmpty == true)
                                  ? staff.staffName![0].toUpperCase()
                                  : "?",
                              style: TextStyle(
                                color: itemColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                staff.staffName ?? "N/A",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Active Performance",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              staff.staffCount ?? "0",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              "Leads",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      animation: true,
                      lineHeight: 8.0,
                      animationDuration: 1200,
                      percent: percentage.clamp(0.0, 1.0),
                      barRadius: const Radius.circular(4),
                      progressColor: itemColor,
                      backgroundColor: const Color(0xFFF1F5F9),
                      trailing: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          "${(percentage * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: itemColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        if (categoryLeads.isNotEmpty) ...[
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Category Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '${categoryLeads.length} Categories',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: categoryLeads.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              final cat = categoryLeads[i];
              double count = double.tryParse(cat.categoryCount ?? "0") ?? 0;
              final double percentage = total > 0 ? count / total : 0;
              final itemColor = _getStaffColor(i + 3);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                itemColor.withOpacity(0.2),
                                itemColor.withOpacity(0.1),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (cat.categoryName?.isNotEmpty == true)
                                  ? cat.categoryName![0].toUpperCase()
                                  : "?",
                              style: TextStyle(
                                color: itemColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.categoryName ?? "N/A",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Category Performance",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              cat.categoryCount ?? "0",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              "Leads",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      animation: true,
                      lineHeight: 8.0,
                      animationDuration: 1200,
                      percent: percentage.clamp(0.0, 1.0),
                      barRadius: const Radius.circular(4),
                      progressColor: itemColor,
                      backgroundColor: const Color(0xFFF1F5F9),
                      trailing: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          "${(percentage * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: itemColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        if (statusLeads.isNotEmpty) ...[
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '${statusLeads.length} Stages',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: statusLeads.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              final statusLead = statusLeads[i];
              double count = double.tryParse(statusLead.statusCount ?? "0") ?? 0;
              final double percentage = total > 0 ? count / total : 0;
              final itemColor = _getStaffColor(i + 7);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                itemColor.withOpacity(0.2),
                                itemColor.withOpacity(0.1),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (statusLead.statusName?.isNotEmpty == true)
                                  ? statusLead.statusName![0].toUpperCase()
                                  : "?",
                              style: TextStyle(
                                color: itemColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                statusLead.statusName ?? "N/A",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Status Progress",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              statusLead.statusCount ?? "0",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              "Leads",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      animation: true,
                      lineHeight: 8.0,
                      animationDuration: 1200,
                      percent: percentage.clamp(0.0, 1.0),
                      barRadius: const Radius.circular(4),
                      progressColor: itemColor,
                      backgroundColor: const Color(0xFFF1F5F9),
                      trailing: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          "${(percentage * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: itemColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        if (missedLeads.isNotEmpty) ...[
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Missed Leads Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '${missedLeads.length} Staffs',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: missedLeads.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              final missed = missedLeads[i];
              double count = double.tryParse(missed.missedstaffCount ?? "0") ?? 0;
              final double percentage = total > 0 ? count / total : 0;
              final itemColor = _getStaffColor(i + 5);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                itemColor.withOpacity(0.2),
                                itemColor.withOpacity(0.1),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (missed.missedstaffName?.isNotEmpty == true)
                                  ? missed.missedstaffName![0].toUpperCase()
                                  : "?",
                              style: TextStyle(
                                color: itemColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                missed.missedstaffName ?? "N/A",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Staff Missed Leads",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              missed.missedstaffCount ?? "0",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              "Leads",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      animation: true,
                      lineHeight: 8.0,
                      animationDuration: 1200,
                      percent: percentage.clamp(0.0, 1.0),
                      barRadius: const Radius.circular(4),
                      progressColor: itemColor,
                      backgroundColor: const Color(0xFFF1F5F9),
                      trailing: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          "${(percentage * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: itemColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        if (staffLeads.isEmpty &&
            categoryLeads.isEmpty &&
            statusLeads.isEmpty &&
            missedLeads.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.pie_chart_outline_rounded,
                    size: 44,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No breakdown data available for $label",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 40),
      ],
    );
  }
}
