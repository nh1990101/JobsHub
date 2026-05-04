import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_colors.dart';
import '../providers/language_provider.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';

class ResumeScreen extends ConsumerStatefulWidget {
  const ResumeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends ConsumerState<ResumeScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _incomeController;
  String _selectedGender = 'Male';
  DateTime? _selectedDate;
  String _countryCode = '+0';
  int? _countryId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _incomeController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 每次进入页面时重新加载用户数据
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();

      // 设置默认国家 ID
      _countryId = prefs.getInt('country_id') ?? 1;
      if (_countryId == null) {
        _countryId = 1;
        await prefs.setInt('country_id', _countryId!);
      }

      // 从本地存储加载用户数据
      _nameController.text = prefs.getString('user_name') ?? '';
      _emailController.text = prefs.getString('user_email') ?? '';
      _phoneController.text = prefs.getString('user_phone') ?? '';
      _selectedGender = prefs.getString('user_gender') ?? 'Male';
      _incomeController.text = prefs.getString('user_income') ?? '';

      final savedDate = prefs.getString('user_birthday');
      if (savedDate != null) {
        _selectedDate = DateTime.parse(savedDate);
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserData() async {
    final strings = ref.read(appStringsProvider);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userService = UserService();
      final apiService = ApiService();

      // 保存到本地存储
      await prefs.setString('user_name', _nameController.text);
      await prefs.setString('user_email', _emailController.text);
      await prefs.setString('user_phone', _phoneController.text);
      await prefs.setString('user_gender', _selectedGender);
      await prefs.setString('user_income', _incomeController.text);
      if (_selectedDate != null) {
        await prefs.setString('user_birthday', _selectedDate!.toIso8601String());
      }
      await prefs.setInt('country_id', _countryId ?? 1);

      // 获取设备 ID 并保存到后端
      final deviceId = await userService.getDeviceId();
      await apiService.saveUserData(
        deviceId,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        gender: _selectedGender,
        age: _incomeController.text,
        birthday: _selectedDate?.toIso8601String(),
        income: _incomeController.text,
        countryId: _countryId ?? 1,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.resumeSaved)),
        );
      }
    } catch (e) {
      print('Error saving user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${strings.saveFailed}: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.myResume,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: AppColors.primary),
            onPressed: _saveUserData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(strings.name),
            _buildTextField(
              controller: _nameController,
              hintText: strings.pleaseEnterName,
            ),
            SizedBox(height: 24.h),
            _buildLabel(strings.email),
            _buildTextField(
              controller: _emailController,
              hintText: strings.pleaseEnterEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24.h),
            _buildLabel(strings.phone),
            Row(
              children: [
                Container(
                  width: 80.w,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.divider,
                        width: 1,
                      ),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _countryCode,
                    isExpanded: true,
                    underline: SizedBox(),
                    items: ['+0', '+1', '+86', '+81', '+65'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _countryCode = newValue ?? '+0';
                      });
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildTextField(
                    controller: _phoneController,
                    hintText: strings.pleaseEnterPhone,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildLabel(strings.gender),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.divider,
                    width: 1,
                  ),
                ),
              ),
              child: DropdownButton<String>(
                value: _selectedGender,
                isExpanded: true,
                underline: SizedBox(),
                items: [
                  DropdownMenuItem<String>(
                    value: 'Male',
                    child: Text(strings.male),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Female',
                    child: Text(strings.female),
                  ),
                ].toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue ?? 'Male';
                  });
                },
              ),
            ),
            SizedBox(height: 24.h),
            _buildLabel(strings.birthday),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.divider,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? strings.pleaseSelectBirthday
                          : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: _selectedDate == null
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            _buildLabel(strings.income),
            _buildTextField(
              controller: _incomeController,
              hintText: strings.pleaseEnterIncome,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
