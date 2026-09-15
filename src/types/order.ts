export type OrderStep = 1 | 2 | 3 | 4 | 5 | 6;

export interface MedicineSKU {
  id: string;
  brandName: string;
  genericSalt: string;
  strength: string;
  dosageForm: 'Tablet' | 'Syrup' | 'Injection' | 'Ointment' | 'Inhaler' | 'Sachet';
  stripSize: string;
  mrp: number;
  category: 'Fever & Pain' | 'Antibiotic' | 'Stomach & Acidity' | 'Pediatric' | 'Emergency & Cardiac' | 'Respiratory & Allergy';
  isScheduleH: boolean; // Requires prescription by Indian Law
  inStock: boolean;
  substituteAvailable?: {
    brandName: string;
    genericSalt: string;
    mrp: number;
    difference: string;
  };
}

export interface CartItem {
  medicine: MedicineSKU;
  quantity: number;
}

export type PaymentMethod = 'COD' | 'UPI';

export interface BillSplit {
  medicineTotal: number;
  deliveryFee: number;
  priorityHandlingFee: number;
  totalPayable: number;
}

export interface PrescriptionData {
  fileName: string;
  previewUrl: string;
  uploadedAt: string;
  detectedSalts?: string[];
}

export interface OrderState {
  orderId: string;
  currentStep: OrderStep;
  customerPhone: string;
  customerAddress: string;
  partnerChemist: {
    name: string;
    distanceKm: number;
    drugLicenseNo: string;
    gstin: string;
    address: string;
  };
  cart: CartItem[];
  paymentMethod: PaymentMethod;
  prescription?: PrescriptionData;
  tamperBagBarcode: string;
  chemistPackingSecondsRemaining: number;
  rider: {
    name: string;
    phone: string;
    vehicleNumber: string;
    rating: number;
    etaMinutes: number;
    currentLocation: { lat: number; lng: number };
  };
  deliveryOtp: string;
  completedAt?: string;
  isSubstitutionAccepted?: boolean;
}
