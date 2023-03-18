import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_project_clim/controllers/register_controller.dart';
import 'package:flutter_application_project_clim/models/register_model.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/components/elevated_button.dart';
import 'package:flutter_application_project_clim/views/components/outlined_button.dart';
import 'package:flutter_application_project_clim/views/components/text_input_field.dart';
import 'package:flutter_application_project_clim/views/components/step_progress.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({Key? key}) : super(key: key);

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  int _currentStep = 1;
  int _totalSteps = 6;
  int _filledSteps = 0;
  bool _isLoading = false;
  bool _sucess = false;

  var genre;
  var typeUser;
  var selectedServices = [];
  var selectedServicesDescription = [];
  File? imageAvatar;

  var name = TextEditingController();
  var cpfCnpj = TextEditingController();
  var phone = TextEditingController();
  var birthDateController = TextEditingController();
  late DateTime birthDate;
  var cep = TextEditingController();
  var street = TextEditingController();
  var number = TextEditingController();
  var neighborhood = TextEditingController();
  var city = TextEditingController();
  var state = TextEditingController();
  var complement = TextEditingController();
  var nickName = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  var image = TextEditingController();
  var description = TextEditingController();
  String? imageString;

  //Validação
  var formValidator = ValueNotifier<bool>(false);
  var formKey = GlobalKey<FormState>();

  //mascaras
  var maskCpfCnpj = MaskTextInputFormatter(mask: '##.###.###/####-##');

  var registerController;
  final ValueNotifier<String> messageNotifier = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    registerController = RegisterController(messageNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              StepProgressView(
                width: MediaQuery.of(context).size.width,
                curStep: _currentStep,
                totalSteps: _totalSteps,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Form(
                      key: formKey,
                      onChanged: () {
                        if (cpfCnpj.text.isNotEmpty) {
                          var len = cpfCnpj.text
                              .replaceAll('.', '')
                              .replaceAll('/', '')
                              .replaceAll('-', '')
                              .length;
                          maskCpfCnpj.updateMask(
                              mask: len < 11
                                  ? '###.###.###-###'
                                  : '##.###.###/####-##');
                        }

                        if (_currentStep == 5) {
                          formKey.currentState?.validate();
                          if (email.text.isNotEmpty &&
                              password.text.isNotEmpty &&
                              confirmPassword.text.isNotEmpty) {
                            formValidator.value =
                                formKey.currentState?.validate() ?? false;
                          }
                        }

                        if (cep.text.isNotEmpty &&
                            street.text.isNotEmpty &&
                            number.text.isNotEmpty &&
                            neighborhood.text.isNotEmpty &&
                            city.text.isNotEmpty &&
                            state.text.isNotEmpty &&
                            _currentStep == 4) {
                          formValidator.value = true;
                        }

                        if (_currentStep == 3) {
                          formKey.currentState?.validate();
                          if (name.text.isNotEmpty &&
                              cpfCnpj.text.isNotEmpty &&
                              phone.text.isNotEmpty &&
                              genre != null &&
                              birthDateController.text.isNotEmpty) {
                            formValidator.value = true;
                          }
                        }
                      },
                      child: pages(context),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: _isLoading
                    ? (const Center(
                        child: CircularProgressIndicator(
                        color: AppColors.green,
                        strokeWidth: 3,
                      )))
                    : _sucess
                        ? null
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Outlined(
                                  text:
                                      _currentStep == 1 ? 'Cancelar' : 'Voltar',
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    _currentStep == 1
                                        ? Navigator.pushNamed(context, '/login')
                                        : setState(() {
                                            _currentStep -= 1;
                                            formValidator.value = true;
                                          });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: ValueListenableBuilder<bool>(
                                valueListenable: formValidator,
                                builder: (context, value, child) {
                                  return Button(
                                    onPressed: !formValidator.value
                                        ? null
                                        : () async {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            if (_currentStep == _totalSteps) {
                                              var parameters = {
                                                'name': name.text,
                                                'kindServise': selectedServices,
                                                'cpfCnpj': cpfCnpj.text.trim(),
                                                'typeUser': typeUser,
                                                'phone': phone.text,
                                                'genre': genre,
                                                'birthDate':
                                                    birthDateController.text,
                                                'cep': cep.text.trim(),
                                                'street': street.text,
                                                'number':
                                                    int.parse(number.text),
                                                'neighborhood':
                                                    neighborhood.text,
                                                'city': city.text,
                                                'state': state.text,
                                                'complement':
                                                    complement.text == ''
                                                        ? ''
                                                        : complement.text,
                                                'nickName': nickName.text == ''
                                                    ? ''
                                                    : nickName.text,
                                                'email': email.text
                                                    .trim()
                                                    .toLowerCase(),
                                                'password':
                                                    password.text.trim(),
                                                'image': imageAvatar!,
                                                'description':
                                                    description.text == ''
                                                        ? ''
                                                        : description.text,
                                              };
                                              setState(() => _isLoading = true);

                                              registerController
                                                  .setParameters(parameters);
                                              await registerController.create();
                                              setState(
                                                  () => _isLoading = false);
                                              if (messageNotifier.value ==
                                                  'Sucess') {
                                                setState(() => _sucess = true);
                                                message('');
                                              } else {
                                                message(messageNotifier.value);
                                              }
                                            } else {
                                              setState(() {
                                                _currentStep += 1;
                                                if (((selectedServices
                                                                .isNotEmpty &&
                                                            _currentStep ==
                                                                2) ||
                                                        (name.text.isNotEmpty &&
                                                            cpfCnpj.text
                                                                .isNotEmpty &&
                                                            phone.text
                                                                .isNotEmpty &&
                                                            genre != null &&
                                                            birthDateController
                                                                .text
                                                                .isNotEmpty &&
                                                            _currentStep ==
                                                                3) ||
                                                        (cep.text.isNotEmpty &&
                                                            street.text
                                                                .isNotEmpty &&
                                                            number.text
                                                                .isNotEmpty &&
                                                            neighborhood.text
                                                                .isNotEmpty &&
                                                            city.text
                                                                .isNotEmpty &&
                                                            state.text
                                                                .isNotEmpty &&
                                                            _currentStep ==
                                                                4) ||
                                                        (email.text.isNotEmpty &&
                                                            password.text
                                                                .isNotEmpty &&
                                                            confirmPassword.text
                                                                .isNotEmpty &&
                                                            _currentStep ==
                                                                5) ||
                                                        (imageString != null &&
                                                            _currentStep ==
                                                                6)) &&
                                                    formKey.currentState!
                                                        .validate()) {
                                                  formValidator.value = true;
                                                } else {
                                                  formValidator.value = false;
                                                }
                                              });
                                            }
                                          },
                                    child: Text(
                                      _currentStep == _totalSteps
                                          ? 'Vamos lá!'
                                          : 'Continuar',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.background),
                                    ),
                                  );
                                },
                              )),
                            ],
                          ),
              )
            ],
          )),
    );
  }

  Widget pages(context) {
    Widget page;
    switch (_currentStep) {
      case 1:
        page = stepOne();
        break;
      case 2:
        page = stepTwo();
        break;
      case 3:
        page = stepThree(context);
        break;
      case 4:
        page = stepFour();
        break;
      case 5:
        page = stepFive();
        break;
      case 6:
        page = stepSix(context);
        break;
      default:
        page = stepFive();
        break;
    }
    return page;
  }

  Widget stepOne() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 30, top: 10),
          alignment: Alignment.center,
          child: const Text(
            "Como você se identifica?",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: AppColors.blue,
                fontWeight: FontWeight.w600),
          ),
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onTap: () {
                  setState(() {
                    typeUser = 2;
                    selectedServices = [];
                    selectedServicesDescription = [];
                    formValidator.value = true;
                  });
                },
                child: Card(
                  shadowColor: AppColors.black,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: (typeUser == 2)
                        ? const BorderSide(
                            color: AppColors.blueOpacity, width: 2.0)
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 33.61, 27, 33.61),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 150.0,
                            width: 150.0,
                            margin: const EdgeInsets.only(right: 17),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/cliente.png"),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sou cliente",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Preciso de um serviço",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: AppColors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onTap: () {
                  setState(() {
                    typeUser = 1;
                    formValidator.value = true;
                    selectedServices = [];
                    selectedServicesDescription = [];
                  });
                },
                child: Card(
                  shadowColor: AppColors.black,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: (typeUser == 1)
                        ? const BorderSide(
                            color: AppColors.blueOpacity, width: 2.0)
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(13.04, 30, 32.06, 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 150.0,
                            width: 150.0,
                            margin: const EdgeInsets.only(right: 34),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/profissional.png"),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sou profissional",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Busco novos clientes",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: AppColors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget stepTwo() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 30, top: 10),
          alignment: Alignment.center,
          child: Text(
            typeUser == 1
                ? "Quais tipos de serviço você realiza?"
                : "Quais tipos de serviço você procura?",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: AppColors.blue,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: StreamBuilder<QuerySnapshot>(
              stream: registerController.getListKindServices(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.green,
                      strokeWidth: 4,
                    ),
                  );
                }
                final data = snapshot.requireData;
                // listview height needs to be set
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap:
                      true, // I thought this line was supposed to stop the overflow
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onTap: () => setState(() {
                          if (selectedServices.contains(data.docs[index].id)) {
                            selectedServices.remove(data.docs[index].id);
                            selectedServicesDescription
                                .remove(data.docs[index]['descricao']);
                          } else {
                            selectedServices.add(data.docs[index].id);
                            selectedServicesDescription
                                .add(data.docs[index]['descricao']);
                          }

                          if (selectedServices.isNotEmpty) {
                            formValidator.value = true;
                          } else {
                            formValidator.value = false;
                          }
                        }),
                        child: Card(
                          shadowColor: AppColors.black,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 13, 24, 13),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.docs[index]['categoria'],
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            color: AppColors.blue,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        data.docs[index]['descricao'],
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            color: AppColors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Checkbox(
                                  value: selectedServices
                                      .contains(data.docs[index].id),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  activeColor: AppColors.blue,
                                  side: const BorderSide(
                                      color: AppColors.blue, width: 1.2),
                                  onChanged: (_) => setState(() {
                                    if (selectedServices
                                        .contains(data.docs[index].id)) {
                                      selectedServices
                                          .remove(data.docs[index].id);
                                      selectedServicesDescription.remove(
                                          data.docs[index]['descricao']);
                                    } else {
                                      selectedServices.add(data.docs[index].id);
                                      selectedServicesDescription
                                          .add(data.docs[index]['descricao']);
                                    }

                                    if (selectedServices.isNotEmpty) {
                                      formValidator.value = true;
                                    } else {
                                      formValidator.value = false;
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ],
    );
  }

  Widget stepThree(context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 30, top: 10),
          alignment: Alignment.center,
          child: const Text(
            "Conte mais sobre você!",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: AppColors.blue,
                fontWeight: FontWeight.w600),
          ),
        ),
        TextInputFeild(
          textLabel: 'Nome*',
          hintText: 'xxxxx',
          type: TextInputType.name,
          obscureText: false,
          controller: name,
          validator: (value) => null,
        ),
        TextInputFeild(
          textLabel: 'CPF/CNPJ*',
          hintText: '000.000.000-00',
          type: TextInputType.text,
          obscureText: false,
          controller: cpfCnpj,
          format: [maskCpfCnpj],
          key: const Key('form_cpfCnpj'),
          validator: (value) {
            var data = value!
                .replaceAll('.', '')
                .replaceAll('/', '')
                .replaceAll('-', '')
                .length;
            if (data <= 10 || data > 14) {
              return 'Insira CPF/CNPJ com no mínimo 11 caracteres e no máximo 14 caracteres.';
            }

            return null;
          },
        ),
        TextInputFeild(
          textLabel: 'Número do celular*',
          hintText: '(00) 00000-0000',
          type: TextInputType.phone,
          obscureText: false,
          controller: phone,
          validator: (value) {
            var data = value!
                .replaceAll('(', '')
                .replaceAll(')', '')
                .replaceAll('-', '')
                .replaceAll(' ', '')
                .length;
            if (data < 11) {
              return 'Insira o número de celular com o DDD de 2 dígitos e o celular de 9 dígitos.';
            }

            return null;
          },
          format: [
            FilteringTextInputFormatter.digitsOnly,
            MaskTextInputFormatter(mask: '(##) #####-####')
          ],
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Genero*",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: AppColors.blue,
                  ),
                ),
              ),
              Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.fields),
                      borderRadius: BorderRadius.circular(47)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: registerController.getListGenre(),
                        //exibir os dados recuperados
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return const Center(
                                child: Text(
                                    'Não foi possível conectar ao Firestore'),
                              );
                            case ConnectionState.waiting:
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.green,
                                  strokeWidth: 4,
                                ),
                              );

                            default:
                              return DropdownButton<String>(
                                hint: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text('Selecione um gênero'),
                                ),
                                key: const Key('form_genre'),
                                value: genre,
                                isExpanded: true,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                ),
                                icon: Icon(
                                  FeatherIcons.chevronDown,
                                  color: AppColors.fields,
                                ),
                                underline: const SizedBox(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    genre = newValue.toString();
                                    if (name.text.isNotEmpty &&
                                        cpfCnpj.text.isNotEmpty &&
                                        phone.text.isNotEmpty &&
                                        genre != null &&
                                        birthDateController.text.isNotEmpty &&
                                        formKey.currentState!.validate()) {
                                      formValidator.value = true;
                                    } else {
                                      formValidator.value = false;
                                    }
                                  });
                                },
                                items: snapshot.data?.docs
                                    .map((DocumentSnapshot document) {
                                  var docId = document.id;
                                  return DropdownMenuItem(
                                      value: docId,
                                      child: Text(
                                        document.get('descricao'),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ));
                                }).toList(),
                              );
                          }
                        }),
                  )),
            ],
          ),
        ),
        date(context)
      ],
    );
  }

  Widget stepFour() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 30, top: 10),
          alignment: Alignment.center,
          child: const Text(
            "Onde podemos te encontrar?",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: AppColors.blue,
                fontWeight: FontWeight.w600),
          ),
        ),
        TextInputFeild(
          textLabel: 'CEP*',
          hintText: '00.000-000',
          type: TextInputType.number,
          obscureText: false,
          controller: cep,
          validator: (value) => null,
          format: [
            FilteringTextInputFormatter.digitsOnly,
            MaskTextInputFormatter(mask: '##.###-###')
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextInputFeild(
                  textLabel: 'Rua*',
                  hintText: 'Rua exemplo',
                  type: TextInputType.text,
                  obscureText: false,
                  controller: street,
                  validator: (value) => null,
                ),
              ),
            ),
            Expanded(
              child: TextInputFeild(
                textLabel: 'Número*',
                hintText: '123',
                type: TextInputType.number,
                obscureText: false,
                controller: number,
                validator: (value) => null,
                format: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        TextInputFeild(
          textLabel: 'Bairro*',
          hintText: 'Bairro exemplo',
          type: TextInputType.text,
          obscureText: false,
          controller: neighborhood,
          validator: (value) => null,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextInputFeild(
                  textLabel: 'Cidade*',
                  hintText: 'Cidade exemplo',
                  type: TextInputType.text,
                  obscureText: false,
                  controller: city,
                  validator: (value) => null,
                ),
              ),
            ),
            Expanded(
              child: TextInputFeild(
                textLabel: 'Estado*',
                hintText: 'UF',
                type: TextInputType.text,
                obscureText: false,
                controller: state,
                validator: (value) => null,
              ),
            ),
          ],
        ),
        TextInputFeild(
          textLabel: 'Complemento',
          hintText: 'Ex.: Padaria na esquina',
          type: TextInputType.text,
          obscureText: false,
          controller: complement,
          validator: (value) => null,
        ),
      ],
    );
  }

  Widget stepFive() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 30, top: 10),
          alignment: Alignment.center,
          child: const Text(
            "Como iremos nos conectar com você?",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: AppColors.blue,
                fontWeight: FontWeight.w600),
          ),
        ),
        TextInputFeild(
          textLabel: 'Apelido',
          hintText: 'Apelido que você terá na plataforma',
          type: TextInputType.text,
          obscureText: false,
          controller: nickName,
          validator: (value) => null,
        ),
        TextInputFeild(
          textLabel: 'E-mail*',
          key: const Key('form_email'),
          hintText: 'exemplo@teste.com',
          type: TextInputType.emailAddress,
          obscureText: false,
          controller: email,
          validator: (value) {
            bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value!);
            if (!emailValid) {
              return 'E-mail não é válido.';
            }
            return null;
          },
        ),
        TextInputFeild(
          textLabel: 'Senha*',
          hintText: '********',
          type: TextInputType.text,
          obscureText: true,
          sufix: true,
          controller: password,
          key: const Key('form_password'),
          validator: (value) {
            if (value!.isNotEmpty && value.length < 7) {
              return 'Insira uma senha maior que 6 caracteres';
            }
            return null;
          },
        ),
        TextInputFeild(
          textLabel: 'Confirme sua senha*',
          hintText: '********',
          type: TextInputType.text,
          obscureText: true,
          sufix: true,
          key: const Key('form_confirmPassword'),
          controller: confirmPassword,
          validator: (value) {
            if (value!.isNotEmpty && value != password.text) {
              return 'As senhas não coincidem';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget stepSix(context) {
    var services = '';
    for (var i = 0; i < selectedServicesDescription.length; i++) {
      services += selectedServicesDescription.length - 1 == i
          ? '${selectedServicesDescription[i]}!'
          : '${selectedServicesDescription[i]}, ';
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 30, top: 10),
          alignment: Alignment.center,
          child: Text(
            typeUser == 1
                ? "Este é seu cartão de visita!"
                : "Este é seu perfil!",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: AppColors.blue,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 26.23),
                child: InkWell(
                  onTap: () async {
                    await _dialog(context);
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                          radius: 52,
                          backgroundImage: imageString == null
                              ? const AssetImage(
                                  'assets/images/iconUser_bg.png')
                              : Image.file(imageAvatar!).image),
                      const Positioned(
                        right: -3,
                        bottom: 0,
                        child: Icon(
                          Icons.edit_outlined,
                          color: AppColors.green,
                          size: 27,
                        ),
                      )
                    ],
                  ),
                  // ),
                ),
              ),
              Text(
                'Olá, sou ${name.text}',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 19),
                child: Text(
                  "${typeUser == 1 ? "Faço" : "Procuro"} $services",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: AppColors.black),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: TextFormField(
                  validator: (value) => null,
                  expands: true,
                  maxLines: null,
                  controller: description,
                  style: const TextStyle(
                    color: AppColors.blueOpacity,
                    fontSize: 14,
                  ),
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    constraints: const BoxConstraints(
                      maxHeight: 40,
                      minHeight: 40,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.blueOpacity,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: "Digite aqui informações adicionais",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.fields),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.blueOpacity, width: 1.0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget date(context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Data de nascimento*',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: AppColors.blue,
              ),
            ),
          ),
          TextFormField(
            key: const Key('form_birthDate'),
            controller: birthDateController,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              MaskTextInputFormatter(mask: '##/##/####')
            ],
            onChanged: ((value) {
              if (name.text.isNotEmpty &&
                  cpfCnpj.text.isNotEmpty &&
                  phone.text.isNotEmpty &&
                  genre != null &&
                  birthDateController.text.isNotEmpty &&
                  formKey.currentState!.validate()) {
                formValidator.value = true;
              } else {
                formValidator.value = false;
              }
            }),
            obscureText: false,
            textAlignVertical: TextAlignVertical.bottom,
            keyboardType: TextInputType.none,
            validator: (value) => null,
            onTap: () async {
              DateTime? _dateTime = await showDatePicker(
                  context: context,
                  locale: const Locale('pt', 'BR'),
                  builder: (context, child) {
                    return Theme(
                        data: ThemeData(
                            colorScheme: Theme.of(context)
                                .colorScheme
                                .copyWith(primary: AppColors.green),
                            splashColor: const Color.fromRGBO(38, 183, 174, 1)),
                        child: child!);
                  },
                  initialDate: DateTime.now(),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  firstDate: DateTime(1930),
                  lastDate: DateTime.now().add(const Duration(days: 365)));
              if (_dateTime != null) {
                setState(() {
                  birthDate = _dateTime;
                  birthDateController.text =
                      '${_dateTime.day}/${_dateTime.month}/${_dateTime.year}';
                });
              }
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              suffixIcon: Icon(
                FeatherIcons.calendar,
                color: AppColors.fields,
                size: 20,
              ),
              constraints: const BoxConstraints(
                maxHeight: 40,
                minHeight: 40,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.blueOpacity),
                borderRadius: BorderRadius.circular(47),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.fields),
                borderRadius: BorderRadius.circular(47),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.blueOpacity, width: 1.0),
                borderRadius: BorderRadius.circular(47),
              ),
              hintText: '00/00/0000',
            ),
          ),
        ],
      ),
    );
  }

  message(erro) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(
                erro == ''
                    ? Icons.check_circle_outline
                    : Icons.dangerous_outlined,
                color: erro == '' ? AppColors.green : Colors.red,
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Flexible(
                child: Text(
                  erro == '' ? 'Usuário cadastrado com sucesso' : erro,
                  style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: AppColors.background),
                ),
              ),
            ],
          ),
          duration: Duration(
            seconds: erro == '' ? 3 : 5,
          ),
          backgroundColor: AppColors.black,
        ))
        .closed
        .then((value) {
      if (erro == '') {
        Navigator.pushNamed(context, '/login');
      }
    });
  }

  _dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        title: const Center(
          child: Text(
            'Escolha uma opção:',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
                onPressed: () async {
                  XFile? pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                  if (pickedFile != null) {
                    setState(() {
                      imageString = pickedFile.path;
                      imageAvatar = File(pickedFile.path);
                      formValidator.value = true;
                    });
                  }
                },
                icon: const Icon(
                  FeatherIcons.aperture,
                  size: 24.0,
                  color: AppColors.green,
                ),
                label: const Text(
                  'Galeria',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 18.0),
                )),
            TextButton.icon(
                onPressed: () async {
                  XFile? pickedFile =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  Navigator.pop(context);
                  if (pickedFile != null) {
                    setState(() {
                      imageString = pickedFile.path;
                      imageAvatar = File(pickedFile.path);
                      formValidator.value = true;
                    });
                  }
                },
                icon: const Icon(
                  FeatherIcons.camera,
                  size: 24.0,
                  color: AppColors.green,
                ),
                label: const Text(
                  'Camera',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 18.0),
                )),
          ],
        ),
        actionsPadding: EdgeInsets.zero,
        buttonPadding: EdgeInsets.zero,
        actions: <Widget>[
          Outlined(
            border: 2,
            text: 'Cancelar',
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
