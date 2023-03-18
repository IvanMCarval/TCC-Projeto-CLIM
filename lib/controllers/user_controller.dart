import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/models/user_model.dart';

class UserController {
  ValueNotifier<String> authMessage = ValueNotifier('');
  ValueNotifier<String> resetMessage = ValueNotifier('');

  Map<String, dynamic> dataUser = {};

  UserController();

  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  authUser(email, senha, context) async {
    Users user = Users(email: email, password: senha);
    authMessage.value = '';
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      if (userCredential != null) {
        final docRef = db.collection('usuario').doc(userCredential.user?.uid);
        docRef.get().then(
          (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;

            if (data['tipo_usuario'] == 1) {
              Navigator.pushNamed(context, '/menu_professional');
            } else {
              Navigator.pushNamed(context, '/menu_client');
            }
          },
          onError: (e) =>
              authMessage.value = 'Não foi possivel carregar seu perfil.',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        authMessage.value = 'E-mail e/ou senha estão incorretos';
      }
    }
    return authMessage.value;
  }

  Future<Map<String, dynamic>> getProfile() async {
    await db
        .collection('usuario')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      dataUser.addAll(data);
    });

    await db
        .collection('perfil')
        .where('usuario', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      final data = value.docs.first.data();
      dataUser.addAll(data);
    });

    return dataUser;
  }

  registerNewPassworld(email) async {
    Users user = Users(email: email);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email);
    } on FirebaseAuthException catch (e) {
      return false;
    }
    return false;
  }
}
