class TailoringOrder {
  final String orderId;
  final String donationId;
  final String clothingCategory;
  final String clothingImage;
  final String problem;
  final String workType; // Repair, Stitching, Upcycling Bag, Upcycling Mat
  final String deadline;
  final String assignedBy;
  final String tailoringUnitId;
  final String tailoringUnitName;
  final String status; // Assigned, Accepted, In Progress, Completed, Returned to NGO
  final int progress; // 0 - 100
  final String? resultImageUrl;

  TailoringOrder({
    required this.orderId,
    required this.donationId,
    required this.clothingCategory,
    required this.clothingImage,
    required this.problem,
    required this.workType,
    required this.deadline,
    required this.assignedBy,
    required this.tailoringUnitId,
    required this.tailoringUnitName,
    required this.status,
    required this.progress,
    this.resultImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'donationId': donationId,
      'clothingCategory': clothingCategory,
      'clothingImage': clothingImage,
      'problem': problem,
      'workType': workType,
      'deadline': deadline,
      'assignedBy': assignedBy,
      'tailoringUnitId': tailoringUnitId,
      'tailoringUnitName': tailoringUnitName,
      'status': status,
      'progress': progress,
      'resultImageUrl': resultImageUrl,
    };
  }

  factory TailoringOrder.fromMap(Map<String, dynamic> map, String id) {
    return TailoringOrder(
      orderId: id,
      donationId: map['donationId'] ?? '',
      clothingCategory: map['clothingCategory'] ?? 'Clothing',
      clothingImage: map['clothingImage'] ?? '',
      problem: map['problem'] ?? 'Minor damage',
      workType: map['workType'] ?? 'Repair',
      deadline: map['deadline'] ?? '3 Days',
      assignedBy: map['assignedBy'] ?? 'System Admin',
      tailoringUnitId: map['tailoringUnitId'] ?? '',
      tailoringUnitName: map['tailoringUnitName'] ?? 'StitchCraft Unit',
      status: map['status'] ?? 'Assigned',
      progress: map['progress'] ?? 0,
      resultImageUrl: map['resultImageUrl'],
    );
  }
}
