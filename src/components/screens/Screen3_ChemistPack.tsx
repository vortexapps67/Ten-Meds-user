'use client';

import React, { useState, useEffect } from 'react';
import { Clock, ShieldCheck, Lock, Package, CheckCircle2, ChevronRight, AlertCircle, RefreshCw } from 'lucide-react';
import { OrderState } from '../../types/order';

interface Screen3Props {
  orderState: OrderState;
  onChemistPackedComplete: () => void;
}

export const Screen3_ChemistPack: React.FC<Screen3Props> = ({
  orderState,
  onChemistPackedComplete,
}) => {
  const [seconds, setSeconds] = useState(12);

  useEffect(() => {
    const timer = setInterval(() => {
      setSeconds((prev) => {
        if (prev <= 1) {
          clearInterval(timer);
          setTimeout(() => {
            onChemistPackedComplete();
          }, 800);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);

    return () => clearInterval(timer);
  }, [onChemistPackedComplete]);

  return (
    <div className="flex-1 flex flex-col p-4 pb-20 space-y-4">
      {/* Top Status Header */}
      <div className="text-center pt-2 pb-1">
        <span className="text-xs font-bold text-emerald-700 bg-emerald-50 px-3 py-1 rounded-full border border-emerald-200 inline-flex items-center space-x-1.5">
          <RefreshCw className="w-3 h-3 text-emerald-600 animate-spin" />
          <span>Live Order Status: Store Packing</span>
        </span>
        <h2 className="text-lg font-black text-slate-900 mt-2">
          Pharmacist is Sealing Your Medicines
        </h2>
        <p className="text-xs text-slate-500 max-w-xs mx-auto mt-0.5">
          Partner Chemist: <strong>{orderState.partnerChemist.name}</strong>
        </p>
      </div>

      {/* Central Visual Countdown & Pulse Ring */}
      <div className="flex flex-col items-center justify-center py-4">
        <div className="relative w-40 h-40 flex items-center justify-center">
          <div className="absolute inset-0 rounded-full bg-emerald-100/70 radar-glow"></div>
          <div className="absolute inset-3 rounded-full bg-emerald-50 border-2 border-emerald-400"></div>

          <div className="relative z-10 flex flex-col items-center text-center">
            <Clock className="w-6 h-6 text-emerald-600 mb-1" />
            <span className="text-3xl font-black text-slate-900 tracking-tight font-mono">
              00:{seconds < 10 ? `0${seconds}` : seconds}
            </span>
            <span className="text-[9px] font-bold text-emerald-700 uppercase tracking-wider mt-0.5">
              ESTIMATED PACK TIME
            </span>
          </div>
        </div>
      </div>

      {/* Tamper-Proof Security Bag Details */}
      <div className="bg-slate-50 border border-slate-200/90 rounded-2xl p-3.5 space-y-2.5 text-xs">
        <div className="flex items-center justify-between pb-2 border-b border-slate-200">
          <div className="flex items-center space-x-1.5">
            <Package className="w-4 h-4 text-emerald-600" />
            <span className="font-bold text-slate-900 text-xs">Assigned Tamper-Proof Pouch</span>
          </div>
          <span className="font-mono font-black text-emerald-800 bg-emerald-100/80 px-2 py-0.5 rounded text-[11px]">
            {orderState.tamperBagBarcode}
          </span>
        </div>

        <div className="space-y-1.5 text-[11px] text-slate-600">
          <div className="flex items-start space-x-2">
            <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600 shrink-0 mt-0.5" />
            <span>Pharmacist verifying medicine batches & 2027/2028 expiry dates.</span>
          </div>
          <div className="flex items-start space-x-2">
            <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600 shrink-0 mt-0.5" />
            <span>Applying green holographic tamper security seal #TM-84920.</span>
          </div>
          <div className="flex items-start space-x-2">
            <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600 shrink-0 mt-0.5" />
            <span>Printed official GST tax invoice inserted in outer sleeve.</span>
          </div>
        </div>
      </div>

      {/* Cancellation Lock Notification for customer */}
      <div className="bg-amber-50 border border-amber-200 rounded-xl p-3 flex items-start space-x-2.5 text-xs text-amber-900">
        <Lock className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
        <div>
          <p className="font-bold">Emergency Delivery In Progress</p>
          <p className="text-[11px] text-amber-800/90 mt-0.5">
            To guarantee 10-15 minute arrival, medicines have already been sealed for dispatch. Cancellation is locked.
          </p>
        </div>
      </div>
    </div>
  );
};
