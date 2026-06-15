import 'package:flutter/material.dart';

class AccountMenuItem {
  final String title;
  final IconData icon;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool showChevron;

  const AccountMenuItem({
    required this.title,
    required this.icon,
    this.trailingText,
    this.onTap,
    this.showChevron = true,
  });
}
