import 'package:firebase_auth/firebase_auth.dart';
class Auth{

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  Future<bool> createUser({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print("Kayıt hatası: ${e.code} - ${e.message}");
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print("Giriş hatası: ${e.code}");
      return false;
    }
  }

  Future<void> singOut()async{
    await _firebaseAuth.signOut();
  }






}