import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '设置',
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
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.notifications, color: AppColors.primary),
            title: Text('通知设置'),
            trailing: Icon(Icons.arrow_forward, color: AppColors.divider),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.lock, color: AppColors.primary),
            title: Text('修改密码'),
            trailing: Icon(Icons.arrow_forward, color: AppColors.divider),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info, color: AppColors.primary),
            title: Text('关于应用'),
            trailing: Icon(Icons.arrow_forward, color: AppColors.divider),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
