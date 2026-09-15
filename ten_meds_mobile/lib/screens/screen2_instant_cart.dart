import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../theme/app_theme.dart';

class Screen2InstantCart extends StatelessWidget {
  final List<CartItem> cart;
  final BillSplit billSplit;
  final PaymentMethod paymentMethod;
  final Function(PaymentMethod) onSelectPayment;
  final PrescriptionData? prescription;
  final VoidCallback onOpenPrescriptionDialog;
  final Function(String) onRemoveItem;
  final VoidCallback onBack;
  final VoidCallback onConfirmOrder;

  const Screen2InstantCart({
    super.key,
    required this.cart,
    required this.billSplit,
    required this.paymentMethod,
    required this.onSelectPayment,
    this.prescription,
    required this.onOpenPrescriptionDialog,
    required this.onRemoveItem,
    required this.onBack,
    required this.onConfirmOrder,
  });

  @override
  Widget build(BuildContext context) {
    final hasScheduleH = cart.any((item) => item.medicine.isScheduleH);
    final isRxMissing = hasScheduleH && prescription == null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instant Cart & Bill',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.slateDark),
            ),
            Text(
              'Step 2 of 6: Transparent Split',
              style: TextStyle(fontSize: 9.5, color: AppTheme.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 90),
        children: [
          // Items header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MEDICINES IN CART',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
              ),
              Text(
                '${cart.length} Items',
                style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Items
          ...cart.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderGrey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              item.medicine.brandName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            if (item.medicine.isScheduleH) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.amber.shade300),
                                ),
                                child: const Text(
                                  'Schedule H',
                                  style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: AppTheme.amberWarning),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.medicine.genericSalt,
                          style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Qty: ${item.quantity} • ₹${item.medicine.mrp.toInt()} each',
                          style: const TextStyle(fontSize: 9.5, color: AppTheme.slateMuted),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '₹${item.total.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => onRemoveItem(item.medicine.id),
                        child: const Icon(Icons.delete_outline, color: AppTheme.slateMuted, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Schedule H Warning Banner
          if (hasScheduleH) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: prescription != null ? AppTheme.mintSurface : Colors.amber.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: prescription != null ? AppTheme.primaryLight : Colors.amber.shade300,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    prescription != null ? Icons.verified : Icons.warning_amber_rounded,
                    color: prescription != null ? AppTheme.primary : AppTheme.amberWarning,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prescription != null
                              ? 'Prescription Attached (${prescription!.fileName})'
                              : 'Schedule H Law: Prescription Mandated',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.5,
                            color: prescription != null ? AppTheme.primaryDark : AppTheme.amberWarning,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          prescription != null
                              ? 'Licensed pharmacist will verify the slip before cutting blister strips.'
                              : 'Order contains prescription-only antibiotics. Indian law mandates an attached doctor slip.',
                          style: TextStyle(
                            fontSize: 10,
                            color: prescription != null ? AppTheme.primaryDark : Colors.amber.shade900,
                          ),
                        ),
                        if (prescription == null) ...[
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: onOpenPrescriptionDialog,
                            icon: const Icon(Icons.camera_alt, size: 14),
                            label: const Text('Snap Doctor Slip Now',
                                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.amberWarning,
                              foregroundColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Transparent Bill Split Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceGrey,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TRANSPARENT LINE-ITEM BILL SPLIT',
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Medicine Cost (MRP)', style: TextStyle(fontSize: 11, color: AppTheme.slateDark)),
                    Text('₹${billSplit.medicineTotal.toInt()}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text('Dynamic Porter Delivery Fee', style: TextStyle(fontSize: 11, color: AppTheme.slateDark)),
                        SizedBox(width: 4),
                        Text('(<2.5 km)', style: TextStyle(fontSize: 9, color: AppTheme.slateMuted)),
                      ],
                    ),
                    Text('₹${billSplit.deliveryFee.toInt()}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text('Priority Handling Fee', style: TextStyle(fontSize: 11, color: AppTheme.slateDark)),
                        SizedBox(width: 4),
                        Text('(10-15 Min SLA)', style: TextStyle(fontSize: 9, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text('₹${billSplit.priorityHandlingFee.toInt()}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total To Pay', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
                    Text(
                      '₹${billSplit.totalPayable.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Payment Selector
          const Text(
            'DOORSTEP PAYMENT METHOD',
            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => onSelectPayment(PaymentMethod.cod),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: paymentMethod == PaymentMethod.cod ? AppTheme.mintSurface : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: paymentMethod == PaymentMethod.cod ? AppTheme.primary : AppTheme.borderGrey,
                        width: paymentMethod == PaymentMethod.cod ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.payments_outlined,
                          color: paymentMethod == PaymentMethod.cod ? AppTheme.primary : AppTheme.slateMuted,
                          size: 20,
                        ),
                        const SizedBox(height: 6),
                        const Text('Cash on Delivery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        const Text('Zero advance risk', style: TextStyle(fontSize: 9.5, color: AppTheme.slateMuted)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => onSelectPayment(PaymentMethod.upi),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: paymentMethod == PaymentMethod.upi ? AppTheme.mintSurface : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: paymentMethod == PaymentMethod.upi ? AppTheme.primary : AppTheme.borderGrey,
                        width: paymentMethod == PaymentMethod.upi ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: paymentMethod == PaymentMethod.upi ? AppTheme.primary : AppTheme.slateMuted,
                          size: 20,
                        ),
                        const SizedBox(height: 6),
                        const Text('Instant UPI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        const Text('GPay/PhonePe at door', style: TextStyle(fontSize: 9.5, color: AppTheme.slateMuted)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // Floating Confirm CTA
      bottomSheet: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppTheme.borderGrey)),
        ),
        child: ElevatedButton(
          onPressed: isRxMissing || cart.isEmpty ? null : onConfirmOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    paymentMethod == PaymentMethod.cod ? 'Cash on Delivery Handover' : 'UPI Doorstep Payment',
                    style: const TextStyle(fontSize: 9, color: Colors.white70),
                  ),
                  Text(
                    '₹${billSplit.totalPayable.toInt()}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    isRxMissing ? 'Upload Rx to Unlock' : 'Confirm & Dispatch Pharmacist',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.bolt, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
