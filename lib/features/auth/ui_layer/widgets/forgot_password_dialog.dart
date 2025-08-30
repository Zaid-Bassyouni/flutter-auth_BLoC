
import 'package:flutter/material.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/my_textfield.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/glassmorphism_snackbar.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/login_bear_animator.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordDialog extends StatelessWidget {
  final TextEditingController controller;
  final LoginBearAnimatorController bearController;

  const ForgotPasswordDialog({super.key, required this.controller, required this.bearController});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: theme.colorScheme.secondary.withOpacity(0.9),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Reset Your Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),

            const SizedBox(height: 12),

            Text(
              "We will send a reset link to the email below.",
              style: TextStyle(fontSize: 14, color: theme.textTheme.bodySmall?.color),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            MyTextField(
              controller: controller,
              hintText: 'example@gmail.com',
              obscureText: false,
              onTap: () => bearController.lookAround?.call(),
              onChanged: (val) => bearController.moveEyes?.call(val),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(color: theme.colorScheme.primary, width: 1.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final message = await authCubit.forgotPassward(controller.text);
                      if (message == "Password reset email sent! Check your inbox ") {
                        Navigator.pop(context);
                        controller.clear();
                      }
                      showTopGlassSnackbar(context: context, message: message, type: SnackbarType.success);
                      bearController.reactToLogin?.call(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Reset", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
