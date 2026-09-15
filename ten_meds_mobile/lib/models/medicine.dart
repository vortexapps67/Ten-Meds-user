class MedicineSKU {
  final String id;
  final String brandName;
  final String genericSalt;
  final String strength;
  final String dosageForm;
  final String stripSize;
  final double mrp;
  final String category;
  final bool isScheduleH;
  final bool inStock;
  final Map<String, dynamic>? substituteAvailable;

  const MedicineSKU({
    required this.id,
    required this.brandName,
    required this.genericSalt,
    required this.strength,
    required this.dosageForm,
    required this.stripSize,
    required this.mrp,
    required this.category,
    required this.isScheduleH,
    required this.inStock,
    this.substituteAvailable,
  });
}

class CartItem {
  final MedicineSKU medicine;
  int quantity;

  CartItem({
    required this.medicine,
    this.quantity = 1,
  });

  double get total => medicine.mrp * quantity;
}

enum PaymentMethod { cod, upi }

class BillSplit {
  final double medicineTotal;
  final double deliveryFee;
  final double priorityHandlingFee;

  const BillSplit({
    required this.medicineTotal,
    this.deliveryFee = 50.0,
    this.priorityHandlingFee = 20.0,
  });

  double get totalPayable =>
      medicineTotal > 0 ? medicineTotal + deliveryFee + priorityHandlingFee : 0;
}

class PrescriptionData {
  final String fileName;
  final String previewUrl;
  final String uploadedAt;
  final List<String> detectedSalts;

  const PrescriptionData({
    required this.fileName,
    required this.previewUrl,
    required this.uploadedAt,
    required this.detectedSalts,
  });
}

class PartnerChemist {
  final String name;
  final double distanceKm;
  final String drugLicenseNo;
  final String gstin;
  final String address;

  const PartnerChemist({
    required this.name,
    required this.distanceKm,
    required this.drugLicenseNo,
    required this.gstin,
    required this.address,
  });
}

class RiderDetails {
  final String name;
  final String phone;
  final String vehicleNumber;
  final double rating;
  final int etaMinutes;

  const RiderDetails({
    required this.name,
    required this.phone,
    required this.vehicleNumber,
    required this.rating,
    required this.etaMinutes,
  });
}
