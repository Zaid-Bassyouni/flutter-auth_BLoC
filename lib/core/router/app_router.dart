import 'package:auth_bloc/features/auth/ui_layer/pages/auth_page.dart';
import 'package:auth_bloc/features/auth/ui_layer/pages/login_page.dart';
import 'package:auth_bloc/features/auth/ui_layer/pages/register_page.dart';
import 'package:auth_bloc/features/home/ui_layer/pages/home_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _fadeRoute(const AuthPage(), settings);
      case '/login':
        return _slideRoute(const LoginPage(), settings);
      case '/register':
        return _slideRoute(const RegisterPage(), settings);
      case '/home':
        return _scaleRoute(const HomePage(), settings);
      default:
        return MaterialPageRoute(builder: (_) => const AuthPage());
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        return FadeTransition(opacity: anim, child: child);
      },
    );
  }

  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final offset = Tween(begin: const Offset(1, 0), end: Offset.zero).animate(anim);
        return SlideTransition(position: offset, child: child);
      },
    );
  }

  static PageRouteBuilder _scaleRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final scale = Tween(begin: 0.9, end: 1.0).animate(anim);
        return ScaleTransition(scale: scale, child: child);
      },
    );
  }
}
