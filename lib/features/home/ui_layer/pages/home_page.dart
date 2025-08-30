import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_state.dart';
import 'package:auth_bloc/features/auth/ui_layer/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthPage()));
        }
      },
      child: Scaffold(
        backgroundColor: color.background,
        drawer: const _SideDrawer(),
        appBar: AppBar(title: const Text("Welcome"), centerTitle: true, backgroundColor: color.surface.withOpacity(0.8), elevation: 0.5),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("You're in!", style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color.primary)),
                const SizedBox(height: 12),
                Text(
                  "This app was built with care to showcase my Flutter design and architecture skills.",
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.flutter_dash),
                  label: const Text("Built with Flutter & BLoC"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color.primary,
                    side: BorderSide(color: color.primary, width: 1.3),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SideDrawer extends StatelessWidget {
  const _SideDrawer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Drawer(
      backgroundColor: color.surface.withOpacity(0.95),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24), bottomLeft: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: color.primary,
                    child: Text(
                      "Z", // Replace with user initial later on.
                      style: theme.textTheme.titleMedium?.copyWith(color: color.onPrimary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello,", style: theme.textTheme.labelMedium),
                      Text("Zaid", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu Items
            _DrawerItem(icon: Icons.home_rounded, label: "Home", onTap: () => Navigator.pop(context)),
            _DrawerItem(icon: Icons.settings_outlined, label: "Settings", onTap: () {}),
            _DrawerItem(icon: Icons.info_outline, label: "About", onTap: () {}),

            const Spacer(),

            // Logout
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton.icon(
                onPressed: () => context.read<AuthCubit>().logout(),
                icon: const Icon(Icons.logout_rounded),
                label: const Text("Logout"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: color.error,
                  side: BorderSide(color: color.error, width: 1.2),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: color.primary),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
      horizontalTitleGap: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: color.primary.withOpacity(0.06),
      splashColor: color.primary.withOpacity(0.1),
    );
  }
}
