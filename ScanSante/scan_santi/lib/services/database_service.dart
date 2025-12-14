import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore Only
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scan_santi/models/food_analysis_model.dart';
import 'package:scan_santi/utilities/utils.dart';

class DatabaseService {
  // Single Firestore Instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==================================================
  // 1. SCAN HISTORY FEATURES
  // ==================================================

  /// Saves a scan to: users/{uid}/scans/{random_doc_id}
  Future<void> saveScan(FoodAnalysisModel model) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).collection('scans').add({
        ...model.toJson(),
        'timestamp': FieldValue.serverTimestamp(), // Firestore Timestamp
      });
    } catch (e) {
      Utils.toast("Failed to save history: $e");
    }
  }

  /// Listens to: users/{uid}/scans
  Stream<List<FoodAnalysisModel>> getUserHistory() {
    final User? user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('scans')
        .orderBy('timestamp', descending: true) // Newest first
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            // Convert Firestore Document to your Model
            return FoodAnalysisModel.fromJson(doc.data());
          }).toList();
        });
  }

  // ==================================================
  // 2. USER PROFILE FEATURES
  // ==================================================

  /// Updates fields in the main user document: users/{uid}
  Future<void> updateUserProfile({String? name, String? mobile}) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    try {
      Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (mobile != null) data['mobile'] = mobile;

      // SetOptions(merge: true) is CRITICAL.
      // It ensures we update 'name'/'mobile' without deleting the 'scans' subcollection.
      await _db
          .collection('users')
          .doc(user.uid)
          .set(data, SetOptions(merge: true));

      // Update Auth Display Name (Optional but good for UI speed)
      if (name != null) {
        await user.updateDisplayName(name);
      }

      Utils.toast("Profile updated successfully");
    } catch (e) {
      Utils.toast("Failed to update profile: $e");
    }
  }

  /// Fetches the document: users/{uid}
  Future<Map<String, dynamic>?> getUserProfile() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    try {
      DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      Utils.toast("Error fetching profile: $e");
    }
    return null;
  }
}
