/*
login page :
  on this page the user can login inthis page using his email and password.

----------------------------------------------------------------------

  - once its successfully login , they will be directed to the homepage.
  - if the user doesn't have an account then he goes to the Register page.

 */

import 'package:auth_bloc/features/auth/ui_layer/components/google_sign_in_button.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/my_button.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/my_textfield.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.togglePages});

  final void Function()? togglePages;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final authCubit = context.read<AuthCubit>();

  //login button action.
  void loginAction() {
    final String email = emailController.text;
    final String password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Fill all the Fields.")));
    }
  }

  //forgot password action
  void forgotPassword() {
    showDialog(
      context: context,
      builder:
          (contex) => AlertDialog(
            title: Text("Forgot Password?"),
            content: MyTextField(controller: emailController, hintText: 'Enter Email..', obscureText: false),
            actions: [
              TextButton(onPressed: () => Navigator.pop(contex), child: const Text("Cancel")),

              TextButton(
                onPressed: () async {
                  String message = await authCubit.forgotPassward(emailController.text);
                  if (message == "Password reset email sent! Check your inbox ") {
                    Navigator.pop(context);
                    emailController.clear();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                },
                child: const Text("Reset"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(Icons.lock_open, size: 80, color: Theme.of(context).colorScheme.primary),

              SizedBox(height: 25),
              //name of the app
              Text(' L O G I N  P A G E '),
              SizedBox(height: 25),

              //email textfield.
              MyTextField(controller: emailController, hintText: 'example@gmail.com', obscureText: false),

              SizedBox(height: 10),

              // passowrd textfield
              MyTextField(controller: passwordController, hintText: "Password...", obscureText: true),

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => forgotPassword(),
                    child: Text(
                      "Forgot Your Password? ",
                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //TextButton(onPressed: () {}, child: Text("Forgot Your Password? "))
                ],
              ),
              SizedBox(height: 15),
              //othre sign in logos
              MyButton(onTap: loginAction, text: "Login"),

              SizedBox(height: 10),

              //Don't have an account? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                  Text("Don't have an Account? ", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12)),

                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      "Register now",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  GoogleSignInButton(
                    onTap: () async {
                      authCubit.singinWithGoogle();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
