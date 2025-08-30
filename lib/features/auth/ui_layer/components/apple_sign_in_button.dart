import 'package:flutter/material.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(20)),

        child: Image.asset('lib/assets/apple.png', height: 25),
      ),
    );
  }
}
