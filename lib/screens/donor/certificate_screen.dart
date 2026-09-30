import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../utils/constants.dart';
import '../../utils/download_helper.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final GlobalKey _certificateKey = GlobalKey();
  bool _isGenerating = false;

  Future<void> _downloadCertificate(BuildContext context) async {
    setState(() {
      _isGenerating = true;
    });

    try {
      // Small delay to ensure frame rendering
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary = _certificateKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to render certificate layout.')),
          );
        }
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final fileName = 'ClothBridge_Impact_Certificate_${DateTime.now().millisecondsSinceEpoch}.png';

        // Trigger file download using helper
        downloadBytes(pngBytes, fileName);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.greenAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Downloaded Certificate as $fileName!'),
                  ),
                ],
              ),
              duration: const Duration(seconds: 4),
              backgroundColor: AppColors.primaryDark,
            ),
          );

          _showDownloadSuccessModal(context, pngBytes, fileName);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Certificate export error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _showDownloadSuccessModal(BuildContext context, Uint8List imageBytes, String fileName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Certificate Exported! 📜', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(imageBytes, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'File saved: $fileName',
              style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your official ClothBridge Sustainability Certificate has been generated & downloaded.',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _downloadCertificate(context);
            },
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Download Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;
    final item = appState.donations.isNotEmpty ? appState.donations.first : null;
    final cert = item != null ? appState.getCertificateForDonation(item) : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Impact Certificate')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Visual Certificate Border Frame inside RepaintBoundary
              RepaintBoundary(
                key: _certificateKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.recycling_rounded, color: AppColors.primary, size: 36),
                          SizedBox(width: 8),
                          Text(
                            'CLOTHBRIDGE',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'CERTIFICATE OF APPRECIATION',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.amber,
                        ),
                      ),
                      const Divider(height: 24, thickness: 1.5),
                      const SizedBox(height: 8),
                      const Text('This certificate is proudly presented to',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'for generously contributing ${cert?.itemQuantity ?? 3} clothing items towards sustainable reuse, textile upcycling, and community welfare.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Badge Awarded: ${cert?.impactBadge ?? 'Sustainability Hero'} 🏅',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: AppColors.primaryDark, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Donation ID', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              Text(cert?.donationId ?? 'CB-88421',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Date Issued', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              Text(cert?.date ?? '08/08/2026',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isGenerating ? null : () => _downloadCertificate(context),
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.download),
                      label: Text(_isGenerating ? 'Exporting...' : 'Download Certificate'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing certificate link: clothbridge.org/cert/CB-88421')),
                        );
                      },
                      icon: const Icon(Icons.share, color: AppColors.primary),
                      label: const Text('Share Impact', style: TextStyle(color: AppColors.primary)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
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
