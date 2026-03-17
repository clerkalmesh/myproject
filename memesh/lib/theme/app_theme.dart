/*
import 'package:flutter/material.dart';

class AppTheme {
    
    static const Color primaryColor = Color(0xFF6F5CEE);
    static const Color secondaryColor = Color(0xFF7A4B9F); 
    static const Color accentColor = Color(0xFFD7D9A8);
    static const Color backgroundColor = Color(0xFFF9F9FA);
    static const Color cardColor = Color(0xFFFFFFFF);
    static const Color textPrimaryColor = Color(0xFF2D3436);
    static const Color textSecondaryColor = Color(0xFF636E72);
    static const Color borderColor = Color(0xFFDDD6FF);
    static const Color errorColor = Color(0xFFE17055);
    
    static ThemeData themeLight = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
            primary: primaryColor,
            secondary: secondaryColor,
            surface: backgroundColor,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            error: errorColor,
            onSurface: textPrimaryColor,
            onBackground: textPrimaryColor
        ), // ColorScheme end
        
        textTheme: GoogleFonts.poppinsTextTheme(
            headlineLarge: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor
            ),
            headlineMedium: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor
            ),
            headlineSmall: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: textPrimaryColor
            ),
            
            bodyLarge: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: textPrimaryColor
            ),
            bodyMedium: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: textPrimaryColor
            ),
            bodySmall: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: textPrimaryColor
            ),
        ), // textTheme end
        
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor
            ),
            iconTheme: IconThemeData(
                color: textPrimaryColor,
            ),
        ), // AppBarTheme end
        
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                ),
            ), // style end
        ), // ElevatedButtonThemeData end
        
        cardTheme: CardThemeData(
            color: cardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                borserSide: BorderSide(
                    color: borderColor,
                    width: 1
                ),
            ),
            
        ), // CardThemeData end
        
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: cardColor,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: borderColor,
                ),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: primaryColor,
                    width: 2
                ),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: borderColor,
                ),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: errorColor,
                ),
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16
            ),
        ), // InputDecorationTheme end
        
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0
        ), // FloatingActionButtonThemeData end
    );
}*/