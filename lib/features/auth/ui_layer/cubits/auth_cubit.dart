/*
  qubits are responsible for managing the statets of the application. -> showing the appropriate stuff on the screen.
  (State managemant)
 */

import 'package:auth_bloc/features/auth/domain/model/app_user.dart';
import 'package:auth_bloc/features/auth/domain/repo/auth_repo.dart';
import 'package:auth_bloc/features/auth/ui_layer/cubits/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // get curerent user

  AppUser? get getCurrentUser => _currentUser;

  //check if the user is authenticated or not.
  void checkAuth() async {
    //loading
    emit(AuthLoading());

    //get current user
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailnPassword(email, password);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  // regester with email + password
  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.regesterWithEmailnPassword(name, email, password);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  //logout.
  Future<void> logout() async {
    emit(AuthLoading());
    await authRepo.logout();
    emit(UnAuthenticated());
  }

  //forgwt password.
  Future<String> forgotPassward(String email) async {
    try {
      final massage = await authRepo.sendPasswordResetEmail(email);
      return massage;
    } catch (e) {
      return e.toString();
    }
  }

  //deleting account
  Future<void> deleteAccount() async {
    try {
      emit(AuthLoading());
      authRepo.deleteAccount();
      emit(UnAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  // google sign-in
  Future<void> singinWithGoogle() async {
    try {
      emit(AuthLoading());
      final user = await authRepo.signInWithGoogle();
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }
}
