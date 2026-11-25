import 'package:flutter/material.dart';
import 'constants.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MonCvApp());
}

class MonCvApp extends StatelessWidget {
  const MonCvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV - Chuma Muzandwa Salman',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans-serif',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'sans-serif',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          hintStyle: const TextStyle(
            fontFamily: 'sans-serif',
            color: AppColors.textMuted,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'sans-serif',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.card,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        dividerTheme: const DividerThemeData(color: AppColors.divider),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'sans-serif'),
          bodyMedium: TextStyle(fontFamily: 'sans-serif'),
          bodySmall: TextStyle(fontFamily: 'sans-serif'),
          titleLarge: TextStyle(fontFamily: 'sans-serif'),
          titleMedium: TextStyle(fontFamily: 'sans-serif'),
          titleSmall: TextStyle(fontFamily: 'sans-serif'),
          headlineLarge: TextStyle(fontFamily: 'sans-serif'),
          headlineMedium: TextStyle(fontFamily: 'sans-serif'),
          headlineSmall: TextStyle(fontFamily: 'sans-serif'),
          labelLarge: TextStyle(fontFamily: 'sans-serif'),
          labelMedium: TextStyle(fontFamily: 'sans-serif'),
          labelSmall: TextStyle(fontFamily: 'sans-serif'),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
