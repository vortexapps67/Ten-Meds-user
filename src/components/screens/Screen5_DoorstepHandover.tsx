'use client';

import React, { useState } from 'react';
import { ShieldCheck, ShieldAlert, KeyRound, Banknote, QrCode, CheckCircle2, ChevronRight, AlertCircle, Phone } from 'lucide-react';
import { OrderState, BillSplit } from '../../types/order';

interface Screen5Props {
  orderState: OrderState;
  billSplit: BillSplit;
  onVerifyAndCompleteOrder: () => void;
}

export const Screen5_DoorstepHandover: React.FC<Screen5Props> = ({
  orderState,
  billSplit,
  onVerifyAndCompleteOrder,
}) => {
  const [isSealInspected, setIsSealInspected] = useState(false);

  return (
    <div className="flex-1 flex flex-col p-4 pb-20 space-y-4">
      {/* 100m Proximity Gate Alert */}
      <div className="bg-emerald-600 text-white p-3.5 rounded-2xl shadow-md flex items-center space-x-3 animate-pulse">
        <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center shrink-0">
          <ShieldCheck className="w-6 h-6 text-white" />
        </div>
        <div>
          <h3 className="font-black text-sm leading-tight">Rider is at your gate!</h3>
          <p className="text-xs text-emerald-100 mt-0.5">
            Please keep {orderState.paymentMethod === 'COD' ? `₹${billSplit.totalPayable} Cash` : 'UPI QR scanner'} ready.
          </p>
        </div>
      </div>

      {/* OTP Security Shield Card */}
      <div className="bg-gradient-to-b from-slate-900 to-slate-950 text-white rounded-3xl p-5 shadow-xl border border-slate-800 text-center space-y-3">
        <div className="flex items-center justify-center space-x-1.5 text-xs font-bold text-emerald-400 uppercase tracking-widest">
          <KeyRound className="w-4 h-4" />
          <span>4-Digit Secure Delivery OTP</span>
        </div>

        {/* Big OTP Digits Display */}
        <div className="flex items-center justify-center space-x-2.5 py-1">
          {orderState.deliveryOtp.split('').map((digit, idx) => (
            <div
              key={idx}
              className="w-14 h-16 rounded-2xl bg-slate-800/90 border-2 border-emerald-500/50 flex items-center justify-center font-mono font-black text-3xl text-white shadow-inner"
            >
              {digit}
            </div>
          ))}
        </div>

        {/* Security Warning */}
        <div className="p-3 bg-amber-500/10 border border-amber-500/30 rounded-xl text-[11px] text-amber-200 text-left flex items-start space-x-2">
          <ShieldAlert className="w-4 h-4 text-amber-400 shrink-0 mt-0.5" />
          <p>
            <strong>Do not share this OTP</strong> until you physically verify the green holographic security seal on pouch barcode <strong>{orderState.tamperBagBarcode}</strong>.
          </p>
        </div>
      </div>

      {/* Payment Settlement Card */}
      <div className="bg-slate-50 border border-slate-200 rounded-2xl p-4 space-y-2.5 text-xs">
        <div className="flex items-center justify-between pb-2 border-b border-slate-200">
          <span className="font-bold text-slate-700 uppercase tracking-wider text-[10px]">
            Payment Due at Handover
          </span>
          <span className="font-extrabold text-sm text-slate-900">
            ₹{billSplit.totalPayable}
          </span>
        </div>

        <div className="flex items-center justify-between text-slate-600">
          <div className="flex items-center space-x-2">
            {orderState.paymentMethod === 'COD' ? (
              <Banknote className="w-4 h-4 text-emerald-600" />
            ) : (
              <QrCode className="w-4 h-4 text-emerald-600" />
            )}
            <span className="font-semibold text-slate-800">
              {orderState.paymentMethod === 'COD' ? 'Cash on Delivery' : 'Rider Dynamic Porter UPI QR'}
            </span>
          </div>
          <span className="text-[11px] font-bold text-emerald-700 bg-emerald-100 px-2 py-0.5 rounded">
            Exact Amount: ₹{billSplit.totalPayable}
          </span>
        </div>

        <p className="text-[11px] text-slate-500">
          Chemist digital tax invoice with Drug License and batch numbers is stamped inside the outer bag pouch.
        </p>
      </div>

      {/* Mandatory Seal Checkbox */}
      <label className="flex items-start space-x-2.5 p-3 bg-white border border-slate-200 rounded-xl cursor-pointer hover:bg-slate-50 transition text-xs">
        <input
          type="checkbox"
          checked={isSealInspected}
          onChange={(e) => setIsSealInspected(e.target.checked)}
          className="mt-0.5 w-4 h-4 rounded text-emerald-600 focus:ring-emerald-500 border-slate-300"
        />
        <div className="text-slate-700">
          <span className="font-bold">I have checked the tamper-evident seal</span>
          <p className="text-[11px] text-slate-500">
            The pouch is intact and matches bag ID {orderState.tamperBagBarcode}.
          </p>
        </div>
      </label>

      {/* Complete Handover Action */}
      <div className="pt-2">
        <button
          onClick={onVerifyAndCompleteOrder}
          disabled={!isSealInspected}
          className={`w-full py-3.5 px-4 rounded-2xl font-black text-xs shadow-lg flex items-center justify-center space-x-2 transition ${
            isSealInspected
              ? 'bg-emerald-600 hover:bg-emerald-700 text-white shadow-emerald-900/20'
              : 'bg-slate-300 text-slate-500 cursor-not-allowed'
          }`}
        >
          <CheckCircle2 className="w-4 h-4" />
          <span>OTP Shared & Paid ₹{billSplit.totalPayable} ➔ Complete Order</span>
        </button>
      </div>
    </div>
  );
};
