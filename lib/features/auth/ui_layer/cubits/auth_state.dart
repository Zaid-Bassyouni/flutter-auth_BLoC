/*
  Auth state - outline the possible states for authentication in our app.
*/
import 'package:auth_bloc/features/auth/domain/model/app_user.dart';

abstract class AuthState {}
// const AuthState();

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

class UnAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String massage;
  AuthError(this.massage);
}
