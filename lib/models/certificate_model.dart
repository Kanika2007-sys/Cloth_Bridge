class DonationCertificate {
  final String certificateId;
  final String donorId;
  final String donorName;
  final int itemQuantity;
  final String donationId;
  final String date;
  final String impactBadge; // Helping Hand, Sustainability Hero, etc.

  DonationCertificate({
    required this.certificateId,
    required this.donorId,
    required this.donorName,
    required this.itemQuantity,
    required this.donationId,
    required this.date,
    required this.impactBadge,
  });

  Map<String, dynamic> toMap() {
    return {
      'certificateId': certificateId,
      'donorId': donorId,
      'donorName': donorName,
      'itemQuantity': itemQuantity,
      'donationId': donationId,
      'date': date,
      'impactBadge': impactBadge,
    };
  }

  factory DonationCertificate.fromMap(Map<String, dynamic> map, String id) {
    return DonationCertificate(
      certificateId: id,
      donorId: map['donorId'] ?? '',
      donorName: map['donorName'] ?? '',
      itemQuantity: map['itemQuantity'] ?? 1,
      donationId: map['donationId'] ?? '',
      date: map['date'] ?? '',
      impactBadge: map['impactBadge'] ?? 'Community Champion',
    );
  }
}
