import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/models/ad_client_model.dart';
import 'package:flutter_application_project_clim/models/professional_model.dart';

class AdClientController {
  ValueNotifier<String> message;
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final adClientModel = AdClientModel();

  AdClientController(this.message);

  getAllAd() {
    adClientModel.id = auth.currentUser!.uid;
    return db
        .collection('anuncio')
        .where('usuario_anunciador', isNotEqualTo: adClientModel.id)
        .snapshots()
        .asyncMap((event) async {
      adClientModel.dataKindService = await db.collection('tipo_servico').get();
      return event.docs.toList();
    });
  }

  getAdOnlyClient() {
    return db
        .collection('anuncio')
        .where('usuario_anunciador', isEqualTo: adClientModel.id)
        .snapshots()
        .asyncMap((event) async {
      adClientModel.dataKindService = await db.collection('tipo_servico').get();
      return event.docs.toList();
    });
  }

  getOnlyAdOnlyClient(id) async {
    return await db.collection('anuncio').doc(id).get();
  }

  getListTypeService() {
    return db.collection('tipo_servico').snapshots();
  }

  getListCandidates(id) {
    return db
        .collection('candidatos_anuncio')
        .where('anuncio', isEqualTo: id)
        .where('status', isEqualTo: 'A')
        .snapshots()
        .asyncMap((event) async {
      var providers = event.docs.map((e) => e.get('prestador'));

      var likes = await db
          .collection('comentarios_usuarios')
          .where('UID_receptor', whereIn: providers.toList())
          .where('curtida', isEqualTo: 1)
          .get();
      var user = await db
          .collection('usuario')
          .where(FieldPath.documentId, whereIn: providers.toList())
          .get();
      return [likes, user];
    });
  }

  Future createAd() async {
    try {
      await db.collection('anuncio').add(adClientModel.crateUpdateAd());
    } on FirebaseException catch (e) {
      if (e.code == 'INTERNAL') {
        message.value = 'Erro interno.';
      } else {
        message.value = 'Error: Informe ao administrador do app.';
      }
    }

    message.value = 'Sucess';
  }

  Future updateAd() async {
    try {
      await db
          .collection('anuncio')
          .doc(adClientModel.id)
          .set(adClientModel.crateUpdateAd());
    } on FirebaseException catch (e) {
      if (e.code == 'INTERNAL') {
        message.value = 'Erro interno.';
      } else {
        message.value = 'Error: Informe ao administrador do app.';
      }
    }

    message.value = 'Sucess';
  }

  Future deleteAd(id) async {
    adClientModel.id = id;
    try {
      await db.collection('anuncio').doc(adClientModel.id).delete();
      await db
          .collection('candidatos_anuncio')
          .where('anuncio', isEqualTo: adClientModel.id)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          db.collection('candidatos_anuncio').doc(element.id).delete();
        });
      });
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
    adClientModel.id = parameters['id'];
    adClientModel.dataCreation = parameters['dataCreation'];
    adClientModel.value = parameters['value'];
    adClientModel.status = parameters['status'];
    adClientModel.title = parameters['title'];
    adClientModel.neighborhood = parameters['neighborhood'];
    adClientModel.street = parameters['street'];
    adClientModel.userAnnouncer = auth.currentUser!.uid;
    adClientModel.kindServise = parameters['kindServise'];
    adClientModel.dataRealization = parameters['dataAd'];
    adClientModel.state = parameters['state'];
    adClientModel.city = parameters['city'];
  }

  getKindService() {
    return adClientModel.dataKindService;
  }

  Future<Map<String, dynamic>> getDetailsClient(id) async {
    await db.collection('anuncio').doc(id).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      adClientModel.dataAdDetails.addAll(data);
      adClientModel.kindServise = doc.get('tipo_servico');
    });

    adClientModel.kindServiseString = '';
    await db
        .collection('tipo_servico')
        .where(FieldPath.documentId, whereIn: adClientModel.kindServise)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (adClientModel.kindServiseString == '') {
          adClientModel.kindServiseString = element.get('categoria');
        } else {
          adClientModel.kindServiseString =
              "${adClientModel.kindServiseString} / ${element.get('categoria')} ";
        }
      });
      adClientModel.dataAdDetails
          .addAll({'services': adClientModel.kindServiseString});
    });

    return adClientModel.dataAdDetails;
  }

  getFilterKindServices() {
    return db.collection('tipo_servico').snapshots();
  }

  Future<ProfessionalModel> sendInformationProvider(id) async {
    final perfil =
        await db.collection("perfil").where("usuario", isEqualTo: id).get();
    var like = await db
        .collection('comentarios_usuarios')
        .where('UID_receptor', isEqualTo: id)
        .where('curtida', isEqualTo: 1)
        .get();

    final user = await db.collection('usuario').doc(id).get();
    var kindService = await db
        .collection('tipo_servico')
        .where(FieldPath.documentId, whereIn: user.get('tipo_sevico'))
        .get();
    return ProfessionalModel(
        user.id,
        user.get('nome'),
        perfil.docs.first.get('descricao'),
        perfil.docs.first.get('foto'),
        like.size,
        kindService.docs.map((e) => e.get('categoria')).toList(),
        user.get('tefone'));
  }
}
