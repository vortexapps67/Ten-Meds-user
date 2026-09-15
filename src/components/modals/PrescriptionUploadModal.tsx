'use client';

import React, { useState } from 'react';
import { Camera, UploadCloud, X, CheckCircle, FileText, Sparkles, ShieldCheck } from 'lucide-react';
import { PrescriptionData } from '../../types/order';

interface PrescriptionUploadModalProps {
  isOpen: boolean;
  onClose: () => void;
  onPrescriptionUploaded: (prescription: PrescriptionData) => void;
}

export const PrescriptionUploadModal: React.FC<PrescriptionUploadModalProps> = ({
  isOpen,
  onClose,
  onPrescriptionUploaded,
}) => {
  const [isProcessing, setIsProcessing] = useState(false);
  const [detectedSalts, setDetectedSalts] = useState<string[]>([]);
  const [mockPreview, setMockPreview] = useState<string | null>(null);

  if (!isOpen) return null;

  const handleSimulatedCapture = (fileName: string) => {
    setIsProcessing(true);
    // Simulate AI Vision/OCR extraction of doctor's handwriting
    setTimeout(() => {
      const salts = [
        'Paracetamol IP 650mg TDS',
        'Amoxicillin + Clavulanate 625mg BD',
        'Pantoprazole 40mg OD Before Food',
      ];
      setDetectedSalts(salts);
      setMockPreview('https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?auto=format&fit=crop&w=600&q=80');
      setIsProcessing(false);
    }, 1200);
  };

  const handleConfirm = () => {
    onPrescriptionUploaded({
      fileName: 'Rx_Dr_Mukherjee_Apollo.jpg',
      previewUrl: mockPreview || '/prescription_sample.jpg',
      uploadedAt: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      detectedSalts,
    });
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/70 backdrop-blur-xs">
      <div className="w-full max-w-sm bg-white rounded-2xl shadow-2xl border border-slate-200 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
        <div className="px-4 py-3 bg-emerald-800 text-white flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <FileText className="w-4 h-4 text-emerald-300" />
            <h3 className="font-bold text-sm">Upload Doctor's Prescription</h3>
          </div>
          <button
            onClick={onClose}
            className="text-emerald-200 hover:text-white p-1 rounded-md transition"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="p-4 space-y-4 text-xs">
          <p className="text-slate-600">
            Schedule H antibiotics & prescription-only medicines require an official physician slip as per Indian Drug Regulations.
          </p>

          {!mockPreview && !isProcessing && (
            <div className="space-y-2.5">
              <button
                onClick={() => handleSimulatedCapture('Rx_Camera_Snap.jpg')}
                className="w-full py-4 border-2 border-dashed border-emerald-300 hover:border-emerald-500 bg-emerald-50/50 hover:bg-emerald-50 rounded-xl flex flex-col items-center justify-center space-y-1.5 transition text-emerald-800 font-semibold"
              >
                <div className="w-10 h-10 rounded-full bg-emerald-100 flex items-center justify-center text-emerald-600">
                  <Camera className="w-5 h-5" />
                </div>
                <span className="text-sm">Quick Snap with Camera</span>
                <span className="text-[11px] text-slate-500 font-normal">Auto-aligns & enhances contrast</span>
              </button>

              <button
                onClick={() => handleSimulatedCapture('Rx_Gallery_Upload.jpg')}
                className="w-full py-3 bg-slate-100 hover:bg-slate-200 rounded-xl flex items-center justify-center space-x-2 text-slate-700 font-semibold transition"
              >
                <UploadCloud className="w-4 h-4" />
                <span>Choose from Gallery / PDF</span>
              </button>
            </div>
          )}

          {isProcessing && (
            <div className="py-8 flex flex-col items-center justify-center space-y-3">
              <div className="w-10 h-10 border-3 border-emerald-500 border-t-transparent rounded-full animate-spin"></div>
              <div className="text-center">
                <p className="font-bold text-slate-800 text-sm">Scanning Prescription...</p>
                <p className="text-slate-500 text-[11px] mt-0.5">Extracting salts, dosage, and doctor registration</p>
              </div>
            </div>
          )}

          {mockPreview && !isProcessing && (
            <div className="space-y-3">
              <div className="relative rounded-xl overflow-hidden border border-slate-200 bg-slate-100 h-36 flex items-center justify-center">
                <img
                  src={mockPreview}
                  alt="Prescription Preview"
                  className="w-full h-full object-cover"
                />
                <div className="absolute top-2 right-2 bg-emerald-600 text-white text-[10px] font-bold px-2 py-0.5 rounded-full flex items-center space-x-1 shadow-sm">
                  <CheckCircle className="w-3 h-3" />
                  <span>Valid Prescription</span>
                </div>
              </div>

              {/* AI Extraction Banner */}
              <div className="bg-emerald-50 border border-emerald-200 rounded-xl p-3 space-y-1.5">
                <div className="flex items-center space-x-1.5 text-emerald-800 font-bold text-[11px]">
                  <Sparkles className="w-3.5 h-3.5 text-emerald-600" />
                  <span>AI Salt Detection Engine</span>
                </div>
                <div className="space-y-1">
                  {detectedSalts.map((salt, idx) => (
                    <div key={idx} className="flex items-center space-x-1 text-[11px] text-emerald-950 font-medium">
                      <span className="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>
                      <span>{salt}</span>
                    </div>
                  ))}
                </div>
              </div>

              <div className="flex items-center space-x-1.5 text-[11px] text-slate-500">
                <ShieldCheck className="w-4 h-4 text-emerald-600 shrink-0" />
                <span>Chemist will verify physical slip before packing.</span>
              </div>

              <button
                onClick={handleConfirm}
                className="w-full py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white font-bold rounded-xl shadow-md transition"
              >
                Attach & Proceed with Cart
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
