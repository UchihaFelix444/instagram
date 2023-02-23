import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/models/user.dart' as model;

class AuthMethods
{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
      User currentUser = firebaseAuth.currentUser!;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

      return model.User.fromSnap(snapshot);
  }


  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try
    {
       if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && bio.isNotEmpty && file != null)
         {
              UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

              print(userCredential.user!.uid);

              String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

              model.User user = model.User(username: username, uid: userCredential.user!.uid, email: email, bio: bio, followers: [], following: [], photoUrl: photoUrl);

              await firebaseFirestore.collection("users").doc(userCredential.user!.uid).set(user.toJSON());
              res = "success";
         }
    } on FirebaseAuthException catch (err)
    {
      if(err.code == 'invalid-email')
        {
          res = 'Email is badly formatted';
        }
      else if(err.code == 'weak-password')
        {
          res = 'Password should be atleast 6 characters';
        }
    }
    catch(err)
    {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({ required String email, required String password}) async {
      String res = "Some err occured";
      try
      {
          if(email.isNotEmpty && password.isNotEmpty)
            {
              await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
              res = "success";
              print(res);
            }
          else
            {
              res = "please enter all fields";
              print(res);
            }
      } on FirebaseAuthException catch (err)
      {
        if(err.code == 'user-not-found')
          {
            res = 'User not found';
          }
        else if(err.code ==  'wrong-password')
          {
            res = 'Incorrect password';
          }
      }
      catch(err)
      {
          print(res);
          res = err.toString();
      }
      return res;
  }

}