import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_cubit.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_state.dart';
import 'package:auth_bloc/features/home/ui_layer/pages/home_page.dart';
import 'package:auth_bloc/features/auth/ui_layer/pages/auth_page.dart';

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() {
    super.initState();

    // Listen after frame build to avoid setState errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      _handleRouting(authState);
    });
  }

  void _handleRouting(AuthState state) {
    if (state is Authenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } else if (state is UnAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) => _handleRouting(state),
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
