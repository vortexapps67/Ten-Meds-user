import 'dart:async';
import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../theme/app_theme.dart';

class Screen3ChemistPack extends StatefulWidget {
  final PartnerChemist chemist;
  final String bagBarcode;
  final VoidCallback onPackingComplete;

  const Screen3ChemistPack({
    super.key,
    required this.chemist,
    required this.bagBarcode,
    required this.onPackingComplete,
  });

  @override
  State<Screen3ChemistPack> createState() => _Screen3ChemistPackState();
}

class _Screen3ChemistPackState extends State<Screen3ChemistPack>
    with SingleTickerProviderStateMixin {
  int _secondsRemaining = 12; // Fast, realistic customer live packing window
  Timer? _timer;
  late AnimationController _pulseController;
  int _activeStage = 2; // 0: Received, 1: Batch Checked, 2: Sealing Pouch, 3: Dispatched

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
          _activeStage = 3;
        });
        // Automatically transition to rider dispatch for user
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) widget.onPackingComplete();
        });
      } else {
        setState(() {
          _secondsRemaining--;
          if (_secondsRemaining <= 4) _activeStage = 3;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Live Status Tag
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.mintSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.primaryLight.withValues(alpha: 0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sync, color: AppTheme.primary, size: 13),
                SizedBox(width: 5),
                Text(
                  'Live Order Status: Store Packing',
                  style: TextStyle(
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Pharmacist is Sealing Your Medicines',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppTheme.slateDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Partner: ${widget.chemist.name}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
        ),
        const SizedBox(height: 18),

        // Animated Radar Clock
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 160 + (_pulseController.value * 20),
                    height: 160 + (_pulseController.value * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryLight.withValues(alpha: 0.12 * (1 - _pulseController.value)),
                    ),
                  );
                },
              ),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.mintSurface,
                  border: Border.all(color: AppTheme.primaryLight, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer_outlined, color: AppTheme.primary, size: 22),
                    const SizedBox(height: 4),
                    Text(
                      '00:${_secondsRemaining < 10 ? "0$_secondsRemaining" : "$_secondsRemaining"}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: AppTheme.slateDark,
                      ),
                    ),
                    const Text(
                      'ESTIMATED PACK TIME',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // Live Pharmacy Checklist (Customer View)
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
                  const Text(
                    'SECURITY PACKING PROGRESS',
                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.mintSurface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.bagBarcode,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              _buildProgressRow(
                isDone: true,
                title: 'Order Confirmed by Licensed Pharmacist',
                subtitle: 'Prescription & salt formulations verified',
              ),
              const SizedBox(height: 8),
              _buildProgressRow(
                isDone: true,
                title: 'Batch & Expiry Quality Check',
                subtitle: 'Verified non-expired genuine stock (2027/2028)',
              ),
              const SizedBox(height: 8),
              _buildProgressRow(
                isDone: _activeStage >= 2,
                isInProgress: _activeStage == 2,
                title: 'Tamper-Evident Pouch Sealing',
                subtitle: 'Holographic safety strip applied to pouch',
              ),
              const SizedBox(height: 8),
              _buildProgressRow(
                isDone: _activeStage >= 3,
                isInProgress: _activeStage == 3,
                title: 'Porter Express Courier Assigned',
                subtitle: 'Pilot heading to store for pickup',
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Cancellation Locked Notice for customer
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_outline, color: AppTheme.amberWarning, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency Delivery In Progress',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.amberWarning,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'To guarantee 10-15 minute arrival, medicines have already been sealed for dispatch. Cancellation is locked.',
                      style: TextStyle(fontSize: 10, color: Colors.amber.shade900),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow({
    required bool isDone,
    bool isInProgress = false,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDone)
          const Icon(Icons.check_circle, color: AppTheme.primary, size: 16)
        else if (isInProgress)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary),
          )
        else
          const Icon(Icons.radio_button_unchecked, color: AppTheme.slateMuted, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isDone || isInProgress ? FontWeight.bold : FontWeight.w500,
                  color: isDone || isInProgress ? AppTheme.slateDark : AppTheme.slateMuted,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 9.5, color: AppTheme.slateMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
