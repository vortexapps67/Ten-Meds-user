package com.tenmeds.ui.screens

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.tenmeds.data.repository.MedicineRepository
import com.tenmeds.ui.components.GlassButton
import com.tenmeds.ui.components.LiquidGlassCard
import com.tenmeds.ui.components.LivePulseDot
import com.tenmeds.ui.theme.*

@Composable
fun TrackOrderScreen(
    onBackToHome: () -> Unit
) {
    val context = LocalContext.current
    val currentOrder by MedicineRepository.currentOrder.collectAsState()
    val courier = MedicineRepository.courierRider
    val chemist = MedicineRepository.partnerChemist

    var enteredOtp by remember { mutableStateOf("") }
    var otpMessage by remember { mutableStateOf<String?>(null) }

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
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    IconButton(onClick = onBackToHome) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back", tint = SlateDark)
                    }
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = "Track Order",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        color = SlateDark
                    )
                }
                IconButton(onClick = {}) {
                    Icon(Icons.Default.HelpOutline, contentDescription = "Help", tint = SlateDark)
                }
            }
        }

        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            item { Spacer(modifier = Modifier.height(4.dp)) }

            // Hero Live Order Card
            item {
                LiquidGlassCard(
                    modifier = Modifier.fillMaxWidth(),
                    cornerRadius = 20.dp
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.Top
                    ) {
                        Column {
                            Text(
                                text = "ORDER ${currentOrder.orderNumber}",
                                fontSize = 11.sp,
                                fontWeight = FontWeight.ExtraBold,
                                color = SlateMuted,
                                letterSpacing = 0.5.sp
                            )
                            Spacer(modifier = Modifier.height(2.dp))
                            Text(
                                text = "Arriving by ${currentOrder.etaTime}",
                                fontSize = 18.sp,
                                fontWeight = FontWeight.Bold,
                                color = SlateDark
                            )
                        }
                        LivePulseDot()
                    }

                    Spacer(modifier = Modifier.height(14.dp))

                    // Courier Rider Row
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(14.dp))
                            .background(MintBackground)
                            .border(1.dp, MintBorder, RoundedCornerShape(14.dp))
                            .padding(10.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(
                            modifier = Modifier
                                .size(40.dp)
                                .clip(CircleShape)
                                .background(Color.White),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(Icons.Default.TwoWheeler, contentDescription = null, tint = ForestEmerald, modifier = Modifier.size(22.dp))
                        }
                        Spacer(modifier = Modifier.width(10.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = courier.name,
                                fontSize = 13.sp,
                                fontWeight = FontWeight.Bold,
                                color = ForestEmeraldDark
                            )
                            Text(
                                text = "${courier.vehicleNumber} • ${courier.rating} ?",
                                fontSize = 11.sp,
                                color = ForestEmeraldLight
                            )
                        }
                        Box(
                            modifier = Modifier
                                .size(36.dp)
                                .clip(CircleShape)
                                .background(Color.White)
                                .clickable {
                                    val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:${courier.phone}"))
                                    context.startActivity(intent)
                                },
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(Icons.Default.Call, contentDescription = "Call", tint = ForestEmerald, modifier = Modifier.size(18.dp))
                        }
                    }
                }
            }

            // 4-Stage Vertical Delivery Timeline
            item {
                LiquidGlassCard(modifier = Modifier.fillMaxWidth()) {
                    Text(
                        text = "Live Order Progress",
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Bold,
                        color = SlateDark
                    )
                    Spacer(modifier = Modifier.height(14.dp))

                    TimelineStepRow(
                        title = "Order confirmed",
                        subtitle = "10:14 AM • Prescription salt matched",
                        isCompleted = true,
                        isActive = false
                    )
                    TimelineStepRow(
                        title = "Packed by ${chemist.name}",
                        subtitle = "10:26 AM • Tamper bag #${currentOrder.tamperBagBarcode}",
                        isCompleted = true,
                        isActive = false
                    )
                    TimelineStepRow(
                        title = "Courier is on the way",
                        subtitle = "Arriving in 13-25 min • Porter Express",
                        isCompleted = currentOrder.status == "delivered",
                        isActive = currentOrder.status == "in_transit",
                        showConnector = true
                    )
                    TimelineStepRow(
                        title = "Delivered to Doorstep",
                        subtitle = "Verify with 4-digit OTP: ${currentOrder.deliveryOtp}",
                        isCompleted = currentOrder.status == "delivered",
                        isActive = false,
                        showConnector = false
                    )
                }
            }

            // Doorstep OTP Verification Box
            item {
                LiquidGlassCard(modifier = Modifier.fillMaxWidth()) {
                    Text(
                        text = "Doorstep Handover Verification",
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Bold,
                        color = SlateDark
                    )
                    Text(
                        text = "Share this 4-digit OTP with the Porter rider when receiving your sealed bag:",
                        fontSize = 12.sp,
                        color = SlateMuted,
                        modifier = Modifier.padding(vertical = 4.dp)
                    )

                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(12.dp))
                            .background(Color(0xFFF1F5F9))
                            .padding(14.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "Handover OTP",
                            fontSize = 13.sp,
                            fontWeight = FontWeight.SemiBold,
                            color = SlateDark
                        )
                        Box(
                            modifier = Modifier
                                .clip(RoundedCornerShape(8.dp))
                                .background(ForestEmerald)
                                .padding(horizontal = 12.dp, vertical = 6.dp)
                        ) {
                            Text(
                                text = currentOrder.deliveryOtp,
                                fontSize = 16.sp,
                                fontWeight = FontWeight.ExtraBold,
                                color = Color.White,
                                letterSpacing = 2.sp
                            )
                        }
                    }

                    if (currentOrder.status != "delivered") {
                        Spacer(modifier = Modifier.height(10.dp))
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(8.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            OutlinedTextField(
                                value = enteredOtp,
                                onValueChange = { if (it.length <= 4) enteredOtp = it },
                                placeholder = { Text("Enter OTP to test", fontSize = 12.sp) },
                                singleLine = true,
                                shape = RoundedCornerShape(10.dp),
                                modifier = Modifier.weight(1f)
                            )
                            Button(
                                onClick = {
                                    val success = MedicineRepository.verifyDeliveryOtp(enteredOtp)
                                    otpMessage = if (success) "? Order Marked Delivered!" else "? Invalid OTP"
                                },
                                colors = ButtonDefaults.buttonColors(containerColor = ForestEmerald),
                                shape = RoundedCornerShape(10.dp)
                            ) {
                                Text("Verify")
                            }
                        }
                    }

                    if (otpMessage != null) {
                        Spacer(modifier = Modifier.height(6.dp))
                        Text(
                            text = otpMessage!!,
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold,
                            color = if (otpMessage!!.startsWith("?")) GreenSuccess else CoralRed
                        )
                    }
                }
            }

            item {
                Spacer(modifier = Modifier.height(80.dp))
            }
        }
    }
}

@Composable
fun TimelineStepRow(
    title: String,
    subtitle: String,
    isCompleted: Boolean,
    isActive: Boolean,
    showConnector: Boolean = true
) {
    Row(modifier = Modifier.fillMaxWidth()) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.width(24.dp)
        ) {
            Box(
                modifier = Modifier
                    .size(20.dp)
                    .clip(CircleShape)
                    .background(
                        if (isCompleted) ForestEmerald
                        else if (isActive) MintBackground
                        else Color(0xFFE2E8F0)
                    )
                    .border(
                        if (isActive) 2.dp else 0.dp,
                        if (isActive) ForestEmerald else Color.Transparent,
                        CircleShape
                    ),
                contentAlignment = Alignment.Center
            ) {
                if (isCompleted) {
                    Icon(Icons.Default.Check, contentDescription = null, tint = Color.White, modifier = Modifier.size(12.dp))
                } else if (isActive) {
                    Box(modifier = Modifier.size(6.dp).clip(CircleShape).background(ForestEmerald))
                }
            }
            if (showConnector) {
                Box(
                    modifier = Modifier
                        .width(2.dp)
                        .height(36.dp)
                        .background(if (isCompleted) ForestEmerald else Color(0xFFE2E8F0))
                )
            }
        }

        Spacer(modifier = Modifier.width(12.dp))

        Column(modifier = Modifier.padding(bottom = if (showConnector) 12.dp else 0.dp)) {
            Text(
                text = title,
                fontSize = 13.sp,
                fontWeight = if (isActive || isCompleted) FontWeight.Bold else FontWeight.Normal,
                color = if (isActive || isCompleted) SlateDark else SlateMuted
            )
            Text(
                text = subtitle,
                fontSize = 11.sp,
                color = SlateMuted
            )
        }
    }
}
