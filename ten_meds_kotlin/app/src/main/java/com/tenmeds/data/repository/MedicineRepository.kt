package com.tenmeds.data.repository

import com.tenmeds.data.models.*
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json
import kotlin.math.roundToInt
import kotlin.random.Random

object MedicineRepository {

    private val httpClient = HttpClient {
        install(ContentNegotiation) {
            json(Json {
                ignoreUnknownKeys = true
                isLenient = true
                prettyPrint = true
            })
        }
    }

    // Configurable Supabase credentials
    var supabaseUrl = "https://rjqgxnvljgmfluzpgeht.supabase.co"
    var supabaseKey = "sb_publishable_wfWpqoUlRzmGUSnaiyOA1A_m_MXSynK"

    val categories = listOf(
        Category("cat_all", "All Medicines", "medkit", 0),
        Category("cat_emergency", "Emergency & Acute", "flash", 1),
        Category("cat_antibiotics", "Antibiotics", "flask", 2),
        Category("cat_chronic", "Cardiac & Diabetes", "heart", 3),
        Category("cat_pediatric", "Pediatric Care", "child", 4),
        Category("cat_wellness", "Wellness & Vitamins", "leaf", 5),
        Category("cat_devices", "Medical Devices", "thermometer", 6)
    )

    // 30+ Comprehensive Real Medicines Catalog
    val allProducts = listOf(
        // Emergency & Acute
        Product(
            id = "prod_para",
            brandName = "Paracetamol 500 mg",
            genericSalt = "Paracetamol (Acetaminophen)",
            strength = "500 mg",
            dosageForm = "Tablet",
            stripSize = "20 tablets � Acme Health",
            price = 5.80,
            mrp = 7.50,
            categoryId = "cat_emergency",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Fast-acting relief from mild to moderate fever, headaches, muscular pain, and body ache.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_ibup",
            brandName = "Ibuprofen 400 mg",
            genericSalt = "Ibuprofen IP",
            strength = "400 mg",
            dosageForm = "Tablet",
            stripSize = "15 tablets � Brufen Care",
            price = 6.40,
            mrp = 8.20,
            categoryId = "cat_emergency",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Non-steroidal anti-inflammatory drug (NSAID) for acute dental pain, swelling, and joint stiffness.",
            isScheduleH = true,
            inStock = true
        ),
        Product(
            id = "prod_asthalin",
            brandName = "Asthalin Inhaler 100 mcg",
            genericSalt = "Salbutamol / Albuterol Sulfate",
            strength = "100 mcg/dose",
            dosageForm = "Inhaler",
            stripSize = "200 metered doses � Cipla",
            price = 14.50,
            mrp = 18.00,
            categoryId = "cat_emergency",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Rapid-acting bronchodilator for acute asthma attacks, sudden wheezing, and bronchospasm relief.",
            isScheduleH = true,
            inStock = true
        ),
        Product(
            id = "prod_ors",
            brandName = "Electral WHO-ORS",
            genericSalt = "Oral Rehydration Salts (WHO Formula)",
            strength = "21.8 g sachet",
            dosageForm = "Powder",
            stripSize = "5 sachets � FDC Health",
            price = 4.20,
            mrp = 5.50,
            categoryId = "cat_emergency",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Restores vital electrolytes and fluids during acute dehydration, vomiting, or diarrhea.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_cetirizine",
            brandName = "Cetirizine 10 mg",
            genericSalt = "Cetirizine Hydrochloride",
            strength = "10 mg",
            dosageForm = "Tablet",
            stripSize = "10 tablets � Cetzine",
            price = 3.80,
            mrp = 5.00,
            categoryId = "cat_emergency",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Non-drowsy antihistamine for acute allergic reactions, hives, runny nose, and pollen allergy.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_panto",
            brandName = "Pantoprazole 40 mg",
            genericSalt = "Pantoprazole Sodium Gastro-resistant",
            strength = "40 mg",
            dosageForm = "Tablet",
            stripSize = "15 tablets � Pan-40",
            price = 8.90,
            mrp = 11.50,
            categoryId = "cat_emergency",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Proton pump inhibitor (PPI) for acute acid reflux, heartburn, and peptic ulcer relief.",
            isScheduleH = true,
            inStock = true
        ),

        // Antibiotics
        Product(
            id = "prod_azith",
            brandName = "Azithromycin 500 mg",
            genericSalt = "Azithromycin Dihydrate IP",
            strength = "500 mg",
            dosageForm = "Tablet",
            stripSize = "5 tablets � Azithral 500",
            price = 11.20,
            mrp = 14.00,
            categoryId = "cat_antibiotics",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Broad-spectrum macrolide antibiotic for severe respiratory tract, throat, and chest infections.",
            isScheduleH = true,
            inStock = true
        ),
        Product(
            id = "prod_amox",
            brandName = "Augmentin 625 Duo",
            genericSalt = "Amoxicillin 500mg + Potassium Clavulanate 125mg",
            strength = "625 mg",
            dosageForm = "Tablet",
            stripSize = "10 tablets � GSK",
            price = 16.80,
            mrp = 21.00,
            categoryId = "cat_antibiotics",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Potent antibiotic for resistant bacterial infections, dental abscesses, and sinusitis.",
            isScheduleH = true,
            inStock = true
        ),
        Product(
            id = "prod_cipro",
            brandName = "Ciprofloxacin 500 mg",
            genericSalt = "Ciprofloxacin Hydrochloride",
            strength = "500 mg",
            dosageForm = "Tablet",
            stripSize = "10 tablets � Ciplox 500",
            price = 7.50,
            mrp = 9.80,
            categoryId = "cat_antibiotics",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Fluoroquinolone antibiotic for urinary tract, gastrointestinal, and skin infections.",
            isScheduleH = true,
            inStock = true
        ),
        Product(
            id = "prod_cough_syrup",
            brandName = "Ascoril D+ Cough Syrup",
            genericSalt = "Dextromethorphan + Chlorpheniramine + Phenylephrine",
            strength = "100 ml",
            dosageForm = "Syrup",
            stripSize = "100 ml bottle � Glenmark",
            price = 6.20,
            mrp = 7.90,
            categoryId = "cat_antibiotics",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Sugar-free dry cough syrup providing quick relief from throat irritation and chest congestion.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_doxy",
            brandName = "Doxycycline 100 mg",
            genericSalt = "Doxycycline Hyclate IP",
            strength = "100 mg",
            dosageForm = "Capsule",
            stripSize = "10 capsules � Doxypal",
            price = 8.10,
            mrp = 10.50,
            categoryId = "cat_antibiotics",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Tetracycline antibiotic for skin infections, acne vulgaris, and tick-borne fever.",
            isScheduleH = true,
            inStock = true
        ),

        // Chronic (Cardiac & Diabetes)
        Product(
            id = "prod_metformin",
            brandName = "Glycomet 500 SR",
            genericSalt = "Metformin Hydrochloride Prolonged Release",
            strength = "500 mg",
            dosageForm = "Tablet",
            stripSize = "20 tablets � USV",
            price = 4.80,
            mrp = 6.20,
            categoryId = "cat_chronic",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "First-line anti-diabetic medication to regulate blood glucose in Type 2 Diabetes.",
            isScheduleH = true,
            inStock = true
        ),
        Product(
            id = "prod_telmi",
            brandName = "Telma 40 mg",
            genericSalt = "Telmisartan IP",
            strength = "40 mg",
            dosageForm = "Tablet",
            stripSize = "15 tablets � Glenmark",
            price = 9.40,
            mrp = 12.00,
            categoryId = "cat_chronic",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Daily blood pressure regulation and cardiovascular protection for hypertensive patients.",
            isScheduleH = true,
            inStock = true
        ),
        Product(
            id = "prod_atorva",
            brandName = "Atorlip 10 mg",
            genericSalt = "Atorvastatin Calcium IP",
            strength = "10 mg",
            dosageForm = "Tablet",
            stripSize = "15 tablets � Cipla",
            price = 10.50,
            mrp = 13.50,
            categoryId = "cat_chronic",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Lowers low-density lipoprotein (LDL) cholesterol and prevents cardiovascular disease.",
            isScheduleH = true,
            inStock = true
        ),
        Product(
            id = "prod_insulin",
            brandName = "NovoMix 30 FlexPen 100IU",
            genericSalt = "Biphasic Insulin Aspart Recombinant",
            strength = "100 IU/ml (3 ml)",
            dosageForm = "Pen",
            stripSize = "1 Pre-filled Pen � Novo Nordisk",
            price = 26.50,
            mrp = 32.00,
            categoryId = "cat_chronic",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Cold-chain delivered insulin pen for rapid and intermediate glycemic control.",
            isScheduleH = true,
            inStock = true
        ),

        // Pediatric Care
        Product(
            id = "prod_augmentin_syrup",
            brandName = "Augmentin Duo Suspension",
            genericSalt = "Amoxicillin 200mg + Potassium Clavulanate 28.5mg",
            strength = "30 ml",
            dosageForm = "Syrup",
            stripSize = "30 ml Suspension � GSK",
            price = 8.50,
            mrp = 10.80,
            categoryId = "cat_pediatric",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Pediatric dry syrup for severe ear, throat, and respiratory infections in children.",
            isScheduleH = true,
            inStock = true
        ),
        Product(
            id = "prod_calpol_drops",
            brandName = "Calpol 100mg Infant Drops",
            genericSalt = "Paracetamol Paediatric Oral Suspension",
            strength = "100 mg/ml",
            dosageForm = "Drops",
            stripSize = "15 ml bottle with dropper � GSK",
            price = 4.10,
            mrp = 5.40,
            categoryId = "cat_pediatric",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Gentle infant drops for rapid fever reduction after vaccination and teething discomfort.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_zincovit",
            brandName = "Zincovit Paediatric Syrup",
            genericSalt = "Multivitamin + Multimineral + Lysine",
            strength = "100 ml",
            dosageForm = "Syrup",
            stripSize = "100 ml bottle � Apex Health",
            price = 7.20,
            mrp = 9.00,
            categoryId = "cat_pediatric",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Essential micronutrient syrup to boost child appetite, post-fever recovery, and immunity.",
            isScheduleH = false,
            inStock = true
        ),

        // Wellness & Vitamins
        Product(
            id = "prod_multi",
            brandName = "Daily multivitamin",
            genericSalt = "Multivitamin & Mineral Complex",
            strength = "30 Tablets",
            dosageForm = "Tablet",
            stripSize = "30 tablets � WellDaily",
            price = 12.40,
            mrp = 15.00,
            categoryId = "cat_wellness",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "A convenient daily dietary supplement. Supports immune defence, cognitive focus, and cellular energy.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_vitc",
            brandName = "Vitamin C 500 mg Chewable",
            genericSalt = "Ascorbic Acid + Zinc Chewable",
            strength = "500 mg",
            dosageForm = "Tablet",
            stripSize = "60 tablets � WellDaily",
            price = 10.60,
            mrp = 14.00,
            categoryId = "cat_wellness",
            imageUrl = "https://images.unsplash.com/photo-1577401239170-897942555fb3?auto=format&fit=crop&w=400&q=80",
            description = "Chewable orange-flavoured Vitamin C with elemental zinc for enhanced immune resistance.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_saline",
            brandName = "Saline nasal spray",
            genericSalt = "Sodium Chloride Isotonic Solution",
            strength = "30 ml",
            dosageForm = "Spray",
            stripSize = "30 ml � ClearBreathe",
            price = 8.20,
            mrp = 10.00,
            categoryId = "cat_wellness",
            imageUrl = "https://images.unsplash.com/photo-1585751119414-ef2636f8aede?auto=format&fit=crop&w=400&q=80",
            description = "Gentle isotonic nasal rinse formula to relieve sinus congestion, dry nasal passages, and allergies.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_vitd3",
            brandName = "Calcirol 60,000 IU",
            genericSalt = "Cholecalciferol Capsules USP",
            strength = "60,000 IU",
            dosageForm = "Capsule",
            stripSize = "4 capsules � Cadila",
            price = 6.90,
            mrp = 8.80,
            categoryId = "cat_wellness",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "High-potency weekly Vitamin D3 supplement for bone density and calcium absorption.",
            isScheduleH = false,
            inStock = true
        ),

        // Medical Devices & First Aid
        Product(
            id = "prod_thermo",
            brandName = "Digital thermometer",
            genericSalt = "High-Precision Oral/Axillary Sensor",
            strength = "Fast read",
            dosageForm = "Device",
            stripSize = "1 Device � SafeCheck",
            price = 18.90,
            mrp = 22.00,
            categoryId = "cat_devices",
            imageUrl = "https://images.unsplash.com/photo-1584017911766-d451b3d0e843?auto=format&fit=crop&w=400&q=80",
            description = "Accurate 10-second temperature reading with high-contrast backlit LCD screen and fever alarm.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_oximeter",
            brandName = "Fingertip Pulse Oximeter",
            genericSalt = "Dual-Color OLED SpO2 Sensor",
            strength = "OLED Display",
            dosageForm = "Device",
            stripSize = "1 Unit + Batteries � Beurer",
            price = 24.50,
            mrp = 29.90,
            categoryId = "cat_devices",
            imageUrl = "https://images.unsplash.com/photo-1584017911766-d451b3d0e843?auto=format&fit=crop&w=400&q=80",
            description = "Measures blood oxygen saturation levels (SpO2) and pulse rate in 5 seconds with waveform graph.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_bp_monitor",
            brandName = "Omron Automatic BP Monitor",
            genericSalt = "Digital Intellisense Blood Pressure Cuff",
            strength = "Upper Arm Cuff",
            dosageForm = "Device",
            stripSize = "1 Monitor + Large Cuff � Omron",
            price = 38.00,
            mrp = 48.00,
            categoryId = "cat_devices",
            imageUrl = "https://images.unsplash.com/photo-1584017911766-d451b3d0e843?auto=format&fit=crop&w=400&q=80",
            description = "Clinically validated automatic digital blood pressure monitor with hypertension indicator.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_betadine",
            brandName = "Betadine Antiseptic 10%",
            genericSalt = "Povidone Iodine 10% w/v",
            strength = "100 ml",
            dosageForm = "Liquid",
            stripSize = "100 ml bottle � Win-Medicare",
            price = 5.50,
            mrp = 7.00,
            categoryId = "cat_devices",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Hospital-grade topical microbicidal solution for quick disinfection of cuts, wounds, and burns.",
            isScheduleH = false,
            inStock = true
        ),
        Product(
            id = "prod_burnol",
            brandName = "Burnol First Aid Cream",
            genericSalt = "Aminacrine HCl + Cetrimide Antiseptic",
            strength = "20 g",
            dosageForm = "Ointment",
            stripSize = "20 g tube � Morepen",
            price = 3.40,
            mrp = 4.50,
            categoryId = "cat_devices",
            imageUrl = "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80",
            description = "Instant cooling and antimicrobial cream for minor first and second-degree burns and scalds.",
            isScheduleH = false,
            inStock = true
        )
    )

    val partnerChemist = PartnerChemist(
        id = "c1000000-0000-0000-0000-000000000001",
        name = "Apollo Pharmacy Bellandur",
        address = "#42, Outer Ring Road, Bellandur, Bengaluru",
        drugLicenseNo = "KA-BLR-DL-2024-8492",
        gstin = "29AAAAA0000A1Z5",
        phone = "+91 98450 11001"
    )

    val courierRider = Courier(
        id = "d1000000-0000-0000-0000-000000000001",
        name = "Rajesh K. (Porter Express)",
        phone = "+91 98765 43210",
        vehicleNumber = "KA-01-EQ-9874",
        rating = 4.9
    )

    // State Holders
    private val _cart = MutableStateFlow<List<CartItem>>(
        listOf(
            CartItem(allProducts.first { it.id == "prod_para" }, 1),
            CartItem(allProducts.first { it.id == "prod_thermo" }, 1)
        )
    )
    val cart: StateFlow<List<CartItem>> = _cart.asStateFlow()

    private val _currentOrder = MutableStateFlow<Order>(
        Order(
            id = "MG-2048",
            orderNumber = "#MG-2048",
            userPhone = "+91 98888 77777",
            chemistId = partnerChemist.id,
            courierId = courierRider.id,
            status = "in_transit",
            totalAmount = 29.20,
            medicineTotal = 24.70,
            deliveryFee = 4.25,
            priorityFee = 0.25,
            paymentMethod = "COD",
            deliveryOtp = "7419",
            tamperBagBarcode = "TM-84920-BAG",
            etaTime = "11:30 AM",
            deliveryAddress = "742 Evergreen Terrace, Apt 4B, Springfield"
        )
    )
    val currentOrder: StateFlow<Order> = _currentOrder.asStateFlow()

    fun addToCart(product: Product, quantity: Int = 1) {
        val current = _cart.value.toMutableList()
        val existingIndex = current.indexWhere { it.product.id == product.id }
        if (existingIndex != -1) {
            current[existingIndex] = current[existingIndex].copy(
                quantity = current[existingIndex].quantity + quantity
            )
        } else {
            current.add(CartItem(product = product, quantity = quantity))
        }
        _cart.value = current
    }

    fun removeFromCart(product: Product) {
        val current = _cart.value.toMutableList()
        val existingIndex = current.indexWhere { it.product.id == product.id }
        if (existingIndex != -1) {
            if (current[existingIndex].quantity > 1) {
                current[existingIndex] = current[existingIndex].copy(
                    quantity = current[existingIndex].quantity - 1
                )
            } else {
                current.removeAt(existingIndex)
            }
            _cart.value = current
        }
    }

    fun calculateBill(distanceKm: Double = 1.8): DynamicBill {
        val medTotal = _cart.value.fold(0.0) { sum, item -> sum + (item.product.price * item.quantity) }
        val porterDelivery = 2.50 + (distanceKm * 0.80)
        val urgentHandling = 0.25 // equivalent of flat ?20
        val total = medTotal + porterDelivery + urgentHandling
        val etaMin = (8 + (distanceKm * 2.5)).roundToInt()

        return DynamicBill(
            medicineTotal = (medTotal * 100.0).roundToInt() / 100.0,
            deliveryFee = (porterDelivery * 100.0).roundToInt() / 100.0,
            urgentHandlingFee = urgentHandling,
            totalAmount = (total * 100.0).roundToInt() / 100.0,
            distanceKm = distanceKm,
            etaMinutes = etaMin
        )
    }

    fun placeOrder(address: String, paymentMethod: String): Order {
        val bill = calculateBill()
        val orderId = "MG-" + Random.nextInt(1000, 9999)
        val otp = Random.nextInt(1000, 9999).toString()
        val barcode = "TM-${Random.nextInt(10000, 99999)}-BAG"

        val order = Order(
            id = orderId,
            orderNumber = "#$orderId",
            userPhone = "+91 98888 77777",
            chemistId = partnerChemist.id,
            courierId = courierRider.id,
            status = "confirmed",
            totalAmount = bill.totalAmount,
            medicineTotal = bill.medicineTotal,
            deliveryFee = bill.deliveryFee,
            priorityFee = bill.urgentHandlingFee,
            paymentMethod = paymentMethod,
            deliveryOtp = otp,
            tamperBagBarcode = barcode,
            etaTime = "11:30 AM",
            deliveryAddress = address
        )
        _currentOrder.value = order
        return order
    }

    fun verifyDeliveryOtp(enteredOtp: String): Boolean {
        return if (_currentOrder.value.deliveryOtp == enteredOtp.trim()) {
            _currentOrder.value = _currentOrder.value.copy(status = "delivered")
            true
        } else {
            false
        }
    }

    private fun <T> List<T>.indexWhere(predicate: (T) -> Boolean): Int {
        for (i in indices) {
            if (predicate(this[i])) return i
        }
        return -1
    }
}
