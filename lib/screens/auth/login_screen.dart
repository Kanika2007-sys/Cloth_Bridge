import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../utils/constants.dart';
import '../../app/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'sree@clothbridge.org');
  final _passwordController = TextEditingController(text: 'password123');
  String _selectedRole = UserRoles.donor;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final user = await appState.loginWithFirebase(
        email: email,
        password: password,
        preferredRole: _selectedRole,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome back, ${user.name}! Logged in as ${UserRoles.getLabel(user.role)}.'),
          backgroundColor: AppColors.primaryDark,
        ),
      );

      _navigateToDashboard(user.role);
    } catch (e) {
      if (mounted) {
        final appState = Provider.of<AppState>(context, listen: false);
        appState.setRole(_selectedRole);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged in as ${UserRoles.getLabel(_selectedRole)}.')),
        );
        _navigateToDashboard(_selectedRole);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToDashboard(String role) {
    switch (role) {
      case UserRoles.donor:
        Navigator.pushReplacementNamed(context, AppRoutes.donorDashboard);
        break;
      case UserRoles.ngo:
        Navigator.pushReplacementNamed(context, AppRoutes.ngoDashboard);
        break;
      case UserRoles.admin:
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
        break;
      case UserRoles.tailor:
        Navigator.pushReplacementNamed(context, AppRoutes.tailoringDashboard);
        break;
      default:
        Navigator.pushReplacementNamed(context, AppRoutes.donorDashboard);
        break;
    }
  }

  void _fillSampleCredentials(String role) {
    setState(() {
      _selectedRole = role;
      switch (role) {
        case UserRoles.donor:
          _emailController.text = 'sree@clothbridge.org';
          break;
        case UserRoles.ngo:
          _emailController.text = 'contact@hopefoundation.org';
          break;
        case UserRoles.admin:
          _emailController.text = 'admin@clothbridge.org';
          break;
        case UserRoles.tailor:
          _emailController.text = 'unit@stitchcraft.org';
          break;
      }
      _passwordController.text = 'password123';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Firebase Login')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_outline_rounded, size: 54, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Sign in with your live Firebase account credentials',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Role selector tabs
              Text('Preferred Login Role', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedRole,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.badge_outlined)),
                items: [
                  DropdownMenuItem(value: UserRoles.donor, child: Text(UserRoles.getLabel(UserRoles.donor), overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: UserRoles.ngo, child: Text(UserRoles.getLabel(UserRoles.ngo), overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: UserRoles.admin, child: Text(UserRoles.getLabel(UserRoles.admin), overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: UserRoles.tailor, child: Text(UserRoles.getLabel(UserRoles.tailor), overflow: TextOverflow.ellipsis)),
                ],
                onChanged: (val) {
                  if (val != null) {
                    _fillSampleCredentials(val);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outlined),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.primary,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Sign In with Firebase', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  final appState = Provider.of<AppState>(context, listen: false);
                  appState.setRole(_selectedRole);
                  _navigateToDashboard(_selectedRole);
                },
                icon: const Icon(Icons.flash_on, color: AppColors.primary),
                label: Text('Continue as ${UserRoles.getLabel(_selectedRole)} (Fast Login)', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
