'use client';

import React, { useEffect } from 'react';
import confetti from 'canvas-confetti';
import { CheckCircle, Download, FileText, RefreshCw, Star, ArrowRight, HeartPulse, ShieldCheck, Clock } from 'lucide-react';
import { OrderState, BillSplit } from '../../types/order';

interface Screen6Props {
  orderState: OrderState;
  billSplit: BillSplit;
  openInvoiceModal: () => void;
  onReorderChronic: () => void;
  onNewOrder: () => void;
}

export const Screen6_OrderComplete: React.FC<Screen6Props> = ({
  orderState,
  billSplit,
  openInvoiceModal,
  onReorderChronic,
  onNewOrder,
}) => {
  useEffect(() => {
    // Trigger celebratory confetti on screen render
    confetti({
      particleCount: 70,
      spread: 60,
      origin: { y: 0.6 },
      colors: ['#059669', '#10B981', '#34D399', '#064E3B'],
    });
  }, []);

  return (
    <div className="flex-1 flex flex-col p-4 pb-20 space-y-4">
      {/* Success Badge */}
      <div className="text-center pt-3 pb-1 space-y-2">
        <div className="w-16 h-16 rounded-3xl bg-emerald-100 text-emerald-600 mx-auto flex items-center justify-center shadow-lg shadow-emerald-500/10">
          <CheckCircle className="w-9 h-9 text-emerald-600" />
        </div>
        <div>
          <h2 className="text-xl font-black text-slate-900 tracking-tight">
            Delivered in 11 Mins 42 Secs!
          </h2>
          <p className="text-xs text-slate-500 mt-0.5">
            Emergency medicine safely received & tamper-seal verified.
          </p>
        </div>
      </div>

      {/* Chemist Tax Invoice Quick Card */}
      <div className="bg-slate-50 border border-slate-200/90 rounded-2xl p-4 space-y-3">
        <div className="flex items-start justify-between">
          <div className="flex items-center space-x-2">
            <FileText className="w-5 h-5 text-emerald-600" />
            <div>
              <h4 className="font-bold text-xs text-slate-900">Chemist Digital Tax Invoice</h4>
              <p className="text-[10px] text-slate-500 font-mono">INV-TM-{orderState.orderId} • GST Compliant</p>
            </div>
          </div>
          <button
            onClick={openInvoiceModal}
            className="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white font-bold rounded-lg text-xs shadow-xs transition flex items-center space-x-1"
          >
            <Download className="w-3.5 h-3.5" />
            <span>Download Invoice</span>
          </button>
        </div>

        <div className="pt-2 border-t border-slate-200/80 flex items-center justify-between text-[11px] text-slate-600">
          <span>Pharmacist: {orderState.partnerChemist.name}</span>
          <span className="font-bold text-slate-800">Paid: ₹{billSplit.totalPayable}</span>
        </div>
      </div>

      {/* Chronic Medicine Auto-Reorder Card */}
      <div className="bg-gradient-to-br from-emerald-50 to-teal-50 border border-emerald-200 rounded-2xl p-4 space-y-2.5">
        <div className="flex items-center space-x-2 text-emerald-900 font-bold text-xs">
          <HeartPulse className="w-4 h-4 text-emerald-600" />
          <span>Chronic Medication 30-Day Refill</span>
        </div>
        <p className="text-xs text-emerald-950/80 leading-relaxed">
          Need recurring monthly refills for maintenance drugs? Ten Meds can auto-lock stock at your neighborhood chemist 2 days before your dose runs out.
        </p>
        <button
          onClick={onReorderChronic}
          className="w-full py-2.5 bg-white border border-emerald-300 hover:bg-emerald-100/50 text-emerald-800 font-bold rounded-xl text-xs shadow-xs transition flex items-center justify-center space-x-1.5"
        >
          <RefreshCw className="w-3.5 h-3.5" />
          <span>Enable 30-Day Chronic Refill Reminder</span>
        </button>
      </div>

      {/* Delivery Feedback Rating */}
      <div className="bg-white border border-slate-200 rounded-2xl p-3.5 text-center space-y-2">
        <p className="font-bold text-xs text-slate-800">Rate Porter Rider {orderState.rider.name}</p>
        <div className="flex justify-center space-x-2 text-amber-400">
          {[1, 2, 3, 4, 5].map((s) => (
            <button key={s} className="p-1 hover:scale-110 transition">
              <Star className="w-6 h-6 fill-amber-400 text-amber-400" />
            </button>
          ))}
        </div>
        <span className="text-[10px] text-slate-400 block">10-15 Min SLA Met • Sealed Bag Delivered</span>
      </div>

      {/* Fresh New Order */}
      <div className="pt-2">
        <button
          onClick={onNewOrder}
          className="w-full py-3.5 bg-slate-900 hover:bg-slate-800 text-white rounded-2xl font-bold text-xs shadow-lg transition flex items-center justify-center space-x-1.5"
        >
          <span>Start Another Emergency Search</span>
          <ArrowRight className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
};
