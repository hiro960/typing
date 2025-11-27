import 'package:flutter/material.dart';

class SectionTitleText extends StatelessWidget {
  const SectionTitleText({super.key, required this.iconData, required this.text, required this.color});

  final IconData iconData;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(iconData, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
