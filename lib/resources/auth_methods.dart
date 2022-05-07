import 'dart:typed_data';

import 'package:app/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/user.dart' as userModel;
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<userModel.UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection("users").doc(currentUser.uid).get();
    return userModel.UserModel.fromSnap(snap);
  }

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String res = 'Some error eccurred';
    try {
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || file.isNotEmpty) {
        // register user
        UserCredential cred =  await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );

        String photoUrl = await StorageMethod().uploadImageToStorage("profilePics", file, false);

        // add user to our DB
        userModel.UserModel user = userModel.UserModel(
          username: username,
          email: email,
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          followers: [],
          following: []
        );

        _firestore.collection("users").doc(cred.user!.uid).set(user.toJson());
        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> singOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Login User

  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    String res = 'Some error eccurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res; 
  }

  
}

