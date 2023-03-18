import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  String? id;

  //Alteração de campos
  int? typeUser;
  List? kindServise;
  String? kindServiseString;
  String? name;
  String? cpfCnpj;
  String? phone;
  String? genre;
  String? birthDate;
  String? cep;
  String? street;
  int? number;
  String? neighborhood;
  String? city;
  String? state;
  String? complement;
  String? nickName;
  String? email;
  String? password;
  File? image;
  String? imageUrl;
  String? description;
  String? idProfile;
  Timestamp? dataCriacao;
  String? imageOriginal;

  ProfileModel(
      {this.typeUser,
      this.kindServise,
      this.name,
      this.cpfCnpj,
      this.phone,
      this.genre,
      this.birthDate,
      this.cep,
      this.street,
      this.number,
      this.neighborhood,
      this.city,
      this.state,
      this.complement,
      this.nickName,
      this.email,
      this.password,
      this.image,
      this.description,
      this.id,
      this.imageUrl,
      this.idProfile,
      this.dataCriacao,
      this.kindServiseString,
      this.imageOriginal});

  Map<String, dynamic> profileImage() =>
      {"foto": imageUrl, "data_modificacao": DateTime.now()};

  Map<String, dynamic> profileDecription() =>
      {"descricao": description, "data_modificacao": DateTime.now()};

  Map<String, dynamic> userInformation() => {
        "nome": name,
        "email": email,
        "apelido": nickName,
        "cpf_cnpj": cpfCnpj,
        "tipo_sevico": kindServise,
        "data_nascimento": birthDate,
        "genero": genre,
        "tefone": phone,
        "tipo_usuario": typeUser,
        "status_usuario": "A",
        "end_cep": cep,
        "end_rua": street,
        "end_bairro": neighborhood,
        "end_complemento": complement,
        "end_cidade": city,
        "end_uf": state,
        "end_numero": number,
        "data_criacao": dataCriacao,
        "data_modificacao": DateTime.now()
      };

  Map<String, dynamic> userAccount() =>
      {"apelido": nickName, "data_modificacao": DateTime.now()};

  Map<String, dynamic> userPassword() =>
      {"password": password, "data_modificacao": DateTime.now()};

  Map<String, dynamic> dataUser = {};

  Map<String, dynamic> profile() => {
        "usuario": id,
        "foto": imageUrl,
        "descricao": description,
        "data_criacao": DateTime.now(),
        "data_modificacao": DateTime.now()
      };
}
