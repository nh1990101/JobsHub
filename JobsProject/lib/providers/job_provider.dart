import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

// 用户所在国家 - 默认中国 (ID: 1)
final userCountryProvider = StateProvider<String>((ref) => '1');

// Mock 数据 - 备用
final _mockJobs = [
  Job(
    id: '2',
    title: '全栈工程师',
    description: '负责前后端开发，参与产品设计和优化。',
    requirements: '3年以上全栈开发经验，熟悉 Node.js 和 React。',
    companyName: 'StartupXYZ',
    companyLogo: 'XYZ',
    location: '上海',
    salary: '25k-40k',
    ageRange: '23-35',
    genderRequirement: 'all',
    weight: 80,
    countryId: '1',
    whatsappPhone: '+86 138 1234 5678',
  ),
  Job(
    id: '3',
    title: 'UI/UX 设计师',
    description: '设计移动应用和网页界面，提升用户体验。',
    requirements: '3年以上 UI/UX 设计经验，熟悉 Figma 和设计系统。',
    companyName: 'DesignStudio',
    companyLogo: 'DS',
    location: '深圳',
    salary: '20k-35k',
    ageRange: '22-38',
    genderRequirement: 'all',
    weight: 70,
    countryId: '1',
    whatsappPhone: '+86 138 9876 5432',
  ),
];

// 职位列表提供者 - 尝试从 API 获取，失败时使用 Mock 数据
final jobsProvider = FutureProvider<List<Job>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final userCountry = ref.watch(userCountryProvider);

  try {
    // 尝试从 API 获取职位列表
    final jobs = await apiService.getJobs(
      country: userCountry,
      gender: 'all',
      limit: 100,
    );

    // 如果 API 返回数据，使用 API 数据
    if (jobs.isNotEmpty) {
      return jobs;
    }
  } catch (e) {
    print('❌ API 请求失败: $e');
  }

  // API 失败或无数据时，使用 Mock 数据
  print('📦 使用 Mock 数据');
  return _mockJobs.where((job) => job.countryId == userCountry).toList();
});

// 国家列表提供者
final countriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return [
    {'id': '1', 'name': '中国', 'code': 'CN'},
    {'id': '2', 'name': '美国', 'code': 'US'},
    {'id': '3', 'name': '日本', 'code': 'JP'},
    {'id': '4', 'name': '新加坡', 'code': 'SG'},
    {'id': '5', 'name': '加拿大', 'code': 'CA'},
  ];
});
