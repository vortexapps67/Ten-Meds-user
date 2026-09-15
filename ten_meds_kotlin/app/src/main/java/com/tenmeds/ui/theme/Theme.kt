package com.tenmeds.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

val ForestEmerald = Color(0xFF0F5B47)
val ForestEmeraldDark = Color(0xFF0A3E31)
val ForestEmeraldLight = Color(0xFF15765D)
val MintBackground = Color(0xFFE8F5F1)
val MintSurface = Color(0xFFF2F9F6)
val MintAccent = Color(0xFFD1EBE3)
val MintBorder = Color(0xFFBDE2D7)

val CoralRed = Color(0xFFEF4444)
val CoralRedLight = Color(0xFFFEE2E2)
val AmberWarning = Color(0xFFF59E0B)
val AmberLight = Color(0xFFFEF3C7)
val GreenSuccess = Color(0xFF10B981)
val GreenLight = Color(0xFFDCFCE7)

val SlateDark = Color(0xFF1E293B)
val SlateMuted = Color(0xFF64748B)
val SlateLight = Color(0xFF94A3B8)
val SlateBorder = Color(0xFFE2E8F0)
val ScaffoldBg = Color(0xFFF8FAFC)

// Liquid Glass Translucency Tokens
val GlassSurface = Color(0xE6FFFFFF)
val GlassSurfaceElevated = Color(0xF2FFFFFF)
val GlassBorder = Color(0x66FFFFFF)
val GlassEmeraldSurface = Color(0xE60F5B47)
val GlassMintSurface = Color(0xCCEEF7F4)

private val LightColorScheme = lightColorScheme(
    primary = ForestEmerald,
    onPrimary = Color.White,
    primaryContainer = MintBackground,
    onPrimaryContainer = ForestEmeraldDark,
    secondary = ForestEmeraldLight,
    onSecondary = Color.White,
    background = ScaffoldBg,
    surface = Color.White,
    onSurface = SlateDark,
    outline = SlateBorder
)

@Composable
fun TenMedsTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = LightColorScheme,
        content = content
    )
}
