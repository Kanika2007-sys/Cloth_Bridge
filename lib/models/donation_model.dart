class AIPredictionResult {
  final String category; // Good, Minor Stain, Repair Required, Severely Damaged
  final double confidence; // e.g. 0.94
  final String destination; // NGO / Orphanage, Tailoring Unit, Upcycling Unit
  final String action; // Action summary
  final String explanation; // Detailed explanation

  AIPredictionResult({
    required this.category,
    required this.confidence,
    required this.destination,
    required this.action,
    required this.explanation,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'confidence': confidence,
      'destination': destination,
      'action': action,
      'explanation': explanation,
    };
  }

  factory AIPredictionResult.fromMap(Map<String, dynamic> map) {
    return AIPredictionResult(
      category: map['category'] ?? 'Good / Donation Ready',
      confidence: (map['confidence'] ?? 0.9).toDouble(),
      destination: map['destination'] ?? 'NGO / Orphanage',
      action: map['action'] ?? 'Suitable for donation after cleaning',
      explanation: map['explanation'] ?? 'Clean clothes with no severe damage.',
    );
  }
}

class DonationItem {
  final String donationId;
  final String donorId;
  final String donorName;
  final String category;
  final String condition;
  final String size;
  final int quantity;
  final String description;
  final List<String> imageUrls;
  final String pickupAddress;
  final double latitude;
  final double longitude;
  final String pickupDate;
  final String pickupTime;
  final AIPredictionResult? aiPrediction;
  final String recommendedDestination;
  final String? ngoId;
  final String? ngoName;
  final String? tailoringUnitId;
  final String? tailoringUnitName;
  final String status; // Pending, AI Classified, NGO Assigned, Pickup Scheduled, Collected, Delivered, Completed
  final DateTime createdAt;
  final DateTime updatedAt;

  DonationItem({
    required this.donationId,
    required this.donorId,
    required this.donorName,
    required this.category,
    required this.condition,
    required this.size,
    required this.quantity,
    required this.description,
    required this.imageUrls,
    required this.pickupAddress,
    required this.latitude,
    required this.longitude,
    required this.pickupDate,
    required this.pickupTime,
    this.aiPrediction,
    required this.recommendedDestination,
    this.ngoId,
    this.ngoName,
    this.tailoringUnitId,
    this.tailoringUnitName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'donationId': donationId,
      'donorId': donorId,
      'donorName': donorName,
      'category': category,
      'condition': condition,
      'size': size,
      'quantity': quantity,
      'description': description,
      'imageUrls': imageUrls,
      'pickupAddress': pickupAddress,
      'latitude': latitude,
      'longitude': longitude,
      'pickupDate': pickupDate,
      'pickupTime': pickupTime,
      'aiPrediction': aiPrediction?.toMap(),
      'recommendedDestination': recommendedDestination,
      'ngoId': ngoId,
      'ngoName': ngoName,
      'tailoringUnitId': tailoringUnitId,
      'tailoringUnitName': tailoringUnitName,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DonationItem.fromMap(Map<String, dynamic> map, String id) {
    return DonationItem(
      donationId: id,
      donorId: map['donorId'] ?? '',
      donorName: map['donorName'] ?? '',
      category: map['category'] ?? 'Clothing',
      condition: map['condition'] ?? 'Good',
      size: map['size'] ?? 'M',
      quantity: map['quantity'] ?? 1,
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      pickupAddress: map['pickupAddress'] ?? '',
      latitude: (map['latitude'] ?? 12.9716).toDouble(),
      longitude: (map['longitude'] ?? 77.5946).toDouble(),
      pickupDate: map['pickupDate'] ?? '',
      pickupTime: map['pickupTime'] ?? '',
      aiPrediction: map['aiPrediction'] != null
          ? AIPredictionResult.fromMap(map['aiPrediction'])
          : null,
      recommendedDestination: map['recommendedDestination'] ?? 'NGO / Orphanage',
      ngoId: map['ngoId'],
      ngoName: map['ngoName'],
      tailoringUnitId: map['tailoringUnitId'],
      tailoringUnitName: map['tailoringUnitName'],
      status: map['status'] ?? 'Pending',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }
}
