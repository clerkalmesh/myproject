import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import '../models/user_models.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;
  
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Generate anonymousId format MESH-XXXXXXXX(8)
  String _generateAnonymousId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code = List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
    return 'MESH-$code';
  }

  // ========== 1. SIGN IN ANONYMOUSLY ==========
  Future<UserModel?> signInAnonymously() async {
    try {
      // 1. Sign in ke Firebase Auth
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      
      print('✅ Anonymous sign-in success: ${user.uid}');
      
      // 2. Buat anonymousId
      String anonymousId = _generateAnonymousId();
      
      // 3. Buat UserModel
      UserModel newUser = UserModel(
        id: user.uid,
        anonymousId: anonymousId,
        name: 'Anonymous',
        avatar: '',
        isOnline: true,
        dayActive: 1,
        lastSeen: DateTime.now(),
        createdAt: DateTime.now(),
      );
      
      // 4. Simpan ke Firestore
      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      
      print('✅ User profile created in anonymous');
      return newUser;
      
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth error: ${e.message}');
      return null;
    } catch (e) {
      print('❌ Sign-in error: $e');
      return null;
    }
  }

  // ========== 2. SIGN OUT ==========
  Future<void> signOut() async {
    try {
      // Update isOnline status before sign out
      if (currentUserId != null) {
        await _firestore.collection('users').doc(currentUserId).update({
          'isOnline': false,
          'lastSeen': DateTime.now().millisecondsSinceEpoch,
        });
      }
      
      await _auth.signOut();
      print('✅ Signed out successfully');
      
    } catch (e) {
      print('❌ Sign out error: $e');
    }
  }

  // ========== 3. GET USER PROFILE FROM FIRESTORE ==========
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
      
    } catch (e) {
      print('❌ Get user profile error: $e');
      return null;
    }
  }

  // ========== 4. UPDATE USER PROFILE ==========
  Future<bool> updateUserProfile({
    String? name,
    String? avatar,
  }) async {
    try {
      if (currentUserId == null) return false;
      
      Map<String, dynamic> updates = {};
      
      if (name != null) updates['name'] = name;
      if (avatar != null) updates['avatar'] = avatar;
      
      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(currentUserId).update(updates);
        print('✅ Profile updated');
        return true;
      }
      
      return false;
      
    } catch (e) {
      print('❌ Update profile error: $e');
      return false;
    }
  }

  // ========== 5. UPDATE ONLINE STATUS ==========
  Future<void> updateOnlineStatus(bool isOnline) async {
    try {
      if (currentUserId == null) return;
      
      await _firestore.collection('users').doc(currentUserId).update({
        'isOnline': isOnline,
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
      });
      
    } catch (e) {
      print('❌ Update online status error: $e');
    }
  }

  // ========== 6. CHECK IF USER IS ANONYMOUS ==========
  bool get isAnonymous {
    return _auth.currentUser?.isAnonymous ?? false;
  }

  // ========== 7. DELETE ACCOUNT ==========
  Future<bool> deleteAccount() async {
    try {
      if (currentUserId == null) return false;
      
      // 1. Delete user data from Firestore
      await _firestore.collection('users').doc(currentUserId).delete();
      
      // 2. Delete user from Firebase Auth
      await _auth.currentUser?.delete();
      
      print('✅ Account deleted successfully');
      return true;
      
    } catch (e) {
      print('❌ Delete account error: $e');
      return false;
    }
  }
}