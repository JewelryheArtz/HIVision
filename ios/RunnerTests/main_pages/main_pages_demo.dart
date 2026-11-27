import 'package:material_ui/material_ui.dart';

import '../main.dart';
import 'home_with_activity.dart';

/// Stand-in entry point solely for previewing and demoing the `lib/main_pages/`
/// logged-in flow without modifying `lib/main.dart`.
///
/// Run in your VS Code terminal with:
/// flutter run -d chrome -t lib/main_pages/main_pages_demo.dart
void main() => runApp(const MainPagesDemoApp());

class MainPagesDemoApp extends StatelessWidget {
  const MainPagesDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HiVision – Main Pages Demo',
      // Keeps the mobile phone frame centered when running in Chrome
      builder: (context, child) {
        return Container(
          color: AppColors.webBackdrop,
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: ClipRect(child: child),
          ),
        );
      },
      theme: appTheme,
      // Opens directly to your logged-in HomeWithActivityScreen
      home: const HomeWithActivityScreen(),
    );
  }
}
