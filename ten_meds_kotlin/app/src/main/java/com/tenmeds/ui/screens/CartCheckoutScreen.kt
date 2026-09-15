package com.tenmeds.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.tenmeds.data.repository.MedicineRepository
import com.tenmeds.ui.components.DeliverySlaBanner
import com.tenmeds.ui.components.GlassButton
import com.tenmeds.ui.components.LiquidGlassCard
import com.tenmeds.ui.theme.*

@Composable
fun CartCheckoutScreen(
    onBack: () -> Unit,
    onOrderPlaced: () -> Unit
) {
    val cartItems by MedicineRepository.cart.collectAsState()
    var selectedPayment by remember { mutableStateOf("COD") }
    var selectedDistanceKm by remember { mutableDoubleStateOf(1.8) }

    val bill = remember(cartItems, selectedDistanceKm) {
        MedicineRepository.calculateBill(selectedDistanceKm)
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(ScaffoldBg)
    ) {
        // Top Header
        Surface(
            modifier = Modifier.fillMaxWidth(),
            color = Color.White,
            shadowElevation = 2.dp
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                IconButton(onClick = onBack) {
                    Icon(Icons.Default.ArrowBack, contentDescription = "Back", tint = SlateDark)
                }
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = "Cart & Dynamic Bill",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    color = SlateDark
                )
            }
        }

        LazyColumn(
            modifier = Modifier
                .weight(1f)
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            item { Spacer(modifier = Modifier.height(4.dp)) }

            // SLA Banner
            item {
                DeliverySlaBanner()
            }

            // Cart Items List
            item {
                Text(
                    text = "Items in Bag (${cartItems.sumOf { it.quantity }})",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Bold,
                    color = SlateDark
                )
            }

            items(cartItems) { item ->
                LiquidGlassCard(
                    modifier = Modifier.fillMaxWidth(),
                    cornerRadius = 16.dp
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = item.product.brandName,
                                fontSize = 13.sp,
                                fontWeight = FontWeight.Bold,
                                color = SlateDark
                            )
                            Text(
                                text = "$${String.format("%.2f", item.product.price)} each • ${item.product.stripSize}",
                                fontSize = 11.sp,
                                color = SlateMuted
                            )
                        }

                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(10.dp)
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(28.dp)
                                    .clip(RoundedCornerShape(6.dp))
                                    .background(Color(0xFFF1F5F9))
                                    .clickable { MedicineRepository.removeFromCart(item.product) },
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(Icons.Default.Remove, contentDescription = null, tint = SlateDark, modifier = Modifier.size(14.dp))
                            }

                            Text(
                                text = item.quantity.toString(),
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Bold,
                                color = SlateDark
                            )

                            Box(
                                modifier = Modifier
                                    .size(28.dp)
                                    .clip(RoundedCornerShape(6.dp))
                                    .background(Color(0xFFF1F5F9))
                                    .clickable { MedicineRepository.addToCart(item.product) },
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(Icons.Default.Add, contentDescription = null, tint = SlateDark, modifier = Modifier.size(14.dp))
                            }
                        }
                    }
                }
            }

            // Distance & Porter Tiers
            item {
                LiquidGlassCard(modifier = Modifier.fillMaxWidth()) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text(
                            text = "Chemist Distance Tier",
                            fontSize = 13.sp,
                            fontWeight = FontWeight.Bold,
                            color = ForestEmeraldDark
                        )
                        Text(
                            text = "${selectedDistanceKm} km (${bill.etaMinutes} min ETA)",
                            fontSize = 13.sp,
                            fontWeight = FontWeight.ExtraBold,
                            color = ForestEmerald
                        )
                    }
                    Spacer(modifier = Modifier.height(10.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        listOf(1.2, 1.8, 3.5, 6.0).forEach { dist ->
                            val isSelected = selectedDistanceKm == dist
                            Box(
                                modifier = Modifier
                                    .weight(1f)
                                    .clip(RoundedCornerShape(10.dp))
                                    .background(if (isSelected) ForestEmerald else Color.White)
                                    .border(1.dp, if (isSelected) ForestEmerald else SlateBorder, RoundedCornerShape(10.dp))
                                    .clickable { selectedDistanceKm = dist }
                                    .padding(vertical = 8.dp),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(
                                    text = "$dist km",
                                    fontSize = 11.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = if (isSelected) Color.White else SlateDark
                                )
                            }
                        }
                    }
                }
            }

            // Dynamic Bill Breakdown
            item {
                LiquidGlassCard(modifier = Modifier.fillMaxWidth()) {
                    Text(
                        text = "Dynamic Bill Breakdown",
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Bold,
                        color = SlateDark
                    )
                    Spacer(modifier = Modifier.height(8.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Medicine Total (MRP)", fontSize = 12.sp, color = SlateMuted)
                        Text("$${String.format("%.2f", bill.medicineTotal)}", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = SlateDark)
                    }
                    Spacer(modifier = Modifier.height(4.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Text("Urgent Handling Fee", fontSize = 12.sp, color = SlateMuted)
                            Spacer(modifier = Modifier.width(4.dp))
                            Box(modifier = Modifier.clip(RoundedCornerShape(4.dp)).background(AmberLight).padding(horizontal = 4.dp, vertical = 1.dp)) {
                                Text("Flat ?20", fontSize = 9.sp, fontWeight = FontWeight.Bold, color = Color(0xFF92400E))
                            }
                        }
                        Text("$${String.format("%.2f", bill.urgentHandlingFee)}", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = SlateDark)
                    }
                    Spacer(modifier = Modifier.height(4.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Porter 2-Wheeler (${selectedDistanceKm} km)", fontSize = 12.sp, color = SlateMuted)
                        Text("$${String.format("%.2f", bill.deliveryFee)}", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = SlateDark)
                    }

                    Divider(modifier = Modifier.padding(vertical = 8.dp), color = SlateBorder)

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Grand Total", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = SlateDark)
                        Text("$${String.format("%.2f", bill.totalAmount)}", fontSize = 18.sp, fontWeight = FontWeight.ExtraBold, color = ForestEmerald)
                    }
                }
            }

            // Payment Mode Selector
            item {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .weight(1f)
                            .clip(RoundedCornerShape(12.dp))
                            .background(if (selectedPayment == "UPI") ForestEmerald else Color.White)
                            .border(1.dp, if (selectedPayment == "UPI") ForestEmerald else SlateBorder, RoundedCornerShape(12.dp))
                            .clickable { selectedPayment = "UPI" }
                            .padding(vertical = 12.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = "Instant UPI (1-Tap)",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold,
                            color = if (selectedPayment == "UPI") Color.White else SlateDark
                        )
                    }

                    Box(
                        modifier = Modifier
                            .weight(1f)
                            .clip(RoundedCornerShape(12.dp))
                            .background(if (selectedPayment == "COD") ForestEmerald else Color.White)
                            .border(1.dp, if (selectedPayment == "COD") ForestEmerald else SlateBorder, RoundedCornerShape(12.dp))
                            .clickable { selectedPayment = "COD" }
                            .padding(vertical = 12.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = "Cash on Delivery",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold,
                            color = if (selectedPayment == "COD") Color.White else SlateDark
                        )
                    }
                }
            }

            item {
                Spacer(modifier = Modifier.height(16.dp))
            }
        }

        // Place Order CTA
        Surface(
            modifier = Modifier.fillMaxWidth(),
            color = Color.White,
            shadowElevation = 8.dp
        ) {
            Box(modifier = Modifier.padding(16.dp)) {
                GlassButton(
                    text = "Place Emergency Order • $${String.format("%.2f", bill.totalAmount)}",
                    onClick = {
                        MedicineRepository.placeOrder(
                            address = "742 Evergreen Terrace, Apt 4B, Springfield",
                            paymentMethod = selectedPayment
                        )
                        onOrderPlaced()
                    },
                    modifier = Modifier.fillMaxWidth()
                )
            }
        }
    }
}
