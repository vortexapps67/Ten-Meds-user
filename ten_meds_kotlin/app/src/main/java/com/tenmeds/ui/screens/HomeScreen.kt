package com.tenmeds.ui.screens

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
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
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import com.tenmeds.R
import com.tenmeds.data.models.Product
import com.tenmeds.data.repository.MedicineRepository
import com.tenmeds.ui.components.GlassEmeraldCard
import com.tenmeds.ui.components.LiquidGlassCard
import com.tenmeds.ui.theme.*

@Composable
fun HomeScreen(
    onNavigateToSearch: () -> Unit,
    onSelectProduct: (Product) -> Unit,
    onNavigateToCart: () -> Unit,
    onNavigateToPrescription: () -> Unit
) {
    var selectedCategoryId by remember { mutableStateOf("cat_all") }
    val cartItems by MedicineRepository.cart.collectAsState()
    val totalCartCount = cartItems.sumOf { it.quantity }

    val displayedProducts = remember(selectedCategoryId) {
        if (selectedCategoryId == "cat_all") {
            MedicineRepository.allProducts
        } else {
            MedicineRepository.allProducts.filter { it.categoryId == selectedCategoryId }
        }
    }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(ScaffoldBg)
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // 1. Top Header
        item {
            Spacer(modifier = Modifier.height(8.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text(
                        text = "Good morning,",
                        fontSize = 13.sp,
                        color = SlateMuted
                    )
                    Text(
                        text = "Alex",
                        fontSize = 20.sp,
                        fontWeight = FontWeight.Bold,
                        color = SlateDark
                    )
                }

                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    // Address Pill
                    Row(
                        modifier = Modifier
                            .clip(RoundedCornerShape(16.dp))
                            .background(MintBackground)
                            .border(1.dp, MintBorder, RoundedCornerShape(16.dp))
                            .padding(horizontal = 10.dp, vertical = 6.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.LocationOn,
                            contentDescription = null,
                            tint = ForestEmerald,
                            modifier = Modifier.size(14.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            text = "742 Evergreen Terr...",
                            fontSize = 11.sp,
                            fontWeight = FontWeight.SemiBold,
                            color = ForestEmeraldDark,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis
                        )
                        Icon(
                            imageVector = Icons.Default.KeyboardArrowDown,
                            contentDescription = null,
                            tint = SlateMuted,
                            modifier = Modifier.size(14.dp)
                        )
                    }

                    // Cart Icon with Badge
                    Box(
                        modifier = Modifier
                            .size(38.dp)
                            .shadow(2.dp, CircleShape)
                            .clip(CircleShape)
                            .background(Color.White)
                            .border(1.dp, SlateBorder, CircleShape)
                            .clickable { onNavigateToCart() },
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.ShoppingBag,
                            contentDescription = "Cart",
                            tint = SlateDark,
                            modifier = Modifier.size(18.dp)
                        )
                        if (totalCartCount > 0) {
                            Box(
                                modifier = Modifier
                                    .align(Alignment.TopEnd)
                                    .offset(x = 2.dp, y = (-2).dp)
                                    .size(16.dp)
                                    .clip(CircleShape)
                                    .background(CoralRed),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(
                                    text = totalCartCount.toString(),
                                    color = Color.White,
                                    fontSize = 9.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }
                        }
                    }
                }
            }
        }

        // 2. Liquid Glass Search Bar
        item {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .shadow(3.dp, RoundedCornerShape(14.dp))
                    .clip(RoundedCornerShape(14.dp))
                    .background(Color.White)
                    .border(1.dp, SlateBorder, RoundedCornerShape(14.dp))
                    .clickable { onNavigateToSearch() }
                    .padding(horizontal = 14.dp, vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Search,
                    contentDescription = null,
                    tint = SlateMuted,
                    modifier = Modifier.size(20.dp)
                )
                Spacer(modifier = Modifier.width(10.dp))
                Text(
                    text = "Search 30+ medicines, symptoms...",
                    fontSize = 14.sp,
                    color = SlateMuted,
                    modifier = Modifier.weight(1f)
                )
                IconButton(
                    onClick = onNavigateToPrescription,
                    modifier = Modifier.size(28.dp)
                ) {
                    Icon(
                        imageVector = Icons.Default.CameraAlt,
                        contentDescription = "Upload Prescription",
                        tint = ForestEmerald,
                        modifier = Modifier.size(18.dp)
                    )
                }
            }
        }

        // 3. Emerald Hero Delivery Banner
        item {
            GlassEmeraldCard(modifier = Modifier.fillMaxWidth()) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Box(
                            modifier = Modifier
                                .clip(RoundedCornerShape(10.dp))
                                .background(Color(0x33FFFFFF))
                                .padding(horizontal = 8.dp, vertical = 4.dp)
                        ) {
                            Text(
                                text = "DELIVERY IN 10-15 MIN",
                                color = Color.White,
                                fontSize = 10.sp,
                                fontWeight = FontWeight.ExtraBold,
                                letterSpacing = 0.5.sp
                            )
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "Everyday care,\nright on time",
                            color = Color.White,
                            fontSize = 20.sp,
                            fontWeight = FontWeight.Bold,
                            lineHeight = 24.sp
                        )
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = "From verified local chemists",
                            color = MintAccent,
                            fontSize = 12.sp
                        )
                    }

                    Box(
                        modifier = Modifier
                            .size(68.dp)
                            .clip(RoundedCornerShape(16.dp))
                            .background(Color(0x26FFFFFF)),
                        contentAlignment = Alignment.Center
                    ) {
                        Image(
                            painter = painterResource(id = R.drawable.logo_no_name),
                            contentDescription = "Ten Meds Logo",
                            modifier = Modifier.size(48.dp)
                        )
                    }
                }
            }
        }

        // 4. Category Rail
        item {
            Column {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Shop by category",
                        fontSize = 15.sp,
                        fontWeight = FontWeight.Bold,
                        color = SlateDark
                    )
                    Text(
                        text = "See all (${MedicineRepository.allProducts.size})",
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = ForestEmerald,
                        modifier = Modifier.clickable { onNavigateToSearch() }
                    )
                }
                Spacer(modifier = Modifier.height(10.dp))
                LazyRow(
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    items(MedicineRepository.categories) { cat ->
                        val isSelected = selectedCategoryId == cat.id
                        Box(
                            modifier = Modifier
                                .clip(RoundedCornerShape(14.dp))
                                .background(if (isSelected) ForestEmerald else Color.White)
                                .border(
                                    1.dp,
                                    if (isSelected) ForestEmerald else SlateBorder,
                                    RoundedCornerShape(14.dp)
                                )
                                .clickable { selectedCategoryId = cat.id }
                                .padding(horizontal = 14.dp, vertical = 8.dp)
                        ) {
                            Text(
                                text = cat.name,
                                fontSize = 12.sp,
                                fontWeight = if (isSelected) FontWeight.Bold else FontWeight.SemiBold,
                                color = if (isSelected) Color.White else SlateDark
                            )
                        }
                    }
                }
            }
        }

        // 5. Popular Essentials Product Grid (30+ Medicines)
        item {
            Text(
                text = "Available in your 7 km radius",
                fontSize = 15.sp,
                fontWeight = FontWeight.Bold,
                color = SlateDark
            )
        }

        // Product Items in 2-Column Grid
        val chunkedProducts = displayedProducts.chunked(2)
        items(chunkedProducts) { rowItems ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                for (product in rowItems) {
                    Box(modifier = Modifier.weight(1f)) {
                        ProductGridCard(
                            product = product,
                            onSelect = { onSelectProduct(product) },
                            onAddToCart = { MedicineRepository.addToCart(product) }
                        )
                    }
                }
                if (rowItems.size == 1) {
                    Spacer(modifier = Modifier.weight(1f))
                }
            }
        }

        item {
            Spacer(modifier = Modifier.height(80.dp))
        }
    }
}

@Composable
fun ProductGridCard(
    product: Product,
    onSelect: () -> Unit,
    onAddToCart: () -> Unit
) {
    LiquidGlassCard(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onSelect() },
        cornerRadius = 18.dp
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(100.dp)
                .clip(RoundedCornerShape(12.dp))
                .background(Color(0xFFF1F5F9))
        ) {
            AsyncImage(
                model = product.imageUrl,
                contentDescription = product.brandName,
                contentScale = ContentScale.Crop,
                modifier = Modifier.fillMaxSize()
            )
            if (product.isScheduleH) {
                Box(
                    modifier = Modifier
                        .align(Alignment.TopStart)
                        .padding(6.dp)
                        .clip(RoundedCornerShape(6.dp))
                        .background(ForestEmeraldDark)
                        .padding(horizontal = 6.dp, vertical = 2.dp)
                ) {
                    Text(
                        text = "Rx Required",
                        color = Color.White,
                        fontSize = 9.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = product.brandName,
            fontSize = 13.sp,
            fontWeight = FontWeight.Bold,
            color = SlateDark,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis
        )

        Text(
            text = product.stripSize,
            fontSize = 11.sp,
            color = SlateMuted,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis
        )

        Spacer(modifier = Modifier.height(6.dp))

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(
                    text = "$${String.format("%.2f", product.price)}",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.ExtraBold,
                    color = ForestEmerald
                )
                Text(
                    text = "MRP $${String.format("%.2f", product.mrp)}",
                    fontSize = 10.sp,
                    color = SlateLight
                )
            }

            Box(
                modifier = Modifier
                    .size(28.dp)
                    .clip(CircleShape)
                    .background(ForestEmerald)
                    .clickable { onAddToCart() },
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = "Add",
                    tint = Color.White,
                    modifier = Modifier.size(16.dp)
                )
            }
        }
    }
}
