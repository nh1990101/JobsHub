import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../config/app_colors.dart';
import '../providers/language_provider.dart';
import '../models/job.dart';

class JobDetailScreen extends ConsumerWidget {
  final Job job;

  const JobDetailScreen({
    Key? key,
    required this.job,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 职位标题
                  Text(
                    job.title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // 公司和薪资
                  Text(
                    '${job.companyName} · ${job.salary}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Divider(color: AppColors.divider),
                  SizedBox(height: 12.h),

                  // 职位要求
                  Text(
                    strings.jobRequirements,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    job.requirements,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Divider(color: AppColors.divider),
                  SizedBox(height: 12.h),

                  // 其他详情
                  _buildDetailRow(strings.location, job.location),
                  SizedBox(height: 12.h),
                  _buildDetailRow(strings.ageRange, job.ageRange),
                  SizedBox(height: 12.h),
                  _buildDetailRow(strings.gender, job.genderRequirement),
                ],
              ),
            ),
          ),
          // Apply 按钮
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => context.push('/chat', extra: job),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  strings.applyNow,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
