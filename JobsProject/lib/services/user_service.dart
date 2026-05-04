import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  late Dio _dio;
  final String baseUrl = 'http://127.0.0.1:3000/api';
  static const String _userIdKey = 'app_user_id';
  static const String _deviceIdKey = 'device_id';

  UserService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }

  // 获取设备 ID
  Future<String> getDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? deviceId = prefs.getString(_deviceIdKey);

      if (deviceId != null) {
        return deviceId;
      }

      // 生成新的设备 ID
      final deviceInfo = DeviceInfoPlugin();
      String newDeviceId = '';

      try {
        final androidInfo = await deviceInfo.androidInfo;
        newDeviceId = androidInfo.id;
      } catch (e) {
        try {
          final iosInfo = await deviceInfo.iosInfo;
          newDeviceId = iosInfo.identifierForVendor ?? 'unknown';
        } catch (e) {
          // Web 或其他平台
          newDeviceId = 'web_${DateTime.now().millisecondsSinceEpoch}';
        }
      }

      await prefs.setString(_deviceIdKey, newDeviceId);
      return newDeviceId;
    } catch (e) {
      print('获取设备 ID 失败: $e');
      return 'unknown_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  // 获取 IP 地址
  Future<String> getIpAddress() async {
    try {
      final response = await _dio.get('https://api.ipify.org?format=json');
      return response.data['ip'] ?? '';
    } catch (e) {
      print('获取 IP 地址失败: $e');
      return '';
    }
  }

  // 生成唯一用户 ID
  Future<String> generateUserId(String deviceId) async {
    return '${deviceId}_${DateTime.now().millisecondsSinceEpoch}';
  }

  // 上报用户信息
  Future<String> registerUser({
    required String deviceId,
    required String name,
    required String email,
    required String phone,
    required int age,
    required String gender,
    required int countryId,
    required String ipAddress,
  }) async {
    try {
      final response = await _dio.post(
        '/app-users/register',
        data: {
          'device_id': deviceId,
          'name': name,
          'email': email,
          'phone': phone,
          'age': age,
          'gender': gender,
          'country_id': countryId,
          'ip_address': ipAddress,
        },
      );

      if (response.statusCode == 201) {
        final userId = response.data['user_id'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userIdKey, userId);
        return userId;
      }

      throw Exception(response.data['error'] ?? '注册失败');
    } catch (e) {
      print('上报用户信息失败: $e');
      throw Exception('上报用户信息失败: $e');
    }
  }

  // 获取保存的用户 ID
  Future<String?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // 检查用户是否已注册
  Future<bool> isUserRegistered() async {
    final userId = await getSavedUserId();
    return userId != null;
  }
}
