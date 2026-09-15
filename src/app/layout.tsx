import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Ten Meds — Emergency Medicines in 10-15 Mins",
  description: "Panic-free, hyper-local emergency medicine sourcing & doorstep delivery within 2.5 km.",
  icons: {
    icon: "/logo_no_name.png",
  }
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-slate-900 text-slate-900 selection:bg-emerald-500 selection:text-white">
        {children}
      </body>
    </html>
  );
}
