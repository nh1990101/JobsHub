class Job {
  final String id;
  final String title;
  final String description;
  final String requirements;
  final String companyName;
  final String companyLogo;
  final String location;
  final String salary;
  final String ageRange;
  final String genderRequirement;
  final int weight;
  final String countryId;
  final String? whatsappPhone;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.requirements,
    required this.companyName,
    required this.companyLogo,
    required this.location,
    required this.salary,
    required this.ageRange,
    required this.genderRequirement,
    required this.weight,
    required this.countryId,
    this.whatsappPhone,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      requirements: json['requirements'] as String,
      companyName: json['companyName'] as String,
      companyLogo: json['companyLogo'] as String,
      location: json['location'] as String,
      salary: json['salary'] as String,
      ageRange: json['ageRange'] as String,
      genderRequirement: json['genderRequirement'] as String,
      weight: json['weight'] as int,
      countryId: json['countryId'] as String,
      whatsappPhone: json['whatsappPhone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'requirements': requirements,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'location': location,
      'salary': salary,
      'ageRange': ageRange,
      'genderRequirement': genderRequirement,
      'weight': weight,
      'countryId': countryId,
      'whatsappPhone': whatsappPhone,
    };
  }
}
