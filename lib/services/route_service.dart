import 'package:geolocator/geolocator.dart';
import '../models/donation_model.dart';

class RouteCluster {
  final String clusterId;
  final String clusterName;
  final String collectionPointAddress;
  final double centerLat;
  final double centerLng;
  final List<DonationItem> donations;
  final double totalDistanceSavedKm;
  final bool isApproved;

  RouteCluster({
    required this.clusterId,
    required this.clusterName,
    required this.collectionPointAddress,
    required this.centerLat,
    required this.centerLng,
    required this.donations,
    required this.totalDistanceSavedKm,
    this.isApproved = false,
  });

  RouteCluster copyWith({bool? isApproved}) {
    return RouteCluster(
      clusterId: clusterId,
      clusterName: clusterName,
      collectionPointAddress: collectionPointAddress,
      centerLat: centerLat,
      centerLng: centerLng,
      donations: donations,
      totalDistanceSavedKm: totalDistanceSavedKm,
      isApproved: isApproved ?? this.isApproved,
    );
  }
}

class RouteOptimizationService {
  static List<RouteCluster> generateClusters(
    List<DonationItem> pendingDonations, {
    double maxRadiusKm = 3.0,
  }) {
    if (pendingDonations.isEmpty) return [];

    List<RouteCluster> clusters = [];
    int clusterCount = 1;

    // Simple clustering prototype by geographical proximity
    Map<String, List<DonationItem>> grouped = {};

    for (var donation in pendingDonations) {
      String key = "Cluster $clusterCount";
      if (!grouped.containsKey(key)) {
        grouped[key] = [donation];
      } else {
        var firstInGroup = grouped[key]!.first;
        double distanceMeters = Geolocator.distanceBetween(
          firstInGroup.latitude,
          firstInGroup.longitude,
          donation.latitude,
          donation.longitude,
        );

        if (distanceMeters / 1000.0 <= maxRadiusKm) {
          grouped[key]!.add(donation);
        } else {
          clusterCount++;
          grouped["Cluster $clusterCount"] = [donation];
        }
      }
    }

    grouped.forEach((name, items) {
      double avgLat = items.map((e) => e.latitude).reduce((a, b) => a + b) / items.length;
      double avgLng = items.map((e) => e.longitude).reduce((a, b) => a + b) / items.length;

      clusters.add(
        RouteCluster(
          clusterId: 'RC-${DateTime.now().millisecondsSinceEpoch}-${clusters.length}',
          clusterName: name,
          collectionPointAddress:
              'Community Hub, Sector ${(clusters.length + 1) * 3}, Nearby Center',
          centerLat: avgLat,
          centerLng: avgLng,
          donations: items,
          totalDistanceSavedKm: (items.length * 1.8),
          isApproved: false,
        ),
      );
    });

    return clusters;
  }
}
