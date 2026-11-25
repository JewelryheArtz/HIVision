import 'package:flutter/material.dart';
import 'screens/medication_tracker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hivision',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB30000)),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MedicationTrackerScreen(),
      builder: (context, child) {
        return Container(
          color: const Color(0xFFE9E9E9),
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: ClipRect(child: child),
          ),
        );
      },
    );
  }
}