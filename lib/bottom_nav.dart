import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SharedColors {
  static const primary = Color(0xFFB30000);
  static const textMuted = Color(0xFF6B6B6B);
}

// ONE bottom nav for every screen.
// It does NOT import any screen — it just reports which icon was tapped.
// Each screen passes its own onTap to say where the icons should go.
class BottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int index)? onTap;

  const BottomNav({super.key, required this.currentIndex, this.onTap});

  static const _icons = [
    LucideIcons.house,
    LucideIcons.mapPin,
    LucideIcons.pill,
    LucideIcons.messageCircle,
    LucideIcons.circleUser,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (i) {
              final selected = i == currentIndex;
              return GestureDetector(
                onTap: onTap == null ? null : () => onTap!(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    _icons[i],
                    size: 26,
                    color: selected ? SharedColors.primary : SharedColors.textMuted,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
