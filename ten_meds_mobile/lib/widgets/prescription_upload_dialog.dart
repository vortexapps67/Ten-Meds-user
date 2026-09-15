import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../theme/app_theme.dart';

class PrescriptionUploadDialog extends StatefulWidget {
  final Function(PrescriptionData) onPrescriptionUploaded;

  const PrescriptionUploadDialog({super.key, required this.onPrescriptionUploaded});

  @override
  State<PrescriptionUploadDialog> createState() => _PrescriptionUploadDialogState();
}

class _PrescriptionUploadDialogState extends State<PrescriptionUploadDialog> {
  bool _isScanning = false;
  bool _isCaptured = false;

  void _handleSimulateScan() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() {
        _isScanning = false;
        _isCaptured = true;
      });
    }
  }

  void _confirmAndAttach() {
    widget.onPrescriptionUploaded(
      const PrescriptionData(
        fileName: 'Rx_Dr_Mukherjee_Apollo.jpg',
        previewUrl: 'assets/images/rx_sample.jpg',
        uploadedAt: '10:30 AM',
        detectedSalts: [
          'Paracetamol IP 650mg TDS',
          'Amoxicillin + Clavulanate 625mg BD',
          'Pantoprazole 40mg OD Before Food',
        ],
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            color: AppTheme.primaryDark,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.camera_alt, color: AppTheme.primaryLight, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Upload Doctor Prescription',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.white70, size: 18),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: _isScanning
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: AppTheme.primary),
                        SizedBox(height: 14),
                        Text(
                          'AI Scanning Doctor Slip...',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Verifying doctor registration & active salt molecules',
                          style: TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                        ),
                      ],
                    ),
                  )
                : !_isCaptured
                    ? Column(
                        children: [
                          const Text(
                            'Schedule H antibiotics & critical drugs require a registered physician prescription under Indian law.',
                            style: TextStyle(fontSize: 11, color: AppTheme.slateMuted, height: 1.3),
                          ),
                          const SizedBox(height: 14),
                          InkWell(
                            onTap: _handleSimulateScan,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              decoration: BoxDecoration(
                                color: AppTheme.mintSurface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppTheme.primaryLight,
                                  style: BorderStyle.solid,
                                  width: 1.5,
                                ),
                              ),
                              child: const Column(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: AppTheme.primary,
                                    child: Icon(Icons.camera_alt, color: Colors.white, size: 22),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Quick Snap with Camera',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppTheme.primaryDark,
                                    ),
                                  ),
                                  Text(
                                    'Auto-aligns & enhances doctor handwriting',
                                    style: TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: _handleSimulateScan,
                            icon: const Icon(Icons.upload_file, size: 16),
                            label: const Text('Choose Gallery Image / PDF',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceGrey,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderGrey),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppTheme.mintSurface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.description, color: AppTheme.primary),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rx_Dr_Mukherjee_Apollo.jpg',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                      ),
                                      Text(
                                        'Valid Physician Stamp Detected',
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 9.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.check_circle, color: AppTheme.primary, size: 18),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'AI Salt Recognition Matches:',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.mintSurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• Amoxicillin + Clavulanate (Augmentin 625)',
                                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: AppTheme.primaryDark)),
                                SizedBox(height: 2),
                                Text('• Pantoprazole + Domperidone (Pan-D)',
                                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: AppTheme.primaryDark)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            onPressed: _confirmAndAttach,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(42),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              'Attach & Unlock Cart Checkout',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
