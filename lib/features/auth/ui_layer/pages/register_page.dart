import 'package:auth_bloc/features/auth/ui_layer/components/login_bear_animator.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/my_button.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/my_textfield.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.togglePages});
  final void Function()? togglePages;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordNode = FocusNode();

  late final AuthCubit authCubit;
  final loginBearController = LoginBearAnimatorController();

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();

    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus) {
        loginBearController.goIdle!();
      }
    });
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
    confirmPasswordNode.addListener(() {
      if (!confirmPasswordNode.hasFocus) {
        loginBearController.goIdle!();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose(); //  Important to call super.dispose()
  }

  void register() {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPw = confirmPasswordController.text;

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPw.isNotEmpty) {
      if (password == confirmPw) {
        authCubit.register(name, email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(" Passwords not matching!")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(" Please fill all the fields!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          //  Prevents overflow on small screens
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bear Animation
              const SizedBox(height: 20),
              LoginBearAnimator(controller: loginBearController),

              const SizedBox(height: 25),

              Text('R E G I S T E R   P A G E', style: Theme.of(context).textTheme.titleMedium),

              const SizedBox(height: 25),

              MyTextField(
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
                focusNode: nameFocusNode,
                onTap: () => loginBearController.lookAround?.call(),
                onChanged: (val) => loginBearController.moveEyes?.call(val),
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: emailController,
                hintText: 'example@gmail.com',
                obscureText: false,
                focusNode: emailFocusNode,
                onTap: () => loginBearController.lookAround?.call(),
                onChanged: (val) => loginBearController.moveEyes?.call(val),
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                focusNode: passwordFocusNode,
                onTap: () => loginBearController.handsUp?.call(),
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
                focusNode: confirmPasswordNode,
                onTap: () => loginBearController.handsUp?.call(),
              ),

              const SizedBox(height: 15),

              MyButton(onTap: register, text: "SIGN UP"),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text("login now", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
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
