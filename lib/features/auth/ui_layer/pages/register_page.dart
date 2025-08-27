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
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final authCubit = context.read<AuthCubit>(); //= new AuthCubit(authRepo: authRepo);

    void register() {
      final String name = nameController.text;
      final String email = emailController.text;
      final String pw = passwordController.text;
      final String confirmPw = confirmPasswordController.text;

      if ( name.isNotEmpty && email.isNotEmpty && pw.isNotEmpty && confirmPw.isNotEmpty)
       {
        if (pw == confirmPw) {
          authCubit.register(name, email, pw);
        }
         else
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match! Sorry ;( ")));
        }
      } 
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all the Fields! ")));
      }
    }

    @override // memory leaks.
    void dispose() {
      nameController.dispose();
      emailController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
    }

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
              Text(' R E G I S T E R   P A G E  '),
              SizedBox(height: 25),

              //name textfield.
              MyTextField(
              controller: nameController, 
              hintText: 'Name', 
              obscureText: false),

              SizedBox(height: 10),

              //email textfield.
              MyTextField(
                controller: emailController,
                hintText: 'example@gmail.com',
                obscureText: false
                  ),

              SizedBox(height: 10),

              // passowrd textfield
              MyTextField(
                controller: passwordController,
                hintText: "Password...",
                obscureText: true
                ),

              SizedBox(height: 10),

              // passowrd textfield
              MyTextField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: true
                  ),

              // forgot password
              SizedBox(height: 15),
              //othre sign in logos
              MyButton(
               onTap: register,
               text: "SIGN UP "
               ),

              SizedBox(height: 10),

              //already have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text("login now ", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
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
