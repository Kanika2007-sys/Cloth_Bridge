class PickupSchedule {
  final String pickupId;
  final String donationId;
  final String ngoId;
  final String ngoName;
  final String donorName;
  final String donorPhone;
  final String pickupAddress;
  final double latitude;
  final double longitude;
  final String pickupDate;
  final String pickupTime;
  final String partnerType; // NGO Staff, Volunteer, Delivery Partner
  final String partnerName;
  final String partnerPhone;
  final String status; // Scheduled, In Transit, Collected, Cancelled

  PickupSchedule({
    required this.pickupId,
    required this.donationId,
    required this.ngoId,
    required this.ngoName,
    required this.donorName,
    required this.donorPhone,
    required this.pickupAddress,
    required this.latitude,
    required this.longitude,
    required this.pickupDate,
    required this.pickupTime,
    required this.partnerType,
    required this.partnerName,
    required this.partnerPhone,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'pickupId': pickupId,
      'donationId': donationId,
      'ngoId': ngoId,
      'ngoName': ngoName,
      'donorName': donorName,
      'donorPhone': donorPhone,
      'pickupAddress': pickupAddress,
      'latitude': latitude,
      'longitude': longitude,
      'pickupDate': pickupDate,
      'pickupTime': pickupTime,
      'partnerType': partnerType,
      'partnerName': partnerName,
      'partnerPhone': partnerPhone,
      'status': status,
    };
  }

  factory PickupSchedule.fromMap(Map<String, dynamic> map, String id) {
    return PickupSchedule(
      pickupId: id,
      donationId: map['donationId'] ?? '',
      ngoId: map['ngoId'] ?? '',
      ngoName: map['ngoName'] ?? '',
      donorName: map['donorName'] ?? '',
      donorPhone: map['donorPhone'] ?? '',
      pickupAddress: map['pickupAddress'] ?? '',
      latitude: (map['latitude'] ?? 12.9716).toDouble(),
      longitude: (map['longitude'] ?? 77.5946).toDouble(),
      pickupDate: map['pickupDate'] ?? '',
      pickupTime: map['pickupTime'] ?? '',
      partnerType: map['partnerType'] ?? 'NGO Staff',
      partnerName: map['partnerName'] ?? 'Ramesh (Volunteer)',
      partnerPhone: map['partnerPhone'] ?? '+91 9876543210',
      status: map['status'] ?? 'Scheduled',
    );
  }
}
