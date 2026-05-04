import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_strings_localized.dart';

final languageProvider = StateProvider<String>((ref) => 'zh');

final appStringsProvider = Provider<AppStringsBase>((ref) {
  final language = ref.watch(languageProvider);
  switch (language) {
    case 'en':
      return AppStringsEN();
    case 'ja':
      return AppStringsJA();
    default:
      return AppStringsZH();
  }
});
