import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../utils/constants.dart';
import '../../services/location_service.dart';
import '../../app/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _selectedRole = UserRoles.donor;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _orgNameController = TextEditingController();
  final _regDetailsController = TextEditingController();
  final _unitNameController = TextEditingController();

  bool _isFetchingLocation = false;

  Future<void> _fetchGPSLocation() async {
    setState(() => _isFetchingLocation = true);
    final pos = await LocationService.getCurrentPosition();
    if (pos != null) {
      final addr = await LocationService.getAddressFromCoordinates(pos.latitude, pos.longitude);
      setState(() => _addressController.text = addr);
    } else {
      setState(() => _addressController.text = "Indiranagar 100ft Road, Bangalore");
    }
    setState(() => _isFetchingLocation = false);
  }

  bool _isLoading = false;

  Future<void> _handleRegister() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name, email, and password.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final user = await appState.registerWithFirebase(
        email: email,
        password: password,
        name: name,
        role: _selectedRole,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty ? 'Indiranagar 100ft Road, Bangalore' : _addressController.text.trim(),
        orgName: _selectedRole == UserRoles.ngo ? _orgNameController.text.trim() : null,
        regDetails: _selectedRole == UserRoles.ngo ? _regDetailsController.text.trim() : null,
        unitName: _selectedRole == UserRoles.tailor ? _unitNameController.text.trim() : null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account registered! Welcome ${user.name} (${UserRoles.getLabel(user.role)}).'),
          backgroundColor: AppColors.primaryDark,
        ),
      );

      switch (user.role) {
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
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Join ClothBridge',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              const Text('Select your user role to complete registration'),
              const SizedBox(height: 20),
              // Role selection dropdown
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Account Role',
                  prefixIcon: Icon(Icons.person_pin_outlined),
                ),
                items: [
                  DropdownMenuItem(value: UserRoles.donor, child: Text(UserRoles.getLabel(UserRoles.donor), overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: UserRoles.ngo, child: Text(UserRoles.getLabel(UserRoles.ngo), overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: UserRoles.admin, child: Text(UserRoles.getLabel(UserRoles.admin), overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: UserRoles.tailor, child: Text(UserRoles.getLabel(UserRoles.tailor), overflow: TextOverflow.ellipsis)),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedRole = val);
                },
              ),
              const SizedBox(height: 16),

              // Role specific dynamic fields
              if (_selectedRole == UserRoles.ngo) ...[
                TextField(
                  controller: _orgNameController,
                  decoration: const InputDecoration(labelText: 'Organization Name', prefixIcon: Icon(Icons.business)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _regDetailsController,
                  decoration: const InputDecoration(labelText: 'Registration / License No.', prefixIcon: Icon(Icons.verified)),
                ),
                const SizedBox(height: 16),
              ],

              if (_selectedRole == UserRoles.tailor) ...[
                TextField(
                  controller: _unitNameController,
                  decoration: const InputDecoration(labelText: 'Tailoring Unit Name', prefixIcon: Icon(Icons.precision_manufacturing)),
                ),
                const SizedBox(height: 16),
              ],

              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: _selectedRole == UserRoles.ngo ? 'Contact Person Name' : 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outlined)),
              ),
              const SizedBox(height: 16),

              // Location with GPS button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address / Location',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: _isFetchingLocation ? null : _fetchGPSLocation,
                    icon: _isFetchingLocation
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.my_location),
                    tooltip: 'Use GPS Location',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
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
                    : const Text('Create Account with Firebase', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
