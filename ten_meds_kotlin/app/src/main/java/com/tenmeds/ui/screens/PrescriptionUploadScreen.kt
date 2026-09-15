package com.tenmeds.ui.screens

import androidx.compose.animation.core.*
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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.tenmeds.data.repository.MedicineRepository
import com.tenmeds.ui.components.GlassButton
import com.tenmeds.ui.components.LiquidGlassCard
import com.tenmeds.ui.theme.*
import kotlinx.coroutines.delay

@Composable
fun PrescriptionUploadScreen(
    onBack: () -> Unit,
    onOrderDispatched: () -> Unit
) {
    var uploadStep by remember { mutableStateOf("upload") } // upload, scanning, locked
    var countdown by remember { mutableIntStateOf(90) }

    LaunchedEffect(uploadStep) {
        if (uploadStep == "scanning") {
            delay(2000)
            uploadStep = "locked"
        } else if (uploadStep == "locked") {
            while (countdown > 0) {
                delay(1000)
                countdown--
            }
        }
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
                    text = "Doctor Prescription",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    color = SlateDark
                )
            }
        }

        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            item { Spacer(modifier = Modifier.height(4.dp)) }

            if (uploadStep == "upload") {
                // Dropzone Box
                item {
                    LiquidGlassCard(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { uploadStep = "scanning" },
                        cornerRadius = 24.dp
                    ) {
                        Column(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(vertical = 24.dp),
                            horizontalAlignment = Alignment.CenterHorizontally
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(64.dp)
                                    .clip(CircleShape)
                                    .background(MintBackground),
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(Icons.Default.CameraAlt, contentDescription = null, tint = ForestEmerald, modifier = Modifier.size(32.dp))
                            }
                            Spacer(modifier = Modifier.height(12.dp))
                            Text(
                                text = "Snap Doctor Prescription",
                                fontSize = 16.sp,
                                fontWeight = FontWeight.Bold,
                                color = ForestEmeraldDark
                            )
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(
                                text = "Tap camera or select image from gallery",
                                fontSize = 12.sp,
                                color = SlateMuted
                            )
                        }
                    }
                }

                // Security & Pharmacist Guarantee Pill
                item {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(14.dp))
                            .background(MintBackground)
                            .border(1.dp, MintBorder, RoundedCornerShape(14.dp))
                            .padding(12.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(Icons.Default.Shield, contentDescription = null, tint = ForestEmerald, modifier = Modifier.size(20.dp))
                        Spacer(modifier = Modifier.width(10.dp))
                        Text(
                            text = "Prescription verified by licensed pharmacist before dispatch. HIPAA & DPDP compliant.",
                            fontSize = 11.sp,
                            color = ForestEmeraldDark,
                            lineHeight = 16.sp
                        )
                    }
                }

                item {
                    GlassButton(
                        text = "Upload & Broadcast to Local Chemists",
                        onClick = { uploadStep = "scanning" },
                        modifier = Modifier.fillMaxWidth()
                    )
                }
            } else if (uploadStep == "scanning") {
                item {
                    LiquidGlassCard(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(top = 40.dp),
                        cornerRadius = 24.dp
                    ) {
                        Column(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(vertical = 32.dp),
                            horizontalAlignment = Alignment.CenterHorizontally
                        ) {
                            CircularProgressIndicator(
                                color = ForestEmerald,
                                modifier = Modifier.size(48.dp)
                            )
                            Spacer(modifier = Modifier.height(16.dp))
                            Text(
                                text = "Scanning & Broadcasting in 7 km Radius...",
                                fontSize = 15.sp,
                                fontWeight = FontWeight.Bold,
                                color = SlateDark
                            )
                            Spacer(modifier = Modifier.height(6.dp))
                            Text(
                                text = "Matching generic salts with 8 verified partner pharmacies",
                                fontSize = 12.sp,
                                color = SlateMuted
                            )
                        }
                    }
                }
            } else {
                // Chemist Locked State
                item {
                    LiquidGlassCard(
                        modifier = Modifier.fillMaxWidth(),
                        cornerRadius = 24.dp
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(12.dp))
                                .background(CoralRedLight)
                                .padding(horizontal = 12.dp, vertical = 8.dp),
                            horizontalArrangement = Arrangement.Center,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(Icons.Default.Timer, contentDescription = null, tint = CoralRed, modifier = Modifier.size(18.dp))
                            Spacer(modifier = Modifier.width(6.dp))
                            Text(
                                text = "${countdown}s Chemist Packing Lock Timer",
                                color = CoralRed,
                                fontSize = 13.sp,
                                fontWeight = FontWeight.ExtraBold
                            )
                        }

                        Spacer(modifier = Modifier.height(14.dp))

                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(14.dp))
                                .background(MintBackground)
                                .padding(12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(Icons.Default.Storefront, contentDescription = null, tint = ForestEmerald, modifier = Modifier.size(24.dp))
                            Spacer(modifier = Modifier.width(10.dp))
                            Column {
                                Text(
                                    text = "MedPlus Green Glen Layout (1.4 km)",
                                    fontSize = 13.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = ForestEmeraldDark
                                )
                                Text(
                                    text = "Inventory reserved • Tamper-proof bag assigned",
                                    fontSize = 11.sp,
                                    color = ForestEmeraldLight
                                )
                            }
                        }

                        Spacer(modifier = Modifier.height(14.dp))

                        Text(
                            text = "OCR Verified Salts:",
                            fontSize = 13.sp,
                            fontWeight = FontWeight.Bold,
                            color = SlateDark
                        )
                        Spacer(modifier = Modifier.height(6.dp))
                        Text(
                            text = "? Paracetamol 500 mg (20 Tablets)",
                            fontSize = 12.sp,
                            color = SlateDark
                        )
                        Text(
                            text = "? Azithromycin 500 mg (5 Tablets)",
                            fontSize = 12.sp,
                            color = SlateDark
                        )
                    }
                }

                item {
                    GlassButton(
                        text = "Confirm & Track Live Porter Dispatch",
                        onClick = {
                            MedicineRepository.placeOrder(
                                address = "742 Evergreen Terrace, Apt 4B, Springfield",
                                paymentMethod = "COD"
                            )
                            onOrderDispatched()
                        },
                        modifier = Modifier.fillMaxWidth()
                    )
                }
            }

            item {
                Spacer(modifier = Modifier.height(80.dp))
            }
        }
    }
}
