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
      if (e.code == 'wrong-password') {
        return Future.error('wrong-password');
      } else {
        return Future.error('invalid-email');
      }
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
      return Future.error(e);
    }
    await sendEmailVerification();
    return userCredential;
  }

  static Future<void> sendEmailVerification() async {
    User user = auth.currentUser;
    ActionCodeSettings settings = ActionCodeSettings(
        url: 'https://www.example.com/?email=${user.email}',
        dynamicLinkDomain: "example.page.link",
        androidPackageName: "com.example.ProjectLocus",
        androidMinimumVersion: "12",
        androidInstallApp: true,
        iOSBundleId: "com.example.ProjectLocus",
        handleCodeInApp: true);
    await user.sendEmailVerification(settings);
  }

  static Future<void> sendResetPasswordEmail(String email) async {
    ActionCodeSettings settings = ActionCodeSettings(
        url: 'https://www.example.com/?email=$email',
        dynamicLinkDomain: "example.page.link",
        androidPackageName: "com.example.ProjectLocus",
        androidMinimumVersion: "12",
        androidInstallApp: true,
        iOSBundleId: "com.example.ProjectLocus",
        handleCodeInApp: true);
    await auth.sendPasswordResetEmail(email: email,actionCodeSettings: settings);
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

  static UserState getUserState(){
    User user = auth.currentUser;
    if (user == null) {
      return UserState.signed_out;
    }
    else{
      if (user.emailVerified){
        return UserState.signed_in_and_verified;
      }
      else{
        return UserState.signed_in_not_verified;
      }
    }
  }
}