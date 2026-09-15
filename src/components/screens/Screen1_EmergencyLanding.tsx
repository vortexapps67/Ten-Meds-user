'use client';

import React, { useState, useMemo } from 'react';
import { Search, Camera, FileText, Plus, Check, ShieldAlert, Sparkles, Navigation, ChevronRight, Zap } from 'lucide-react';
import { MedicineSKU, CartItem, PrescriptionData } from '../../types/order';
import { EMERGENCY_CATALOG } from '../../data/emergencyCatalog';

interface Screen1Props {
  cart: CartItem[];
  addToCart: (med: MedicineSKU) => void;
  removeFromCart: (medId: string) => void;
  openPrescriptionModal: () => void;
  prescription?: PrescriptionData;
  customerAddress: string;
  customerPhone: string;
  onProceedToCart: () => void;
}

export const Screen1_EmergencyLanding: React.FC<Screen1Props> = ({
  cart,
  addToCart,
  removeFromCart,
  openPrescriptionModal,
  prescription,
  customerAddress,
  customerPhone,
  onProceedToCart,
}) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('All');

  const categories = ['All', 'Fever & Pain', 'Antibiotic', 'Stomach & Acidity', 'Pediatric', 'Emergency & Cardiac'];

  const filteredCatalog = useMemo(() => {
    return EMERGENCY_CATALOG.filter((med) => {
      const matchesSearch =
        med.brandName.toLowerCase().includes(searchQuery.toLowerCase()) ||
        med.genericSalt.toLowerCase().includes(searchQuery.toLowerCase());
      const matchesCategory =
        selectedCategory === 'All' || med.category === selectedCategory;
      return matchesSearch && matchesCategory;
    });
  }, [searchQuery, selectedCategory]);

  const totalCartCount = cart.reduce((acc, item) => acc + item.quantity, 0);
  const totalCartValue = cart.reduce((acc, item) => acc + item.medicine.mrp * item.quantity, 0);

  const getQuantityInCart = (medId: string) => {
    const item = cart.find((i) => i.medicine.id === medId);
    return item ? item.quantity : 0;
  };

  return (
    <div className="flex-1 flex flex-col pb-24">
      {/* Zero Friction Login & GPS Anchor */}
      <div className="bg-slate-50 border-b border-slate-200/80 px-4 py-2.5 flex items-center justify-between text-xs">
        <div className="flex items-center space-x-2 truncate">
          <div className="w-6 h-6 rounded-full bg-emerald-100 flex items-center justify-center text-emerald-700 shrink-0 font-bold text-[10px]">
            <Navigation className="w-3.5 h-3.5" />
          </div>
          <div className="truncate">
            <span className="text-[10px] uppercase font-bold text-emerald-800 tracking-wider">Delivering to</span>
            <p className="font-semibold text-slate-800 truncate text-xs">{customerAddress}</p>
          </div>
        </div>
        <div className="shrink-0 text-right">
          <span className="text-[10px] text-slate-400">1-Tap Verified</span>
          <p className="font-mono text-xs font-bold text-slate-700">{customerPhone}</p>
        </div>
      </div>

      {/* Hero Dual-Action Card (Search vs Upload Rx) */}
      <div className="p-4 space-y-3">
        {/* Prescription Upload Card */}
        <div className="bg-gradient-to-br from-emerald-900 to-emerald-950 text-white rounded-2xl p-4 shadow-lg relative overflow-hidden">
          <div className="relative z-10 flex items-start justify-between">
            <div className="space-y-1 max-w-[75%]">
              <span className="inline-flex items-center space-x-1 text-[10px] font-bold uppercase tracking-wider bg-emerald-800/80 text-emerald-200 px-2 py-0.5 rounded-full">
                <Zap className="w-3 h-3 text-emerald-400" />
                <span>Panic Mode • 10-15 Min Delivery</span>
              </span>
              <h2 className="text-base font-extrabold tracking-tight pt-1">
                Have a Doctor's Prescription?
              </h2>
              <p className="text-xs text-emerald-200/90 leading-relaxed">
                Snap the paper slip. Our 24x7 pharmacist will pack & dispatch via Porter in 90 seconds.
              </p>
            </div>
            <button
              onClick={openPrescriptionModal}
              className="w-12 h-12 rounded-2xl bg-emerald-500 hover:bg-emerald-400 text-slate-950 flex items-center justify-center shadow-lg transition shrink-0"
              title="Snap Prescription"
            >
              <Camera className="w-6 h-6" />
            </button>
          </div>

          <div className="mt-3 pt-3 border-t border-emerald-800/60 flex items-center justify-between">
            {prescription ? (
              <div className="flex items-center space-x-1.5 text-xs text-emerald-300 font-semibold">
                <Check className="w-4 h-4 text-emerald-400" />
                <span>Rx Uploaded ({prescription.fileName})</span>
              </div>
            ) : (
              <div className="flex items-center space-x-1.5 text-xs text-emerald-300 font-medium">
                <FileText className="w-3.5 h-3.5" />
                <span>Supports WhatsApp images, Clinic slips, Hospital PDFs</span>
              </div>
            )}
            <button
              onClick={openPrescriptionModal}
              className="text-xs font-bold text-emerald-300 hover:text-white underline"
            >
              {prescription ? 'View Slip' : 'Snap Rx'}
            </button>
          </div>
        </div>

        {/* Search Direct SKU Bar */}
        <div className="relative">
          <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none">
            <Search className="h-4 w-4 text-slate-400" />
          </div>
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search urgent medicines, salts (Dolo, Meftal, ORS)..."
            className="w-full pl-10 pr-4 py-2.5 bg-slate-100/90 border border-slate-200 rounded-xl text-xs font-medium text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:bg-white transition"
          />
        </div>

        {/* Quick Category Chips */}
        <div className="flex items-center space-x-1.5 overflow-x-auto pb-1 scrollbar-none text-xs">
          {categories.map((cat) => (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              className={`px-3 py-1.5 rounded-full whitespace-nowrap font-medium text-xs transition ${
                selectedCategory === cat
                  ? 'bg-emerald-600 text-white shadow-xs'
                  : 'bg-slate-100 hover:bg-slate-200 text-slate-600'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>
      </div>

      {/* Catalog List */}
      <div className="px-4 space-y-2.5 flex-1">
        <div className="flex items-center justify-between text-xs text-slate-500 font-medium px-1">
          <span>Available Near You (&lt;2.5 km)</span>
          <span>{filteredCatalog.length} Medicines Found</span>
        </div>

        {filteredCatalog.map((med) => {
          const qty = getQuantityInCart(med.id);
          return (
            <div
              key={med.id}
              className="p-3 bg-white border border-slate-200/90 rounded-xl hover:border-emerald-300 transition shadow-xs flex items-start justify-between space-x-3"
            >
              <div className="flex-1 min-w-0">
                <div className="flex items-center space-x-1.5 flex-wrap gap-y-1">
                  <h4 className="font-bold text-sm text-slate-900 leading-tight">
                    {med.brandName}
                  </h4>
                  <span className="text-[10px] font-semibold text-slate-600 bg-slate-100 px-1.5 py-0.2 rounded">
                    {med.dosageForm}
                  </span>
                  {med.isScheduleH && (
                    <span className="text-[9px] font-bold text-amber-700 bg-amber-50 border border-amber-200 px-1.5 py-0.2 rounded flex items-center space-x-0.5">
                      <ShieldAlert className="w-2.5 h-2.5 text-amber-600" />
                      <span>Rx Required</span>
                    </span>
                  )}
                  {!med.inStock && (
                    <span className="text-[9px] font-bold text-rose-600 bg-rose-50 px-1.5 py-0.2 rounded">
                      Out of Stock
                    </span>
                  )}
                </div>

                <p className="text-[11px] text-slate-500 font-medium mt-0.5">
                  Salt: <span className="text-slate-700">{med.genericSalt}</span>
                </p>
                <p className="text-[10px] text-slate-400 mt-0.5">
                  Packaging: {med.stripSize} • {med.strength}
                </p>

                <div className="mt-2 flex items-center space-x-2">
                  <span className="text-sm font-extrabold text-slate-900">₹{med.mrp}</span>
                  <span className="text-[10px] text-emerald-600 font-semibold bg-emerald-50 px-1.5 py-0.5 rounded">
                    MRP Incl. GST
                  </span>
                </div>
              </div>

              {/* Action Button */}
              <div className="shrink-0 flex flex-col items-end justify-center pt-1">
                {!med.inStock ? (
                  <button
                    onClick={() => {
                      if (med.substituteAvailable) {
                        const substituteMed = EMERGENCY_CATALOG.find(
                          (m) => m.brandName === med.substituteAvailable?.brandName
                        );
                        if (substituteMed) addToCart(substituteMed);
                      }
                    }}
                    className="px-2.5 py-1.5 bg-amber-500 hover:bg-amber-600 text-white rounded-lg text-xs font-bold shadow-xs transition"
                  >
                    View Salt Alt
                  </button>
                ) : qty > 0 ? (
                  <div className="flex items-center space-x-1.5 bg-emerald-50 border border-emerald-300 rounded-lg p-1">
                    <button
                      onClick={() => removeFromCart(med.id)}
                      className="w-6 h-6 rounded bg-white text-emerald-700 font-bold text-xs flex items-center justify-center hover:bg-emerald-100 transition shadow-xs"
                    >
                      -
                    </button>
                    <span className="font-bold text-xs text-emerald-900 px-1.5">{qty}</span>
                    <button
                      onClick={() => addToCart(med)}
                      className="w-6 h-6 rounded bg-emerald-600 text-white font-bold text-xs flex items-center justify-center hover:bg-emerald-700 transition shadow-xs"
                    >
                      +
                    </button>
                  </div>
                ) : (
                  <button
                    onClick={() => addToCart(med)}
                    className="px-3.5 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-bold shadow-xs transition flex items-center space-x-1"
                  >
                    <Plus className="w-3.5 h-3.5" />
                    <span>Add</span>
                  </button>
                )}
              </div>
            </div>
          );
        })}
      </div>

      {/* Floating Bottom Cart Bar */}
      {totalCartCount > 0 && (
        <div className="fixed bottom-0 left-0 right-0 max-w-md mx-auto p-3 z-40">
          <button
            onClick={onProceedToCart}
            className="w-full bg-emerald-600 hover:bg-emerald-700 text-white rounded-2xl p-3.5 shadow-xl shadow-emerald-900/30 flex items-center justify-between transition animate-in slide-in-from-bottom-3 duration-200"
          >
            <div className="flex items-center space-x-2">
              <span className="bg-emerald-800 text-white font-extrabold text-xs px-2.5 py-1 rounded-full">
                {totalCartCount} {totalCartCount === 1 ? 'item' : 'items'}
              </span>
              <div className="text-left">
                <span className="text-[10px] text-emerald-100 block leading-none">Estimated Total</span>
                <span className="font-black text-sm text-white">₹{totalCartValue}</span>
              </div>
            </div>
            <div className="flex items-center space-x-1 text-xs font-bold">
              <span>Review Cart & Bill</span>
              <ChevronRight className="w-4 h-4" />
            </div>
          </button>
        </div>
      )}
    </div>
  );
};
