/*
Auth repository - outline the possible methods for authentication in our app.
*/

//import '../model/app_user.dart';

import '../model/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailnPassword(String email, String password);
  Future<AppUser?> regesterWithEmailnPassword(String name, String email, String passwoed);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<String> sendPasswordResetEmail(String email);
  Future<void> deleteAccount();
  Future<AppUser?> signInWithGoogle();
}
