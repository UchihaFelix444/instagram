import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods
{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    //required Uint8List file,
  }) async {
    String res = "Some error occured";
    try
    {
       if(email.isEmpty || password.isEmpty || username.isEmpty || bio.isEmpty)
         {
              UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

              print(userCredential.user!.uid);

              await firebaseFirestore.collection("users").doc(userCredential.user!.uid).set({
                    "username" : username,
                    "uid"      : userCredential.user!.uid,
                    "email"    : email,
                    "password" : password,
                    "bio"      : bio,
                    "followers": [],
                    "following": [],
              });
              res = "success";
         }
    }
    catch(err)
    {
      res = err.toString();
    }
    return res;
  }
}