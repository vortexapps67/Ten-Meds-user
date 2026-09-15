'use client';

import React from 'react';
import { X, Printer, Download, CheckCircle2, ShieldCheck } from 'lucide-react';
import { OrderState, BillSplit } from '../../types/order';

interface InvoiceModalProps {
  isOpen: boolean;
  onClose: () => void;
  orderState: OrderState;
  billSplit: BillSplit;
}

export const InvoiceModal: React.FC<InvoiceModalProps> = ({
  isOpen,
  onClose,
  orderState,
  billSplit,
}) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-4 bg-slate-950/75 backdrop-blur-xs">
      <div className="w-full max-w-lg bg-white rounded-2xl shadow-2xl border border-slate-200 overflow-hidden flex flex-col max-h-[92vh] animate-in fade-in zoom-in-95 duration-200">
        {/* Header Bar */}
        <div className="bg-slate-900 text-white px-4 py-3 flex items-center justify-between shrink-0">
          <div className="flex items-center space-x-2">
            <ShieldCheck className="w-5 h-5 text-emerald-400" />
            <div>
              <h3 className="font-bold text-sm leading-tight">Official Chemist Tax Invoice</h3>
              <p className="text-[10px] text-slate-400">Govt. Drugs & Cosmetics Act Compliant</p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="text-slate-400 hover:text-white p-1 rounded-md transition"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Invoice Printable Sheet */}
        <div className="flex-1 overflow-y-auto p-4 sm:p-5 text-xs text-slate-800 space-y-4 bg-white" id="tax-invoice-printable">
          {/* Pharmacy Header */}
          <div className="border-b border-slate-200 pb-3 flex items-start justify-between">
            <div>
              <h4 className="font-extrabold text-sm text-slate-900">{orderState.partnerChemist.name}</h4>
              <p className="text-slate-600 text-[11px] max-w-xs">{orderState.partnerChemist.address}</p>
              <div className="mt-1.5 space-y-0.5 text-[10px] text-slate-500 font-mono">
                <p><strong>Drug License (DL):</strong> {orderState.partnerChemist.drugLicenseNo}</p>
                <p><strong>GSTIN:</strong> {orderState.partnerChemist.gstin}</p>
              </div>
            </div>
            <div className="text-right">
              <span className="text-[10px] uppercase font-bold tracking-wider bg-emerald-100 text-emerald-800 px-2 py-0.5 rounded">
                Paid Tax Invoice
              </span>
              <p className="font-mono text-xs font-bold text-slate-900 mt-1">INV-TM-{orderState.orderId}</p>
              <p className="text-[10px] text-slate-500">{new Date().toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' })}</p>
            </div>
          </div>

          {/* Customer & Bag Metadata */}
          <div className="grid grid-cols-2 gap-3 bg-slate-50 p-3 rounded-xl border border-slate-200/80 text-[11px]">
            <div>
              <span className="text-slate-400 uppercase font-semibold text-[9px] block">Customer Details</span>
              <p className="font-bold text-slate-800">{orderState.customerPhone}</p>
              <p className="text-slate-600 truncate">{orderState.customerAddress}</p>
            </div>
            <div>
              <span className="text-slate-400 uppercase font-semibold text-[9px] block">Security Bag Barcode</span>
              <p className="font-mono font-bold text-emerald-800">{orderState.tamperBagBarcode}</p>
              <p className="text-slate-500 text-[10px]">Payment: {orderState.paymentMethod} Handover</p>
            </div>
          </div>

          {/* Itemized Table */}
          <div className="border border-slate-200 rounded-xl overflow-hidden">
            <table className="w-full text-left text-[11px]">
              <thead className="bg-slate-100 text-slate-600 font-semibold border-b border-slate-200">
                <tr>
                  <th className="p-2">Item Description</th>
                  <th className="p-2 text-center">Batch / Exp</th>
                  <th className="p-2 text-center">Qty</th>
                  <th className="p-2 text-right">MRP</th>
                  <th className="p-2 text-right">Total</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-200">
                {orderState.cart.map((item, idx) => (
                  <tr key={idx} className="hover:bg-slate-50/60">
                    <td className="p-2">
                      <p className="font-bold text-slate-900">{item.medicine.brandName}</p>
                      <p className="text-[10px] text-slate-500 italic">{item.medicine.genericSalt}</p>
                    </td>
                    <td className="p-2 text-center font-mono text-[10px] text-slate-600">
                      B: D650-84<br />Exp: 08/2028
                    </td>
                    <td className="p-2 text-center font-medium">{item.quantity}</td>
                    <td className="p-2 text-right font-medium">₹{item.medicine.mrp}</td>
                    <td className="p-2 text-right font-bold text-slate-900">₹{item.medicine.mrp * item.quantity}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Financial Calculation */}
          <div className="space-y-1.5 pt-1 text-[11px] border-t border-slate-200">
            <div className="flex justify-between text-slate-600">
              <span>Medicine Value (Inclusive of 12% GST)</span>
              <span>₹{billSplit.medicineTotal}</span>
            </div>
            <div className="flex justify-between text-slate-600">
              <span>Hyperlocal Porter Courier (2.5 km Zone)</span>
              <span>₹{billSplit.deliveryFee}</span>
            </div>
            <div className="flex justify-between text-slate-600">
              <span>Priority Handling Fee</span>
              <span>₹{billSplit.priorityHandlingFee}</span>
            </div>
            <div className="flex justify-between items-center pt-2 border-t-2 border-slate-900 font-extrabold text-sm text-slate-900">
              <span>Total Amount Paid</span>
              <span>₹{billSplit.totalPayable}</span>
            </div>
          </div>

          {/* Digital Signature & Pharmacist Stamp */}
          <div className="pt-3 flex items-center justify-between border-t border-dashed border-slate-200">
            <div className="flex items-center space-x-2">
              <CheckCircle2 className="w-5 h-5 text-emerald-600 shrink-0" />
              <div>
                <p className="font-bold text-[10px] text-slate-800">Dispensed by Registered Pharmacist</p>
                <p className="text-[9px] text-slate-500">Reg No: KA-PH-84920 • Stamped Digitally</p>
              </div>
            </div>
            <div className="border border-emerald-300 bg-emerald-50 text-emerald-800 font-serif font-bold text-[9px] px-2 py-1 rounded text-center rotate-[-3deg]">
              TEN MEDS VERIFIED<br />STAMP & SEAL
            </div>
          </div>
        </div>

        {/* Footer Actions */}
        <div className="bg-slate-50 border-t border-slate-200 px-4 py-3 flex items-center justify-between gap-3 shrink-0">
          <span className="text-[11px] text-slate-500">Saved to Ten Meds Order History</span>
          <div className="flex items-center space-x-2">
            <button
              onClick={() => window.print()}
              className="px-3 py-1.5 bg-white border border-slate-200 hover:bg-slate-100 rounded-lg text-xs font-semibold text-slate-700 flex items-center space-x-1.5 transition"
            >
              <Printer className="w-3.5 h-3.5" />
              <span>Print</span>
            </button>
            <button
              onClick={onClose}
              className="px-4 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-bold shadow-sm transition flex items-center space-x-1.5"
            >
              <Download className="w-3.5 h-3.5" />
              <span>Done</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
