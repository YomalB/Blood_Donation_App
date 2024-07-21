class CampModel {
  String title;
  String location;
  String description;
  String date;
  String? email;

  CampModel({
    required this.title,
    required this.location,
    required this.description,
    required this.date,
    this.email,
  });

  factory CampModel.fromMap(Map<String, dynamic> map) {
    return CampModel(
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "location": location,
      "description": description,
      "date": date,
      "email": email,
    };
  }
}
