abstract class AppStringsBase {
  String get appName;
  String get applyNow;
  String get myResume;
  String get privacy;
  String get language;
  String get logout;
  String get hello;
  String get congratulations;
  String get applyMessage;
  String get contactMessage;
  String get jobRequirements;
  String get location;
  String get ageRange;
  String get gender;
  String get salary;
  String get back;
  String get noJobs;
  String get name;
  String get email;
  String get phone;
  String get birthday;
  String get income;
  String get pleaseEnterName;
  String get pleaseEnterEmail;
  String get pleaseEnterPhone;
  String get pleaseSelectBirthday;
  String get pleaseEnterIncome;
  String get resumeSaved;
  String get saveFailed;
  String get userManagement;
  String get male;
  String get female;
  String get genderAll;
  String get privacyContent;

  // 性别翻译辅助方法
  String getGenderText(String? gender) {
    switch (gender?.toLowerCase()) {
      case 'male':
        return male;
      case 'female':
        return female;
      case 'all':
        return genderAll;
      default:
        return genderAll;
    }
  }
}

class AppStringsZH extends AppStringsBase {
  String get appName => 'JobHub';
  String get applyNow => '立即申请';
  String get myResume => '我的简历';
  String get privacy => '隐私政策';
  String get language => '语言';
  String get logout => '登出';
  String get hello => '你好，我需要做什么？';
  String get congratulations => '恭喜！';
  String get applyMessage => '请点击下方申请\n联系您的经理\n主动向其问好\n立即获得这个机会';
  String get contactMessage => '点击下方链接。现在问好并\n联系招聘经理！';
  String get jobRequirements => '职位要求';
  String get location => '工作地点';
  String get ageRange => '年龄范围';
  String get gender => '性别';
  String get salary => '薪资';
  String get back => '返回';
  String get noJobs => '暂无职位';
  String get name => '姓名';
  String get email => '邮箱';
  String get phone => '电话';
  String get birthday => '生日';
  String get income => '收入';
  String get pleaseEnterName => '请输入您的姓名';
  String get pleaseEnterEmail => '请输入您的邮箱';
  String get pleaseEnterPhone => '请输入您的电话';
  String get pleaseSelectBirthday => '请选择出生日期';
  String get pleaseEnterIncome => '请输入您的月收入';
  String get resumeSaved => '简历已保存';
  String get saveFailed => '保存失败';
  String get userManagement => '用户管理';
  String get male => '男性';
  String get female => '女性';
  String get genderAll => '不限';
  String get privacyContent => '隐私政策\n\n我们重视您的隐私。本隐私政策说明我们如何收集、使用和保护您的个人信息。\n\n1. 信息收集\n我们收集您在使用本应用时主动提供的信息，包括姓名、邮箱、电话等。\n\n2. 信息使用\n我们使用您的信息来改进服务、发送更新和提供客户支持。\n\n3. 信息保护\n我们采取适当的安全措施保护您的个人信息。\n\n4. 联系我们\n如有任何隐私问题，请联系我们。';
}

class AppStringsEN extends AppStringsBase {
  String get appName => 'JobHub';
  String get applyNow => 'Apply Now';
  String get myResume => 'My Resume';
  String get privacy => 'Privacy';
  String get language => 'Language';
  String get logout => 'Logout';
  String get hello => 'Hello, what do I need to do?';
  String get congratulations => 'Congratulations!';
  String get applyMessage => 'Please click on Apply below\nto contact your manager and\nproactively send your greetings\nto get this opportunity\nimmediately.';
  String get contactMessage => 'Click on the link below. Greet and\ncontact hiring manager now!';
  String get jobRequirements => 'Job Requirements';
  String get location => 'Location';
  String get ageRange => 'Age Range';
  String get gender => 'Gender';
  String get salary => 'Salary';
  String get back => 'Back';
  String get noJobs => 'No jobs available';
  String get name => 'Name';
  String get email => 'Email';
  String get phone => 'Phone';
  String get birthday => 'Birthday';
  String get income => 'Income';
  String get pleaseEnterName => 'Please enter your name';
  String get pleaseEnterEmail => 'Please enter your email';
  String get pleaseEnterPhone => 'Please enter your phone';
  String get pleaseSelectBirthday => 'Please select date of birth';
  String get pleaseEnterIncome => 'Please enter your monthly income';
  String get resumeSaved => 'Resume saved successfully';
  String get saveFailed => 'Save failed';
  String get userManagement => 'User Management';
  String get male => 'Male';
  String get female => 'Female';
  String get genderAll => 'All';
  String get privacyContent => 'Privacy Policy\n\nWe value your privacy. This privacy policy explains how we collect, use, and protect your personal information.\n\n1. Information Collection\nWe collect information you voluntarily provide when using this application, including name, email, phone, etc.\n\n2. Information Usage\nWe use your information to improve our services, send updates, and provide customer support.\n\n3. Information Protection\nWe take appropriate security measures to protect your personal information.\n\n4. Contact Us\nIf you have any privacy questions, please contact us.';
}

class AppStringsJA extends AppStringsBase {
  String get appName => 'JobHub';
  String get applyNow => '今すぐ申請';
  String get myResume => '私の履歴書';
  String get privacy => 'プライバシー';
  String get language => '言語';
  String get logout => 'ログアウト';
  String get hello => 'こんにちは、何をする必要がありますか？';
  String get congratulations => 'おめでとうございます！';
  String get applyMessage => '下のボタンをクリックして\nマネージャーに連絡し\n積極的にあいさつして\nこの機会を\n今すぐ手に入れてください';
  String get contactMessage => '下のリンクをクリックしてください。挨拶して\n採用担当者に今すぐ連絡してください！';
  String get jobRequirements => '職務経歴書';
  String get location => '勤務地';
  String get ageRange => '年齢範囲';
  String get gender => '性別';
  String get salary => '給与';
  String get back => '戻る';
  String get noJobs => '利用可能なジョブはありません';
  String get name => '名前';
  String get email => 'メール';
  String get phone => '電話';
  String get birthday => '誕生日';
  String get income => '収入';
  String get pleaseEnterName => 'お名前を入力してください';
  String get pleaseEnterEmail => 'メールアドレスを入力してください';
  String get pleaseEnterPhone => '電話番号を入力してください';
  String get pleaseSelectBirthday => '生年月日を選択してください';
  String get pleaseEnterIncome => '月収を入力してください';
  String get resumeSaved => '履歴書が保存されました';
  String get saveFailed => '保存に失敗しました';
  String get userManagement => 'ユーザー管理';
  String get male => '男性';
  String get female => '女性';
  String get genderAll => '不問';
  String get privacyContent => 'プライバシーポリシー\n\nお客様のプライバシーを大切にしています。本プライバシーポリシーは、個人情報の収集、使用、保護方法について説明しています。\n\n1. 情報の収集\nこのアプリケーションを使用する際に自発的に提供する情報を収集します。名前、メール、電話番号など。\n\n2. 情報の使用\nお客様の情報を使用して、サービスを改善し、更新を送信し、カスタマーサポートを提供します。\n\n3. 情報の保護\nお客様の個人情報を保護するために、適切なセキュリティ対策を講じています。\n\n4. お問い合わせ\nプライバシーに関するご質問がある場合は、お気軽にお問い合わせください。';
}

class AppStrings {
  static const String appName = 'JobHub';
  static const String applyNow = 'Apply Now';
  static const String myResume = 'My Resume';
  static const String privacy = 'Privacy';
  static const String language = 'Language';
  static const String logout = 'Logout';
  static const String hello = 'Hello, what do I need to do?';
  static const String congratulations = 'Congratulations!';
  static const String applyMessage = 'Please click on Apply below\nto contact your manager and\nproactively send your greetings\nto get this opportunity\nimmediately.';
  static const String contactMessage = 'Click on the link below. Greet and\ncontact hiring manager now!';
  static const String jobRequirements = 'Job Requirements';
  static const String location = 'Location';
  static const String ageRange = 'Age Range';
  static const String gender = 'Gender';
  static const String salary = 'Salary';
  static const String back = 'Back';
  static const String noJobs = 'No jobs available';
  static const String name = 'Name';
  static const String email = 'Email';
  static const String phone = 'Phone';
  static const String birthday = 'Birthday';
  static const String income = 'Income';
  static const String pleaseEnterName = 'Please enter your name';
  static const String pleaseEnterEmail = 'Please enter your email';
  static const String pleaseEnterPhone = 'Please enter your phone';
  static const String pleaseSelectBirthday = 'Please select date of birth';
  static const String pleaseEnterIncome = 'Please enter your monthly income';
  static const String resumeSaved = 'Resume saved successfully';
  static const String saveFailed = 'Save failed';
  static const String userManagement = 'User Management';
  static const String male = 'Male';
  static const String female = 'Female';
  static const String privacyContent = 'Privacy Policy\n\nWe value your privacy. This privacy policy explains how we collect, use, and protect your personal information.\n\n1. Information Collection\nWe collect information you voluntarily provide when using this application, including name, email, phone, etc.\n\n2. Information Usage\nWe use your information to improve our services, send updates, and provide customer support.\n\n3. Information Protection\nWe take appropriate security measures to protect your personal information.\n\n4. Contact Us\nIf you have any privacy questions, please contact us.';
}
