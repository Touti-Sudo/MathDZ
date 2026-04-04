import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<UserCredential> signinWithGoogle() async {
    final GoogleSignInAccount? gUser =
        await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth =
        await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );


    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);


    final user = userCredential.user;


    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
            'name': user.displayName,
            'email': user.email,
            'profilePicture': user.photoURL,
            'provider': 'google',
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    }

    return userCredential;
  }
}
