import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/donation_model.dart';
import '../models/notification_model.dart';
import '../models/tailoring_order_model.dart';
import '../models/certificate_model.dart';
import '../models/message_model.dart';
import '../models/upcycled_product_model.dart';
import '../services/ml_service.dart';
import '../services/tflite_ml_service.dart';
import '../services/route_service.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../utils/sample_data.dart';

class AppState extends ChangeNotifier {
  final MLService _mlService = TFLiteMLService();
  final AuthService _authService = AuthService();

  // Active Role & User
  String _currentRole = UserRoles.donor;
  AppUser _currentUser = SampleData.donorUser;

  // Data lists
  final List<DonationItem> _donations = List.from(SampleData.sampleDonations);
  final List<NotificationItem> _notifications = List.from(SampleData.sampleNotifications);
  final List<TailoringOrder> _tailoringOrders = List.from(SampleData.sampleTailoringOrders);
  final List<ChatMessage> _messages = List.from(SampleData.sampleMessages);
  final List<UpcycledProduct> _upcycledProducts = List.from(SampleData.sampleUpcycledProducts);
  final List<UpcycledOrder> _upcycledOrders = List.from(SampleData.sampleUpcycledOrders);
  List<RouteCluster> _routeClusters = [];

  bool _isProcessingML = false;

  // Getters
  String get currentRole => _currentRole;
  AppUser get currentUser => _currentUser;
  List<DonationItem> get donations => _donations;
  List<NotificationItem> get notifications => _notifications;
  List<TailoringOrder> get tailoringOrders => _tailoringOrders;
  List<ChatMessage> get messages => _messages;
  List<UpcycledProduct> get upcycledProducts => _upcycledProducts;
  List<UpcycledOrder> get upcycledOrders => _upcycledOrders;
  List<RouteCluster> get routeClusters => _routeClusters;
  bool get isProcessingML => _isProcessingML;

  double get totalUpcycledSalesRevenue =>
      _upcycledOrders.fold(0.0, (sum, o) => sum + o.totalPrice);
  double get totalNgoUpcycledEarnings =>
      _upcycledOrders.fold(0.0, (sum, o) => sum + o.ngoEarnings);
  double get totalTailorUpcycledEarnings =>
      _upcycledOrders.fold(0.0, (sum, o) => sum + o.tailorEarnings);

  AppState() {
    _refreshRouteClusters();
  }

  // Live Firebase Auth Integration with Seamless Local Fallback
  Future<AppUser> loginWithFirebase({
    required String email,
    required String password,
    String preferredRole = UserRoles.donor,
  }) async {
    try {
      final user = await _authService.signIn(
        email: email,
        password: password,
        preferredRole: preferredRole,
      );
      _currentUser = user;
      _currentRole = user.role;
      notifyListeners();
      return user;
    } catch (e) {
      setRole(preferredRole);
      return _currentUser;
    }
  }

  Future<AppUser> registerWithFirebase({
    required String email,
    required String password,
    required String name,
    required String role,
    required String phone,
    required String address,
    String? orgName,
    String? regDetails,
    String? unitName,
  }) async {
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
        phone: phone,
        address: address,
        orgName: orgName,
        regDetails: regDetails,
        unitName: unitName,
      );
      _currentUser = user;
      _currentRole = user.role;
      notifyListeners();
      return user;
    } catch (e) {
      _currentUser = AppUser(
        uid: 'user-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
        role: role,
        address: address,
        orgName: orgName,
        regDetails: regDetails,
        unitName: unitName,
      );
      _currentRole = role;
      notifyListeners();
      return _currentUser;
    }
  }

  Future<void> signOutFirebase() async {
    await _authService.signOut();
    _currentRole = UserRoles.donor;
    _currentUser = SampleData.donorUser;
    notifyListeners();
  }

  // Role Switcher
  void setRole(String role) {
    _currentRole = role;
    switch (role) {
      case UserRoles.donor:
        _currentUser = SampleData.donorUser;
        break;
      case UserRoles.ngo:
        _currentUser = SampleData.ngoUser;
        break;
      case UserRoles.admin:
        _currentUser = SampleData.adminUser;
        break;
      case UserRoles.tailor:
        _currentUser = SampleData.tailorUser;
        break;
    }
    notifyListeners();
  }

  // Update user profile
  void updateUser(AppUser updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  // ML Prediction Call
  Future<AIPredictionResult> classifyClothingImage(String imagePath, {String? categoryHint}) async {
    _isProcessingML = true;
    notifyListeners();

    final result = await _mlService.predictClothingCondition(imagePath, categoryHint: categoryHint);

    _isProcessingML = false;
    notifyListeners();

    return result;
  }

  // Submit New Donation
  Future<void> submitDonation({
    required String category,
    required String condition,
    required String size,
    required int quantity,
    required String description,
    required List<String> imageUrls,
    required String pickupAddress,
    required double latitude,
    required double longitude,
    required String pickupDate,
    required String pickupTime,
    required AIPredictionResult aiPrediction,
  }) async {
    final String newId = 'CB-${10000 + _donations.length + 1}';

    final newDonation = DonationItem(
      donationId: newId,
      donorId: _currentUser.uid,
      donorName: _currentUser.name,
      category: category,
      condition: condition,
      size: size,
      quantity: quantity,
      description: description,
      imageUrls: imageUrls.isEmpty
          ? ['https://images.unsplash.com/photo-1544441893-675973e31985?w=500&q=80']
          : imageUrls,
      pickupAddress: pickupAddress,
      latitude: latitude,
      longitude: longitude,
      pickupDate: pickupDate,
      pickupTime: pickupTime,
      aiPrediction: aiPrediction,
      recommendedDestination: aiPrediction.destination,
      status: DonationStatus.aiClassified,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _donations.insert(0, newDonation);

    // If repair/upcycling required, auto-create tailoring order
    if (aiPrediction.destination == DestinationType.tailoring ||
        aiPrediction.destination == DestinationType.upcycling) {
      _tailoringOrders.add(
        TailoringOrder(
          orderId: 'TL-${600 + _tailoringOrders.length}',
          donationId: newId,
          clothingCategory: category,
          clothingImage: newDonation.imageUrls.first,
          problem: aiPrediction.explanation,
          workType: aiPrediction.action,
          deadline: '3 Days',
          assignedBy: 'AI Decision Engine',
          tailoringUnitId: 'tailor-301',
          tailoringUnitName: 'StitchCraft Unit',
          status: 'Assigned',
          progress: 0,
        ),
      );
    }

    // Reward points for submitting
    final updatedPoints = _currentUser.rewardPoints + 50;
    final updatedTotal = _currentUser.totalDonations + 1;
    _currentUser = AppUser(
      uid: _currentUser.uid,
      name: _currentUser.name,
      email: _currentUser.email,
      phone: _currentUser.phone,
      role: _currentUser.role,
      address: _currentUser.address,
      rewardPoints: updatedPoints,
      totalDonations: updatedTotal,
      peopleHelped: _currentUser.peopleHelped + (quantity * 2),
    );

    // Push notification
    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        userId: _currentUser.uid,
        title: 'Donation Submitted Successfully!',
        message:
            'Item $newId classified by AI as ${aiPrediction.category}. Earned +50 Reward Points!',
        type: 'reward_earned',
        timestamp: DateTime.now(),
        relatedDonationId: newId,
      ),
    );

    _refreshRouteClusters();
    notifyListeners();
  }

  // Schedule NGO Pickup
  void schedulePickup(String donationId, String date, String time, String partner) {
    int index = _donations.indexWhere((d) => d.donationId == donationId);
    if (index != -1) {
      final old = _donations[index];
      _donations[index] = DonationItem(
        donationId: old.donationId,
        donorId: old.donorId,
        donorName: old.donorName,
        category: old.category,
        condition: old.condition,
        size: old.size,
        quantity: old.quantity,
        description: old.description,
        imageUrls: old.imageUrls,
        pickupAddress: old.pickupAddress,
        latitude: old.latitude,
        longitude: old.longitude,
        pickupDate: date,
        pickupTime: time,
        aiPrediction: old.aiPrediction,
        recommendedDestination: old.recommendedDestination,
        ngoId: _currentUser.uid,
        ngoName: _currentUser.orgName ?? _currentUser.name,
        status: DonationStatus.pickupScheduled,
        createdAt: old.createdAt,
        updatedAt: DateTime.now(),
      );

      _notifications.insert(
        0,
        NotificationItem(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          userId: old.donorId,
          title: 'Pickup Confirmed by ${old.ngoName ?? 'NGO'}',
          message: 'Pickup scheduled for $date at $time by $partner.',
          type: 'pickup_scheduled',
          timestamp: DateTime.now(),
          relatedDonationId: donationId,
        ),
      );

      notifyListeners();
    }
  }

  // Update Donation Status
  void updateDonationStatus(String donationId, String newStatus) {
    int index = _donations.indexWhere((d) => d.donationId == donationId);
    if (index != -1) {
      final old = _donations[index];
      _donations[index] = DonationItem(
        donationId: old.donationId,
        donorId: old.donorId,
        donorName: old.donorName,
        category: old.category,
        condition: old.condition,
        size: old.size,
        quantity: old.quantity,
        description: old.description,
        imageUrls: old.imageUrls,
        pickupAddress: old.pickupAddress,
        latitude: old.latitude,
        longitude: old.longitude,
        pickupDate: old.pickupDate,
        pickupTime: old.pickupTime,
        aiPrediction: old.aiPrediction,
        recommendedDestination: old.recommendedDestination,
        ngoId: old.ngoId,
        ngoName: old.ngoName,
        tailoringUnitId: old.tailoringUnitId,
        tailoringUnitName: old.tailoringUnitName,
        status: newStatus,
        createdAt: old.createdAt,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Update Tailoring Progress
  void updateTailoringOrder(String orderId, int progress, String status) {
    int index = _tailoringOrders.indexWhere((t) => t.orderId == orderId);
    if (index != -1) {
      final old = _tailoringOrders[index];
      _tailoringOrders[index] = TailoringOrder(
        orderId: old.orderId,
        donationId: old.donationId,
        clothingCategory: old.clothingCategory,
        clothingImage: old.clothingImage,
        problem: old.problem,
        workType: old.workType,
        deadline: old.deadline,
        assignedBy: old.assignedBy,
        tailoringUnitId: old.tailoringUnitId,
        tailoringUnitName: old.tailoringUnitName,
        status: status,
        progress: progress,
        resultImageUrl: old.resultImageUrl,
      );

      if (status == 'Completed') {
        updateDonationStatus(old.donationId, DonationStatus.completed);
      }

      notifyListeners();
    }
  }

  // Send Chat Message
  void sendMessage(String receiverId, String text) {
    _messages.add(
      ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        senderId: _currentUser.uid,
        senderName: _currentUser.name,
        receiverId: receiverId,
        message: text,
        timestamp: DateTime.now(),
        isNgo: _currentRole == UserRoles.ngo,
      ),
    );
    notifyListeners();
  }

  // Admin approves route cluster
  void approveCluster(String clusterId) {
    int index = _routeClusters.indexWhere((c) => c.clusterId == clusterId);
    if (index != -1) {
      _routeClusters[index] = _routeClusters[index].copyWith(isApproved: true);
      notifyListeners();
    }
  }

  void _refreshRouteClusters() {
    _routeClusters = RouteOptimizationService.generateClusters(_donations);
  }

  DonationCertificate getCertificateForDonation(DonationItem item) {
    return DonationCertificate(
      certificateId: 'CERT-${item.donationId}',
      donorId: item.donorId,
      donorName: item.donorName,
      itemQuantity: item.quantity,
      donationId: item.donationId,
      date: '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
      impactBadge: item.quantity > 5 ? 'Sustainability Hero' : 'Helping Hand',
    );
  }

  // Upcycled Product Marketplace Actions
  UpcycledOrder purchaseUpcycledProduct({
    required UpcycledProduct product,
    required String shippingAddress,
  }) {
    final orderId = 'ORD-${1000 + _upcycledOrders.length + 1}';
    final ngoEarnings = product.ngoAmountPerUnit;
    final tailorEarnings = product.tailorAmountPerUnit;

    final newOrder = UpcycledOrder(
      orderId: orderId,
      productId: product.id,
      productTitle: product.title,
      buyerId: _currentUser.uid,
      buyerName: _currentUser.name,
      totalPrice: product.price,
      ngoEarnings: ngoEarnings,
      tailorEarnings: tailorEarnings,
      associatedNgoName: product.associatedNgoName,
      tailoringUnitName: product.tailoringUnitName,
      purchaseDate: DateTime.now(),
      shippingAddress: shippingAddress,
    );

    _upcycledOrders.insert(0, newOrder);

    // Reduce stock count
    if (product.stockQuantity > 0) {
      product.stockQuantity -= 1;
    }

    // Reward buyer points
    _currentUser = AppUser(
      uid: _currentUser.uid,
      name: _currentUser.name,
      email: _currentUser.email,
      phone: _currentUser.phone,
      role: _currentUser.role,
      address: _currentUser.address,
      orgName: _currentUser.orgName,
      unitName: _currentUser.unitName,
      regDetails: _currentUser.regDetails,
      latitude: _currentUser.latitude,
      longitude: _currentUser.longitude,
      rewardPoints: _currentUser.rewardPoints + 30,
      totalDonations: _currentUser.totalDonations,
      peopleHelped: _currentUser.peopleHelped + 1,
    );

    // Add Notification
    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        userId: _currentUser.uid,
        title: 'Upcycled Order Confirmed! 🛍️',
        message:
            'Purchased ${product.title}. ₹${ngoEarnings.toStringAsFixed(0)} sent to ${product.associatedNgoName} & ₹${tailorEarnings.toStringAsFixed(0)} sent to ${product.tailoringUnitName}.',
        type: 'upcycled_purchase',
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
    return newOrder;
  }

  void addUpcycledProduct({
    required String title,
    required String description,
    required double price,
    required String imageUrl,
    required String originalDonationId,
    required int stockQuantity,
  }) {
    final newProduct = UpcycledProduct(
      id: 'UPC-${100 + _upcycledProducts.length + 1}',
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
      tailoringUnitId: _currentUser.uid,
      tailoringUnitName: _currentUser.unitName ?? 'StitchCraft Unit',
      associatedNgoId: 'ngo-201',
      associatedNgoName: 'Hope Foundation',
      originalDonationId: originalDonationId,
      stockQuantity: stockQuantity,
      ngoSharePercentage: 50.0,
      tailorSharePercentage: 50.0,
      createdAt: DateTime.now(),
    );

    _upcycledProducts.insert(0, newProduct);
    notifyListeners();
  }
}
