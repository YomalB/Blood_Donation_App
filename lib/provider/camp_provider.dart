import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/camp_model.dart';

class CampProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _uid;
  String get uid => _uid!;

  CampModel? _campModel;
  CampModel get campModel => _campModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String?> saveCampDataToFirebase({
    required CampModel campModel,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      campModel.email = _firebaseAuth.currentUser!.email!;
      await _firebaseFirestore
          .collection("blood_camps")
          .doc()
          .set(campModel.toMap());

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Error saving camp data: $e";
    }
  }

  Future<int> fetchEmailCount() async {
    try {
      String? uid = _firebaseAuth.currentUser?.uid;
      if (uid != null) {
        var userDoc =
            await _firebaseFirestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          String email = userDoc['email'];
          var querySnapshot = await _firebaseFirestore
              .collection('blood_camps')
              .where('email', isEqualTo: email)
              .get();
          return querySnapshot.docs.length;
        }
      }
      return 0;
    } catch (e) {
      print('Error counting similar emails: $e');
      return 0;
    }
  }

  Future<void> fetchCampData(String docId) async {
    _isLoading = true;
    notifyListeners();

    try {
      DocumentSnapshot campDoc =
          await _firebaseFirestore.collection('blood_camps').doc(docId).get();
      if (campDoc.exists) {
        _campModel = CampModel.fromMap(campDoc.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching camp data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
