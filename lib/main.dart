import 'package:auth_bloc/features/auth/data/firebase_auth_repo.dart';
import 'package:rive/rive.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_cubit.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_state.dart';
import 'package:auth_bloc/features/auth/ui_layer/pages/auth_page.dart';
import 'package:auth_bloc/features/home/ui_layer/pages/home_page.dart';
import 'package:auth_bloc/themes/dark_mode.dart';
import 'package:auth_bloc/themes/light_mode.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:auth_bloc/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await RiveNative.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  //Firebase auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthCubit>(create: (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            //  print(state);

            if (state is UnAuthenticated) {
              return const AuthPage();
            }

            if (state is Authenticated) {
              return HomePage();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.massage)));
            }
          },
        ),
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
