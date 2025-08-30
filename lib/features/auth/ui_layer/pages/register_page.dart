import 'package:auth_bloc/features/auth/ui_layer/components/glassmorphism_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/login_bear_animator.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/my_button.dart';
import 'package:auth_bloc/features/auth/ui_layer/components/my_textfield.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_cubit.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_state.dart';
import 'package:auth_bloc/features/auth/ui_layer/utils/bear_focus_manager.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.togglePages});
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

  final loginBearController = LoginBearAnimatorController();
  late final BearFocusManager bearFocusManager;
  late final AuthCubit authCubit;

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();

    bearFocusManager =
        BearFocusManager(controller: loginBearController)
          ..register(nameFocusNode, BearReactionType.lookAround)
          ..register(emailFocusNode, BearReactionType.lookAround)
          ..register(passwordFocusNode, BearReactionType.handsUp)
          ..register(confirmPasswordNode, BearReactionType.handsUp);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    bearFocusManager.dispose();
    super.dispose();
  }

  void _register() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPw = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPw.isEmpty) {
      showTopGlassSnackbar(context: context, message: "Please fill all fields", type: SnackbarType.error);
    } else if (password != confirmPw) {
      showTopGlassSnackbar(context: context, message: "Passwords do not match", type: SnackbarType.error);
    } else {
      authCubit.register(name, email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          loginBearController.reactToLogin?.call(true);
          showTopGlassSnackbar(context: context, message: "Registered successfully", type: SnackbarType.success);
          // Navigate to login page
          widget.togglePages?.call();
        } else if (state is AuthError) {
          loginBearController.reactToLogin?.call(false);
          showTopGlassSnackbar(context: context, message: state.massage, type: SnackbarType.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text('R E G I S T E R   P A G E', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                        LoginBearAnimator(controller: loginBearController),
                        _buildGlassCard(),
                        const SizedBox(height: 20),
                        _buildLoginText(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildGlassCard() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 6))],
    ),
    child: Column(
      children: [
        _buildNameField(),
        const SizedBox(height: 12),
        _buildEmailField(),
        const SizedBox(height: 12),
        _buildPasswordField(),
        const SizedBox(height: 12),
        _buildConfirmPasswordField(),
        const SizedBox(height: 20),
        MyButton(onTap: _register, text: "SIGN UP"),
      ],
    ),
  );

  Widget _buildNameField() => MyTextField(
    controller: nameController,
    hintText: 'Name',
    obscureText: false,
    focusNode: nameFocusNode,
    onChanged: (val) => loginBearController.moveEyes?.call(val),
  );

  Widget _buildEmailField() => MyTextField(
    controller: emailController,
    hintText: 'example@gmail.com',
    obscureText: false,
    focusNode: emailFocusNode,
    onChanged: (val) => loginBearController.moveEyes?.call(val),
  );

  Widget _buildPasswordField() =>
      MyTextField(controller: passwordController, hintText: 'Password', obscureText: true, focusNode: passwordFocusNode);

  Widget _buildConfirmPasswordField() =>
      MyTextField(controller: confirmPasswordController, hintText: 'Confirm Password', obscureText: true, focusNode: confirmPasswordNode);

  Widget _buildLoginText() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Already have an account? ", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      GestureDetector(
        onTap: widget.togglePages,
        child: Text("login now", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
      ),
    ],
  );
}
