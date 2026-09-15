package com.tenmeds.data.models

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class Category(
    val id: String,
    val name: String,
    @SerialName("icon_name") val iconName: String = "medkit",
    @SerialName("display_order") val displayOrder: Int = 0
)

@Serializable
data class Product(
    val id: String,
    @SerialName("brand_name") val brandName: String,
    @SerialName("generic_salt") val genericSalt: String,
    val strength: String,
    @SerialName("dosage_form") val dosageForm: String = "Tablet",
    @SerialName("strip_size") val stripSize: String,
    val price: Double,
    val mrp: Double,
    @SerialName("category_id") val categoryId: String,
    @SerialName("image_url") val imageUrl: String,
    val description: String,
    @SerialName("is_schedule_h") val isScheduleH: Boolean = false,
    @SerialName("in_stock") val inStock: Boolean = true,
    @SerialName("substitute_product_id") val substituteProductId: String? = null
)

data class CartItem(
    val product: Product,
    var quantity: Int = 1
)

@Serializable
data class PartnerChemist(
    val id: String,
    val name: String,
    val address: String,
    @SerialName("drug_license_no") val drugLicenseNo: String,
    val gstin: String,
    val phone: String,
    val latitude: Double = 12.9304,
    val longitude: Double = 77.6784,
    @SerialName("is_active") val isActive: Boolean = true
)

@Serializable
data class Courier(
    val id: String,
    val name: String,
    val phone: String,
    @SerialName("vehicle_number") val vehicleNumber: String,
    val rating: Double = 4.9,
    @SerialName("current_latitude") val currentLatitude: Double = 12.9310,
    @SerialName("current_longitude") val currentLongitude: Double = 77.6770,
    @SerialName("is_available") val isAvailable: Boolean = true
)

@Serializable
data class Order(
    val id: String,
    @SerialName("order_number") val orderNumber: String,
    @SerialName("user_phone") val userPhone: String,
    @SerialName("chemist_id") val chemistId: String? = null,
    @SerialName("courier_id") val courierId: String? = null,
    val status: String = "confirmed", // confirmed, packed, in_transit, delivered
    @SerialName("total_amount") val totalAmount: Double,
    @SerialName("medicine_total") val medicineTotal: Double,
    @SerialName("delivery_fee") val deliveryFee: Double = 40.0,
    @SerialName("priority_fee") val priorityFee: Double = 20.0,
    @SerialName("payment_method") val paymentMethod: String = "COD",
    @SerialName("delivery_otp") val deliveryOtp: String = "7419",
    @SerialName("tamper_bag_barcode") val tamperBagBarcode: String = "TM-84920-BAG",
    @SerialName("eta_time") val etaTime: String = "11:30 AM",
    @SerialName("delivery_address") val deliveryAddress: String,
    @SerialName("prescription_url") val prescriptionUrl: String? = null,
    @SerialName("created_at") val createdAt: String? = null
)

data class DynamicBill(
    val medicineTotal: Double,
    val deliveryFee: Double,
    val urgentHandlingFee: Double = 20.0,
    val totalAmount: Double,
    val distanceKm: Double = 1.8,
    val etaMinutes: Int = 12
)
