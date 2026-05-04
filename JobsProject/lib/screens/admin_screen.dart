import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/app_colors.dart';
import '../services/api_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final apiService = ApiService();
  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> users = [];
  Map<int, String> countryMap = {};
  int? selectedCountryId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      setState(() => isLoading = true);
      final data = await apiService.getCountries();

      setState(() {
        countries = data;
        // 构建国家 ID 到名字的映射
        for (var country in countries) {
          countryMap[country['id']] = country['name'];
        }
        // 默认选择第一个国家
        if (countries.isNotEmpty) {
          selectedCountryId = countries[0]['id'];
          _loadUsers(selectedCountryId!);
        }
      });
    } catch (e) {
      print('Error loading countries: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载国家列表失败: $e')),
        );
      }
    }
  }

  Future<void> _loadUsers(int countryId) async {
    try {
      setState(() => isLoading = true);
      final data = await apiService.getAppUsers();

      // 过滤指定国家的用户
      final filteredUsers = (data as List)
          .where((user) => user['country_id'] == countryId)
          .toList();

      setState(() {
        users = filteredUsers.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading users: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载用户列表失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户管理'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 国家选择器
                Container(
                  padding: EdgeInsets.all(16.w),
                  color: AppColors.primary.withOpacity(0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '选择国家',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: countries.map((country) {
                            final isSelected = selectedCountryId == country['id'];
                            return Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: FilterChip(
                                label: Text(country['name']),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => selectedCountryId = country['id']);
                                    _loadUsers(country['id']);
                                  }
                                },
                                backgroundColor: Colors.white,
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontSize: 12.sp,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                // 用户列表
                Expanded(
                  child: users.isEmpty
                      ? Center(
                          child: Text(
                            '暂无用户',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final countryName = countryMap[user['country_id']] ?? '未知国家';
                            return Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            user['name'] ?? '未命名',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: Text(
                                            countryName,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    _buildUserInfoRow('邮箱', user['email'] ?? '-'),
                                    _buildUserInfoRow('电话', user['phone'] ?? '-'),
                                    _buildUserInfoRow('性别', user['gender'] ?? '-'),
                                    if (user['age'] != null)
                                      _buildUserInfoRow('年龄', user['age'].toString()),
                                    _buildUserInfoRow(
                                      '设备ID',
                                      user['device_id'] ?? '-',
                                      isMonospace: true,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildUserInfoRow(String label, String value, {bool isMonospace = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          SizedBox(
            width: 60.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                fontFamily: isMonospace ? 'monospace' : null,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
