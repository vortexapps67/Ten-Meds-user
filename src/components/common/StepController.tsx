'use client';

import React from 'react';
import { OrderStep } from '../../types/order';
import { RefreshCw, AlertCircle, FastForward } from 'lucide-react';

interface StepControllerProps {
  currentStep: OrderStep;
  setStep: (step: OrderStep) => void;
  triggerSubstituteModal: () => void;
  toggleDriverGlitch: () => void;
  isDriverGlitch: boolean;
  resetOrder: () => void;
}

export const StepController: React.FC<StepControllerProps> = ({
  currentStep,
  setStep,
  triggerSubstituteModal,
  toggleDriverGlitch,
  isDriverGlitch,
  resetOrder,
}) => {
  const steps: { step: OrderStep; label: string; desc: string }[] = [
    { step: 1, label: '1. Landing', desc: 'Auto-GPS & Catalog' },
    { step: 2, label: '2. Cart', desc: 'Bill & COD/UPI' },
    { step: 3, label: '3. Packing', desc: '90s Chemist Barcode' },
    { step: 4, label: '4. Transit', desc: 'Porter Live Map' },
    { step: 5, label: '5. Handover', desc: 'Seal & OTP (₹470)' },
    { step: 6, label: '6. Complete', desc: 'Tax Invoice & Rx' },
  ];

  return (
    <aside aria-label="Simulation Step Controller" className="w-full max-w-2xl mx-auto my-4 px-3 py-2.5 bg-slate-900 border border-slate-800 rounded-xl shadow-lg text-slate-200">
      <div className="flex items-center justify-between mb-2 text-xs">
        <div className="flex items-center space-x-1.5">
          <FastForward className="w-3.5 h-3.5 text-emerald-400" />
          <span className="font-bold text-white uppercase tracking-wider text-[11px]">Demo Step Controller</span>
        </div>
        <div className="flex items-center space-x-2">
          <button
            onClick={resetOrder}
            className="flex items-center space-x-1 text-[11px] text-slate-400 hover:text-white bg-slate-800 hover:bg-slate-700 px-2 py-0.5 rounded transition"
            title="Reset to fresh landing state"
          >
            <RefreshCw className="w-3 h-3" />
            <span>Reset Demo</span>
          </button>
        </div>
      </div>

      {/* Step Buttons */}
      <div className="grid grid-cols-6 gap-1 mb-2.5">
        {steps.map((s) => (
          <button
            key={s.step}
            onClick={() => setStep(s.step)}
            className={`p-1.5 rounded-lg text-center transition flex flex-col items-center justify-center border ${
              currentStep === s.step
                ? 'bg-emerald-600/90 border-emerald-400 text-white shadow-xs'
                : 'bg-slate-800/60 border-slate-700/60 text-slate-300 hover:bg-slate-800 hover:text-white'
            }`}
          >
            <span className="font-bold text-[11px] leading-tight">{s.label}</span>
            <span className="text-[9px] text-slate-400 truncate w-full hidden sm:block">{s.desc}</span>
          </button>
        ))}
      </div>

      {/* Edge Case Simulation Buttons */}
      <div className="pt-2 border-t border-slate-800/80 flex flex-wrap items-center justify-between gap-2 text-xs">
        <span className="text-[11px] text-slate-400 font-medium">Interactive Edge Cases:</span>
        <div className="flex items-center space-x-2">
          <button
            onClick={triggerSubstituteModal}
            className="text-[11px] bg-amber-500/20 hover:bg-amber-500/30 text-amber-300 border border-amber-500/40 px-2.5 py-1 rounded-md transition font-medium flex items-center space-x-1"
          >
            <AlertCircle className="w-3 h-3" />
            <span>Test Salt Substitute (Calpol ➔ Dolo)</span>
          </button>

          {currentStep === 4 && (
            <button
              onClick={toggleDriverGlitch}
              className={`text-[11px] px-2.5 py-1 rounded-md transition font-medium border ${
                isDriverGlitch
                  ? 'bg-rose-600 text-white border-rose-500'
                  : 'bg-slate-800 text-slate-300 border-slate-700 hover:text-white'
              }`}
            >
              {isDriverGlitch ? 'Disable Driver Glitch' : 'Simulate GPS Glitch'}
            </button>
          )}
        </div>
      </div>
    </aside>
  );
};
