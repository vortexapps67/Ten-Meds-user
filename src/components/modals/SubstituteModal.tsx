'use client';

import React, { useState, useEffect } from 'react';
import { AlertTriangle, CheckCircle2, XCircle, Clock, ShieldCheck } from 'lucide-react';

interface SubstituteModalProps {
  isOpen: boolean;
  onClose: () => void;
  onAccept: () => void;
}

export const SubstituteModal: React.FC<SubstituteModalProps> = ({
  isOpen,
  onClose,
  onAccept,
}) => {
  const [secondsRemaining, setSecondsRemaining] = useState(60);

  useEffect(() => {
    if (!isOpen) {
      setSecondsRemaining(60);
      return;
    }

    const timer = setInterval(() => {
      setSecondsRemaining((prev) => {
        if (prev <= 1) {
          clearInterval(timer);
          onClose();
          return 0;
        }
        return prev - 1;
      });
    }, 1000);

    return () => clearInterval(timer);
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/70 backdrop-blur-xs">
      <div className="w-full max-w-sm bg-white rounded-2xl shadow-2xl border border-amber-200 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
        {/* Urgent Top Ribbon */}
        <div className="bg-amber-500 text-white px-4 py-2 flex items-center justify-between text-xs font-semibold">
          <div className="flex items-center space-x-1.5">
            <AlertTriangle className="w-4 h-4" />
            <span>Chemist Stock Substitution Notice</span>
          </div>
          <div className="flex items-center space-x-1 bg-amber-600/60 px-2 py-0.5 rounded-full text-[11px]">
            <Clock className="w-3 h-3" />
            <span>{secondsRemaining}s remaining</span>
          </div>
        </div>

        <div className="p-4 space-y-3.5">
          <div className="text-center">
            <h3 className="font-bold text-slate-900 text-base">
              Identical Salt Recommendation
            </h3>
            <p className="text-xs text-slate-500 mt-1">
              Your requested brand is unavailable at partner chemist. The licensed pharmacist has verified an identical active salt formulation.
            </p>
          </div>

          {/* Comparison Cards */}
          <div className="bg-slate-50 border border-slate-200 rounded-xl p-3 space-y-2.5 text-xs">
            <div className="flex items-start justify-between pb-2 border-b border-slate-200">
              <div>
                <span className="text-[10px] uppercase font-bold text-rose-600 bg-rose-50 px-1.5 py-0.5 rounded">
                  Out of Stock
                </span>
                <p className="font-semibold text-slate-800 text-sm mt-0.5">Calpol 650</p>
                <p className="text-slate-500 text-[11px]">Paracetamol 650 mg • 15 Tabs</p>
              </div>
              <span className="font-bold text-slate-600">₹32</span>
            </div>

            <div className="flex items-start justify-between pt-0.5">
              <div>
                <span className="text-[10px] uppercase font-bold text-emerald-700 bg-emerald-100 px-1.5 py-0.5 rounded flex items-center space-x-1 w-fit">
                  <ShieldCheck className="w-3 h-3 text-emerald-600" />
                  <span>Exact Bio-Equivalent (In Stock)</span>
                </span>
                <p className="font-bold text-emerald-900 text-sm mt-0.5">Dolo 650</p>
                <p className="text-emerald-700 text-[11px]">Paracetamol 650 mg • Micro Labs Ltd</p>
              </div>
              <span className="font-bold text-slate-900">₹34</span>
            </div>
          </div>

          <div className="p-2.5 bg-emerald-50/70 border border-emerald-100 rounded-lg flex items-start space-x-2 text-[11px] text-emerald-900">
            <ShieldCheck className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
            <p>
              <strong>100% Medically Equivalent:</strong> Same active pharmacological molecule, dosage strength, and bioavailability approved by CDSCO.
            </p>
          </div>

          {/* Actions */}
          <div className="grid grid-cols-2 gap-2 pt-1">
            <button
              onClick={onClose}
              className="px-3 py-2.5 rounded-xl border border-slate-200 text-slate-600 text-xs font-semibold hover:bg-slate-50 transition flex items-center justify-center space-x-1"
            >
              <XCircle className="w-3.5 h-3.5" />
              <span>Reject & Keep Looking</span>
            </button>
            <button
              onClick={() => {
                onAccept();
                onClose();
              }}
              className="px-3 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold shadow-md shadow-emerald-700/20 transition flex items-center justify-center space-x-1.5"
            >
              <CheckCircle2 className="w-4 h-4" />
              <span>Approve Dolo 650</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
