import 'package:flutter/material.dart';
import 'models/medicine.dart';
import 'data/catalog_data.dart';
import 'theme/app_theme.dart';
import 'widgets/ten_meds_header.dart';
import 'widgets/substitute_dialog.dart';
import 'widgets/prescription_upload_dialog.dart';
import 'widgets/chemist_invoice_dialog.dart';
import 'screens/screen1_emergency_landing.dart';
import 'screens/screen2_instant_cart.dart';
import 'screens/screen3_chemist_pack.dart';
import 'screens/screen4_porter_dispatch.dart';
import 'screens/screen5_doorstep_handover.dart';
import 'screens/screen6_order_complete.dart';

void main() {
  runApp(const TenMedsApp());
}

class TenMedsApp extends StatelessWidget {
  const TenMedsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ten Meds — Emergency 10-15 Min Medicine Delivery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainWorkflowScreen(),
    );
  }
}

class MainWorkflowScreen extends StatefulWidget {
  const MainWorkflowScreen({super.key});

  @override
  State<MainWorkflowScreen> createState() => _MainWorkflowScreenState();
}

class _MainWorkflowScreenState extends State<MainWorkflowScreen> {
  int _currentStep = 1;
  final String _orderId = '84920';
  final String _customerPhone = '+91 98451 90234';
  final String _customerAddress = '#104, Green Glen Layout, Bellandur, Bengaluru';
  final String _bagBarcode = 'TM-84920-BAG';
  final String _deliveryOtp = '7419';

  PaymentMethod _paymentMethod = PaymentMethod.cod;
  PrescriptionData? _prescription;

  late List<CartItem> _cart;

  @override
  void initState() {
    super.initState();
    _resetDemoData();
  }

  void _resetDemoData() {
    setState(() {
      _currentStep = 1;
      _paymentMethod = PaymentMethod.cod;
      _prescription = null;
      _cart = [
        CartItem(medicine: emergencyCatalog[3], quantity: 1), // Augmentin 625: ₹204
        CartItem(medicine: emergencyCatalog[5], quantity: 1), // Pan-D: ₹198
      ];
    });
  }

  BillSplit get _billSplit {
    final medTotal = _cart.fold<double>(0.0, (sum, i) => sum + i.total);
    return BillSplit(medicineTotal: medTotal);
  }

  void _addToCart(MedicineSKU med) {
    setState(() {
      final idx = _cart.indexWhere((i) => i.medicine.id == med.id);
      if (idx != -1) {
        _cart[idx].quantity++;
      } else {
        _cart.add(CartItem(medicine: med, quantity: 1));
      }
    });
  }

  void _removeFromCart(String medId) {
    setState(() {
      final idx = _cart.indexWhere((i) => i.medicine.id == medId);
      if (idx != -1) {
        if (_cart[idx].quantity > 1) {
          _cart[idx].quantity--;
        } else {
          _cart.removeAt(idx);
        }
      }
    });
  }

  void _openPrescriptionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => PrescriptionUploadDialog(
        onPrescriptionUploaded: (data) {
          setState(() => _prescription = data);
        },
      ),
    );
  }

  void _openSubstituteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SubstituteDialog(
        onAccept: () {
          final dolo = emergencyCatalog.firstWhere((m) => m.brandName == 'Dolo 650');
          _addToCart(dolo);
        },
      ),
    );
  }

  void _openInvoiceDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ChemistInvoiceDialog(
        chemist: defaultPartnerChemist,
        cart: _cart,
        billSplit: _billSplit,
        orderId: _orderId,
        bagBarcode: _bagBarcode,
        customerPhone: _customerPhone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOrderInProgress = _currentStep >= 3 && _currentStep <= 5;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TenMedsHeader(
        chemistName: defaultPartnerChemist.name,
        onHelpTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Connecting to 24x7 Emergency Pharmacist Hotline: 1800-TEN-MEDS'),
              backgroundColor: AppTheme.primary,
            ),
          );
        },
      ),
      body: Column(
        children: [
          // User-facing Order Tracking Progress Bar (Only visible while an active order is running)
          if (isOrderInProgress)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: AppTheme.slateDark,
                border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCustomerStepPill(
                    stepNum: 1,
                    title: 'Packing',
                    isActive: _currentStep == 3,
                    isDone: _currentStep > 3,
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white38),
                  _buildCustomerStepPill(
                    stepNum: 2,
                    title: 'In-Transit',
                    isActive: _currentStep == 4,
                    isDone: _currentStep > 4,
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white38),
                  _buildCustomerStepPill(
                    stepNum: 3,
                    title: 'At Gate (OTP)',
                    isActive: _currentStep == 5,
                    isDone: _currentStep > 5,
                  ),
                ],
              ),
            ),

          // Customer Screen
          Expanded(
            child: IndexedStack(
              index: _currentStep - 1,
              children: [
                Screen1EmergencyLanding(
                  cart: _cart,
                  onAddToCart: _addToCart,
                  onRemoveFromCart: _removeFromCart,
                  onOpenPrescriptionDialog: _openPrescriptionDialog,
                  onOpenSubstituteDialog: _openSubstituteDialog,
                  prescription: _prescription,
                  customerAddress: _customerAddress,
                  customerPhone: _customerPhone,
                  onProceedToCart: () => setState(() => _currentStep = 2),
                ),
                Screen2InstantCart(
                  cart: _cart,
                  billSplit: _billSplit,
                  paymentMethod: _paymentMethod,
                  onSelectPayment: (m) => setState(() => _paymentMethod = m),
                  prescription: _prescription,
                  onOpenPrescriptionDialog: _openPrescriptionDialog,
                  onRemoveItem: _removeFromCart,
                  onBack: () => setState(() => _currentStep = 1),
                  onConfirmOrder: () => setState(() => _currentStep = 3),
                ),
                Screen3ChemistPack(
                  chemist: defaultPartnerChemist,
                  bagBarcode: _bagBarcode,
                  onPackingComplete: () => setState(() => _currentStep = 4),
                ),
                Screen4PorterDispatch(
                  rider: defaultRider,
                  onRiderArrived: () => setState(() => _currentStep = 5),
                ),
                Screen5DoorstepHandover(
                  billSplit: _billSplit,
                  paymentMethod: _paymentMethod,
                  deliveryOtp: _deliveryOtp,
                  bagBarcode: _bagBarcode,
                  onCompleteOrder: () => setState(() => _currentStep = 6),
                ),
                Screen6OrderComplete(
                  billSplit: _billSplit,
                  orderId: _orderId,
                  chemist: defaultPartnerChemist,
                  rider: defaultRider,
                  onOpenInvoice: _openInvoiceDialog,
                  onNewOrder: _resetDemoData,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerStepPill({
    required int stepNum,
    required String title,
    required bool isActive,
    required bool isDone,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 9,
          backgroundColor: isDone
              ? AppTheme.primary
              : isActive
                  ? AppTheme.primaryLight
                  : Colors.white24,
          child: isDone
              ? const Icon(Icons.check, size: 10, color: Colors.white)
              : Text(
                  '$stepNum',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppTheme.slateDark : Colors.white,
                  ),
                ),
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: TextStyle(
            color: isActive || isDone ? Colors.white : Colors.white54,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
