# 💊 TenMeds — 10-Minute Rapid Medicine Delivery App

**TenMeds** is a production-grade native Android application written in **Kotlin** and **Jetpack Compose**, engineered with **Liquid Glassmorphism visuals**, real-time **Supabase backend**, and a comprehensive **30+ medicine catalog** across 6 clinical categories.

---

## ✨ Key Features
- **Liquid Glass Visuals:** Custom translucent blur surfaces, gradient borders, dynamic reflections, and Emerald/Coral status lighting.
- **30+ Medicine Catalog:** Real OTC & Rx medicines (Emergency, Antibiotics, Cardiac & Diabetes, Pediatric Care, Wellness, Medical Devices).
- **10-15 Min Delivery SLA:** Live countdown timers, partner chemist auto-dispatch, and Porter courier routing.
- **Doorstep Security OTP:** 4-digit verification code system for high-security medical handoffs.
- **Supabase Realtime Backend:** Full PostgreSQL schema with RLS policies, live subscriptions, orders, and prescription storage.

---

## 🗄️ Backend Setup (Supabase)
1. Open your Supabase project: [Supabase Dashboard](https://supabase.com/dashboard).
2. Go to **SQL Editor** -> **New Query**.
3. Copy and run the entire contents of [supabase_schema.sql](./supabase_schema.sql).
4. All tables, seed medicines, dummy couriers, chemist partners, and security policies will be automatically provisioned.

---

## 🔐 Environment Variables
Copy .env.example to .env and fill in your Supabase project credentials:
`env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_PUBLISHABLE_KEY=your-publishable-key
SUPABASE_SECRET_KEY=your-secret-key
SUPABASE_JWKS_URL=https://your-project.supabase.co/auth/v1/.well-known/jwks.json
`

---

## 🚀 Building the APK via GitHub Actions
A GitHub Actions workflow is pre-configured at .github/workflows/build-apk.yml.
- Pushing to main or master will automatically trigger a build and publish TenMeds-Debug-APK as a downloadable artifact.