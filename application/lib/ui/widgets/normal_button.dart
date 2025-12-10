import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NormalButton extends StatelessWidget {
  const NormalButton({
    super.key,
    required this.onTap,
    required this.label,
    this.icon = Iconsax.edit_2,
    this.enabled = true,
  });

  final VoidCallback? onTap;
  final String label;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: Container(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
