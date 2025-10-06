import 'package:flutter/material.dart';
import 'package:expenses_tracker/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define our color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          // Define custom colors
          primary: Colors.deepPurple,
          secondary: Colors.amberAccent,
          surface: Colors.white,
          surfaceDim: Colors.grey[50],
        ),
        // Use rounded corners and smooth edges throughout the app
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // Make buttons have rounded corners
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        // Apply similar rounding to input fields
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        // Use a modern font and styling
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}


/*  TO DO: 
      - EDIT  *done
      - CATEGORIES sredi gi
      - PIXELS screenshotot   *done
      - SIDEBAR tab 
        * HISTORY with filters
        * SETTINGS
        * PROFILE?
        * TRACKER SELECT
      - make everything be in a special tab that the user can 
        select at the main menu screen
      - SQL for the transactions
      - NOTIF google pay
      - LOGIN? 
*/ 
