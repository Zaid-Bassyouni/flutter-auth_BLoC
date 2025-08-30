import 'package:flutter/material.dart';

enum SnackbarType { success, error, info }

class GlassmorphismSnackbar extends StatelessWidget {
  final String message;
  final SnackbarType type;

  const GlassmorphismSnackbar({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    Color color;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        color = isDarkMode ? Colors.greenAccent.shade100 : Colors.green;
        icon = Icons.check_circle;
        break;
      case SnackbarType.error:
        color = isDarkMode ? Colors.redAccent.shade100 : Colors.redAccent;
        icon = Icons.warning_amber_rounded;
        break;
      case SnackbarType.info:
        color = isDarkMode ? Colors.lightBlue.shade100 : Colors.blueAccent;
        icon = Icons.info_outline;
        break;
    }

    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(child: Text(message, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18))),
            ],
          ),
        ),
      ),
    );
  }
}

void showTopGlassSnackbar({
  required BuildContext context,
  required String message,
  required SnackbarType type,
  Duration duration = const Duration(seconds: 4),
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(top: 40, left: 0, right: 0, child: GlassmorphismSnackbar(message: message, type: type)),
  );

  overlay.insert(overlayEntry);
  Future.delayed(duration, () => overlayEntry.remove());
}
