import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_project_clim/controllers/profile_controller.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/components/custom_appBar.dart';
import 'package:flutter_application_project_clim/views/components/elevated_button.dart';
import 'package:flutter_application_project_clim/views/components/text_input_field.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage({Key? key}) : super(key: key);

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  bool _isLoading = false;
  bool _sucess = false;
  bool _isLoadingInicial = true;

  var genre;
  var genreSelected;
  var name = TextEditingController();
  var cpfCnpj = TextEditingController();
  var phone = TextEditingController();
  var birthDateController = TextEditingController();
  late DateTime birthDate;
  //mascaras
  var maskCpfCnpj = MaskTextInputFormatter(mask: '##.###.###/####-##');

  var formValidator = ValueNotifier<bool>(false);
  var formKey = GlobalKey<FormState>();

  var profileController;
  final ValueNotifier<String> messageNotifier = ValueNotifier('');
  var information;
  int complet = 0;

  @override
  void initState() {
    super.initState();
    profileController = ProfileController(messageNotifier);
  }

  Future getUser() async {
    await profileController.getUserPages().then((value) {
      name.text = value.get('nome').toString();
      cpfCnpj.text = value.get('cpf_cnpj');
      phone.text = value.get('tefone');
      birthDateController.text = value.get('data_nascimento');
      information = value;
      complet = 1;
    });
    setState(() {
      genre = information.get('genero').toString();
      _isLoadingInicial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (complet == 0) {
      getUser();
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: CustomAppBar(
            back: true,
            title: "Dados Pessoais",
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
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Form(
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

                          if (name.text.isNotEmpty &&
                              cpfCnpj.text.isNotEmpty &&
                              phone.text.isNotEmpty &&
                              genre != null &&
                              birthDateController.text.isNotEmpty &&
                              (name.text != information.get('nome') ||
                                  cpfCnpj.text != information.get('cpf_cnpj') ||
                                  phone.text != information.get('tefone') ||
                                  genre != information.get('genero') ||
                                  birthDateController.text !=
                                      information.get('data_nascimento')) &&
                              formKey.currentState!.validate()) {
                            formValidator.value = true;
                          } else {
                            formValidator.value = false;
                          }
                        },
                        key: formKey,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                          child: Column(
                            children: [
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
                                  MaskTextInputFormatter(
                                      mask: '(##) #####-####')
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
                                            border: Border.all(
                                                color: AppColors.fields),
                                            borderRadius:
                                                BorderRadius.circular(47)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 0, 8.0, 0),
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: profileController
                                                  .getListGenre(),
                                              //exibir os dados recuperados
                                              builder: (context, snapshot) {
                                                switch (
                                                    snapshot.connectionState) {
                                                  case ConnectionState.none:
                                                    return const Center(
                                                      child: Text(
                                                          'Não foi possível conectar ao Firestore'),
                                                    );
                                                  case ConnectionState.waiting:
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: AppColors.green,
                                                        strokeWidth: 4,
                                                      ),
                                                    );
                                                  default:
                                                    return DropdownButton<
                                                        String>(
                                                      hint: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    15.0),
                                                        child: Text(
                                                            'Selecione um gênero'),
                                                      ),
                                                      key: const Key(
                                                          'form_genre'),
                                                      value: genre,
                                                      isExpanded: true,
                                                      style: TextStyle(
                                                        color: AppColors.black,
                                                        fontSize: 14,
                                                      ),
                                                      icon: Icon(
                                                        FeatherIcons
                                                            .chevronDown,
                                                        color: AppColors.fields,
                                                      ),
                                                      underline:
                                                          const SizedBox(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          genre = newValue
                                                              .toString();
                                                          if (name.text
                                                                  .isNotEmpty &&
                                                              cpfCnpj.text
                                                                  .isNotEmpty &&
                                                              phone.text
                                                                  .isNotEmpty &&
                                                              genre != null &&
                                                              birthDateController
                                                                  .text
                                                                  .isNotEmpty &&
                                                              (name
                                                                          .text !=
                                                                      information
                                                                          .get(
                                                                              'nome') ||
                                                                  cpfCnpj
                                                                          .text !=
                                                                      information
                                                                          .get(
                                                                              'cpf_cnpj') ||
                                                                  phone.text !=
                                                                      information
                                                                          .get(
                                                                              'tefone') ||
                                                                  genre !=
                                                                      information
                                                                          .get(
                                                                              'genero') ||
                                                                  birthDateController
                                                                          .text !=
                                                                      information
                                                                          .get(
                                                                              'data_nascimento')) &&
                                                              formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                            formValidator
                                                                .value = true;
                                                          } else {
                                                            formValidator
                                                                .value = false;
                                                          }
                                                        });
                                                      },
                                                      items: snapshot.data?.docs
                                                          .map((DocumentSnapshot
                                                              document) {
                                                        var docId = document.id;
                                                        return DropdownMenuItem(
                                                            value: docId,
                                                            child: Text(
                                                              document.get(
                                                                  'descricao'),
                                                              style:
                                                                  const TextStyle(
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
                              date(context),
                            ],
                          ),
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
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            setState(() => _isLoading = true);

                                            var parameters = {
                                              'name': name.text,
                                              'kindServise': information
                                                  .get('tipo_sevico'),
                                              'cpfCnpj': cpfCnpj.text.trim(),
                                              'typeUser': information
                                                  .get('tipo_usuario'),
                                              'phone': phone.text,
                                              'genre': genre,
                                              'birthDate':
                                                  birthDateController.text,
                                              'cep': information.get('end_cep'),
                                              'street':
                                                  information.get('end_rua'),
                                              'number':
                                                  information.get('end_numero'),
                                              'neighborhood':
                                                  information.get('end_bairro'),
                                              'city':
                                                  information.get('end_cidade'),
                                              'state':
                                                  information.get('end_uf'),
                                              'complement': information.get(
                                                          'end_complemento') ==
                                                      ''
                                                  ? ''
                                                  : information
                                                      .get('end_complemento'),
                                              'email': information.get('email'),
                                              'nickName':
                                                  information.get('apelido'),
                                              'dataCriacao': information
                                                  .get('data_criacao'),
                                            };
                                            setState(() => _isLoading = true);

                                            profileController
                                                .setParameters(parameters);
                                            await profileController
                                                .updateUser();
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
      ),
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
                  (name.text != information.get('nome') ||
                      cpfCnpj.text != information.get('cpf_cnpj') ||
                      phone.text != information.get('tefone') ||
                      genre != information.get('genero') ||
                      birthDateController.text !=
                          information.get('data_nascimento')) &&
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
                  erro == '' ? 'Dados Pessoais alterados com sucesso' : erro,
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
