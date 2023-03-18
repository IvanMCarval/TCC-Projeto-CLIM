import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterModel {
  int? typeUser;
  List? kindServise;
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
  String? user;

  RegisterModel(
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
      this.user,
      this.imageUrl});

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
        "data_criacao": DateTime.now(),
        "data_modificacao": DateTime.now()
      };

  Map<String, dynamic> profile() => {
        "usuario": user,
        "foto": imageUrl,
        "descricao": description,
        "data_criacao": DateTime.now(),
        "data_modificacao": DateTime.now()
      };
}
