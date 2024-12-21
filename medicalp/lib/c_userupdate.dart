class UserProfile {
  final String username;
  String name;
  String phoneNumber;
  String relationship;
  String patientName;
  String diagnosis;
  String? caretakerImage;

  UserProfile({
    required this.username,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    required this.patientName,
    required this.diagnosis,
    this.caretakerImage,
  });
}
