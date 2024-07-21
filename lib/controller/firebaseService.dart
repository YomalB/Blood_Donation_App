import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential _userCredentials = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userCredentials.user;
    } catch (e) {
      return null;
    }
  }
}
