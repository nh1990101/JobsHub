import 'package:dio/dio.dart';
import '../models/job.dart';
import '../config/api_config.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    // 打印当前 API 配置
    ApiConfig.printConfig();

    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(seconds: ApiConfig.connectTimeout),
      receiveTimeout: Duration(seconds: ApiConfig.receiveTimeout),
      headers: {
        'ngrok-skip-browser-warning': '69420',  // 跳过 ngrok 警告页面
      },
      validateStatus: (status) {
        // 接受所有状态码
        return status != null && status < 500;
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          print('❌ API错误: ${error.message}');
          print('📍 错误类型: ${error.type}');
          print('🔗 请求URL: ${error.requestOptions.path}');

          // 如果是CORS错误，尝试重新请求
          final message = error.message ?? '';
          if (message.contains('CORS') || message.contains('XMLHttpRequest')) {
            print('💡 检测到CORS错误，尝试替代方案...');
          }

          return handler.next(error);
        },
      ),
    );
  }

  // 获取职位列表
  Future<List<Job>> getJobs({
    String? country,
    String? gender,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final params = <String, dynamic>{
        'limit': limit,
        'offset': offset,
      };

      if (country != null && country.isNotEmpty) {
        params['country'] = country;
      }

      if (gender != null && gender.isNotEmpty && gender != 'all') {
        params['gender'] = gender;
      }

      print('📡 API请求: GET /jobs 参数: $params');

      // 尝试直接请求
      final response = await _dio.get(
        ApiConfig.jobs,
        queryParameters: params,
      );

      print('✅ API响应状态码: ${response.statusCode}');
      print('📦 API响应数据: ${response.data}');

      // 处理响应数据结构
      List<dynamic> jobsList;
      if (response.data is Map && response.data.containsKey('data')) {
        // 新的响应格式：{ data: [...], pagination: {...} }
        jobsList = response.data['data'] as List<dynamic>;
      } else if (response.data is List) {
        // 旧的响应格式：直接返回数组
        jobsList = response.data as List<dynamic>;
      } else {
        print('❌ 未知的响应格式');
        return [];
      }

      // 将响应转换为 Job 对象列表，并按权重排序
      List<Job> jobs = jobsList
          .map((job) => Job(
                id: job['id'].toString(),
                title: job['title'] ?? '',
                description: job['description'] ?? '',
                requirements: job['requirements'] ?? '',
                companyName: job['company_name'] ?? '',
                companyLogo: job['company_logo'] ?? '🏢',
                location: job['location'] ?? '',
                salary: job['salary'] ?? '',
                ageRange: job['age_range'] ?? '',
                genderRequirement: job['gender_requirement'] ?? 'all',
                weight: job['weight'] ?? 0,
                countryId: job['country_id'].toString(),
                whatsappPhone: job['whatsapp_phone'] as String?,
              ))
          .toList();

      // 按权重排序（从高到低）
      jobs.sort((a, b) => b.weight.compareTo(a.weight));

      print('✅ 获取职位数: ${jobs.length}');
      return jobs;
    } catch (e) {
      print('❌ 获取职位列表失败: $e');
      print('💡 提示: 确保后端服务运行在 http://localhost:3000');
      // 如果连接失败，返回空列表
      return [];
    }
  }

  // 用户登录
  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConfig.authLogin,
        data: {'email': email, 'password': password},
      );
      return response.data['token'];
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // 用户注册
  Future<String> register(String email, String password, int age, String gender) async {
    try {
      final response = await _dio.post(
        ApiConfig.authRegister,
        data: {
          'email': email,
          'password': password,
          'age': age,
          'gender': gender,
        },
      );
      return response.data['token'];
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // 保存/更新用户信息
  Future<void> saveUserData(String deviceId, {
    required String name,
    required String email,
    required String phone,
    required String gender,
    String? age,
    String? birthday,
    String? income,
    int? countryId,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.appUsersRegister,
        data: {
          'device_id': deviceId,
          'name': name,
          'email': email,
          'phone': phone,
          'gender': gender,
          'age': age,
          'country_id': countryId ?? 1,
        },
      );
      print('✅ 用户信息已保存: ${response.data}');
    } catch (e) {
      print('❌ 保存用户信息失败: $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  // 根据IP获取国家信息
  Future<Map<String, dynamic>> getCountryByIp(String ip) async {
    try {
      final response = await _dio.get(
        ApiConfig.geoCountryByIp,
        queryParameters: {'ip': ip},
      );
      print('✅ 获取国家信息: ${response.data}');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('❌ 获取国家信息失败: $e');
      return {'country_id': 1, 'country_name': '中国'};
    }
  }

  // 根据设备ID获取用户信息
  Future<Map<String, dynamic>?> getUserByDeviceId(String deviceId) async {
    try {
      final response = await _dio.get(ApiConfig.appUserByDeviceId(deviceId));
      if (response.statusCode == 200 && response.data != null) {
        print('✅ 获取用户信息: ${response.data}');
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('❌ 获取用户信息失败: $e');
      return null;
    }
  }

  // 获取国家列表
  Future<List<Map<String, dynamic>>> getCountries() async {
    try {
      final response = await _dio.get(ApiConfig.countries);
      print('✅ 获取国家列表: ${response.data}');
      return List<Map<String, dynamic>>.from(response.data as List);
    } catch (e) {
      print('❌ 获取国家列表失败: $e');
      return [];
    }
  }

  // 获取应用用户列表
  Future<List<Map<String, dynamic>>> getAppUsers() async {
    try {
      final response = await _dio.get(ApiConfig.appUsersList);
      print('✅ 获取应用用户列表: ${response.data}');
      return List<Map<String, dynamic>>.from(response.data as List);
    } catch (e) {
      print('❌ 获取应用用户列表失败: $e，使用本地模拟数据');
      // 返回本地模拟数据
      return [
        {
          'id': 'user_1',
          'device_id': 'device_001',
          'name': '张三',
          'email': 'zhangsan@example.com',
          'phone': '13800138000',
          'gender': 'Male',
          'age': 28,
          'country_id': 1,
          'created_at': '2026-05-03T10:00:00Z',
        },
        {
          'id': 'user_2',
          'device_id': 'device_002',
          'name': '李四',
          'email': 'lisi@example.com',
          'phone': '13900139000',
          'gender': 'Female',
          'age': 26,
          'country_id': 1,
          'created_at': '2026-05-03T11:00:00Z',
        },
        {
          'id': 'user_3',
          'device_id': 'device_003',
          'name': 'John Smith',
          'email': 'john@example.com',
          'phone': '+1-555-0123',
          'gender': 'Male',
          'age': 32,
          'country_id': 2,
          'created_at': '2026-05-03T12:00:00Z',
        },
      ];
    }
  }

  String? _getToken() {
    // TODO: 从 SharedPreferences 获取
    return null;
  }
}
