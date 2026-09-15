import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../theme/app_theme.dart';

class Screen6OrderComplete extends StatelessWidget {
  final BillSplit billSplit;
  final String orderId;
  final PartnerChemist chemist;
  final RiderDetails rider;
  final VoidCallback onOpenInvoice;
  final VoidCallback onNewOrder;

  const Screen6OrderComplete({
    super.key,
    required this.billSplit,
    required this.orderId,
    required this.chemist,
    required this.rider,
    required this.onOpenInvoice,
    required this.onNewOrder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 10),
        // Success Circle
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.mintSurface,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryLight, width: 2),
            ),
            child: const Icon(Icons.check_circle, color: AppTheme.primary, size: 40),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Delivered in 11 Mins 42 Secs!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
        ),
        const SizedBox(height: 2),
        const Text(
          'Emergency medicine safely received & tamper-seal verified.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: AppTheme.slateMuted),
        ),
        const SizedBox(height: 20),

        // Chemist Tax Invoice Download Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceGrey,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderGrey),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.receipt_long, color: AppTheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Chemist Tax Invoice',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('INV-TM-$orderId • GST Compliant',
                              style: const TextStyle(fontSize: 9.5, color: AppTheme.slateMuted)),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: onOpenInvoice,
                    icon: const Icon(Icons.file_download, size: 14),
                    label: const Text('View Invoice', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dispensed by ${chemist.name}',
                      style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted)),
                  Text('Paid: ₹${billSplit.totalPayable.toInt()}',
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Chronic Refill Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.mintSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryLight.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.favorite, color: AppTheme.primary, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Chronic Medication 30-Day Refill',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppTheme.primaryDark),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Need regular refills for cardiac, diabetes, or maintenance medicines? Ten Meds can lock stock at your partner chemist 48 hours in advance.',
                style: TextStyle(fontSize: 10.5, color: AppTheme.primaryDark, height: 1.3),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('30-Day Refill Reminder Saved! We will notify you 48h prior.'),
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                },
                icon: const Icon(Icons.alarm, size: 14),
                label: const Text('Enable 30-Day Chronic Refill Reminder',
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(36),
                  side: const BorderSide(color: AppTheme.primary),
                  foregroundColor: AppTheme.primaryDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Rider Rating
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.borderGrey),
          ),
          child: Column(
            children: [
              Text(
                'Rate Porter Rider ${rider.name}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
              ),
              const SizedBox(height: 6),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 22),
                  Icon(Icons.star, color: Colors.amber, size: 22),
                  Icon(Icons.star, color: Colors.amber, size: 22),
                  Icon(Icons.star, color: Colors.amber, size: 22),
                  Icon(Icons.star, color: Colors.amber, size: 22),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // New Emergency Order Button
        ElevatedButton.icon(
          onPressed: onNewOrder,
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Start Another Emergency Search',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.slateDark,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(46),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}
