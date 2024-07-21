import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
   FirebaseAuth _auth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
    String email, String password) async {
      try{
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
      }catch(e) {
        print(e); 
      }
      return null;
    }
   Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> createNewUserProfile(Map<String, dynamic> userdata) async {
    try {
      await db.collection("users").add(userdata).then((DocumentReference doc) =>
          print('DocumentSnapshot added with ID: ${doc.id}'));
      ;
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

}
