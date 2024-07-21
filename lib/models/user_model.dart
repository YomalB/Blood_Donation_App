class UserModel {
  String firstName;
  String lastName;
  String contactNumber;
  String gender;
  String userType;
  String bloodType;
  String profileImage;
   String uid;
  String email;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.gender,
    required this.userType,
    required this.bloodType,
    required this.profileImage,
    required this.uid,
    required this.email,
    
  });

    // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      gender: map['gender'] ?? '',
      userType: map['userType'] ?? '',
      bloodType: map['bloodType'] ?? '',
      profileImage: map['profileImage'] ?? '',
       uid: map['uid'] ?? '',
      email: map['email'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "contactNumber": contactNumber,
      "gender": gender,
      "userType": userType,
      "bloodType": bloodType,
      "profileImage": profileImage,
      "uid": uid,
      "email": email,
    };
  }
}

