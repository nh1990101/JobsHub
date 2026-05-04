import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../config/app_colors.dart';
import '../providers/job_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/job_card.dart';
import 'resume_screen.dart';
import 'privacy_screen.dart';
import 'language_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobsProvider);
    final strings = ref.watch(appStringsProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          strings.appName,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.textPrimary, size: 24.sp),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: _buildDrawer(context, strings),
      body: jobsAsync.when(
        data: (jobs) => jobs.isEmpty
            ? Center(
                child: Text(
                  strings.noJobs,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(12.w),
                itemCount: jobs.length,
                itemBuilder: (context, index) => JobCard(
                  job: jobs[index],
                  onTap: () => context.push('/job-detail', extra: jobs[index]),
                ),
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, dynamic strings) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                strings.appName,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.description, color: AppColors.primary),
            title: Text(strings.myResume),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResumeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: AppColors.primary),
            title: Text(strings.privacy),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.language, color: AppColors.primary),
            title: Text(strings.language),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguageScreen()),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text(
                  'V1.0',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Copyright © 2025 JobHub',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.divider,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
