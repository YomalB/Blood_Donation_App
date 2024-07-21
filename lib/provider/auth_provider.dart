import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _uid;
  String get uid => _uid!;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

   AuthProvider() {
    _firebaseAuth.authStateChanges().listen((user) {
      if (user == null) {
        _isSignedIn = false;
      } else {
        _isSignedIn = true;
        _uid = user.uid;
        fetchUserData();
      }
      notifyListeners();
    });
  }

  Future<void> fetchUserData() async {
    if (_uid != null) {
      DocumentSnapshot userDoc = await _firebaseFirestore.collection('users').doc(_uid).get();
      if (userDoc.exists) {
        _userModel = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        notifyListeners();
      }
    }
  }

  Future<String?> signUpWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _uid = userCredential.user?.uid;
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Sign up error: $e";
    }
  }

  Future<String?> saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required String profileImageUrl,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      userModel.profileImage = profileImageUrl;
      userModel.email = _firebaseAuth.currentUser!.email!;
      userModel.uid = _firebaseAuth.currentUser!.uid;

      _userModel = userModel;

      await _firebaseFirestore
          .collection("users")
          .doc(_firebaseAuth.currentUser!.uid)
          .set(userModel.toMap());

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Error saving user data: $e";
    }
  }
   
  Future<String> storeFileToStorage(String path, Uint8List file, BuildContext context) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putData(file);
      final taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
      rethrow;
    }
  }
  
Future<String?> loginWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _uid = userCredential.user?.uid;

    // Fetch user data
    DocumentSnapshot userDoc = await _firebaseFirestore
        .collection('users')
        .doc(_uid)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data != null) {
        _userModel = UserModel.fromMap(data);
        _isSignedIn = true;
        notifyListeners();
        return null;
      } else {
        return 'User data not found';
      }
    } else {
      return 'User data not found';
    }
  } on FirebaseAuthException catch (e) {
    return e.message;
  } catch (e) {
    return 'Login error: $e';
  }
}

  Future<void> saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future<void> getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  Future<void> userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }
}
