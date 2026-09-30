class UpcycledProduct {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String tailoringUnitId;
  final String tailoringUnitName;
  final String associatedNgoId;
  final String associatedNgoName;
  final String originalDonationId;
  int stockQuantity;
  final double ngoSharePercentage;
  final double tailorSharePercentage;
  final DateTime createdAt;

  UpcycledProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.tailoringUnitId,
    required this.tailoringUnitName,
    required this.associatedNgoId,
    required this.associatedNgoName,
    required this.originalDonationId,
    required this.stockQuantity,
    this.ngoSharePercentage = 50.0,
    this.tailorSharePercentage = 50.0,
    required this.createdAt,
  });

  double get ngoAmountPerUnit => price * (ngoSharePercentage / 100.0);
  double get tailorAmountPerUnit => price * (tailorSharePercentage / 100.0);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'tailoringUnitId': tailoringUnitId,
        'tailoringUnitName': tailoringUnitName,
        'associatedNgoId': associatedNgoId,
        'associatedNgoName': associatedNgoName,
        'originalDonationId': originalDonationId,
        'stockQuantity': stockQuantity,
        'ngoSharePercentage': ngoSharePercentage,
        'tailorSharePercentage': tailorSharePercentage,
        'createdAt': createdAt.toIso8601String(),
      };
}

class UpcycledOrder {
  final String orderId;
  final String productId;
  final String productTitle;
  final String buyerId;
  final String buyerName;
  final double totalPrice;
  final double ngoEarnings;
  final double tailorEarnings;
  final String associatedNgoName;
  final String tailoringUnitName;
  final DateTime purchaseDate;
  final String shippingAddress;
  final String status;

  UpcycledOrder({
    required this.orderId,
    required this.productId,
    required this.productTitle,
    required this.buyerId,
    required this.buyerName,
    required this.totalPrice,
    required this.ngoEarnings,
    required this.tailorEarnings,
    required this.associatedNgoName,
    required this.tailoringUnitName,
    required this.purchaseDate,
    required this.shippingAddress,
    this.status = 'Paid & Confirmed',
  });
}
