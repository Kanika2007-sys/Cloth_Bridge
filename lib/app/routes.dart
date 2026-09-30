import 'package:flutter/material.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/donor/donor_dashboard.dart';
import '../screens/donor/donation_form_screen.dart';
import '../screens/donor/ai_assessment_screen.dart';
import '../screens/donor/donation_tracking_screen.dart';
import '../screens/donor/notifications_screen.dart';
import '../screens/donor/certificate_screen.dart';
import '../screens/donor/leaderboard_screen.dart';
import '../screens/ngo/ngo_dashboard.dart';
import '../screens/ngo/ngo_chat_screen.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/route_optimization_screen.dart';
import '../screens/tailoring/tailoring_dashboard.dart';
import '../screens/marketplace/upcycled_store_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Role Dashboards
  static const String donorDashboard = '/donor-dashboard';
  static const String ngoDashboard = '/ngo-dashboard';
  static const String adminDashboard = '/admin-dashboard';
  static const String tailoringDashboard = '/tailoring-dashboard';

  // Donor Sub-screens
  static const String donationForm = '/donation-form';
  static const String aiAssessment = '/ai-assessment';
  static const String donationTracking = '/donation-tracking';
  static const String notifications = '/notifications';
  static const String certificate = '/certificate';
  static const String leaderboard = '/leaderboard';
  static const String upcycledStore = '/upcycled-store';

  // NGO & Admin Sub-screens
  static const String ngoChat = '/ngo-chat';
  static const String routeOptimization = '/route-optimization';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        welcome: (context) => const WelcomeScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        forgotPassword: (context) => const ForgotPasswordScreen(),
        donorDashboard: (context) => const DonorDashboard(),
        ngoDashboard: (context) => const NgoDashboard(),
        adminDashboard: (context) => const AdminDashboard(),
        tailoringDashboard: (context) => const TailoringDashboard(),
        donationForm: (context) => const DonationFormScreen(),
        aiAssessment: (context) => const AIAssessmentScreen(),
        donationTracking: (context) => const DonationTrackingScreen(),
        notifications: (context) => const NotificationsScreen(),
        certificate: (context) => const CertificateScreen(),
        leaderboard: (context) => const LeaderboardScreen(),
        upcycledStore: (context) => const UpcycledStoreScreen(),
        ngoChat: (context) => const NgoChatScreen(),
        routeOptimization: (context) => const RouteOptimizationScreen(),
      };
}
