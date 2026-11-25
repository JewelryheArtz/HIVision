import 'package:material_ui/material_ui.dart';

import 'scan_inconclusive.dart';
import 'scan_invalid.dart';
import 'scan_non_reactive.dart';
import 'scan_reactive.dart';

enum ScanResult { reactive, nonReactive, inconclusive, invalid }

class ScanAnalyzer {
  const ScanAnalyzer._();

  static Future<ScanResult> analyze({String? fileName}) async {
    // Demo routing only: the real image-classification model is not connected.
    final normalizedName = (fileName ?? '')
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .trim();
    final tokens = normalizedName
        .split(' ')
        .where((token) => token.isNotEmpty)
        .toSet();

    final matches = <ScanResult>[];
    if (tokens.contains('invalid')) {
      matches.add(ScanResult.invalid);
    }
    if (tokens.contains('inconclusive')) {
      matches.add(ScanResult.inconclusive);
    }

    final isNonReactive =
        tokens.contains('nonreactive') ||
        (tokens.contains('non') && tokens.contains('reactive'));
    if (isNonReactive) {
      matches.add(ScanResult.nonReactive);
    } else if (tokens.contains('reactive')) {
      matches.add(ScanResult.reactive);
    }

    return matches.length == 1 ? matches.single : ScanResult.inconclusive;
  }

  static Future<void> openResult(BuildContext context, ScanResult result) async {
    final Widget page = switch (result) {
      ScanResult.reactive => const ScanReactiveScreen(),
      ScanResult.nonReactive => const ScanNonReactiveScreen(),
      ScanResult.inconclusive => const ScanInconclusiveScreen(),
      ScanResult.invalid => const ScanInvalidScreen(),
    };

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
