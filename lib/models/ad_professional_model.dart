import 'package:cloud_firestore/cloud_firestore.dart';

class AdProfessionalModel {
  late QuerySnapshot<Map<String, dynamic>> dataKindService;
  String? id;

  Timestamp? dataCreation;
  String? ad;
  String? provider;
  String? status;

  AdProfessionalModel({
    this.id,
    this.dataCreation,
    this.status,
  });

  Map<String, dynamic> crateUpdateAd() => {
        "data_criacao": dataCreation,
        "data_modificacao": Timestamp.now(),
        "anuncio": ad,
        "prestador": provider,
        "status": status
      };
}
