import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../theme/app_theme.dart';

class ChemistInvoiceDialog extends StatelessWidget {
  final PartnerChemist chemist;
  final List<CartItem> cart;
  final BillSplit billSplit;
  final String orderId;
  final String bagBarcode;
  final String customerPhone;

  const ChemistInvoiceDialog({
    super.key,
    required this.chemist,
    required this.cart,
    required this.billSplit,
    required this.orderId,
    required this.bagBarcode,
    required this.customerPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            color: AppTheme.slateDark,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.receipt_long, color: AppTheme.primaryLight, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Official Chemist Tax Invoice',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
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

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chemist header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chemist.name,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              chemist.address,
                              style: const TextStyle(fontSize: 9.5, color: AppTheme.slateMuted),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'DL: ${chemist.drugLicenseNo}\nGSTIN: ${chemist.gstin}',
                              style: const TextStyle(
                                fontSize: 9,
                                fontFamily: 'monospace',
                                color: AppTheme.slateMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.mintSurface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'INV-TM-$orderId',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDark,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  // Customer & Barcode
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Billed To', style: TextStyle(fontSize: 8, color: AppTheme.slateMuted)),
                            Text(customerPhone, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Security Pouch', style: TextStyle(fontSize: 8, color: AppTheme.slateMuted)),
                            Text(bagBarcode,
                                style: const TextStyle(
                                    fontSize: 10.5, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Item list
                  const Text('Prescribed Items',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppTheme.slateDark)),
                  const SizedBox(height: 6),
                  ...cart.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.medicine.brandName,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                Text(
                                  '${item.medicine.genericSalt} • Batch: D650-84 (Exp: 08/2028)',
                                  style: const TextStyle(fontSize: 8.5, color: AppTheme.slateMuted),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${item.quantity} x ₹${item.medicine.mrp.toInt()} = ₹${item.total.toInt()}',
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 16),

                  // Bill split
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Medicine Total (Incl. 12% GST)', style: TextStyle(fontSize: 10, color: AppTheme.slateMuted)),
                      Text('₹${billSplit.medicineTotal.toInt()}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Hyperlocal Porter Courier (2.5 km)', style: TextStyle(fontSize: 10, color: AppTheme.slateMuted)),
                      Text('₹${billSplit.deliveryFee.toInt()}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Priority Handling Fee', style: TextStyle(fontSize: 10, color: AppTheme.slateMuted)),
                      Text('₹${billSplit.priorityHandlingFee.toInt()}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount Paid', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
                      Text(
                        '₹${billSplit.totalPayable.toInt()}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.mintSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.primaryLight.withOpacity(0.4)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user, color: AppTheme.primary, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'Digitally Signed by Licensed Pharmacist • Reg: KA-PH-84920',
                          style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.check, size: 16),
              label: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
