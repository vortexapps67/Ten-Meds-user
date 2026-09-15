'use client';

import React, { useState, useMemo } from 'react';
import { MobileFrame } from '../components/common/MobileFrame';
import { Header } from '../components/common/Header';
import { StepController } from '../components/common/StepController';
import { Screen1_EmergencyLanding } from '../components/screens/Screen1_EmergencyLanding';
import { Screen2_InstantCart } from '../components/screens/Screen2_InstantCart';
import { Screen3_ChemistPack } from '../components/screens/Screen3_ChemistPack';
import { Screen4_PorterDispatch } from '../components/screens/Screen4_PorterDispatch';
import { Screen5_DoorstepHandover } from '../components/screens/Screen5_DoorstepHandover';
import { Screen6_OrderComplete } from '../components/screens/Screen6_OrderComplete';
import { SubstituteModal } from '../components/modals/SubstituteModal';
import { PrescriptionUploadModal } from '../components/modals/PrescriptionUploadModal';
import { InvoiceModal } from '../components/modals/InvoiceModal';
import {
  OrderState,
  OrderStep,
  MedicineSKU,
  CartItem,
  PaymentMethod,
  BillSplit,
  PrescriptionData,
} from '../types/order';
import {
  EMERGENCY_CATALOG,
  DEFAULT_PARTNER_CHEMIST,
  DEFAULT_RIDER,
} from '../data/emergencyCatalog';

export default function Home() {
  // Mobile device simulation state
  const [isMobileDeviceFrame, setIsMobileDeviceFrame] = useState(true);

  // Initial order state
  const [orderState, setOrderState] = useState<OrderState>({
    orderId: '84920',
    currentStep: 1,
    customerPhone: '+91 98451 90234',
    customerAddress: '#104, Green Glen Layout, Bellandur, Bengaluru',
    partnerChemist: DEFAULT_PARTNER_CHEMIST,
    cart: [
      // Pre-seed with the user's workflow sample: ~₹400 total
      { medicine: EMERGENCY_CATALOG[3], quantity: 1 }, // Augmentin 625 Duo: ₹204
      { medicine: EMERGENCY_CATALOG[5], quantity: 1 }, // Pan-D: ₹198
      // Total medicine: ₹402 (~₹400)
    ],
    paymentMethod: 'COD',
    prescription: undefined,
    tamperBagBarcode: 'TM-84920-BAG',
    chemistPackingSecondsRemaining: 75,
    rider: DEFAULT_RIDER,
    deliveryOtp: '7419',
  });

  // Modal states
  const [isSubstituteModalOpen, setIsSubstituteModalOpen] = useState(false);
  const [isPrescriptionModalOpen, setIsPrescriptionModalOpen] = useState(false);
  const [isInvoiceModalOpen, setIsInvoiceModalOpen] = useState(false);

  // Edge case simulation
  const [isDriverGlitch, setIsDriverGlitch] = useState(false);

  // Calculate bill split according to the user's workflow:
  // Medicine Total (MRP)
  // Dynamic Porter Delivery Fee (Distance-based: ₹50)
  // Urgent Handling Fee: ₹20
  // To Pay: ₹470 (or exact sum)
  const billSplit: BillSplit = useMemo(() => {
    const medicineTotal = orderState.cart.reduce(
      (acc, item) => acc + item.medicine.mrp * item.quantity,
      0
    );
    const deliveryFee = 50;
    const priorityHandlingFee = 20;
    const totalPayable = medicineTotal > 0 ? medicineTotal + deliveryFee + priorityHandlingFee : 0;
    return {
      medicineTotal,
      deliveryFee,
      priorityHandlingFee,
      totalPayable,
    };
  }, [orderState.cart]);

  // Cart operations
  const addToCart = (med: MedicineSKU) => {
    setOrderState((prev) => {
      const existing = prev.cart.find((i) => i.medicine.id === med.id);
      if (existing) {
        return {
          ...prev,
          cart: prev.cart.map((i) =>
            i.medicine.id === med.id ? { ...i, quantity: i.quantity + 1 } : i
          ),
        };
      }
      return {
        ...prev,
        cart: [...prev.cart, { medicine: med, quantity: 1 }],
      };
    });
  };

  const removeFromCart = (medId: string) => {
    setOrderState((prev) => ({
      ...prev,
      cart: prev.cart
        .map((i) => (i.medicine.id === medId ? { ...i, quantity: i.quantity - 1 } : i))
        .filter((i) => i.quantity > 0),
    }));
  };

  const setPaymentMethod = (method: PaymentMethod) => {
    setOrderState((prev) => ({ ...prev, paymentMethod: method }));
  };

  const handlePrescriptionUploaded = (prescription: PrescriptionData) => {
    setOrderState((prev) => ({ ...prev, prescription }));
  };

  const handleAcceptSubstitute = () => {
    const dolo650 = EMERGENCY_CATALOG.find((m) => m.brandName === 'Dolo 650');
    if (dolo650) {
      addToCart(dolo650);
    }
  };

  const resetOrder = () => {
    setOrderState({
      orderId: Math.floor(10000 + Math.random() * 90000).toString(),
      currentStep: 1,
      customerPhone: '+91 98451 90234',
      customerAddress: '#104, Green Glen Layout, Bellandur, Bengaluru',
      partnerChemist: DEFAULT_PARTNER_CHEMIST,
      cart: [
        { medicine: EMERGENCY_CATALOG[3], quantity: 1 },
        { medicine: EMERGENCY_CATALOG[5], quantity: 1 },
      ],
      paymentMethod: 'COD',
      prescription: undefined,
      tamperBagBarcode: `TM-${Math.floor(10000 + Math.random() * 90000)}-BAG`,
      chemistPackingSecondsRemaining: 75,
      rider: DEFAULT_RIDER,
      deliveryOtp: Math.floor(1000 + Math.random() * 9000).toString(),
    });
    setIsDriverGlitch(false);
  };

  return (
    <main className="min-h-screen bg-slate-950 flex flex-col items-center justify-start">
      {/* Main App Frame (Realistic Smartphone or Responsive Full Width) */}
      <MobileFrame
        isMobileDeviceFrame={isMobileDeviceFrame}
        setIsMobileDeviceFrame={setIsMobileDeviceFrame}
      >
        {/* Persistent Brand Header & 2.5km Geofence Indicator */}
        <Header
          chemistName={orderState.partnerChemist.name}
          step={orderState.currentStep}
        />

        {/* User-facing Active Order Progress Indicator */}
        {orderState.currentStep >= 3 && orderState.currentStep <= 5 && (
          <div className="bg-slate-900 border-b border-slate-800 px-4 py-2 flex items-center justify-between text-xs text-slate-300">
            <div className={`flex items-center space-x-1.5 ${orderState.currentStep === 3 ? 'text-emerald-400 font-bold' : orderState.currentStep > 3 ? 'text-white' : 'text-slate-500'}`}>
              <span className={`w-4 h-4 rounded-full flex items-center justify-center text-[10px] ${orderState.currentStep >= 3 ? 'bg-emerald-600 text-white' : 'bg-slate-800'}`}>1</span>
              <span>Packing</span>
            </div>
            <span className="text-slate-600">➔</span>
            <div className={`flex items-center space-x-1.5 ${orderState.currentStep === 4 ? 'text-emerald-400 font-bold' : orderState.currentStep > 4 ? 'text-white' : 'text-slate-500'}`}>
              <span className={`w-4 h-4 rounded-full flex items-center justify-center text-[10px] ${orderState.currentStep >= 4 ? 'bg-emerald-600 text-white' : 'bg-slate-800'}`}>2</span>
              <span>In-Transit</span>
            </div>
            <span className="text-slate-600">➔</span>
            <div className={`flex items-center space-x-1.5 ${orderState.currentStep === 5 ? 'text-emerald-400 font-bold' : 'text-slate-500'}`}>
              <span className={`w-4 h-4 rounded-full flex items-center justify-center text-[10px] ${orderState.currentStep === 5 ? 'bg-emerald-600 text-white' : 'bg-slate-800'}`}>3</span>
              <span>At Gate (OTP)</span>
            </div>
          </div>
        )}

        {/* Dynamic Screen Renderer */}
        {orderState.currentStep === 1 && (
          <Screen1_EmergencyLanding
            cart={orderState.cart}
            addToCart={addToCart}
            removeFromCart={removeFromCart}
            openPrescriptionModal={() => setIsPrescriptionModalOpen(true)}
            prescription={orderState.prescription}
            customerAddress={orderState.customerAddress}
            customerPhone={orderState.customerPhone}
            onProceedToCart={() =>
              setOrderState((prev) => ({ ...prev, currentStep: 2 }))
            }
          />
        )}

        {orderState.currentStep === 2 && (
          <Screen2_InstantCart
            cart={orderState.cart}
            billSplit={billSplit}
            paymentMethod={orderState.paymentMethod}
            setPaymentMethod={setPaymentMethod}
            prescription={orderState.prescription}
            openPrescriptionModal={() => setIsPrescriptionModalOpen(true)}
            removeFromCart={removeFromCart}
            onBack={() => setOrderState((prev) => ({ ...prev, currentStep: 1 }))}
            onConfirmOrder={() =>
              setOrderState((prev) => ({ ...prev, currentStep: 3 }))
            }
            triggerSubstituteModal={() => setIsSubstituteModalOpen(true)}
          />
        )}

        {orderState.currentStep === 3 && (
          <Screen3_ChemistPack
            orderState={orderState}
            onChemistPackedComplete={() =>
              setOrderState((prev) => ({ ...prev, currentStep: 4 }))
            }
          />
        )}

        {orderState.currentStep === 4 && (
          <Screen4_PorterDispatch
            orderState={orderState}
            isDriverGlitch={isDriverGlitch}
            onRiderArrived={() =>
              setOrderState((prev) => ({ ...prev, currentStep: 5 }))
            }
          />
        )}

        {orderState.currentStep === 5 && (
          <Screen5_DoorstepHandover
            orderState={orderState}
            billSplit={billSplit}
            onVerifyAndCompleteOrder={() =>
              setOrderState((prev) => ({ ...prev, currentStep: 6 }))
            }
          />
        )}

        {orderState.currentStep === 6 && (
          <Screen6_OrderComplete
            orderState={orderState}
            billSplit={billSplit}
            openInvoiceModal={() => setIsInvoiceModalOpen(true)}
            onReorderChronic={() => {
              alert('Chronic 30-Day Refill Reminder set! We will notify your partner chemist 48 hours prior.');
            }}
            onNewOrder={resetOrder}
          />
        )}
      </MobileFrame>

      {/* Edge Case Modals */}
      <SubstituteModal
        isOpen={isSubstituteModalOpen}
        onClose={() => setIsSubstituteModalOpen(false)}
        onAccept={handleAcceptSubstitute}
      />

      <PrescriptionUploadModal
        isOpen={isPrescriptionModalOpen}
        onClose={() => setIsPrescriptionModalOpen(false)}
        onPrescriptionUploaded={handlePrescriptionUploaded}
      />

      <InvoiceModal
        isOpen={isInvoiceModalOpen}
        onClose={() => setIsInvoiceModalOpen(false)}
        orderState={orderState}
        billSplit={billSplit}
      />
    </main>
  );
}
