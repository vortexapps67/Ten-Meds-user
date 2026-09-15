package com.tenmeds

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.tenmeds.data.models.Product
import com.tenmeds.data.repository.MedicineRepository
import com.tenmeds.ui.screens.*
import com.tenmeds.ui.theme.*

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            TenMedsTheme {
                MainAppScaffold()
            }
        }
    }
}

@Composable
fun MainAppScaffold() {
    var activeTab by remember { mutableStateOf("home") } // home, search, orders, profile
    var selectedProduct by remember { mutableStateOf<Product?>(null) }
    var isInCart by remember { mutableStateOf(false) }
    var isUploadingRx by remember { mutableStateOf(false) }

    val cartItems by MedicineRepository.cart.collectAsState()
    val totalCartCount = cartItems.sumOf { it.quantity }

    Scaffold(
        bottomBar = {
            if (selectedProduct == null && !isInCart && !isUploadingRx) {
                Surface(
                    modifier = Modifier.fillMaxWidth(),
                    color = Color.White,
                    shadowElevation = 10.dp
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .navigationBarsPadding()
                            .padding(vertical = 8.dp),
                        horizontalArrangement = Arrangement.SpaceAround,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        BottomTabItem(
                            label = "Home",
                            icon = Icons.Outlined.Home,
                            iconActive = Icons.Filled.Home,
                            isActive = activeTab == "home",
                            onClick = { activeTab = "home" }
                        )
                        BottomTabItem(
                            label = "Search",
                            icon = Icons.Outlined.Search,
                            iconActive = Icons.Filled.Search,
                            isActive = activeTab == "search",
                            onClick = { activeTab = "search" }
                        )
                        BottomTabItem(
                            label = "Orders",
                            icon = Icons.Outlined.Receipt,
                            iconActive = Icons.Filled.Receipt,
                            isActive = activeTab == "orders",
                            badgeCount = if (activeTab != "orders" && totalCartCount > 0) totalCartCount else null,
                            onClick = { activeTab = "orders" }
                        )
                        BottomTabItem(
                            label = "Profile",
                            icon = Icons.Outlined.Person,
                            iconActive = Icons.Filled.Person,
                            isActive = activeTab == "profile",
                            onClick = { activeTab = "profile" }
                        )
                    }
                }
            }
        }
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            when {
                selectedProduct != null -> {
                    ProductDetailsScreen(
                        product = selectedProduct!!,
                        onBack = { selectedProduct = null },
                        onNavigateToCart = {
                            selectedProduct = null
                            isInCart = true
                        }
                    )
                }
                isInCart -> {
                    CartCheckoutScreen(
                        onBack = { isInCart = false },
                        onOrderPlaced = {
                            isInCart = false
                            activeTab = "orders"
                        }
                    )
                }
                isUploadingRx -> {
                    PrescriptionUploadScreen(
                        onBack = { isUploadingRx = false },
                        onOrderDispatched = {
                            isUploadingRx = false
                            activeTab = "orders"
                        }
                    )
                }
                activeTab == "home" -> {
                    HomeScreen(
                        onNavigateToSearch = { activeTab = "search" },
                        onSelectProduct = { selectedProduct = it },
                        onNavigateToCart = { isInCart = true },
                        onNavigateToPrescription = { isUploadingRx = true }
                    )
                }
                activeTab == "search" -> {
                    SearchScreen(
                        onSelectProduct = { selectedProduct = it }
                    )
                }
                activeTab == "orders" -> {
                    TrackOrderScreen(
                        onBackToHome = { activeTab = "home" }
                    )
                }
                else -> {
                    HomeScreen(
                        onNavigateToSearch = { activeTab = "search" },
                        onSelectProduct = { selectedProduct = it },
                        onNavigateToCart = { isInCart = true },
                        onNavigateToPrescription = { isUploadingRx = true }
                    )
                }
            }
        }
    }
}

@Composable
fun BottomTabItem(
    label: String,
    icon: ImageVector,
    iconActive: ImageVector,
    isActive: Boolean,
    badgeCount: Int? = null,
    onClick: () -> Unit
) {
    Box(
        modifier = Modifier
            .clickable { onClick() }
            .padding(horizontal = 12.dp, vertical = 4.dp),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Box {
                Icon(
                    imageVector = if (isActive) iconActive else icon,
                    contentDescription = label,
                    tint = if (isActive) ForestEmerald else SlateMuted,
                    modifier = Modifier.size(22.dp)
                )
                if (badgeCount != null && badgeCount > 0) {
                    Box(
                        modifier = Modifier
                            .align(Alignment.TopEnd)
                            .offset(x = 4.dp, y = (-4).dp)
                            .size(14.dp)
                            .clip(CircleShape)
                            .background(CoralRed),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = badgeCount.toString(),
                            color = Color.White,
                            fontSize = 8.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
            }
            Spacer(modifier = Modifier.height(2.dp))
            Text(
                text = label,
                fontSize = 10.sp,
                fontWeight = if (isActive) FontWeight.Bold else FontWeight.Normal,
                color = if (isActive) ForestEmerald else SlateMuted
            )
            if (isActive) {
                Spacer(modifier = Modifier.height(2.dp))
                Box(
                    modifier = Modifier
                        .size(4.dp)
                        .clip(CircleShape)
                        .background(CoralRed)
                )
            }
        }
    }
}
