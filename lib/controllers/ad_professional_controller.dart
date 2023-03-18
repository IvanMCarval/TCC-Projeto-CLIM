import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/models/ad_professional_model.dart';

class AdProfessionalController {
  ValueNotifier<String> message;
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final adProfessionalModel = AdProfessionalModel();

  AdProfessionalController(this.message);

  getAllAd() {
    return db.collection('anuncio').snapshots().asyncMap((event) async {
      var adsCand = [];
      await db
          .collection('candidatos_anuncio')
          .where('prestador', isEqualTo: auth.currentUser!.uid)
          .where('status', isEqualTo: 'A')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          adsCand.add(element.get('anuncio'));
        });
      });

      adProfessionalModel.dataKindService =
          await db.collection('tipo_servico').get();

      return event.docs
          .where((element) =>
              adsCand.contains(element.id) != true &&
              element.get('status') == 'A')
          .toList();
    });
  }

  getKindService() {
    return adProfessionalModel.dataKindService;
  }

  getAdOnlySubscribe() {
    return db.collection('anuncio').snapshots().asyncMap((event) async {
      var adsCand = [];
      await db
          .collection('candidatos_anuncio')
          .where('prestador', isEqualTo: auth.currentUser!.uid)
          .where('status', isEqualTo: 'A')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          adsCand.add(element.get('anuncio'));
        });
      });

      adProfessionalModel.dataKindService =
          await db.collection('tipo_servico').get();

      return event.docs
          .where((element) =>
              adsCand.contains(element.id) == true &&
              element.get('status') == 'A')
          .toList();
    });
  }

  getFilterKindServices() {
    return db.collection('tipo_servico').snapshots();
  }

  Future adUnsubscribe() async {
    try {
      var existCad = await db
          .collection('candidatos_anuncio')
          .where('anuncio', isEqualTo: adProfessionalModel.ad)
          .where('prestador', isEqualTo: adProfessionalModel.provider)
          .get();
      adProfessionalModel.id = existCad.docs.first.id;
      adProfessionalModel.dataCreation =
          existCad.docs.first.get('data_criacao');
      await db
          .collection('candidatos_anuncio')
          .doc(adProfessionalModel.id)
          .set(adProfessionalModel.crateUpdateAd());
    } on FirebaseException catch (e) {
      if (e.code == 'INTERNAL') {
        message.value = 'Erro interno.';
      } else {
        message.value = 'Error: Informe ao administrador do app.';
      }
    }

    message.value = 'Sucess';
  }

  Future adSubcribe() async {
    try {
      var existCad = await db
          .collection('candidatos_anuncio')
          .where('anuncio', isEqualTo: adProfessionalModel.ad)
          .where('prestador', isEqualTo: adProfessionalModel.provider)
          .get();
      if (existCad.docs.isEmpty) {
        await db
            .collection('candidatos_anuncio')
            .add(adProfessionalModel.crateUpdateAd());
      } else {
        adProfessionalModel.id = existCad.docs.first.id;
        adProfessionalModel.dataCreation =
            existCad.docs.first.get('data_criacao');
        await db
            .collection('candidatos_anuncio')
            .doc(adProfessionalModel.id)
            .set(adProfessionalModel.crateUpdateAd());
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
    adProfessionalModel.dataCreation = parameters['dataCreation'];
    adProfessionalModel.ad = parameters['ad'];
    adProfessionalModel.provider = auth.currentUser!.uid;
    adProfessionalModel.status = parameters['status'];
  }
}
