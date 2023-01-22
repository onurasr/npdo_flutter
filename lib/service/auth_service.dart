import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../helper/helper_function.dart';
import '../service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // giriş yap
  Future loginWithUserNameandPassword(
      String email, String password, bool admin) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;

      if (user != null) {
        var response = await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: email)
            .get();
        if (response.docs.length > 0) {
          if (response.docs.first.data()["admin"]) {
            //admin
          } else {
            //Admin değil
          }
        }
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // kayıt ol
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password, bool admin) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await Database(uid: user.uid).savingUserData(fullName, email, admin);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // çıkış yap
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
