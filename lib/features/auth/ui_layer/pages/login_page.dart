import 'package:auth_bloc/features/auth/ui_layer/components/glassy_card_container.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/apple_sign_in_button.dart';
import '../components/glassmorphism_snackbar.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/google_sign_in_button.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/my_button.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/my_textfield.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_cubit.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/login_bear_animator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.togglePages});

  final void Function()? togglePages;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginBearController = LoginBearAnimatorController();
  final resetPasswordEmailController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  late AuthCubit authCubit;

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();

    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        loginBearController.lookAround?.call();
      } else {
        loginBearController.goIdle?.call();
      }
    });

    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        loginBearController.handsUp?.call();
      } else {
        loginBearController.goIdle?.call();
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
    resetPasswordEmailController.dispose();
  }

  // Login button action
  void loginAction() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      loginBearController.reactToLogin?.call(false);
      showTopGlassSnackbar(context: context, message: "Please fill in all fields.", type: SnackbarType.error);
    }
  }

  // Forgot password action
  void forgotPassword() {
    resetPasswordEmailController.text = emailController.text.trim();

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    final secondary = theme.colorScheme.secondary.withOpacity(0.9);

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: secondary,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Reset Your Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: primary)),

                  const SizedBox(height: 12),

                  Text(
                    "We will send a reset link to the email below.",
                    style: TextStyle(fontSize: 14, color: theme.textTheme.bodySmall?.color),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  MyTextField(
                    controller: resetPasswordEmailController,
                    hintText: 'example@gmail.com',
                    obscureText: false,
                    onTap: () => loginBearController.lookAround?.call(),
                    onChanged: (val) => loginBearController.moveEyes?.call(val),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primary,
                            side: BorderSide(color: primary, width: 1.4),
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
                            final email = resetPasswordEmailController.text.trim();

                            if (email.isEmpty) {
                              showTopGlassSnackbar(context: context, message: "Please enter your email address.", type: SnackbarType.info);
                              return;
                            }
                            final message = await authCubit.forgotPassward(resetPasswordEmailController.text);
                            if (message == "Password reset email sent! Check your inbox ") {
                              Navigator.pop(context);
                              resetPasswordEmailController.clear();
                            }

                            showTopGlassSnackbar(context: context, message: message, type: SnackbarType.success);
                            loginBearController.reactToLogin?.call(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: onPrimary,
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
         
            showTopGlassSnackbar(context: context, message: state.massage, type: SnackbarType.error);
          } else if (state is Authenticated) {
            loginBearController.reactToLogin?.call(true);

            // Delay navigation to allow bear animation to play
            Future.delayed(const Duration(milliseconds: 600), () {
              Navigator.pushReplacementNamed(context, '/home');
            });
          }
        },

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(top: 30.0), // adjust value as needed
                    child: Text('L O G I N  P A G E', style: Theme.of(context).textTheme.titleLarge),
                  ),

                  // Bear animation
                  Transform.translate(offset: const Offset(0, -50), child: LoginBearAnimator(controller: loginBearController)),

                  Transform.translate(
                    offset: Offset(0, -40),
                    child: GlassCardContainer(
                      children: [
                        MyTextField(
                          controller: emailController,
                          hintText: 'example@gmail.com',
                          obscureText: false,
                          focusNode: emailFocusNode,
                          onTap: () => loginBearController.lookAround?.call(),
                          onChanged: (val) => loginBearController.moveEyes?.call(val),
                        ),
                        const SizedBox(height: 20),
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
                                "Forgot Password?",
                                style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // Login button
                        MyButton(onTap: loginAction, text: "Login"),
                      ],
                    ),
                  ),

                  //Divider
                  Row(
                    children: [
                      Expanded(child: Divider(thickness: 0.8, color: Theme.of(context).colorScheme.primary)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("or sign in with")),
                      Expanded(child: Divider(thickness: 0.8, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Apple sgin-in
                      AppleSignInButton(
                        onTap: () {
                          
                          showTopGlassSnackbar(context: context, message: "Apple Sign-in Not Avalible", type: SnackbarType.error);
                        },
                      ),

                      SizedBox(width: 15),

                      // Google sign-in
                      GoogleSignInButton(
                        onTap: () async {
                          authCubit.singinWithGoogle();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Register now 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
