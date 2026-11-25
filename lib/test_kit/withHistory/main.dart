import 'package:flutter/material.dart';

import 'common.dart';
import 'hisources.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Kits',
      // Shows the app in a phone-width frame when run on web/desktop.
      // On a real phone (width <= 430) it fills the screen as normal.
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SourcesScreen(),
    );
  }
}
