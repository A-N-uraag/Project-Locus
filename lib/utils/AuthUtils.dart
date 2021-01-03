import 'package:firebase_auth/firebase_auth.dart';

enum UserState {
  signed_out,
  signed_in_not_verified,
  signed_in_and_verified
}

class AuthUtils{
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<UserCredential> signInWithEmail(String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
    } on FirebaseAuthException catch (e) {
      return Future.error(e.code);
    }
    return userCredential;
  }

  static Future<UserCredential> registerWithEmail(String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
    } on FirebaseAuthException catch (e) {
      return Future.error(e.code);
    }
    await sendEmailVerification();
    return userCredential;
  }

  static Future<void> sendEmailVerification() async {
    User user = auth.currentUser;
    await user.sendEmailVerification();
  }

  static Future<void> sendResetPasswordEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  static Future<bool> updateUserPassword(String newPassword) async {
    User user = auth.currentUser;
    try{
      user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e){
      return Future.error(e);
    }
    return true;
  }

  static Future<bool> checkIfExistingUser(String email) async {
    List<String> result = await auth.fetchSignInMethodsForEmail(email);
    return result.isNotEmpty;
  }

  static Future<UserState> getUserState()async {
    User user = auth.currentUser;
    if (user == null) {
      return UserState.signed_out;
    }
    else{
      if (user.emailVerified){
        return UserState.signed_in_and_verified;
      }
      else{
        await user.getIdTokenResult(true);
        await user.reload();
        if(user.emailVerified){
          return UserState.signed_in_and_verified;
        }
        return UserState.signed_in_not_verified;
      }
    }
  }

  static Future<void> signOut() async {
    await auth.signOut();
  }

  static Map<String,String> getCurrentUser(){
    User user = auth.currentUser;
    return {"name": user.displayName, "email": user.email};
  }
}