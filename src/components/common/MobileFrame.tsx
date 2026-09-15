'use client';

import React from 'react';
import { Smartphone, Monitor, Signal, Wifi, Battery } from 'lucide-react';

interface MobileFrameProps {
  children: React.ReactNode;
  isMobileDeviceFrame: boolean;
  setIsMobileDeviceFrame: (val: boolean) => void;
}

export const MobileFrame: React.FC<MobileFrameProps> = ({
  children,
  isMobileDeviceFrame,
  setIsMobileDeviceFrame,
}) => {
  return (
    <div className="min-h-screen bg-slate-950 flex flex-col items-center justify-start p-0 md:p-6 text-slate-100">
      {/* Top Viewport Mode Switcher (Desktop Only) */}
      <aside aria-label="Simulator Controls" className="hidden md:flex items-center justify-between w-full max-w-md mb-4 px-4 py-2 bg-slate-900/90 border border-slate-800 rounded-full backdrop-blur-sm shadow-lg text-xs">
        <div className="flex items-center space-x-2">
          <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse"></span>
          <span className="font-semibold text-slate-300">Ten Meds Customer App Simulator</span>
        </div>
        <div className="flex items-center space-x-1 bg-slate-950 p-1 rounded-full border border-slate-800">
          <button
            onClick={() => setIsMobileDeviceFrame(true)}
            className={`flex items-center space-x-1 px-3 py-1 rounded-full text-xs font-medium transition ${
              isMobileDeviceFrame
                ? 'bg-emerald-600 text-white shadow-xs'
                : 'text-slate-400 hover:text-slate-200'
            }`}
          >
            <Smartphone className="w-3.5 h-3.5" />
            <span>Mobile Shell</span>
          </button>
          <button
            onClick={() => setIsMobileDeviceFrame(false)}
            className={`flex items-center space-x-1 px-3 py-1 rounded-full text-xs font-medium transition ${
              !isMobileDeviceFrame
                ? 'bg-emerald-600 text-white shadow-xs'
                : 'text-slate-400 hover:text-slate-200'
            }`}
          >
            <Monitor className="w-3.5 h-3.5" />
            <span>Full Width</span>
          </button>
        </div>
      </aside>

      {/* Main Viewport Container */}
      <div
        className={`w-full transition-all duration-300 ${
          isMobileDeviceFrame
            ? 'max-w-[420px] bg-slate-900 border-4 border-slate-700/80 rounded-[44px] shadow-2xl shadow-emerald-950/20 overflow-hidden flex flex-col'
            : 'max-w-2xl bg-white rounded-2xl shadow-2xl overflow-hidden'
        }`}
        style={{ minHeight: isMobileDeviceFrame ? '840px' : '100vh' }}
      >
        {/* Smartphone Notch & Status Bar (Only in Mobile Shell Mode) */}
        {isMobileDeviceFrame && (
          <div className="bg-slate-950 text-white px-7 pt-3 pb-2 flex items-center justify-between text-xs select-none">
            <span className="font-semibold text-[13px] tracking-tight">09:41</span>
            {/* Dynamic Island / Speaker Pill */}
            <div className="h-4 w-24 bg-slate-800 rounded-full flex items-center justify-center space-x-1.5">
              <div className="h-2 w-2 rounded-full bg-slate-950/80"></div>
              <div className="h-2 w-2 rounded-full bg-emerald-500/80"></div>
            </div>
            <div className="flex items-center space-x-1.5 text-slate-300">
              <Signal className="w-3.5 h-3.5" />
              <Wifi className="w-3.5 h-3.5" />
              <Battery className="w-4 h-4 text-emerald-400" />
            </div>
          </div>
        )}

        {/* Content Body */}
        <div className="flex-1 bg-white text-slate-900 overflow-y-auto flex flex-col">
          {children}
        </div>
      </div>
    </div>
  );
};
