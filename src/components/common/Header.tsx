'use client';

import React from 'react';
import Image from 'next/image';
import { MapPin, ShieldCheck, PhoneCall } from 'lucide-react';

interface HeaderProps {
  chemistName: string;
  step: number;
}

export const Header: React.FC<HeaderProps> = ({ chemistName, step }) => {
  return (
    <header className="sticky top-0 z-30 bg-white border-b border-slate-100 shadow-sm">
      {/* Top Geofence & Speed Assurance Bar */}
      <div className="bg-emerald-700 text-white px-3 py-1.5 flex items-center justify-between text-xs font-medium tracking-tight">
        <div className="flex items-center space-x-1.5 truncate">
          <span className="relative flex h-2 w-2">
            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-300 opacity-75"></span>
            <span className="relative inline-flex rounded-full h-2 w-2 bg-white"></span>
          </span>
          <span className="truncate">Delivering in <strong>12–15 mins</strong> from {chemistName}</span>
        </div>
        <div className="flex items-center space-x-1 shrink-0 text-emerald-100 bg-emerald-800/60 px-2 py-0.5 rounded-full text-[10px]">
          <MapPin className="w-3 h-3 text-emerald-300" />
          <span>2.5 km Geofence</span>
        </div>
      </div>

      {/* Main Brand & Action Row */}
      <div className="px-4 py-2.5 flex items-center justify-between">
        <div className="flex items-center space-x-2.5">
          <div className="relative w-9 h-9 rounded-xl overflow-hidden border border-emerald-100 shadow-xs bg-white shrink-0">
            <Image
              src="/logo_no_name.png"
              alt="Ten Meds Capsule Logo"
              fill
              className="object-contain p-0.5"
              priority
            />
          </div>
          <div>
            <div className="flex items-center space-x-1">
              <span className="font-extrabold text-lg tracking-tight text-slate-900 leading-none">Ten</span>
              <span className="font-extrabold text-lg tracking-tight text-emerald-600 leading-none">Meds</span>
              <span className="text-[10px] font-bold uppercase tracking-wider bg-emerald-100 text-emerald-800 px-1.5 py-0.5 rounded ml-1">
                Emergency
              </span>
            </div>
            <p className="text-[10px] text-slate-500 font-medium leading-none mt-0.5">
              Verified Pharmacist Network
            </p>
          </div>
        </div>

        {/* Quick Emergency Support */}
        <a
          href="tel:1800-TEN-MEDS"
          className="flex items-center space-x-1 bg-slate-50 hover:bg-slate-100 border border-slate-200 text-slate-700 px-2.5 py-1.5 rounded-lg text-xs font-semibold transition"
          title="Emergency Pharmacist Hotline"
        >
          <PhoneCall className="w-3.5 h-3.5 text-emerald-600" />
          <span className="hidden sm:inline">24x7 Help</span>
        </a>
      </div>
    </header>
  );
};
