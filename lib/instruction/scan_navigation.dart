import 'package:material_ui/material_ui.dart';

import '../main_pages/home_with_activity.dart';

/// Goes to the activity home and clears the scan flow from the back stack.
void goToHome(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const HomeWithActivityScreen()),
    (route) => false,
  );
}
