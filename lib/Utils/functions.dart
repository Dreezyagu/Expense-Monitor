import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthFunctions {
  static Future register(
      String name, String email, String password, FirebaseAuth auth) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? user = auth.currentUser;
      user?.updateDisplayName(name);
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      Fluttertoast.showToast(msg: "Sign up successful");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "The password provided is too weak.",
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "The account already exists for that email.",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  static Future login(String email, String password, FirebaseAuth auth) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      Fluttertoast.showToast(msg: "Sign up successful");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Wrong password.');
      }
    }
  }
}
