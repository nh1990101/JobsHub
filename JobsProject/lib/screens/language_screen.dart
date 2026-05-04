import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/app_colors.dart';
import '../providers/language_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedLanguage == 'zh'
              ? '语言设置'
              : selectedLanguage == 'en'
                  ? 'Language Settings'
                  : '言語設定',
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
          RadioListTile<String>(
            title: Text('中文'),
            value: 'zh',
            groupValue: selectedLanguage,
            onChanged: (value) {
              ref.read(languageProvider.notifier).state = value ?? 'zh';
            },
          ),
          RadioListTile<String>(
            title: Text('English'),
            value: 'en',
            groupValue: selectedLanguage,
            onChanged: (value) {
              ref.read(languageProvider.notifier).state = value ?? 'en';
            },
          ),
          RadioListTile<String>(
            title: Text('日本語'),
            value: 'ja',
            groupValue: selectedLanguage,
            onChanged: (value) {
              ref.read(languageProvider.notifier).state = value ?? 'ja';
            },
          ),
        ],
      ),
    );
  }
}
