import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SharedColors {
  static const primary = Color(0xFFB30000);
  static const textMuted = Color(0xFF6B6B6B);
}

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int index)? onTap;

  const BottomNav({super.key, required this.currentIndex, this.onTap});

  // Home, Camera, Location, Shopping Bag, Pill
  static const _icons = [
    LucideIcons.house,
    LucideIcons.camera,
    LucideIcons.mapPin,
    LucideIcons.shoppingBag,
    LucideIcons.pill,
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
              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (onTap != null) {
                      onTap!(i);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      _icons[i],
                      size: 26,
                      color: selected ? SharedColors.primary : SharedColors.textMuted,
                    ),
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