/*
This page is determinse wether to show login page or the register page. 
 */
import 'package:auth_bloc/features/auth/ui_layer/pages/login_page.dart';
import 'package:auth_bloc/features/auth/ui_layer/pages/register_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoadingPage = true;

  void togglePage() {
    setState(() {
      showLoadingPage = !showLoadingPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    if (showLoadingPage) {
      return LoginPage(togglePages: togglePage,);
    } else {
      return RegisterPage( togglePages: togglePage);
    }

  }
}
