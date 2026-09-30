class NotificationItem {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // status_update, pickup_scheduled, reward_earned, chat
  final DateTime timestamp;
  final bool isRead;
  final String? relatedDonationId;

  NotificationItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.relatedDonationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'relatedDonationId': relatedDonationId,
    };
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map, String id) {
    return NotificationItem(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'info',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
      relatedDonationId: map['relatedDonationId'],
    );
  }
}
