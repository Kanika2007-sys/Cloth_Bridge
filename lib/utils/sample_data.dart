import '../models/user_model.dart';
import '../models/donation_model.dart';
import '../models/notification_model.dart';
import '../models/tailoring_order_model.dart';
import '../models/message_model.dart';
import '../models/upcycled_product_model.dart';

class SampleData {
  static final AppUser donorUser = AppUser(
    uid: 'donor-101',
    name: 'Sree',
    email: 'sree@clothbridge.org',
    phone: '+91 98765 43210',
    role: 'donor',
    address: 'Indiranagar 100ft Road, Bangalore',
    latitude: 12.9716,
    longitude: 77.5946,
    rewardPoints: 560,
    totalDonations: 18,
    peopleHelped: 74,
  );

  static final AppUser ngoUser = AppUser(
    uid: 'ngo-201',
    name: 'Hope Foundation',
    email: 'contact@hopefoundation.org',
    phone: '+91 91234 56789',
    role: 'ngo',
    address: 'Koramangala 4th Block, Bangalore',
    orgName: 'Hope Care Trust NGO',
    regDetails: 'REG-NGO-2024-889',
    latitude: 12.9352,
    longitude: 77.6245,
  );

  static final AppUser adminUser = AppUser(
    uid: 'admin-001',
    name: 'Master Admin',
    email: 'admin@clothbridge.org',
    phone: '+91 99999 00000',
    role: 'admin',
    address: 'ClothBridge HQ, MG Road, Bangalore',
  );

  static final AppUser tailorUser = AppUser(
    uid: 'tailor-301',
    name: 'StitchCraft Upcycling Unit',
    email: 'unit@stitchcraft.org',
    phone: '+91 98888 77777',
    role: 'tailor',
    unitName: 'StitchCraft Upcycling & Repair Center',
    address: 'HSR Layout Sector 2, Bangalore',
  );

  static final List<DonationItem> sampleDonations = [
    DonationItem(
      donationId: 'CB-88421',
      donorId: 'donor-101',
      donorName: 'Sree',
      category: 'Winter Jackets',
      condition: 'Good / Donation Ready',
      size: 'L',
      quantity: 3,
      description: 'Warm fleece and puffer jackets in great condition.',
      imageUrls: [
        'https://images.unsplash.com/photo-1544441893-675973e31985?w=500&q=80',
      ],
      pickupAddress: 'Indiranagar 100ft Road, Bangalore',
      latitude: 12.9716,
      longitude: 77.5946,
      pickupDate: '2026-08-10',
      pickupTime: '04:00 PM',
      aiPrediction: AIPredictionResult(
        category: 'Good / Donation Ready',
        confidence: 0.96,
        destination: 'NGO / Orphanage',
        action: 'Direct Donation Ready',
        explanation: 'Fleece material in pristine condition, ready for winter drive.',
      ),
      recommendedDestination: 'Hope Foundation NGO',
      ngoId: 'ngo-201',
      ngoName: 'Hope Foundation',
      status: 'Pickup Scheduled',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
    ),
    DonationItem(
      donationId: 'CB-88422',
      donorId: 'donor-101',
      donorName: 'Sree',
      category: 'School Uniforms',
      condition: 'Minor Stain',
      size: 'M',
      quantity: 5,
      description: 'Navy blue school pants and white cotton shirts.',
      imageUrls: [
        'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=500&q=80',
      ],
      pickupAddress: 'Indiranagar 100ft Road, Bangalore',
      latitude: 12.9720,
      longitude: 77.5950,
      pickupDate: '2026-08-11',
      pickupTime: '10:00 AM',
      aiPrediction: AIPredictionResult(
        category: 'Minor Stain',
        confidence: 0.91,
        destination: 'NGO / Orphanage',
        action: 'Suitable after laundry wash',
        explanation: 'Minor washable ink stain on pocket. Cleanable before donation.',
      ),
      recommendedDestination: 'Smile Trust',
      status: 'AI Classified',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now(),
    ),
    DonationItem(
      donationId: 'CB-88423',
      donorId: 'donor-101',
      donorName: 'Sree',
      category: 'Cotton Shirts',
      condition: 'Repair Required',
      size: 'XL',
      quantity: 4,
      description: 'Formal shirts with missing top buttons and slight seam tear.',
      imageUrls: [
        'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500&q=80',
      ],
      pickupAddress: 'Indiranagar 100ft Road, Bangalore',
      latitude: 12.9730,
      longitude: 77.5960,
      pickupDate: '2026-08-12',
      pickupTime: '02:00 PM',
      aiPrediction: AIPredictionResult(
        category: 'Repair Required',
        confidence: 0.94,
        destination: 'Tailoring Unit',
        action: 'Button replacement & seam stitching',
        explanation: 'AI detected 2 missing buttons and a minor sleeve tear.',
      ),
      recommendedDestination: 'StitchCraft Tailoring Unit',
      tailoringUnitId: 'tailor-301',
      tailoringUnitName: 'StitchCraft Unit',
      status: 'Tailoring Assigned',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
    ),
    DonationItem(
      donationId: 'CB-88424',
      donorId: 'donor-101',
      donorName: 'Sree',
      category: 'Children Dresses',
      condition: 'Severely Damaged',
      size: 'S',
      quantity: 6,
      description: 'Heavily worn denim clothes suitable for upcycling bags.',
      imageUrls: [
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=500&q=80',
      ],
      pickupAddress: 'Indiranagar 100ft Road, Bangalore',
      latitude: 12.9740,
      longitude: 77.5970,
      pickupDate: '2026-08-05',
      pickupTime: '11:00 AM',
      aiPrediction: AIPredictionResult(
        category: 'Severely Damaged',
        confidence: 0.97,
        destination: 'Upcycling Unit',
        action: 'Upcycle into eco tote bags',
        explanation: 'Denim fabric structurally strong for upcycled tote bags.',
      ),
      recommendedDestination: 'StitchCraft Upcycling Unit',
      status: 'Completed',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
  ];

  static final List<Map<String, dynamic>> sampleNgos = [
    {
      'name': 'Hope Foundation NGO',
      'distance': '1.2 km',
      'rating': 4.9,
      'categories': 'Jackets, Uniforms, Winter Wear',
      'address': 'Koramangala, Bangalore',
    },
    {
      'name': 'Smile Trust Orphanage',
      'distance': '2.4 km',
      'rating': 4.8,
      'categories': 'Children Clothes, Dresses, Toys',
      'address': 'Indiranagar, Bangalore',
    },
    {
      'name': 'Helping Hands Care Center',
      'distance': '3.8 km',
      'rating': 4.7,
      'categories': 'All Clothes & Blankets',
      'address': 'Jayanagar, Bangalore',
    },
  ];

  static final List<Map<String, dynamic>> leaderboardDonors = [
    {
      'rank': 1,
      'name': 'Ananya R.',
      'donations': 42,
      'points': 2100,
      'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    },
    {
      'rank': 2,
      'name': 'Rahul Sharma',
      'donations': 36,
      'points': 1800,
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    },
    {
      'rank': 3,
      'name': 'Sree (You)',
      'donations': 28,
      'points': 1400,
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      'isCurrent': true,
    },
    {
      'rank': 4,
      'name': 'Priya Nair',
      'donations': 24,
      'points': 1200,
      'avatar': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
    },
    {
      'rank': 5,
      'name': 'Vikram Kumar',
      'donations': 19,
      'points': 950,
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    },
  ];

  static final List<NotificationItem> sampleNotifications = [
    NotificationItem(
      id: 'notif-1',
      userId: 'donor-101',
      title: 'Pickup Scheduled!',
      message: 'Hope Foundation scheduled pickup for 10 Aug at 4:00 PM.',
      type: 'pickup_scheduled',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationItem(
      id: 'notif-2',
      userId: 'donor-101',
      title: 'AI Classification Completed',
      message: 'Donation CB-88423 classified for Tailoring Repair.',
      type: 'status_update',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    NotificationItem(
      id: 'notif-3',
      userId: 'donor-101',
      title: '+100 Reward Points Earned!',
      message: 'Your upcycled tote bag donation was delivered successfully.',
      type: 'reward_earned',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static final List<TailoringOrder> sampleTailoringOrders = [
    TailoringOrder(
      orderId: 'TL-501',
      donationId: 'CB-88423',
      clothingCategory: 'Cotton Shirts',
      clothingImage:
          'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500&q=80',
      problem: '2 Missing buttons on front placket and minor cuff tear',
      workType: 'Button Replacement & Stitching',
      deadline: '12 Aug 2026',
      assignedBy: 'AI Decision Engine',
      tailoringUnitId: 'tailor-301',
      tailoringUnitName: 'StitchCraft Unit',
      status: 'In Progress',
      progress: 60,
    ),
    TailoringOrder(
      orderId: 'TL-502',
      donationId: 'CB-88424',
      clothingCategory: 'Children Denim Dresses',
      clothingImage:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=500&q=80',
      problem: 'Faded and torn fabric unsuitable for wearing',
      workType: 'Upcycling - Convertible Tote Bags (2 Units)',
      deadline: '14 Aug 2026',
      assignedBy: 'Admin Override',
      tailoringUnitId: 'tailor-301',
      tailoringUnitName: 'StitchCraft Unit',
      status: 'Completed',
      progress: 100,
      resultImageUrl:
          'https://images.unsplash.com/photo-1544816155-12df9643f363?w=500&q=80',
    ),
  ];

  static final List<ChatMessage> sampleMessages = [
    ChatMessage(
      id: 'msg-1',
      senderId: 'ngo-201',
      senderName: 'Hope Foundation',
      receiverId: 'donor-101',
      message: 'Hello Sree! We have assigned Ramesh to collect your winter jackets tomorrow.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      isNgo: true,
    ),
    ChatMessage(
      id: 'msg-2',
      senderId: 'donor-101',
      senderName: 'Sree',
      receiverId: 'ngo-201',
      message: 'Thank you! The items are packed and ready at the front reception desk.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isNgo: false,
    ),
  ];

  static final List<UpcycledProduct> sampleUpcycledProducts = [
    UpcycledProduct(
      id: 'UPC-101',
      title: 'Handcrafted Eco Denim Tote Bag',
      description:
          'Sturdy & stylish multi-pocket tote bag upcycled from donated heavily worn jeans (Donation CB-88424). Features reinforced handles and inner lining.',
      price: 499.0,
      imageUrl:
          'https://images.unsplash.com/photo-1544816155-12df9643f363?w=500&q=80',
      tailoringUnitId: 'tailor-301',
      tailoringUnitName: 'StitchCraft Unit',
      associatedNgoId: 'ngo-201',
      associatedNgoName: 'Hope Foundation',
      originalDonationId: 'CB-88424',
      stockQuantity: 8,
      ngoSharePercentage: 50.0,
      tailorSharePercentage: 50.0,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    UpcycledProduct(
      id: 'UPC-102',
      title: 'Patchwork Fabric Cushion Cover Set',
      description:
          'Set of 2 bohemian cushion covers sewn using upcycled colorful cotton fabric scraps. Supports artisan women at StitchCraft unit.',
      price: 649.0,
      imageUrl:
          'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=500&q=80',
      tailoringUnitId: 'tailor-301',
      tailoringUnitName: 'StitchCraft Unit',
      associatedNgoId: 'ngo-201',
      associatedNgoName: 'Hope Foundation',
      originalDonationId: 'CB-88425',
      stockQuantity: 5,
      ngoSharePercentage: 50.0,
      tailorSharePercentage: 50.0,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    UpcycledProduct(
      id: 'UPC-103',
      title: 'Upcycled Cotton Kitchen Apron',
      description:
          'Durable full-length cooking apron with double utility pockets crafted from re-purposed cotton shirts and canvas trim.',
      price: 399.0,
      imageUrl:
          'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=500&q=80',
      tailoringUnitId: 'tailor-301',
      tailoringUnitName: 'StitchCraft Unit',
      associatedNgoId: 'ngo-201',
      associatedNgoName: 'Hope Foundation',
      originalDonationId: 'CB-88423',
      stockQuantity: 12,
      ngoSharePercentage: 50.0,
      tailorSharePercentage: 50.0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static final List<UpcycledOrder> sampleUpcycledOrders = [
    UpcycledOrder(
      orderId: 'ORD-9901',
      productId: 'UPC-101',
      productTitle: 'Handcrafted Eco Denim Tote Bag',
      buyerId: 'donor-101',
      buyerName: 'Sree',
      totalPrice: 499.0,
      ngoEarnings: 249.5,
      tailorEarnings: 249.5,
      associatedNgoName: 'Hope Foundation',
      tailoringUnitName: 'StitchCraft Unit',
      purchaseDate: DateTime.now().subtract(const Duration(days: 1)),
      shippingAddress: 'Indiranagar 100ft Road, Bangalore',
    ),
  ];
}
