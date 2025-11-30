import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.iconData,
    required this.text,
    this.color,
  });

  final IconData iconData;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    return Row(
      children: [
        Icon(
          iconData,
          color: color ?? theme.colors.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.typography.lg.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colors.foreground,
          ),
        ),
      ],
    );
  }
}
