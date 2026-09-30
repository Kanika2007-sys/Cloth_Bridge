import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../utils/constants.dart';
import '../../services/location_service.dart';
import '../../app/routes.dart';

class DonationFormScreen extends StatefulWidget {
  const DonationFormScreen({super.key});

  @override
  State<DonationFormScreen> createState() => _DonationFormScreenState();
}

class _DonationFormScreenState extends State<DonationFormScreen> {
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  String _category = ClothingCategory.shirts;
  int _quantity = 3;
  String _size = 'M';
  final _descriptionController = TextEditingController(text: '');
  final _addressController = TextEditingController(text: 'Indiranagar 100ft Road, Bangalore');
  final _notesController = TextEditingController(text: 'Please call before arrival.');
  
  String _pickupDate = '2026-08-11';
  String _pickupTime = '04:00 PM';
  double _lat = 12.9716;
  double _lng = 77.5946;

  bool _isGettingLocation = false;

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    final pos = await LocationService.getCurrentPosition();
    if (pos != null) {
      _lat = pos.latitude;
      _lng = pos.longitude;
      final addr = await LocationService.getAddressFromCoordinates(_lat, _lng);
      setState(() => _addressController.text = addr);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Using default Bangalore sample location.')),
      );
    }
    setState(() => _isGettingLocation = false);
  }

  void _proceedToAIAssessment() async {
    final appState = Provider.of<AppState>(context, listen: false);

    // ML inference trigger with imagePath and category hint context
    final imagePath = _selectedImages.isNotEmpty ? _selectedImages.first.path : 'sample_clothing.jpg';
    final categoryHint = '$_category ${_descriptionController.text}';
    final aiResult = await appState.classifyClothingImage(imagePath, categoryHint: categoryHint);

    if (mounted) {
      Navigator.pushNamed(
        context,
        AppRoutes.aiAssessment,
        arguments: {
          'category': _category,
          'quantity': _quantity,
          'size': _size,
          'description': _descriptionController.text,
          'imageUrls': _selectedImages.map((e) => e.path).toList(),
          'pickupAddress': _addressController.text,
          'latitude': _lat,
          'longitude': _lng,
          'pickupDate': _pickupDate,
          'pickupTime': _pickupTime,
          'aiPrediction': aiResult,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donate Clothes')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Upload Clothing Images',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              // Image Picker Box
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                ),
                child: _selectedImages.isEmpty
                    ? InkWell(
                        onTap: _pickImages,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo, size: 36, color: AppColors.primary),
                            SizedBox(height: 6),
                            Text('Tap to pick clothing photos from gallery', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(8),
                        itemCount: _selectedImages.length + 1,
                        itemBuilder: (context, idx) {
                          if (idx == _selectedImages.length) {
                            return InkWell(
                              onTap: _pickImages,
                              child: Container(
                                width: 90,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.add_photo_alternate, color: AppColors.primary),
                              ),
                            );
                          }
                          return Stack(
                            children: [
                              Container(
                                width: 90,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(File(_selectedImages[idx].path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImages.removeAt(idx);
                                    });
                                  },
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close, size: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),

              // Category & Size
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: ClothingCategory.all
                          .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _category = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _size,
                      decoration: const InputDecoration(labelText: 'Size'),
                      items: ['S', 'M', 'L', 'XL', 'Free Size']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _size = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quantity counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Quantity (Items)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                        icon: const Icon(Icons.remove, size: 18),
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add, size: 18),
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              TextField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description / Fabric details',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              // Address with GPS
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Pickup Address',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: _isGettingLocation ? null : _useCurrentLocation,
                    icon: _isGettingLocation
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.my_location),
                    tooltip: 'Use GPS Location',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date & Time
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(text: _pickupDate),
                      decoration: const InputDecoration(
                        labelText: 'Pickup Date',
                        prefixIcon: Icon(Icons.calendar_today, size: 18),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (picked != null) {
                          setState(() => _pickupDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}");
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(text: _pickupTime),
                      decoration: const InputDecoration(
                        labelText: 'Preferred Time',
                        prefixIcon: Icon(Icons.access_time, size: 18),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Additional Notes (Optional)'),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _proceedToAIAssessment,
                icon: const Icon(Icons.psychology, color: Colors.white),
                label: const Flexible(
                  child: Text(
                    'Analyze Condition with AI & Continue',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
