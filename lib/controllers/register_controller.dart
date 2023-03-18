import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/models/register_model.dart';

class RegisterController {
  ValueNotifier<String> message;
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final registerModel = RegisterModel();

  RegisterController(this.message);

  getListGenre() {
    return db.collection('genero').snapshots();
  }

  getListKindServices() {
    return db.collection('tipo_servico').snapshots();
  }

  Future create() async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: registerModel.email!, password: registerModel.password!);

      registerModel.user = auth.currentUser!.uid;
      await db
          .collection('usuario')
          .doc(registerModel.user)
          .set(registerModel.userInformation());

      final refImage = FirebaseStorage.instance
          .ref('perfil/${DateTime.now().toString()}-${registerModel.user}.jpg');
      await refImage.putFile(registerModel.image!);
      registerModel.imageUrl = await refImage.getDownloadURL();

      await db.collection('perfil').add(registerModel.profile());
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-exists') {
        message.value = 'Email já existente.';
      } else if (e.code == 'weak-password') {
        message.value = 'A senha é muito fraca.';
      } else if (e.code == 'user-not-found') {
        message.value = 'Usuário não encontrado.';
      } else if (e.code == 'INTERNAL') {
        message.value = 'Erro interno.';
      } else {
        message.value = 'Error: Informe ao administrador do app.';
      }
    }

    message.value = 'Sucess';
  }

  setParameters(parameters) {
    registerModel.name = parameters['name'];
    registerModel.kindServise = parameters['kindServise'];
    registerModel.cpfCnpj = parameters['cpfCnpj'];
    registerModel.typeUser = parameters['typeUser'];
    registerModel.phone = parameters['phone'];
    registerModel.genre = parameters['genre'];
    registerModel.birthDate = parameters['birthDate'];
    registerModel.cep = parameters['cep'];
    registerModel.street = parameters['street'];
    registerModel.number = parameters['number'];
    registerModel.neighborhood = parameters['neighborhood'];
    registerModel.city = parameters['city'];
    registerModel.state = parameters['state'];
    registerModel.complement = parameters['complement'];
    registerModel.nickName = parameters['nickName'];
    registerModel.email = parameters['email'];
    registerModel.password = parameters['password'];
    registerModel.image = parameters['image'];
    registerModel.description = parameters['description'];
  }
}
