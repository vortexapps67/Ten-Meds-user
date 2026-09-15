-- ============================================================================
-- TEN MEDS - SUPABASE POSTGRESQL PRODUCTION DATABASE SCHEMA
-- ============================================================================

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Clean up existing tables if re-running
DROP TABLE IF EXISTS prescriptions CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS couriers CASCADE;
DROP TABLE IF EXISTS partner_chemists CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;

-- 3. PROFILES (Customer Accounts & Addresses)
CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone TEXT UNIQUE NOT NULL,
    full_name TEXT DEFAULT 'Alex Customer',
    default_address TEXT DEFAULT '742 Evergreen Terrace, Apt 4B, Springfield',
    emergency_contact TEXT DEFAULT '+91 98765 43210',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. CATEGORIES
CREATE TABLE categories (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    icon_name TEXT NOT NULL,
    display_order INT DEFAULT 0
);

-- 5. PRODUCTS (30+ Medicines across Emergency, Antibiotics, Chronic, Pediatric, Wellness, Devices)
CREATE TABLE products (
    id TEXT PRIMARY KEY,
    brand_name TEXT NOT NULL,
    generic_salt TEXT NOT NULL,
    strength TEXT NOT NULL,
    dosage_form TEXT DEFAULT 'Tablet',
    strip_size TEXT NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    mrp NUMERIC(10, 2) NOT NULL,
    category_id TEXT REFERENCES categories(id),
    image_url TEXT NOT NULL,
    description TEXT NOT NULL,
    is_schedule_h BOOLEAN DEFAULT FALSE,
    in_stock BOOLEAN DEFAULT TRUE,
    substitute_product_id TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. PARTNER CHEMISTS (Local Pharmacies within 7 km)
CREATE TABLE partner_chemists (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    drug_license_no TEXT NOT NULL,
    gstin TEXT NOT NULL,
    phone TEXT NOT NULL,
    latitude DOUBLE PRECISION DEFAULT 12.9716,
    longitude DOUBLE PRECISION DEFAULT 77.5946,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. COURIERS (Porter Express Delivery Pilots)
CREATE TABLE couriers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    vehicle_number TEXT NOT NULL,
    rating NUMERIC(2, 1) DEFAULT 4.9,
    current_latitude DOUBLE PRECISION DEFAULT 12.9720,
    current_longitude DOUBLE PRECISION DEFAULT 77.5950,
    is_available BOOLEAN DEFAULT TRUE
);

-- 8. ORDERS (Emergency Orders)
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_number TEXT UNIQUE NOT NULL,
    user_phone TEXT NOT NULL,
    chemist_id UUID REFERENCES partner_chemists(id),
    courier_id UUID REFERENCES couriers(id),
    status TEXT NOT NULL DEFAULT 'confirmed' CHECK (status IN ('confirmed', 'packed', 'in_transit', 'delivered', 'cancelled')),
    total_amount NUMERIC(10, 2) NOT NULL,
    medicine_total NUMERIC(10, 2) NOT NULL,
    delivery_fee NUMERIC(10, 2) DEFAULT 50.00,
    priority_fee NUMERIC(10, 2) DEFAULT 20.00,
    payment_method TEXT DEFAULT 'COD' CHECK (payment_method IN ('COD', 'UPI')),
    delivery_otp TEXT NOT NULL DEFAULT '7419',
    tamper_bag_barcode TEXT NOT NULL DEFAULT 'TM-84920-BAG',
    eta_time TEXT DEFAULT '11:30 AM',
    delivery_address TEXT NOT NULL,
    prescription_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. ORDER ITEMS
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id TEXT REFERENCES products(id),
    quantity INT NOT NULL DEFAULT 1,
    unit_price NUMERIC(10, 2) NOT NULL,
    total_price NUMERIC(10, 2) NOT NULL
);

-- 10. PRESCRIPTIONS
CREATE TABLE prescriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_phone TEXT NOT NULL,
    image_url TEXT NOT NULL,
    detected_salts TEXT[] DEFAULT '{}',
    status TEXT DEFAULT 'uploaded' CHECK (status IN ('uploaded', 'scanning', 'locked', 'fulfilled')),
    locked_chemist_id UUID REFERENCES partner_chemists(id),
    lock_expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE partner_chemists ENABLE ROW LEVEL SECURITY;
ALTER TABLE couriers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE prescriptions ENABLE ROW LEVEL SECURITY;

-- Public Read / Insert Policies
CREATE POLICY "Public categories are viewable" ON categories FOR SELECT USING (true);
CREATE POLICY "Public products are viewable" ON products FOR SELECT USING (true);
CREATE POLICY "Public partner_chemists are viewable" ON partner_chemists FOR SELECT USING (true);
CREATE POLICY "Public couriers are viewable" ON couriers FOR SELECT USING (true);
CREATE POLICY "Orders can be created" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Orders are viewable" ON orders FOR SELECT USING (true);
CREATE POLICY "Orders can be updated" ON orders FOR UPDATE USING (true);
CREATE POLICY "Order items viewable" ON order_items FOR SELECT USING (true);
CREATE POLICY "Order items insertable" ON order_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Prescriptions can be uploaded" ON prescriptions FOR INSERT WITH CHECK (true);
CREATE POLICY "Prescriptions viewable" ON prescriptions FOR SELECT USING (true);

-- Enable Realtime for Live Order Status Updates
ALTER PUBLICATION supabase_realtime ADD TABLE orders;
ALTER PUBLICATION supabase_realtime ADD TABLE order_items;

-- ============================================================================
-- SEED DATA: CATEGORIES
-- ============================================================================
INSERT INTO categories (id, name, icon_name, display_order) VALUES
('cat_emergency', 'Emergency & Acute', 'medkit', 1),
('cat_antibiotics', 'Antibiotics & Syrups', 'flask', 2),
('cat_chronic', 'Cardiac & Diabetes', 'heart', 3),
('cat_pediatric', 'Pediatric Care', 'baby', 4),
('cat_wellness', 'Wellness & Immunity', 'leaf', 5),
('cat_devices', 'Medical Devices', 'thermometer', 6);

-- ============================================================================
-- SEED DATA: 30+ MEDICINES & ESSENTIALS
-- ============================================================================
INSERT INTO products (id, brand_name, generic_salt, strength, dosage_form, strip_size, price, mrp, category_id, image_url, description, is_schedule_h, in_stock) VALUES
-- Emergency & Acute
('prod_para', 'Paracetamol 500 mg', 'Paracetamol (Acetaminophen)', '500 mg', 'Tablet', '20 tablets • Acme Health', 5.80, 7.50, 'cat_emergency', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Fast-acting antipyretic and analgesic for fever, headache, and body aches.', false, true),
('prod_ibup', 'Ibuprofen 400 mg', 'Ibuprofen IP', '400 mg', 'Tablet', '15 tablets • Brufen Care', 6.40, 8.20, 'cat_emergency', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Non-steroidal anti-inflammatory drug (NSAID) for acute dental pain, swelling, and arthritis flare-ups.', true, true),
('prod_asthalin', 'Asthalin Inhaler 100 mcg', 'Salbutamol / Albuterol Sulfate', '100 mcg/dose', 'Inhaler', '200 metered doses • Cipla', 14.50, 18.00, 'cat_emergency', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Rapid-acting bronchodilator for acute asthma attacks, wheezing, and bronchospasm relief.', true, true),
('prod_ors', 'Electral ORS Solution', 'Oral Rehydration Salts IP (WHO Formula)', '21.8 g sachet', 'Powder', '5 sachets • FDC Health', 4.20, 5.50, 'cat_emergency', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Restores vital electrolytes and fluids during acute dehydration, vomiting, or diarrhea.', false, true),
('prod_cetirizine', 'Cetirizine 10 mg', 'Cetirizine Hydrochloride', '10 mg', 'Tablet', '10 tablets • Cetzine', 3.80, 5.00, 'cat_emergency', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Non-drowsy antihistamine for acute allergic reactions, hives, and pollen allergy relief.', false, true),
('prod_panto', 'Pantoprazole 40 mg', 'Pantoprazole Sodium Gastro-resistant', '40 mg', 'Tablet', '15 tablets • Pan-40', 8.90, 11.50, 'cat_emergency', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Proton pump inhibitor (PPI) for acute acid reflux, heartburn, and peptic ulcer relief.', true, true),

-- Antibiotics & Syrups
('prod_azith', 'Azithromycin 500 mg', 'Azithromycin Dihydrate IP', '500 mg', 'Tablet', '5 tablets • Azithral 500', 11.20, 14.00, 'cat_antibiotics', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Broad-spectrum macrolide antibiotic for severe respiratory tract, throat, and ear infections.', true, true),
('prod_amox', 'Amoxicillin + Clav 625', 'Amoxicillin 500mg + Potassium Clavulanate 125mg', '625 mg', 'Tablet', '10 tablets • Augmentin 625', 16.80, 21.00, 'cat_antibiotics', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Potent antibiotic for resistant bacterial infections, post-operative care, and sinusitis.', true, true),
('prod_cipro', 'Ciprofloxacin 500 mg', 'Ciprofloxacin Hydrochloride', '500 mg', 'Tablet', '10 tablets • Ciplox 500', 7.50, 9.80, 'cat_antibiotics', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Fluoroquinolone antibiotic for urinary tract, gastrointestinal, and skin infections.', true, true),
('prod_cough_syrup', 'Ascoril D+ Cough Syrup', 'Dextromethorphan + Chlorpheniramine + Phenylephrine', '100 ml', 'Syrup', '100 ml bottle • Glenmark', 6.20, 7.90, 'cat_antibiotics', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Sugar-free dry cough syrup providing quick relief from throat irritation and congestion.', false, true),
('prod_doxy', 'Doxycycline 100 mg', 'Doxycycline Hyclate IP', '100 mg', 'Capsule', '10 capsules • Doxypal', 8.10, 10.50, 'cat_antibiotics', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Tetracycline antibiotic for skin infections, acne vulgaris, and tick-borne fever.', true, true),

-- Chronic (Cardiac & Diabetes)
('prod_metformin', 'Metformin 500 mg SR', 'Metformin Hydrochloride Prolonged Release', '500 mg', 'Tablet', '20 tablets • Glycomet-500', 4.80, 6.20, 'cat_chronic', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'First-line anti-diabetic medication to regulate blood glucose in Type 2 Diabetes.', true, true),
('prod_telmi', 'Telmisartan 40 mg', 'Telmisartan IP', '40 mg', 'Tablet', '15 tablets • Telma 40', 9.40, 12.00, 'cat_chronic', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Angiotensin receptor blocker for daily blood pressure control and cardiovascular health.', true, true),
('prod_atorva', 'Atorvastatin 10 mg', 'Atorvastatin Calcium IP', '10 mg', 'Tablet', '15 tablets • Atorlip 10', 10.50, 13.50, 'cat_chronic', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Statin medication to lower low-density lipoprotein (LDL) cholesterol and triglycerides.', true, true),
('prod_glim', 'Glimepiride 2 mg', 'Glimepiride IP', '2 mg', 'Tablet', '15 tablets • Amaryl 2', 7.90, 10.20, 'cat_chronic', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Sulfonylurea oral hypoglycemic agent for glycemic control in adult diabetic patients.', true, true),
('prod_insulin', 'Human Insulin Pen 100IU', 'Recombinant Human Insulin 30/70', '100 IU/ml (3 ml)', 'Pen', '1 Pre-filled Pen • NovoMix', 26.50, 32.00, 'cat_chronic', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Cold-chain delivery pre-filled insulin pen for glycemic control in diabetes mellitus.', true, true),

-- Pediatric Care
('prod_augmentin_syrup', 'Augmentin Duo Syrup', 'Amoxicillin 200mg + Potassium Clavulanate 28.5mg', '30 ml', 'Syrup', '30 ml Suspension • GSK', 8.50, 10.80, 'cat_pediatric', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Pediatric dry syrup for severe ear, throat, and chest infections in infants.', true, true),
('prod_calpol_drops', 'Calpol 100mg Paediatric Drops', 'Paracetamol Oral Suspension', '100 mg/ml', 'Drops', '15 ml bottle with dropper', 4.10, 5.40, 'cat_pediatric', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Gentle infant drops for rapid fever reduction after vaccination or teething pain.', false, true),
('prod_zincovit', 'Zincovit Paediatric Syrup', 'Multivitamin + Multimineral + Lysine', '100 ml', 'Syrup', '100 ml bottle • Apex Health', 7.20, 9.00, 'cat_pediatric', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Essential micronutrient syrup to boost infant appetite, recovery, and immunity.', false, true),
('prod_budecort', 'Budecort 0.5mg Respules', 'Budesonide Inhalation Suspension', '0.5 mg/2 ml', 'Respules', '5 respules • Cipla', 9.80, 12.50, 'cat_pediatric', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Corticosteroid nebulization solution for acute croup and pediatric asthma flare-ups.', true, true),

-- Wellness & Immunity
('prod_multi', 'Daily multivitamin', 'Multivitamin & Mineral Complex', '30 Tablets', 'Tablet', '30 tablets • WellDaily', 12.40, 15.00, 'cat_wellness', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Supports immune defence, cognitive focus, and cellular metabolic energy.', false, true),
('prod_vitc', 'Vitamin C 500 mg', 'Ascorbic Acid + Zinc Chewable', '500 mg', 'Tablet', '60 tablets • WellDaily', 10.60, 14.00, 'cat_wellness', 'https://images.unsplash.com/photo-1577401239170-897942555fb3?auto=format&fit=crop&w=400&q=80', 'Chewable orange-flavoured Vitamin C with elemental zinc for immune defense.', false, true),
('prod_saline', 'Saline nasal spray', 'Sodium Chloride Isotonic Solution', '30 ml', 'Spray', '30 ml • ClearBreathe', 8.20, 10.00, 'cat_wellness', 'https://images.unsplash.com/photo-1585751119414-ef2636f8aede?auto=format&fit=crop&w=400&q=80', 'Gentle isotonic nasal rinse formula to relieve sinus congestion and allergies.', false, true),
('prod_vitd3', 'Vitamin D3 60,000 IU', 'Cholecalciferol Capsules', '60,000 IU', 'Capsule', '4 capsules • Calcirol', 6.90, 8.80, 'cat_wellness', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'High-potency weekly Vitamin D3 supplement for bone density and calcium absorption.', false, true),
('prod_omega3', 'Omega-3 Triple Strength', 'Fish Oil 1000mg (550mg EPA / 330mg DHA)', '1000 mg', 'Softgel', '30 softgels • TrueBasics', 15.20, 19.50, 'cat_wellness', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Enteric-coated pure Omega-3 fish oil for heart, joint, and brain health.', false, true),

-- Medical Devices & First Aid
('prod_thermo', 'Digital thermometer', 'High-Precision Oral/Axillary Sensor', 'Fast read', 'Device', '1 Device • SafeCheck', 18.90, 22.00, 'cat_devices', 'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?auto=format&fit=crop&w=400&q=80', 'Accurate 10-second temperature reading with backlit LCD screen and fever alarm.', false, true),
('prod_oximeter', 'Fingertip Pulse Oximeter', 'Dual-Color OLED SpO2 & PR Monitor', 'OLED Sensor', 'Device', '1 Unit + Batteries • Beurer', 24.50, 29.90, 'cat_devices', 'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?auto=format&fit=crop&w=400&q=80', 'Measures blood oxygen saturation levels (SpO2) and pulse rate in 5 seconds.', false, true),
('prod_bp_monitor', 'Automatic BP Monitor', 'Digital Upper Arm Blood Pressure Cuff', 'Intellisense', 'Device', '1 Monitor + Large Cuff • Omron', 38.00, 48.00, 'cat_devices', 'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?auto=format&fit=crop&w=400&q=80', 'Clinically validated automatic digital blood pressure monitor with hypertension indicator.', false, true),
('prod_betadine', 'Betadine Antiseptic Solution', 'Povidone Iodine 10% w/v', '100 ml', 'Liquid', '100 ml bottle • Win-Medicare', 5.50, 7.00, 'cat_devices', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Hospital-grade topical microbicidal solution for cuts, wounds, and burns.', false, true),
('prod_burnol', 'Burnol First Aid Cream', 'Aminacrine HCl + Cetrimide Antiseptic', '20 g', 'Ointment', '20 g tube • Morepen', 3.40, 4.50, 'cat_devices', 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80', 'Instant cooling and antimicrobial cream for minor first and second-degree burns.', false, true);

-- ============================================================================
-- SEED DATA: 8 PARTNER CHEMISTS (WITHIN 7 KM)
-- ============================================================================
INSERT INTO partner_chemists (id, name, address, drug_license_no, gstin, phone, latitude, longitude) VALUES
('c1000000-0000-0000-0000-000000000001', 'Apollo Pharmacy Bellandur', '#42, Outer Ring Road, Bellandur, Bengaluru', 'KA-BLR-DL-2024-8492', '29AAAAA0000A1Z5', '+91 98450 11001', 12.9304, 77.6784),
('c1000000-0000-0000-0000-000000000002', 'MedPlus Green Glen Layout', '#108, Green Glen Layout, Bengaluru', 'KA-BLR-DL-2024-8493', '29BBBBB0000A1Z6', '+91 98450 11002', 12.9345, 77.6740),
('c1000000-0000-0000-0000-000000000003', 'Sanjeevani Care Medicals', '#12, Harlur Main Road, Bengaluru', 'KA-BLR-DL-2024-8494', '29CCCCC0000A1Z7', '+91 98450 11003', 12.9120, 77.6650),
('c1000000-0000-0000-0000-000000000004', 'Shree Ganesh Pharma (24/7)', '#88, Marathahalli Bridge, Bengaluru', 'KA-BLR-DL-2024-8495', '29DDDDD0000A1Z8', '+91 98450 11004', 12.9560, 77.7010),
('c1000000-0000-0000-0000-000000000005', 'Sarjapur Specialty Chemist', '#305, Sarjapur Road, Kaikondrahalli', 'KA-BLR-DL-2024-8496', '29EEEEE0000A1Z9', '+91 98450 11005', 12.9150, 77.6850),
('c1000000-0000-0000-0000-000000000006', 'LifeLine 24Hr Medicals', '#55, Kadubeesanahalli, Bengaluru', 'KA-BLR-DL-2024-8497', '29FFFFF0000A1Z1', '+91 98450 11006', 12.9410, 77.6920),
('c1000000-0000-0000-0000-000000000007', 'Koramangala Emergency Drugs', '#14, 5th Block, Koramangala, Bengaluru', 'KA-BLR-DL-2024-8498', '29GGGGG0000A1Z2', '+91 98450 11007', 12.9350, 77.6240),
('c1000000-0000-0000-0000-000000000008', 'Indiranagar 100ft Specialist Pharma', '#202, 100ft Road, Indiranagar', 'KA-BLR-DL-2024-8499', '29HHHHH0000A1Z3', '+91 98450 11008', 12.9780, 77.6430);

-- ============================================================================
-- SEED DATA: 6 PORTER RIDER COURIERS
-- ============================================================================
INSERT INTO couriers (id, name, phone, vehicle_number, rating, current_latitude, current_longitude) VALUES
('d1000000-0000-0000-0000-000000000001', 'Rajesh K.', '+91 98765 43210', 'KA-01-EQ-9874', 4.9, 12.9310, 77.6770),
('d1000000-0000-0000-0000-000000000002', 'Suresh M.', '+91 98765 43211', 'KA-03-HJ-4512', 4.8, 12.9350, 77.6730),
('d1000000-0000-0000-0000-000000000003', 'Anand Kumar', '+91 98765 43212', 'KA-05-MK-1290', 5.0, 12.9130, 77.6660),
('d1000000-0000-0000-0000-000000000004', 'Vikas Gowda', '+91 98765 43213', 'KA-53-EX-7821', 4.9, 12.9550, 77.7000),
('d1000000-0000-0000-0000-000000000005', 'Manoj Patil', '+91 98765 43214', 'KA-04-TR-9034', 4.8, 12.9160, 77.6840),
('d1000000-0000-0000-0000-000000000006', 'Rohan Verma', '+91 98765 43215', 'KA-02-ZZ-6712', 5.0, 12.9770, 77.6420);

-- ============================================================================
-- SEED DATA: SAMPLE LIVE ORDER (#MG-2048) & ORDER ITEMS
-- ============================================================================
INSERT INTO orders (id, order_number, user_phone, chemist_id, courier_id, status, total_amount, medicine_total, delivery_fee, priority_fee, payment_method, delivery_otp, tamper_bag_barcode, eta_time, delivery_address) VALUES
('b2048000-0000-0000-0000-000000002048', '#MG-2048', '+91 98888 77777', 'c1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000001', 'in_transit', 29.20, 24.70, 4.25, 0.25, 'COD', '7419', 'TM-84920-BAG', '11:30 AM', '742 Evergreen Terrace, Apt 4B, Springfield');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES
('b2048000-0000-0000-0000-000000002048', 'prod_para', 1, 5.80, 5.80),
('b2048000-0000-0000-0000-000000002048', 'prod_thermo', 1, 18.90, 18.90);
