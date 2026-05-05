/// API 配置文件
/// 集中管理所有 API 相关的配置
class ApiConfig {
  // ============ 环境配置 ============

  /// 当前环境：development（开发）、production（生产）、auto（自动检测）
  static const String environment = 'auto';

  /// 开发环境 API 地址（本地开发时使用）
  static const String developmentBaseUrl = 'http://localhost:3000/api';

  /// 生产环境 API 地址（使用相对路径，前后端同源）
  static const String productionBaseUrl = '/api';

  /// 根据环境自动选择 API 地址
  static String get baseUrl {
    if (environment == 'auto') {
      // 自动检测：如果是通过 localhost 访问，使用开发环境
      // 否则使用相对路径（生产环境，前后端同源）
      try {
        // 在 Web 环境下检测当前 URL
        if (Uri.base.host == 'localhost' || Uri.base.host == '127.0.0.1') {
          return developmentBaseUrl;
        }
      } catch (e) {
        // 非 Web 环境或检测失败，使用生产环境
      }
      return productionBaseUrl;
    }
    return environment == 'production' ? productionBaseUrl : developmentBaseUrl;
  }

  // ============ 超时配置 ============

  /// 连接超时时间（秒）
  static const int connectTimeout = 10;

  /// 接收超时时间（秒）
  static const int receiveTimeout = 10;

  // ============ API 路由 ============

  // 认证相关
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authProfile = '/auth/profile';
  static const String authRegisterAdmin = '/auth/register-admin';

  // 职位相关
  static const String jobs = '/jobs';
  static String jobDetail(String id) => '/jobs/$id';

  // 国家相关
  static const String countries = '/countries';
  static String countryDetail(String id) => '/countries/$id';

  // 应用用户相关
  static const String appUsersRegister = '/app-users/register';
  static const String appUsersList = '/app-users-list';
  static String appUserByDeviceId(String deviceId) => '/app-users/$deviceId';

  // 地理位置相关
  static const String geoCountryByIp = '/geo/country-by-ip';

  // 健康检查
  static const String health = '/health';

  // ============ 辅助方法 ============

  /// 获取完整的 API URL
  static String getFullUrl(String path) {
    return '$baseUrl$path';
  }

  /// 切换到开发环境
  static void useDevelopment() {
    // 注意：这只是示例，实际使用时需要重启应用
    // environment = 'development';
    print('⚠️ 切换环境需要修改 environment 常量并重启应用');
  }

  /// 切换到生产环境
  static void useProduction() {
    // 注意：这只是示例，实际使用时需要重启应用
    // environment = 'production';
    print('⚠️ 切换环境需要修改 environment 常量并重启应用');
  }

  /// 打印当前配置
  static void printConfig() {
    print('╔════════════════════════════════════════╗');
    print('║          API 配置信息                    ║');
    print('╚════════════════════════════════════════╝');
    print('🌍 当前环境: $environment');
    print('🔗 API 地址: $baseUrl');
    print('⏱️  连接超时: ${connectTimeout}s');
    print('⏱️  接收超时: ${receiveTimeout}s');
    print('════════════════════════════════════════');
  }
}
