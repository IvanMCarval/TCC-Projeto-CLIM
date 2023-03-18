import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_project_clim/models/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileController {
  ValueNotifier<String> message;
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final profileModel = ProfileModel();

  ProfileController(this.message);

  getListGenre() {
    return db.collection('genero').snapshots();
  }

  getListKindServices() {
    return db.collection('tipo_servico').snapshots();
  }

  inicializeIdAndName(id, name) {
    profileModel.id = id;
    profileModel.name = name;
  }

  getProfile() {
    return db
        .collection('perfil')
        .where("usuario", isEqualTo: profileModel.id)
        .snapshots();
  }

  getUserPages() {
    profileModel.id = auth.currentUser!.uid;
    return db.collection('usuario').doc(auth.currentUser!.uid).get();
  }

  Future<Map<String, dynamic>> getUser() async {
    await db
        .collection('usuario')
        .doc(auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      profileModel.dataUser.addAll(data);
      profileModel.kindServise = doc.get('tipo_sevico');
    });
    // auth.currentUser!.uid
    await db
        .collection('perfil')
        .where('usuario', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((value) {
      final data = value.docs.first.data();
      profileModel.dataUser.addAll(data);
      profileModel.idProfile = value.docs.first.id;
      profileModel.imageOriginal = data['foto'];
    });
    profileModel.kindServiseString = '';
    await db
        .collection('tipo_servico')
        .where(FieldPath.documentId, whereIn: profileModel.kindServise)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        profileModel.kindServiseString =
            '${profileModel.kindServiseString} ' + element.get('descricao');
      });
      profileModel.dataUser
          .addAll({'services': profileModel.kindServiseString});
    });

    return profileModel.dataUser;
  }

  getUserSnappshot(id) {
    profileModel.id = id;
    return db.collection('usuario').doc(profileModel.id).get();
  }

  Future updateUser() async {
    message.value = '';
    try {
      await db
          .collection('usuario')
          .doc(profileModel.id)
          .set(profileModel.userInformation());
    } on FirebaseException catch (e) {
      if (e.code == 'INTERNAL') {
        message.value = 'Erro interno.';
      } else {
        message.value = 'Error: Informe ao administrador do app.';
      }
    }

    message.value = 'Sucess';
  }

  Future updateUserAndPassword() async {
    message.value = '';
    try {
      if (profileModel.password != '') {
        var firebaseUser = auth.currentUser!;
        firebaseUser.updatePassword(profileModel.password!);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'INTERNAL') {
        message.value = 'Erro interno.';
      } else {
        message.value = 'Error: Informe ao administrador do app.';
      }
    }

    message.value = 'Sucess';
  }

  Future<bool> validatePassword(password) async {
    try {
      var firebaseUser = auth.currentUser!;
      var authCredentials = EmailAuthProvider.credential(
          email: firebaseUser.email!, password: password);
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

  Future logout() async {
    message.value = '';
    try {
      await auth.signOut();
    } on FirebaseException catch (e) {
      if (e.code == 'INTERNAL') {
        message.value = 'Erro interno.';
      } else {
        message.value = 'Error: Informe ao administrador do app.';
      }
    }

    message.value = 'Sucess';
  }

  Future updateProfile(type) async {
    message.value = '';
    try {
      profileModel.id = auth.currentUser!.uid;
      if (type == 1) {
        storage.refFromURL(profileModel.imageOriginal!).delete();
        final refImage = storage
            .ref('perfil/${DateTime.now().toString()}-${profileModel.id}.jpg');
        await refImage.putFile(profileModel.image!);
        profileModel.imageUrl = await refImage.getDownloadURL();
        await db
            .collection('perfil')
            .doc(profileModel.idProfile)
            .set(profileModel.profile());
      } else {
        await db.collection('perfil').doc(profileModel.idProfile).update({
          'descricao': profileModel.description,
          "data_modificacao": DateTime.now()
        });
      }
    } on FirebaseException catch (e) {
      if (e.code == 'INTERNAL') {
        message.value = 'Erro interno.';
      } else {
        message.value = 'Error: Informe ao administrador do app.';
      }
    }

    message.value = 'Sucess';
  }

  setParameters(parameters) {
    profileModel.name = parameters['name'];
    profileModel.kindServise = parameters['kindServise'];
    profileModel.cpfCnpj = parameters['cpfCnpj'];
    profileModel.typeUser = parameters['typeUser'];
    profileModel.phone = parameters['phone'];
    profileModel.genre = parameters['genre'];
    profileModel.birthDate = parameters['birthDate'];
    profileModel.cep = parameters['cep'];
    profileModel.street = parameters['street'];
    profileModel.number = parameters['number'];
    profileModel.neighborhood = parameters['neighborhood'];
    profileModel.city = parameters['city'];
    profileModel.state = parameters['state'];
    profileModel.complement = parameters['complement'];
    profileModel.email = parameters['email'];
    profileModel.nickName = parameters['nickName'];
    profileModel.dataCriacao = parameters['dataCriacao'];
  }

  setParametersNickNameAndPassword(parameters) {
    profileModel.nickName = parameters['nickName'];
    profileModel.password = parameters['password'];
  }

  setParametersProfile(parameters, type) {
    if (type == 2) {
      profileModel.image = parameters['image'];
    } else {
      profileModel.imageUrl = parameters['image'];
    }

    profileModel.description = parameters['description'];
  }
}
