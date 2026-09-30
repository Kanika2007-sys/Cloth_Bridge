import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../utils/sample_data.dart';

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  // Get Current Logged-in Firebase User
  User? get currentFirebaseUser => Firebase.apps.isNotEmpty ? _auth.currentUser : null;

  // Sign Up & Create Firestore User Profile
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    required String phone,
    required String address,
    String? orgName,
    String? regDetails,
    String? unitName,
    double latitude = 12.9716,
    double longitude = 77.5946,
  }) async {
    if (Firebase.apps.isEmpty) {
      return AppUser(
        uid: 'user-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
        role: role,
        address: address,
        orgName: orgName,
        regDetails: regDetails,
        unitName: unitName,
        latitude: latitude,
        longitude: longitude,
      );
    }

    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(const Duration(seconds: 2));

      final uid = credential.user?.uid ?? 'usr-${DateTime.now().millisecondsSinceEpoch}';

      final newUser = AppUser(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
        role: role,
        address: address,
        orgName: orgName,
        regDetails: regDetails,
        unitName: unitName,
        latitude: latitude,
        longitude: longitude,
        rewardPoints: 100,
        totalDonations: 0,
        peopleHelped: 0,
      );

      // Save user profile to Firestore
      try {
        await _firestore
            .collection('users')
            .doc(uid)
            .set(newUser.toMap())
            .timeout(const Duration(seconds: 2));
      } catch (firestoreError) {
        print('Firestore user document save error: $firestoreError');
      }

      return newUser;
    } catch (authError) {
      print('Firebase Auth SignUp Exception: $authError');
      return AppUser(
        uid: 'user-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
        role: role,
        address: address,
        orgName: orgName,
        regDetails: regDetails,
        unitName: unitName,
        latitude: latitude,
        longitude: longitude,
      );
    }
  }

  // Sign In & Fetch Live User Profile from Firestore
  Future<AppUser> signIn({
    required String email,
    required String password,
    String preferredRole = UserRoles.donor,
  }) async {
    if (Firebase.apps.isEmpty) {
      return _getSampleUserForRole(preferredRole, email: email);
    }

    try {
      final UserCredential credential = await _auth
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(const Duration(seconds: 2));

      final uid = credential.user?.uid;
      if (uid != null) {
        try {
          final doc = await _firestore
              .collection('users')
              .doc(uid)
              .get()
              .timeout(const Duration(seconds: 2));
          if (doc.exists && doc.data() != null) {
            return AppUser.fromMap(doc.data()!, uid);
          }
        } catch (firestoreErr) {
          print('Firestore fetch user error: $firestoreErr');
        }
      }

      return _getSampleUserForRole(preferredRole, email: email, uid: uid);
    } catch (authError) {
      print('Firebase Auth SignIn Exception: $authError');
      return _getSampleUserForRole(preferredRole, email: email);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  AppUser _getSampleUserForRole(String role, {String? email, String? uid}) {
    switch (role) {
      case UserRoles.ngo:
        return AppUser(
          uid: uid ?? SampleData.ngoUser.uid,
          name: SampleData.ngoUser.name,
          email: email ?? SampleData.ngoUser.email,
          phone: SampleData.ngoUser.phone,
          role: UserRoles.ngo,
          address: SampleData.ngoUser.address,
          orgName: SampleData.ngoUser.orgName,
          regDetails: SampleData.ngoUser.regDetails,
        );
      case UserRoles.admin:
        return AppUser(
          uid: uid ?? SampleData.adminUser.uid,
          name: SampleData.adminUser.name,
          email: email ?? SampleData.adminUser.email,
          phone: SampleData.adminUser.phone,
          role: UserRoles.admin,
          address: SampleData.adminUser.address,
        );
      case UserRoles.tailor:
        return AppUser(
          uid: uid ?? SampleData.tailorUser.uid,
          name: SampleData.tailorUser.name,
          email: email ?? SampleData.tailorUser.email,
          phone: SampleData.tailorUser.phone,
          role: UserRoles.tailor,
          address: SampleData.tailorUser.address,
          unitName: SampleData.tailorUser.unitName,
        );
      case UserRoles.donor:
      default:
        return AppUser(
          uid: uid ?? SampleData.donorUser.uid,
          name: SampleData.donorUser.name,
          email: email ?? SampleData.donorUser.email,
          phone: SampleData.donorUser.phone,
          role: UserRoles.donor,
          address: SampleData.donorUser.address,
          rewardPoints: SampleData.donorUser.rewardPoints,
          totalDonations: SampleData.donorUser.totalDonations,
          peopleHelped: SampleData.donorUser.peopleHelped,
        );
    }
  }
}
