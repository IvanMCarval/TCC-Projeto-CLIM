import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/models/professional_model.dart';

class ProfessionalsController {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  ValueNotifier<List>? listLikes;
  ValueNotifier<String> message;
  ProfessionalsController(this.listLikes, this.message);

  getProfessionals() {
    return db
        .collection('comentarios_usuarios')
        .snapshots()
        .asyncMap((likes) async {
      var users = await db
          .collection('usuario')
          .where('tipo_usuario', isEqualTo: 1)
          .get();
      var profile = await db
          .collection('perfil')
          .where('usuario', whereIn: users.docs.map((e) => e.id).toList())
          .get();
      var kindService = await db.collection('tipo_servico').get();
      return [users, likes, profile, kindService];
    });
  }

  addLike(idReceptor, like, id) async {
    try {
      if (id != '') {
        await db.collection('comentarios_usuarios').doc(id).update(
            {'curtida': like == 0 ? 1 : 0, "data_modificacao": DateTime.now()});
      } else {
        await db.collection('comentarios_usuarios').add({
          "UID_comentarista": auth.currentUser!.uid,
          "UID_receptor": idReceptor,
          "comentario": [],
          "curtida": 1,
          "data_criacao": DateTime.now(),
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

    message.value = message.value = 'Sucess';
  }

  addComment(idReceptor, text, List texts, id) async {
    try {
      if (id != '') {
        texts.add(text);
        await db
            .collection('comentarios_usuarios')
            .doc(id)
            .update({'comentario': texts, "data_modificacao": DateTime.now()});
      } else {
        await db.collection('comentarios_usuarios').add({
          "UID_comentarista": auth.currentUser!.uid,
          "UID_receptor": idReceptor,
          "comentario": [text],
          "curtida": 0,
          "data_criacao": DateTime.now(),
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

    message.value = message.value = 'Sucess';
  }

  getFilterKindServices() {
    return db.collection('tipo_servico').get();
  }

  getDetailsProfessional(id) {
    return db
        .collection('comentarios_usuarios')
        .where('UID_receptor', isEqualTo: id)
        .snapshots()
        .asyncMap((event) async {
      var user = await db
          .collection('perfil')
          .where('usuario',
              whereIn: event.docs.map((e) => e.get('UID_receptor')).toList())
          .get();
      listLikes!.value = event.docs.toList();
      return [event, user];
    });
  }

  getLikesComments(id) {
    return db
        .collection('comentarios_usuarios')
        .where('UID_receptor', isEqualTo: id)
        .snapshots();
  }
}
