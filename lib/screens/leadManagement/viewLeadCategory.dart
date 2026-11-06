import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:login2/screens/leadManagement/viewLeadSubcategory.dart';
import 'package:login2/widgets/inputTextFeildWidget.dart';

import '../../core/common.dart';
import '../../models/lead_management/addLeadCategoryModel.dart';
import '../../models/lead_management/editLeadCategoryModel.dart';
import '../../models/lead_management/leadCategoryDeleteModel.dart';
import '../../models/lead_management/viewLeadCategoryModel.dart';
import '../../service/service.dart';

class ViewLeadCategory extends StatefulWidget {
  final String token;
  final bool createLeads;
  final bool updateLeads;
  final bool deleteLeads;

  const ViewLeadCategory(
    this.token,
    this.createLeads,
    this.updateLeads,
    this.deleteLeads, {
    super.key,
  });

  @override
  State<ViewLeadCategory> createState() => _ViewLeadCategoryState();
}

class _ViewLeadCategoryState extends State<ViewLeadCategory>
    with SingleTickerProviderStateMixin {
  bool? _hasConnection = true;
  ViewLeadCategoryModel? _viewLeadsCategory;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _editCategoryController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _getData();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _editCategoryController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = connectivityResult is List<ConnectivityResult>
        ? connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi)
        : connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi;

    setState(() {
      _hasConnection = hasInternet;
    });

    if (hasInternet) {
      _viewLeadsCategory = await HttpService.viewLeadsCategory(widget.token);
      if (_viewLeadsCategory != null && mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _refreshData() async {
    await _getData();
  }

  void _showAddCategoryDialog() {
    _categoryController.clear();
    showGeneralDialog(
      barrierLabel: "addCategoryDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: BoxConstraints(
                maxWidth: 400,
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Create New Category',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => Navigator.pop(context),
                            splashRadius: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: InputTextField(
                            hintText: 'Enter category name',
                            hintTextColor: Colors.grey.shade500,
                            backgroundColor: Colors.transparent,
                            controller: _categoryController,
                            width: 1,
                            iconData: Icons.category_outlined,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _addCategory,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 47, 131, 180),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Create Category',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _addCategory() async {
    if (_categoryController.text.trim().isEmpty) {
      Common.toastMessaage('Please enter a category name', Colors.red);
      return;
    }

    Common.showProgressDialog(context, "Creating...");
    final addCategory = await HttpService.addLeadCategory(
      widget.token,
      _categoryController.text.trim(),
    );

    if (mounted) Navigator.pop(context);

    if (addCategory.data == true) {
      Common.toastMessaage(addCategory.message, Colors.green);
      if (mounted) {
        Navigator.pop(context);
        _refreshData();
      }
    } else {
      Common.toastMessaage(addCategory.message, Colors.red);
    }
  }

  void _showEditCategoryDialog(String id, String name) {
    _editCategoryController.text = name;
    showGeneralDialog(
      barrierLabel: "editCategoryDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Category',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => Navigator.pop(context),
                            splashRadius: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: InputTextField(
                            hintText: 'Category name',
                            hintTextColor: Colors.grey.shade500,
                            backgroundColor: Colors.transparent,
                            controller: _editCategoryController,
                            width: 1,
                            iconData: Icons.edit_outlined,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => _updateCategory(id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 47, 131, 180),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _updateCategory(String id) async {
    if (_editCategoryController.text.trim().isEmpty) {
      Common.toastMessaage('Please enter a category name', Colors.red);
      return;
    }

    Common.showProgressDialog(context, "Updating...");
    final editCategory = await HttpService.editLeadCategory(
      widget.token,
      _editCategoryController.text.trim(),
      id,
    );

    if (mounted) Navigator.pop(context);

    if (editCategory.data == true) {
      Common.toastMessaage(editCategory.message, Colors.green);
      if (mounted) {
        Navigator.pop(context);
        _refreshData();
      }
    } else {
      Common.toastMessaage(editCategory.message, Colors.red);
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          'Delete Category',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete this category? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          TextButton(
            onPressed: () => _deleteCategory(id, ctx),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(String id, BuildContext ctx) async {
    Navigator.pop(ctx);
    Common.showProgressDialog(context, "Deleting...");
    final deleteCategory =
        await HttpService.deleteLeadCategory(widget.token, id);

    if (mounted) Navigator.pop(context);

    if (deleteCategory.data == true) {
      Common.toastMessaage(deleteCategory.message, Colors.green);
      if (mounted) _refreshData();
    } else {
      Common.toastMessaage(deleteCategory.message, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: const Color(0xFF3366FF),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFF),
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 47, 131, 180),
              Color.fromARGB(255, 47, 131, 180)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Lead Categories',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      //letterSpacing: -0.5,
                    ),
                  ),
                ),
                if (widget.createLeads)
                  GestureDetector(
                    onTap: _showAddCategoryDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_hasConnection == false) {
      return _buildNoNetworkView();
    }

    if (_viewLeadsCategory == null) {
      return Center(
        child: Lottie.asset(
          'assets/main/loading.json',
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
      );
    }

    final categories = _viewLeadsCategory!.data;
    if (categories == null || categories.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          id: category.leadCategoryId.toString(),
          name: category.leadCategory.toString(),
          index: index,
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required String id,
    required String name,
    required int index,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200 + (index * 50)),
      curve: Curves.easeOutCubic,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _navigateToSubcategories(id),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 47, 131, 180)
                              .withOpacity(0.1),
                          const Color.fromARGB(255, 47, 131, 180)
                              .withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.category_rounded,
                      color: Color.fromARGB(255, 47, 131, 180),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(
                        icon: Icons.remove_red_eye_outlined,
                        color: const Color(0xFF10B981),
                        onTap: () => _navigateToSubcategories(id),
                      ),
                      if (widget.updateLeads) ...[
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.edit_outlined,
                          color: const Color(0xFFF59E0B),
                          onTap: () => _showEditCategoryDialog(id, name),
                        ),
                      ],
                      if (widget.deleteLeads) ...[
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.delete_outline,
                          color: const Color(0xFFEF4444),
                          onTap: () => _confirmDelete(id),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }

  void _navigateToSubcategories(String categoryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewLeadSubCategory(
          widget.token,
          widget.createLeads,
          widget.updateLeads,
          widget.deleteLeads,
          categoryId,
        ),
      ),
    ).then((_) => _refreshData());
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/main/empty_state.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Categories Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get started by creating your first Stream',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          if (widget.createLeads)
            ElevatedButton.icon(
              onPressed: _showAddCategoryDialog,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Create Category'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 47, 131, 180),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoNetworkView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/main/no_network.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3366FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
