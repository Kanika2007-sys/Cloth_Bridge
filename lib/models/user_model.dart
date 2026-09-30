class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role; // donor, ngo, admin, tailor
  final String address;
  final double latitude;
  final double longitude;
  final String? orgName; // For NGO
  final String? regDetails; // For NGO
  final String? unitName; // For Tailoring Unit
  final int rewardPoints;
  final int totalDonations;
  final int peopleHelped;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.address,
    this.latitude = 12.9716,
    this.longitude = 77.5946,
    this.orgName,
    this.regDetails,
    this.unitName,
    this.rewardPoints = 0,
    this.totalDonations = 0,
    this.peopleHelped = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'orgName': orgName,
      'regDetails': regDetails,
      'unitName': unitName,
      'rewardPoints': rewardPoints,
      'totalDonations': totalDonations,
      'peopleHelped': peopleHelped,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  factory AppUser.fromMap(Map<String, dynamic> map, [String? id]) {
    return AppUser(
      uid: id ?? map['uid'] ?? 'usr-001',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'donor',
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 12.9716).toDouble(),
      longitude: (map['longitude'] ?? 77.5946).toDouble(),
      orgName: map['orgName'],
      regDetails: map['regDetails'],
      unitName: map['unitName'],
      rewardPoints: map['rewardPoints'] ?? 0,
      totalDonations: map['totalDonations'] ?? 0,
      peopleHelped: map['peopleHelped'] ?? 0,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser.fromMap(json, json['uid']);
}
