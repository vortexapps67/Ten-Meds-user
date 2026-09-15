import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../theme/app_theme.dart';

class Screen5DoorstepHandover extends StatefulWidget {
  final BillSplit billSplit;
  final PaymentMethod paymentMethod;
  final String deliveryOtp;
  final String bagBarcode;
  final VoidCallback onCompleteOrder;

  const Screen5DoorstepHandover({
    super.key,
    required this.billSplit,
    required this.paymentMethod,
    required this.deliveryOtp,
    required this.bagBarcode,
    required this.onCompleteOrder,
  });

  @override
  State<Screen5DoorstepHandover> createState() => _Screen5DoorstepHandoverState();
}

class _Screen5DoorstepHandoverState extends State<Screen5DoorstepHandover> {
  bool _isSealChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 100m Proximity Gate Alert
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryDark.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white24,
                child: Icon(Icons.notifications_active, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rider is at your gate!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Please keep ${widget.paymentMethod == PaymentMethod.cod ? "₹${widget.billSplit.totalPayable.toInt()} Cash" : "UPI QR Scanner"} ready.',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // OTP Security Shield Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.slateDark, Color(0xFF020617)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, color: AppTheme.primaryLight, size: 16),
                  SizedBox(width: 6),
                  Text(
                    '4-DIGIT SECURE DELIVERY OTP',
                    style: TextStyle(
                      color: AppTheme.primaryLight,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // OTP Digits Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.deliveryOtp.split('').map((digit) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 46,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryLight.withOpacity(0.6), width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      digit,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // Warning
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade600.withOpacity(0.4)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_outlined, color: Colors.amber, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Do not share this OTP until you verify the green security seal on bag ${widget.bagBarcode}.',
                        style: const TextStyle(color: Colors.amber, fontSize: 9.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Payment Details Card
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payment Settlement at Door',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.slateMuted)),
                  Text(
                    '₹${widget.billSplit.totalPayable.toInt()}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    widget.paymentMethod == PaymentMethod.cod ? Icons.payments : Icons.qr_code,
                    color: AppTheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.paymentMethod == PaymentMethod.cod
                      ? 'Pay ₹${widget.billSplit.totalPayable.toInt()} Cash to Rider'
                      : 'Scan Rider\'s Porter UPI QR',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Seal Inspection Checkbox
        CheckboxListTile(
          value: _isSealChecked,
          onChanged: (val) => setState(() => _isSealChecked = val ?? false),
          activeColor: AppTheme.primary,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'I have checked the tamper-evident seal',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
          ),
          subtitle: Text(
            'The medical pouch is intact with unbroken seal ${widget.bagBarcode}.',
            style: const TextStyle(fontSize: 9.5, color: AppTheme.slateMuted),
          ),
        ),

        const SizedBox(height: 10),

        // Complete Action
        ElevatedButton.icon(
          onPressed: _isSealChecked ? widget.onCompleteOrder : null,
          icon: const Icon(Icons.check_circle, size: 18),
          label: Text(
            'OTP Shared & Paid ₹${widget.billSplit.totalPayable.toInt()} ➔ Complete Order',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}
