import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../data/catalog_data.dart';
import '../theme/app_theme.dart';

class Screen1EmergencyLanding extends StatefulWidget {
  final List<CartItem> cart;
  final Function(MedicineSKU) onAddToCart;
  final Function(String) onRemoveFromCart;
  final VoidCallback onOpenPrescriptionDialog;
  final VoidCallback onOpenSubstituteDialog;
  final PrescriptionData? prescription;
  final String customerAddress;
  final String customerPhone;
  final VoidCallback onProceedToCart;

  const Screen1EmergencyLanding({
    super.key,
    required this.cart,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onOpenPrescriptionDialog,
    required this.onOpenSubstituteDialog,
    this.prescription,
    required this.customerAddress,
    required this.customerPhone,
    required this.onProceedToCart,
  });

  @override
  State<Screen1EmergencyLanding> createState() => _Screen1EmergencyLandingState();
}

class _Screen1EmergencyLandingState extends State<Screen1EmergencyLanding> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Fever & Pain',
    'Antibiotic',
    'Stomach & Acidity',
    'Pediatric',
    'Emergency & Cardiac',
  ];

  int _getQuantity(String medId) {
    final item = widget.cart.where((i) => i.medicine.id == medId).toList();
    return item.isNotEmpty ? item.first.quantity : 0;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = emergencyCatalog.where((med) {
      final matchesSearch = med.brandName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          med.genericSalt.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == 'All' || med.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    final totalItems = widget.cart.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalValue = widget.cart.fold<double>(0.0, (sum, item) => sum + item.total);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 90),
          children: [
            // GPS and Phone Anchor
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: AppTheme.surfaceGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 12,
                          backgroundColor: AppTheme.mintSurface,
                          child: Icon(Icons.near_me, color: AppTheme.primary, size: 12),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'DELIVERING TO',
                                style: TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                              Text(
                                widget.customerAddress,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.slateDark,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '1-Tap Verified',
                        style: TextStyle(fontSize: 8.5, color: AppTheme.slateMuted),
                      ),
                      Text(
                        widget.customerPhone,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Hero Prescription Upload Card
            Padding(
              padding: const EdgeInsets.all(14),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryDark, Color(0xFF022c22)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryDark.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.bolt, color: Colors.amber, size: 12),
                                    SizedBox(width: 3),
                                    Text(
                                      'PANIC MODE • 10-15 MIN DELIVERY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Have a Doctor\'s Prescription?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Snap your prescription. 24x7 chemist will pack & dispatch via Porter in 90 seconds.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 11,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: widget.onOpenPrescriptionDialog,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.camera_alt, color: AppTheme.slateDark, size: 24),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.white.withOpacity(0.15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              widget.prescription != null ? Icons.check_circle : Icons.upload_file,
                              color: widget.prescription != null ? AppTheme.primaryLight : Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.prescription != null
                                  ? 'Rx Uploaded (${widget.prescription!.fileName})'
                                  : 'Supports WhatsApp photo & Clinic slips',
                              style: const TextStyle(color: Colors.white, fontSize: 10.5),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: widget.onOpenPrescriptionDialog,
                          child: Text(
                            widget.prescription != null ? 'View Slip' : 'Snap Rx',
                            style: const TextStyle(
                              color: AppTheme.primaryLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search urgent medicines, salts (Dolo, Meftal, ORS)...',
                  hintStyle: const TextStyle(fontSize: 12, color: AppTheme.slateMuted),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.slateMuted, size: 18),
                  filled: true,
                  fillColor: AppTheme.surfaceGrey,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.borderGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.borderGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
                  ),
                ),
              ),
            ),

            // Category Chips
            Container(
              height: 36,
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: _categories.length,
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : AppTheme.slateDark,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.surfaceGrey,
                      side: BorderSide(
                        color: isSelected ? AppTheme.primary : AppTheme.borderGrey,
                      ),
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    ),
                  );
                },
              ),
            ),

            // Medicine List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Near You (<2.5 km)',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
                  ),
                  Text(
                    '${filtered.length} Medicines',
                    style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                  ),
                ],
              ),
            ),

            // Medicine Items
            ...filtered.map((med) {
              final qty = _getQuantity(med.id);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderGrey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                med.brandName,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceGrey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  med.dosageForm,
                                  style: const TextStyle(fontSize: 9, color: AppTheme.slateMuted),
                                ),
                              ),
                              if (med.isScheduleH) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.amber.shade300),
                                  ),
                                  child: const Text(
                                    'Rx',
                                    style: TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.amberWarning,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Salt: ${med.genericSalt}',
                            style: const TextStyle(fontSize: 10.5, color: AppTheme.slateMuted),
                          ),
                          Text(
                            'Pack: ${med.stripSize} • ${med.strength}',
                            style: const TextStyle(fontSize: 9.5, color: AppTheme.slateMuted),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                '₹${med.mrp.toInt()}',
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.mintSurface,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'MRP Incl. GST',
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Add button / counter
                    if (!med.inStock)
                      ElevatedButton(
                        onPressed: widget.onOpenSubstituteDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.amberWarning,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text('View Alt', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      )
                    else if (qty > 0)
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.mintSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.primaryLight),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => widget.onRemoveFromCart(med.id),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text('-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ),
                            Text(
                              '$qty',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                            InkWell(
                              onTap: () => widget.onAddToCart(med),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text('+', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () => widget.onAddToCart(med),
                        icon: const Icon(Icons.add, size: 14),
                        label: const Text('Add', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),

        // Floating Bottom Cart Bar
        if (totalItems > 0)
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: InkWell(
              onTap: widget.onProceedToCart,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryDark.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$totalItems ${totalItems == 1 ? "item" : "items"}',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Estimated Total',
                              style: TextStyle(color: Colors.white70, fontSize: 9.5),
                            ),
                            Text(
                              '₹${totalValue.toInt()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          'Review Cart & Bill',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
