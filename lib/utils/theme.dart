import 'package:flutter/material.dart';

// 🎨 Canva-Inspired Theme for ClubHub

class AppTheme {
  // ============= CANVA-STYLE COLOR PALETTE =============
  
  // Primary Colors (Your existing palette)
  static const Color primaryBlue = Color(0xFF1A2B4A);      // Navy Blue
  static const Color primaryOrange = Color(0xFFFF8C42);    // Orange
  static const Color appleGreen = Color(0xFF8DB600);       // Apple Green
  
  // Canva-inspired Neutrals
  static const Color canvaWhite = Color(0xFFFFFFFF);
  static const Color canvaBlack = Color(0xFF0D0C0F);
  static const Color canvaGray100 = Color(0xFFF7F7F8);
  static const Color canvaGray200 = Color(0xFFECECED);
  static const Color canvaGray300 = Color(0xFFDCDCDD);
  static const Color canvaGray400 = Color(0xFFB4B4B5);
  static const Color canvaGray600 = Color(0xFF7D7D7E);
  static const Color canvaGray800 = Color(0xFF3D3D3F);
  
  // Background Colors
  static const Color backgroundLight = canvaGray100;       // Very light gray
  static const Color cardBackground = canvaWhite;          // Pure white
  static const Color surfaceColor = canvaWhite;            // Pure white
  static const Color hoverBackground = canvaGray200;       // Light hover
  
  // Text Colors (Canva-style)
  static const Color textPrimary = canvaBlack;             // Almost black
  static const Color textSecondary = canvaGray600;         // Medium gray
  static const Color textTertiary = canvaGray400;          // Light gray
  static const Color textOnColor = canvaWhite;             // White on colored bg
  
  // Accent Colors
  static const Color accentPurple = Color(0xFF7C4DFF);
  static const Color accentTeal = Color(0xFF00BFA5);
  static const Color accentPink = Color(0xFFFF4081);
  
  // Status Colors
  static const Color success = appleGreen;
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);
  
  // Legacy support (backward compatibility)
  static const Color navyBlue = primaryBlue;
  static const Color orange = primaryOrange;
  static const Color white = canvaWhite;
  static const Color black = canvaBlack;
  static const Color grey = textSecondary;
  static const Color darkGrey = textPrimary;
  static const Color lightGreen = appleGreen;
  static const Color lightGray = canvaGray200;
  static const Color primary = primaryBlue;
  static const Color accent = primaryOrange;
  static const Color background = backgroundLight;
  static const Color textDark = textPrimary;
  static const Color textLight = textSecondary;
  static const Color textOnAccent = white;
  static const Color secondaryBackground = Color(0xFFD4E09B);
  static const Color accentPrimary = accent;
  static const Color accentSecondary = secondaryBackground;
  static const Color primaryBackground = background;
  
  // ============= CANVA-STYLE GRADIENTS =============
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A2B4A), Color(0xFF2C4A7C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF8C42), Color(0xFFFFAA66)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF8DB600), Color(0xFFA8D400)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Canva-style subtle gradients
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [Color(0xFFF7F7F8), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // ============= CANVA-STYLE SHADOWS =============
  
  // Soft, subtle shadows like Canva
  static List<BoxShadow> canvaShadowSM = [
    BoxShadow(
      color: canvaBlack.withOpacity(0.04),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> canvaShadowMD = [
    BoxShadow(
      color: canvaBlack.withOpacity(0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> canvaShadowLG = [
    BoxShadow(
      color: canvaBlack.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> canvaShadowXL = [
    BoxShadow(
      color: canvaBlack.withOpacity(0.10),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
  
  // Hover effect shadow
  static List<BoxShadow> hoverShadow = [
    BoxShadow(
      color: canvaBlack.withOpacity(0.12),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];
  
  // Legacy shadows
  static List<BoxShadow> cardShadow = canvaShadowMD;
  static List<BoxShadow> buttonShadow = canvaShadowMD;
  static List<BoxShadow> softShadow = canvaShadowSM;
  
  // ============= CANVA-STYLE BORDER RADIUS =============
  
  static const BorderRadius radiusNone = BorderRadius.zero;
  static const BorderRadius radiusXS = BorderRadius.all(Radius.circular(4));
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusXLarge = BorderRadius.all(Radius.circular(20));
  static const BorderRadius radiusXXLarge = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(9999));
  
  // ============= CANVA-STYLE SPACING =============
  
  static const double space0 = 0;
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
  static const double space12 = 48;
  static const double space16 = 64;
  static const double space20 = 80;
  
  // Legacy spacing
  static const double spaceXS = space1;
  static const double spaceS = space2;
  static const double spaceM = space4;
  static const double spaceL = space6;
  static const double spaceXL = space8;
  static const double spaceXXL = space12;
  
  // ============= CANVA-STYLE TYPOGRAPHY =============
  
  static const String fontFamily = 'Inter'; // Canva uses similar clean fonts
  
  // ============= THEME DATA =============
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryOrange,
        tertiary: appleGreen,
        surface: cardBackground,
        background: backgroundLight,
        error: error,
        onPrimary: canvaWhite,
        onSecondary: canvaWhite,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: backgroundLight,
      
      // AppBar - Canva-style (minimal)
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: canvaWhite,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        shadowColor: canvaBlack.withOpacity(0.04),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          fontFamily: fontFamily,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      
      // Card - Canva-style
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardBackground,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radiusMedium,
          side: BorderSide(
            color: canvaGray200,
            width: 1,
          ),
        ),
        shadowColor: Colors.transparent,
      ),
      
      // Buttons - Canva-style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: canvaWhite,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: radiusMedium,
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            fontFamily: fontFamily,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: canvaGray300, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: radiusMedium,
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            fontFamily: fontFamily,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryOrange,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            fontFamily: fontFamily,
          ),
        ),
      ),
      
      // Input - Canva-style
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: canvaWhite,
        border: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(color: canvaGray300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(color: canvaGray300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(
          color: canvaGray400,
          fontSize: 15,
          fontFamily: fontFamily,
        ),
        labelStyle: TextStyle(
          color: textSecondary,
          fontSize: 15,
          fontFamily: fontFamily,
        ),
      ),
      
      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryOrange,
        foregroundColor: canvaWhite,
        elevation: canvaShadowLG.first.blurRadius,
        shape: RoundedRectangleBorder(
          borderRadius: radiusXLarge,
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: canvaWhite,
        selectedItemColor: primaryOrange,
        unselectedItemColor: canvaGray600,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      // Tab Bar
      tabBarTheme: const TabBarThemeData(
        indicatorColor: primaryOrange,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: textPrimary,
        unselectedLabelColor: textSecondary,
        labelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: canvaGray100,
        selectedColor: primaryOrange,
        labelStyle: const TextStyle(
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: radiusFull,
        ),
        side: BorderSide.none,
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: canvaGray200,
        thickness: 1,
        space: 1,
      ),
      
      // Text Theme - Canva-style typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -1.5,
          height: 1.2,
          fontFamily: fontFamily,
        ),
        displayMedium: TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -1,
          height: 1.2,
          fontFamily: fontFamily,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
          height: 1.2,
          fontFamily: fontFamily,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.5,
          height: 1.3,
          fontFamily: fontFamily,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
          height: 1.3,
          fontFamily: fontFamily,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.2,
          height: 1.3,
          fontFamily: fontFamily,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.2,
          height: 1.4,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.1,
          height: 1.4,
          fontFamily: fontFamily,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0,
          height: 1.4,
          fontFamily: fontFamily,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          letterSpacing: 0,
          height: 1.5,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          letterSpacing: 0,
          height: 1.5,
          fontFamily: fontFamily,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textTertiary,
          letterSpacing: 0,
          height: 1.5,
          fontFamily: fontFamily,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0,
          fontFamily: fontFamily,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textSecondary,
          letterSpacing: 0,
          fontFamily: fontFamily,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textTertiary,
          letterSpacing: 0,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}