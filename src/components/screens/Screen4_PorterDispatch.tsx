'use client';

import React, { useState, useEffect } from 'react';
import { Phone, MapPin, Bike, ShieldCheck, Navigation, AlertTriangle, ExternalLink, ChevronRight, Star, Key } from 'lucide-react';
import { OrderState } from '../../types/order';

interface Screen4Props {
  orderState: OrderState;
  isDriverGlitch?: boolean;
  onRiderArrived: () => void;
}

export const Screen4_PorterDispatch: React.FC<Screen4Props> = ({
  orderState,
  isDriverGlitch = false,
  onRiderArrived,
}) => {
  const [etaMinutes, setEtaMinutes] = useState(5);
  const [riderProgress, setRiderProgress] = useState(20);

  useEffect(() => {
    const progressInterval = setInterval(() => {
      setRiderProgress((prev) => {
        if (prev >= 90) {
          clearInterval(progressInterval);
          setTimeout(() => {
            onRiderArrived();
          }, 1000);
          return 95;
        }
        return prev + 15;
      });
      setEtaMinutes((prev) => (prev > 1 ? prev - 1 : 1));
    }, 2500);

    return () => clearInterval(progressInterval);
  }, [onRiderArrived]);

  const isNearGate = riderProgress >= 80;

  return (
    <div className="flex-1 flex flex-col p-4 pb-20 space-y-3.5">
      {/* Step Header */}
      <div className="flex items-center justify-between">
        <span className="text-xs font-bold text-emerald-700 bg-emerald-50 px-2.5 py-0.5 rounded-full border border-emerald-200 flex items-center space-x-1">
          <Bike className="w-3.5 h-3.5 text-emerald-600" />
          <span>{isNearGate ? 'Rider Arriving at Gate' : 'Porter Courier In-Transit'}</span>
        </span>
        <span className="text-xs font-mono font-bold text-slate-700">
          {isNearGate ? '< 100m Away' : `ETA: ~${etaMinutes} Mins`}
        </span>
      </div>

      {/* Rider Information Card */}
      <div className="bg-white border border-slate-200 rounded-2xl p-3.5 shadow-sm space-y-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 rounded-full bg-emerald-100 border-2 border-emerald-500 flex items-center justify-center text-emerald-800 font-extrabold text-sm relative">
              RK
              <span className="absolute bottom-0 right-0 w-3.5 h-3.5 rounded-full bg-emerald-500 border-2 border-white"></span>
            </div>
            <div>
              <div className="flex items-center space-x-1.5">
                <h3 className="font-extrabold text-sm text-slate-900">{orderState.rider.name}</h3>
                <span className="flex items-center space-x-0.5 text-[10px] font-bold bg-amber-100 text-amber-900 px-1.5 py-0.2 rounded">
                  <Star className="w-2.5 h-2.5 fill-amber-500 text-amber-500" />
                  <span>{orderState.rider.rating}</span>
                </span>
              </div>
              <p className="text-[11px] font-mono text-slate-500 mt-0.5">
                {orderState.rider.vehicleNumber}
              </p>
              <p className="text-[10px] text-emerald-600 font-semibold">
                Porter Verified Express Pilot
              </p>
            </div>
          </div>

          {/* Masked Call Button */}
          <a
            href={`tel:${orderState.rider.phone}`}
            className="w-11 h-11 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white flex items-center justify-center shadow-md shadow-emerald-700/20 transition shrink-0"
            title="Call Rider (Masked Number)"
          >
            <Phone className="w-5 h-5" />
          </a>
        </div>
      </div>

      {/* Live Porter Simulated GPS Map */}
      <div className="relative rounded-2xl overflow-hidden border border-slate-200 bg-slate-100 h-64 shadow-inner flex flex-col justify-between p-3">
        {/* Map Header Status */}
        <div className="z-10 bg-white/95 backdrop-blur-xs px-3 py-1.5 rounded-xl border border-slate-200 flex items-center justify-between text-xs">
          <div className="flex items-center space-x-2">
            <span className="relative flex h-2 w-2">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
              <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-600"></span>
            </span>
            <span className="font-bold text-slate-800 text-[11px]">Porter Live GPS Stream</span>
          </div>
          <span className="font-mono text-[10px] text-emerald-700 font-bold">
            {isNearGate ? 'Near your gate' : `${(1.4 * (1 - riderProgress / 100)).toFixed(1)} km away`}
          </span>
        </div>

        {/* SVG Route Visualization */}
        <div className="absolute inset-0 flex items-center justify-center">
          <svg className="w-full h-full opacity-60" viewBox="0 0 400 240">
            <path d="M 40 40 L 360 40" stroke="#cbd5e1" strokeWidth="12" fill="none" />
            <path d="M 40 120 L 360 120" stroke="#cbd5e1" strokeWidth="16" fill="none" />
            <path d="M 40 200 L 360 200" stroke="#cbd5e1" strokeWidth="12" fill="none" />
            <path d="M 100 20 L 100 220" stroke="#cbd5e1" strokeWidth="14" fill="none" />
            <path d="M 220 20 L 220 220" stroke="#cbd5e1" strokeWidth="18" fill="none" />
            <path d="M 320 20 L 320 220" stroke="#cbd5e1" strokeWidth="14" fill="none" />

            <path
              d="M 80 120 L 220 120 L 220 70 L 330 70"
              stroke="#10b981"
              strokeWidth="5"
              strokeDasharray="6,4"
              fill="none"
            />

            <circle cx="80" cy="120" r="10" fill="#064e3b" />
            <text x="80" y="145" textAnchor="middle" fontSize="10" fontWeight="bold" fill="#064e3b">
              Chemist
            </text>

            <circle cx="330" cy="70" r="10" fill="#dc2626" />
            <text x="330" y="95" textAnchor="middle" fontSize="10" fontWeight="bold" fill="#dc2626">
              Your Gate
            </text>
          </svg>

          {/* Moving Bike Icon along route */}
          <div
            className="absolute z-10 transition-all duration-1000 ease-in-out"
            style={{
              left: `${30 + (riderProgress * 0.45)}%`,
              top: `${45 - (riderProgress * 0.15)}%`,
            }}
          >
            <div className="relative">
              <div className="w-9 h-9 rounded-full bg-emerald-600 text-white flex items-center justify-center shadow-lg border-2 border-white transform -rotate-12 animate-bounce">
                <Bike className="w-5 h-5" />
              </div>
              <div className="absolute -top-5 left-1/2 -translate-x-1/2 bg-slate-900 text-white text-[9px] font-bold px-1.5 py-0.2 rounded whitespace-nowrap">
                Ramesh (~{etaMinutes}m)
              </div>
            </div>
          </div>
        </div>

        {/* Live Bottom Location Note */}
        <div className="z-10 bg-slate-900/90 text-white px-3 py-1.5 rounded-xl flex items-center justify-between text-[11px]">
          <div className="flex items-center space-x-1.5 truncate">
            <Navigation className="w-3.5 h-3.5 text-emerald-400 shrink-0" />
            <span className="truncate">Navigating 100ft Road ➔ 12th Main Indiranagar</span>
          </div>
          <span className="font-bold text-emerald-400 shrink-0">On Track</span>
        </div>
      </div>

      {/* User Action */}
      <div className="pt-2">
        <button
          onClick={onRiderArrived}
          className="w-full py-3.5 px-4 bg-emerald-600 hover:bg-emerald-700 text-white rounded-2xl font-bold text-xs shadow-lg shadow-emerald-900/20 flex items-center justify-center space-x-2 transition"
        >
          <Key className="w-4 h-4" />
          <span>Rider is Here • View Handover OTP</span>
        </button>
      </div>
    </div>
  );
};
