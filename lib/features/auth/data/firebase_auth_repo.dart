//firebase our backend
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/model/app_user.dart';

import '../domain/repo/auth_repo.dart';

class FirebaseAuthRepo extends AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  @override
  Future<AppUser?> loginWithEmailnPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      AppUser user = AppUser(uid: userCredential.user!.uid, email: email);
      return user;
    } catch (e) {
      throw Exception('error in login $e');
    }
  }

  // sign up
  @override
  Future<AppUser?> regesterWithEmailnPassword(String name, String email, String passwoed) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: passwoed);

      AppUser user = AppUser(uid: userCredential.user!.uid, email: email);
      return user;
    } catch (e) {
      throw Exception('error in sign up $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) throw Exception('No user logged in');

      await user.delete();

      await logout();
    } catch (e) {
      throw Exception('error in delete account $e');
    }
  }

  // logout
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  //send passord reset.
  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      firebaseAuth.sendPasswordResetEmail(email: email);
      return "Password reset email sent! Check your inbox ";
    } catch (e) {
      throw Exception('error in sending password reset email $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {

    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) return null;

    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!);
  }
  
  @override
  Future<AppUser?> signInWithGoogle() async {
    try{

      final GoogleSignIn googleSignIn = GoogleSignIn.standard();
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();


      if(gUser == null) 
      {return null;}

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken
      );

      UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);

      final firebaseUser = userCredential.user;

      if(firebaseUser == null){
        return null;
      }

      AppUser appUser = AppUser(uid: firebaseUser.uid, email: firebaseUser.email ?? " " );
      return appUser;

    }
    catch(e)
    {
      print(e);
throw Exception("Error Signin With Google.");
    }
  }


}
