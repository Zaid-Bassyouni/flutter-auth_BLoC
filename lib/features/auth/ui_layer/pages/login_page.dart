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
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/login_bear_animator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.togglePages});

  final void Function()? togglePages;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginBearController = LoginBearAnimatorController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  late AuthCubit authCubit;

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();

    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        loginBearController.goIdle!();
      }
    });
    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        loginBearController.goIdle!();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordController.dispose();
  }

  // Login button action
  void loginAction() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      loginBearController.reactToLogin?.call(false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all the fields.")));
    }
  }

  // Forgot password action
  void forgotPassword() {
    final forgotEmailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (contex) => AlertDialog(
            title:
             const Text("Forgot Password?"),
            content: MyTextField(
              controller: forgotEmailController,
              hintText: 'example@gmail.com',
              obscureText: false,
              focusNode: emailFocusNode,
              onTap: () => loginBearController.lookAround?.call(),
              onChanged: (val) => loginBearController.moveEyes?.call(val),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              TextButton(
                onPressed: () async {
                  final message = await authCubit.forgotPassward(forgotEmailController.text);
                  if (message == "Password reset email sent! Check your inbox ") {
                    Navigator.pop(context);
                    forgotEmailController.clear();
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
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            loginBearController.reactToLogin?.call(false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.massage)));
          } else if (state is Authenticated) {
            loginBearController.reactToLogin?.call(true);
          }
        },
        
        child: 
        Center(
          child: 
          SingleChildScrollView(
            padding:const 
             EdgeInsets.symmetric(horizontal: 20.0),
            child: 
            Column(
              mainAxisAlignment:
               MainAxisAlignment.center,
              children: [
                // Page title
                Text('L O G I N  P A G E', style: Theme.of(context).textTheme.titleLarge),

                const SizedBox(height: 20),

                // Bear animation
                LoginBearAnimator(controller: loginBearController),

                const SizedBox(height: 25),

                // Email text field
                MyTextField(
                  controller: emailController,
                  hintText: 'example@gmail.com',
                  obscureText: false,
                  focusNode: emailFocusNode,
                  onTap: () => loginBearController.lookAround?.call(),
                  onChanged: (val) => loginBearController.moveEyes?.call(val),
                ),

                const SizedBox(height: 10),

                // Password text field
                MyTextField(
                  controller: passwordController,
                  hintText: "Password...",
                  obscureText: true,
                  focusNode: passwordFocusNode,
                  onTap: () => loginBearController.handsUp?.call(),
                ),

                // Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: forgotPassword,
                      child: Text(
                        "Forgot Your Password?",
                        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Login button
                MyButton(onTap: loginAction, text: "Login"),

                const SizedBox(height: 10),

                // Register now prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Don't have an account? ", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12)),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        "Register now",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Google sign-in
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
      ),
    );
  }
}
