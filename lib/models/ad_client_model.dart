import 'package:cloud_firestore/cloud_firestore.dart';

class AdClientModel {
  String? id;

  Timestamp? dataCreation;
  Timestamp? dataRealization;
  String? street;
  String? neighborhood;
  String? city;
  String? state;
  String? status;
  List? kindServise;
  String? kindServiseString;
  String? title;
  String? userAnnouncer;
  double? value;

  AdClientModel({
    this.id,
    this.dataCreation,
    this.dataRealization,
    this.street,
    this.neighborhood,
    this.city,
    this.state,
    this.status,
    this.kindServise,
    this.kindServiseString,
    this.title,
    this.userAnnouncer,
    this.value,
  });

  Map<String, dynamic> crateUpdateAd() => {
        "data_criacao": dataCreation,
        "data_modificacao": Timestamp.now(),
        "data_realizacao": dataRealization,
        "end_rua": street,
        "end_bairro": neighborhood,
        "end_cidade": city,
        "end_estado": state,
        "status": status,
        "tipo_servico": kindServise,
        "titulo": title,
        "usuario_anunciador": userAnnouncer,
        "valor": value
      };

  Map<String, dynamic> dataAd = {};

  Map<String, dynamic> dataAdDetails = {};

  late QuerySnapshot<Map<String, dynamic>> dataKindService;
}
