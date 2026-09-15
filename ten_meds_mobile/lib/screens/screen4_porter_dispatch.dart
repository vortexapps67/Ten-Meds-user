import 'dart:async';
import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../theme/app_theme.dart';

class Screen4PorterDispatch extends StatefulWidget {
  final RiderDetails rider;
  final bool isDriverGlitch;
  final VoidCallback onRiderArrived;

  const Screen4PorterDispatch({
    super.key,
    required this.rider,
    this.isDriverGlitch = false,
    required this.onRiderArrived,
  });

  @override
  State<Screen4PorterDispatch> createState() => _Screen4PorterDispatchState();
}

class _Screen4PorterDispatchState extends State<Screen4PorterDispatch> {
  int _etaMinutes = 5;
  double _routeProgress = 0.2;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          if (_routeProgress < 0.95) {
            _routeProgress += 0.15;
            if (_etaMinutes > 1) _etaMinutes--;
          } else {
            timer.cancel();
            // Automatically transition when rider arrives at gate
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (mounted) widget.onRiderArrived();
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNearGate = _routeProgress >= 0.8;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Live Proximity Chip
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isNearGate ? Colors.amber.shade50 : AppTheme.mintSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isNearGate ? Colors.amber.shade300 : AppTheme.primaryLight.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.two_wheeler,
                    color: isNearGate ? AppTheme.amberWarning : AppTheme.primary,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isNearGate ? 'Rider Arriving at Gate' : 'Porter Courier In-Transit',
                    style: TextStyle(
                      color: isNearGate ? AppTheme.amberWarning : AppTheme.primaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              isNearGate ? '< 100m Away' : 'ETA: ~$_etaMinutes Mins',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                fontSize: 11.5,
                color: isNearGate ? AppTheme.amberWarning : AppTheme.slateDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Rider Profile Card (User View)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderGrey),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppTheme.mintSurface,
                    child: Text(
                      widget.rider.name.substring(0, 2).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryDark,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.rider.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 10),
                                const SizedBox(width: 2),
                                Text(
                                  '${widget.rider.rating}',
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.amberWarning,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.rider.vehicleNumber,
                        style: const TextStyle(fontSize: 10.5, color: AppTheme.slateMuted),
                      ),
                      const Text(
                        'Porter Verified Express Pilot',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Masked Call Button (For User to call Rider)
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calling Porter Rider ${widget.rider.name} (Number Masked for Privacy)'),
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.phone, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Live Simulated Map Area
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: AppTheme.surfaceGrey,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.borderGrey),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Custom Paint Map Grid and Route
              CustomPaint(
                size: const Size(double.infinity, 250),
                painter: _MapRoutePainter(progress: _routeProgress),
              ),

              // Map Header Status
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.borderGrey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.gps_fixed, color: AppTheme.primary, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Porter Live GPS Tracking',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        isNearGate ? 'Near your gate' : '${(1.4 * (1 - _routeProgress)).toStringAsFixed(1)} km away',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Street Label
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.slateDark.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.navigation, color: AppTheme.primaryLight, size: 14),
                          SizedBox(width: 6),
                          Text(
                            '100ft Road ➔ 12th Main Indiranagar',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                      Text(
                        'ON TRACK',
                        style: TextStyle(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w900,
                          fontSize: 9.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // User action: Can tap to reveal OTP right away
        ElevatedButton.icon(
          onPressed: widget.onRiderArrived,
          icon: const Icon(Icons.key, size: 16),
          label: const Text(
            'Rider is Here • View Handover OTP',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(46),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}

class _MapRoutePainter extends CustomPainter {
  final double progress;
  _MapRoutePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    // Roads
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), roadPaint);
    canvas.drawLine(Offset(size.width * 0.25, 0), Offset(size.width * 0.25, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height), roadPaint);

    // Route path (green dashed)
    final routePaint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final startPoint = Offset(size.width * 0.15, size.height * 0.7);
    final midPoint = Offset(size.width * 0.7, size.height * 0.7);
    final endPoint = Offset(size.width * 0.7, size.height * 0.3);

    final path = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..lineTo(midPoint.dx, midPoint.dy)
      ..lineTo(endPoint.dx, endPoint.dy);

    canvas.drawPath(path, routePaint);

    // Store marker
    final storePaint = Paint()..color = AppTheme.primaryDark;
    canvas.drawCircle(startPoint, 8, storePaint);

    // Destination gate marker
    final destPaint = Paint()..color = Colors.red;
    canvas.drawCircle(endPoint, 8, destPaint);

    // Bike marker position along path
    final bikeX = startPoint.dx + ((midPoint.dx - startPoint.dx) * progress);
    final bikeY = startPoint.dy;

    final bikePaint = Paint()..color = AppTheme.primary;
    canvas.drawCircle(Offset(bikeX, bikeY), 12, bikePaint);

    final bikeWhite = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(bikeX, bikeY), 6, bikeWhite);
  }

  @override
  bool shouldRepaint(covariant _MapRoutePainter oldDelegate) => oldDelegate.progress != progress;
}
