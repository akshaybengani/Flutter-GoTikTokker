import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// abstract class AuthProvider {
//   Future<String> loginWithEmail(
//       {@required String email, @required String password});
//   Future<String> signUpWithEmail({
//     @required String email,
//     @required String password,
//   });
//   Future<String> getCurrentUser();
//   Future<void> signOut();
// }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> loginWithEmail(
      {@required String email, @required String password}) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUpWithEmail({
    @required String email,
    @required String password,
  }) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> _getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> _signOut() async {
    _firebaseAuth.signOut();
    notifyListeners();
  }

  


}
