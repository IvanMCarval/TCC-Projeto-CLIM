import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/controllers/profile_controller.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/components/custom_appBar.dart';
import 'package:flutter_application_project_clim/views/components/elevated_button.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  var selectedServices = [];
  var selectedServicesOriginal = [];
  bool _isLoading = false;
  bool _isLoadingInicial = true;
  bool _sucess = false;

  var information;

  var formValidator = ValueNotifier<bool>(false);
  var formKey = GlobalKey<FormState>();

  var profileController;
  final ValueNotifier<String> messageNotifier = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    profileController = ProfileController(messageNotifier);
  }

  Future getUser() async {
    await profileController.getUserPages().then((value) {
      information = value;
      value.get("tipo_sevico").forEach((value) {
        selectedServices.add(value);
        selectedServicesOriginal.add(value);
      });
    });
    setState(() {
      _isLoadingInicial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedServicesOriginal.isEmpty) {
      getUser();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: CustomAppBar(
          back: true,
          title: "Serviços",
        ),
      ),
      body: _isLoadingInicial
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.green,
                strokeWidth: 4,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: profileController.getListKindServices(),
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
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      onTap: () => setState(() {
                                        if (selectedServices
                                            .contains(data.docs[index].id)) {
                                          selectedServices
                                              .remove(data.docs[index].id);
                                        } else {
                                          selectedServices
                                              .add(data.docs[index].id);
                                        }
                                        bool egualy = listEquals(
                                            selectedServicesOriginal,
                                            selectedServices);
                                        if (egualy == false) {
                                          if (selectedServices.isNotEmpty) {
                                            formValidator.value = true;
                                          } else {
                                            formValidator.value = false;
                                          }
                                        } else {
                                          formValidator.value = false;
                                        }
                                      }),
                                      child: Card(
                                        shadowColor: AppColors.black,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              24, 13, 24, 13),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.docs[index]
                                                          ['categoria'],
                                                      style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 18,
                                                          color: AppColors.blue,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    Text(
                                                      data.docs[index]
                                                          ['descricao'],
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 16,
                                                          color:
                                                              AppColors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Checkbox(
                                                value:
                                                    selectedServices.contains(
                                                        data.docs[index].id),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                                activeColor: AppColors.blue,
                                                side: const BorderSide(
                                                    color: AppColors.blue,
                                                    width: 1.2),
                                                onChanged: (_) => setState(() {
                                                  int type = 1;
                                                  if (selectedServices.contains(
                                                      data.docs[index].id)) {
                                                    selectedServices.remove(
                                                        data.docs[index].id);
                                                  } else {
                                                    type = 2;
                                                    selectedServices.add(
                                                        data.docs[index].id);
                                                  }
                                                  bool egualy = listEquals(
                                                      selectedServicesOriginal,
                                                      selectedServices);
                                                  if (egualy == false) {
                                                    if (selectedServices
                                                        .isNotEmpty) {
                                                      formValidator.value =
                                                          true;
                                                    } else {
                                                      formValidator.value =
                                                          false;
                                                    }
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
                          : ValueListenableBuilder<bool>(
                              valueListenable: formValidator,
                              builder: (context, value, child) {
                                return Button(
                                  onPressed: !formValidator.value
                                      ? null
                                      : () async {
                                          setState(() => _isLoading = true);

                                          var parameters = {
                                            'name': information.get('nome'),
                                            'kindServise': selectedServices,
                                            'cpfCnpj':
                                                information.get('cpf_cnpj'),
                                            'typeUser':
                                                information.get('tipo_usuario'),
                                            'phone': information.get('tefone'),
                                            'genre': information.get('genero'),
                                            'birthDate': information
                                                .get('data_nascimento'),
                                            'cep': information.get('end_cep'),
                                            'street':
                                                information.get('end_rua'),
                                            'number':
                                                information.get('end_numero'),
                                            'neighborhood':
                                                information.get('end_bairro'),
                                            'city':
                                                information.get('end_cidade'),
                                            'state': information.get('end_uf'),
                                            'complement': information.get(
                                                        'end_complemento') ==
                                                    ''
                                                ? ''
                                                : information
                                                    .get('end_complemento'),
                                            'email': information.get('email'),
                                            'nickName':
                                                information.get('apelido'),
                                            'dataCriacao':
                                                information.get('data_criacao'),
                                          };
                                          setState(() => _isLoading = true);

                                          profileController
                                              .setParameters(parameters);
                                          await profileController.updateUser();
                                          setState(() => _isLoading = false);
                                          if (messageNotifier.value ==
                                              'Sucess') {
                                            setState(() => _sucess = true);
                                            message('');
                                          } else {
                                            message(messageNotifier.value);
                                          }
                                        },
                                  child: const Text(
                                    'Salvar alterações',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.background),
                                  ),
                                );
                              },
                            ),
                )
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
                  erro == '' ? 'Serviços alterados com sucesso' : erro,
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
        Navigator.pop(context);
      }
    });
  }
}
