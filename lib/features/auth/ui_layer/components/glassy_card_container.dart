import 'package:flutter/material.dart';

class GlassCardContainer extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const GlassCardContainer({super.key, required this.children, this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 25)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }
}
