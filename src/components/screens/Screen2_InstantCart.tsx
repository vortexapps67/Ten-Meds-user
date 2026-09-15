'use client';

import React from 'react';
import { ArrowLeft, ShieldAlert, ShieldCheck, Banknote, QrCode, Upload, Trash2, Zap, AlertCircle } from 'lucide-react';
import { CartItem, PaymentMethod, BillSplit, PrescriptionData } from '../../types/order';

interface Screen2Props {
  cart: CartItem[];
  billSplit: BillSplit;
  paymentMethod: PaymentMethod;
  setPaymentMethod: (method: PaymentMethod) => void;
  prescription?: PrescriptionData;
  openPrescriptionModal: () => void;
  removeFromCart: (medId: string) => void;
  onBack: () => void;
  onConfirmOrder: () => void;
  triggerSubstituteModal: () => void;
}

export const Screen2_InstantCart: React.FC<Screen2Props> = ({
  cart,
  billSplit,
  paymentMethod,
  setPaymentMethod,
  prescription,
  openPrescriptionModal,
  removeFromCart,
  onBack,
  onConfirmOrder,
  triggerSubstituteModal,
}) => {
  // Check if any cart item is Schedule H (requires Rx)
  const hasScheduleHItems = cart.some((item) => item.medicine.isScheduleH);
  const isPrescriptionRequiredAndMissing = hasScheduleHItems && !prescription;

  return (
    <div className="flex-1 flex flex-col p-4 pb-24 space-y-4">
      {/* Top Navigation */}
      <div className="flex items-center justify-between pb-2 border-b border-slate-200">
        <button
          onClick={onBack}
          className="flex items-center space-x-1.5 text-xs font-bold text-slate-700 hover:text-slate-900 transition"
        >
          <ArrowLeft className="w-4 h-4" />
          <span>Add More Medicines</span>
        </button>
        <span className="text-xs font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-full">
          Step 2 of 6: Instant Cart
        </span>
      </div>

      {/* Cart Items List */}
      <div className="space-y-2.5">
        <h3 className="text-xs font-bold text-slate-500 uppercase tracking-wider">
          Medicines in Cart ({cart.length})
        </h3>
        {cart.length === 0 ? (
          <div className="p-6 text-center bg-slate-50 rounded-xl border border-slate-200">
            <p className="text-xs text-slate-500">Your cart is empty.</p>
            <button
              onClick={onBack}
              className="mt-2 text-xs font-bold text-emerald-600 hover:underline"
            >
              Browse emergency medicines
            </button>
          </div>
        ) : (
          cart.map((item) => (
            <div
              key={item.medicine.id}
              className="p-3 bg-white border border-slate-200 rounded-xl shadow-xs flex items-center justify-between space-x-3"
            >
              <div className="flex-1 min-w-0">
                <div className="flex items-center space-x-1.5 flex-wrap">
                  <h4 className="font-bold text-sm text-slate-900 leading-tight">
                    {item.medicine.brandName}
                  </h4>
                  {item.medicine.isScheduleH && (
                    <span className="text-[9px] font-bold text-amber-700 bg-amber-50 border border-amber-200 px-1.5 py-0.2 rounded flex items-center space-x-0.5">
                      <ShieldAlert className="w-2.5 h-2.5 text-amber-600" />
                      <span>Schedule H</span>
                    </span>
                  )}
                </div>
                <p className="text-[11px] text-slate-500 truncate mt-0.5">
                  {item.medicine.genericSalt}
                </p>
                <p className="text-[10px] text-slate-400">
                  Qty: {item.quantity} • ₹{item.medicine.mrp} per unit
                </p>
              </div>

              <div className="flex items-center space-x-3 shrink-0">
                <span className="font-extrabold text-sm text-slate-900">
                  ₹{item.medicine.mrp * item.quantity}
                </span>
                <button
                  onClick={() => removeFromCart(item.medicine.id)}
                  className="text-slate-400 hover:text-rose-500 p-1 rounded transition"
                  title="Remove item"
                >
                  <Trash2 className="w-3.5 h-3.5" />
                </button>
              </div>
            </div>
          ))
        )}
      </div>

      {/* Schedule H Prescription Warning Banner */}
      {hasScheduleHItems && (
        <div className={`p-3.5 rounded-xl border text-xs ${
          prescription
            ? 'bg-emerald-50 border-emerald-200 text-emerald-900'
            : 'bg-amber-50 border-amber-200 text-amber-900'
        }`}>
          <div className="flex items-start space-x-2.5">
            {prescription ? (
              <ShieldCheck className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
            ) : (
              <ShieldAlert className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
            )}
            <div className="flex-1">
              <p className="font-bold leading-tight">
                {prescription ? 'Doctor Prescription Verified' : 'Schedule H Law: Prescription Mandated'}
              </p>
              <p className="text-[11px] mt-0.5 opacity-90">
                {prescription
                  ? `Attached: ${prescription.fileName}. Licensed pharmacist will review during 90s packing.`
                  : 'Contains regulated drugs (Antibiotics/Specialized). Government regulations prohibit dispatch without a doctor prescription.'}
              </p>
              {!prescription && (
                <button
                  onClick={openPrescriptionModal}
                  className="mt-2.5 px-3 py-1.5 bg-amber-600 hover:bg-amber-700 text-white font-bold rounded-lg text-xs shadow-xs transition flex items-center space-x-1"
                >
                  <Upload className="w-3.5 h-3.5" />
                  <span>Snap Doctor Slip Now</span>
                </button>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Transparent Bill Split Card */}
      <div className="bg-slate-50 border border-slate-200/90 rounded-2xl p-3.5 space-y-2 text-xs">
        <h3 className="font-bold text-slate-700 uppercase tracking-wider text-[10px] pb-1 border-b border-slate-200">
          Transparent Line-Item Bill Split
        </h3>

        <div className="flex items-center justify-between text-slate-600">
          <span>Medicine Total (MRP)</span>
          <span className="font-semibold text-slate-800">₹{billSplit.medicineTotal}</span>
        </div>

        <div className="flex items-center justify-between text-slate-600">
          <div className="flex items-center space-x-1">
            <span>Dynamic Porter Delivery Fee</span>
            <span className="text-[9px] bg-slate-200 text-slate-700 px-1.5 py-0.2 rounded font-mono">
              &lt;2.5 km
            </span>
          </div>
          <span className="font-semibold text-slate-800">₹{billSplit.deliveryFee}</span>
        </div>

        <div className="flex items-center justify-between text-slate-600">
          <div className="flex items-center space-x-1">
            <span>Priority Emergency Handling</span>
            <span className="text-[9px] bg-emerald-100 text-emerald-800 px-1 py-0.2 rounded font-bold">
              10-15 Min SLA
            </span>
          </div>
          <span className="font-semibold text-slate-800">₹{billSplit.priorityHandlingFee}</span>
        </div>

        <div className="pt-2 border-t-2 border-slate-300 flex items-center justify-between text-sm font-extrabold text-slate-900">
          <span>Total To Pay</span>
          <span className="text-base text-emerald-700">₹{billSplit.totalPayable}</span>
        </div>
      </div>

      {/* Payment Selection */}
      <div className="space-y-2">
        <h3 className="text-xs font-bold text-slate-500 uppercase tracking-wider">
          Select Doorstep Payment
        </h3>
        <div className="grid grid-cols-2 gap-2">
          {/* COD */}
          <button
            type="button"
            onClick={() => setPaymentMethod('COD')}
            className={`p-3 rounded-xl border text-left transition flex flex-col justify-between space-y-2 ${
              paymentMethod === 'COD'
                ? 'border-emerald-600 bg-emerald-50/70 ring-2 ring-emerald-500/20'
                : 'border-slate-200 bg-white hover:bg-slate-50'
            }`}
          >
            <div className="flex items-center justify-between">
              <Banknote className={`w-5 h-5 ${paymentMethod === 'COD' ? 'text-emerald-600' : 'text-slate-500'}`} />
              {paymentMethod === 'COD' && (
                <span className="h-2 w-2 rounded-full bg-emerald-600"></span>
              )}
            </div>
            <div>
              <p className="font-bold text-xs text-slate-900">Cash on Delivery</p>
              <p className="text-[10px] text-slate-500">Pay cash at door upon OTP</p>
            </div>
          </button>

          {/* UPI */}
          <button
            type="button"
            onClick={() => setPaymentMethod('UPI')}
            className={`p-3 rounded-xl border text-left transition flex flex-col justify-between space-y-2 ${
              paymentMethod === 'UPI'
                ? 'border-emerald-600 bg-emerald-50/70 ring-2 ring-emerald-500/20'
                : 'border-slate-200 bg-white hover:bg-slate-50'
            }`}
          >
            <div className="flex items-center justify-between">
              <QrCode className={`w-5 h-5 ${paymentMethod === 'UPI' ? 'text-emerald-600' : 'text-slate-500'}`} />
              {paymentMethod === 'UPI' && (
                <span className="h-2 w-2 rounded-full bg-emerald-600"></span>
              )}
            </div>
            <div>
              <p className="font-bold text-xs text-slate-900">Instant UPI</p>
              <p className="text-[10px] text-slate-500">GPay / PhonePe / QR at door</p>
            </div>
          </button>
        </div>
      </div>

      {/* Order Lock Floating CTA */}
      <div className="fixed bottom-0 left-0 right-0 max-w-md mx-auto p-3 z-40 bg-gradient-to-t from-slate-900/40 via-slate-900/10 to-transparent">
        <button
          onClick={onConfirmOrder}
          disabled={isPrescriptionRequiredAndMissing || cart.length === 0}
          className={`w-full py-3.5 px-4 rounded-2xl font-black text-sm shadow-xl flex items-center justify-between transition ${
            isPrescriptionRequiredAndMissing || cart.length === 0
              ? 'bg-slate-400 text-slate-200 cursor-not-allowed'
              : 'bg-emerald-600 hover:bg-emerald-700 text-white shadow-emerald-900/30 active:scale-[0.99]'
          }`}
        >
          <div className="text-left">
            <span className="text-[10px] text-emerald-100 block font-normal">
              {paymentMethod === 'COD' ? 'Cash on Delivery Handover' : 'UPI Doorstep Payment'}
            </span>
            <span className="text-base font-extrabold">₹{billSplit.totalPayable}</span>
          </div>

          <div className="flex items-center space-x-1.5 font-bold text-xs">
            {isPrescriptionRequiredAndMissing ? (
              <span>Upload Rx to Unlock</span>
            ) : (
              <>
                <Zap className="w-4 h-4 fill-white" />
                <span>Confirm & Dispatch Pharmacist</span>
              </>
            )}
          </div>
        </button>
      </div>
    </div>
  );
};
