import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_project_clim/controllers/profile_controller.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/components/custom_appBar.dart';
import 'package:flutter_application_project_clim/views/components/elevated_button.dart';
import 'package:flutter_application_project_clim/views/components/text_input_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool _isLoading = false;
  bool _sucess = false;
  bool _isLoadingInicial = true;
  var cep = TextEditingController();
  var street = TextEditingController();
  var number = TextEditingController();
  var neighborhood = TextEditingController();
  var city = TextEditingController();
  var state = TextEditingController();
  var complement = TextEditingController();

  //Validação
  var formValidator = ValueNotifier<bool>(false);
  var formKey = GlobalKey<FormState>();
  var information;
  int complet = 0;

  var profileController;
  final ValueNotifier<String> messageNotifier = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    profileController = ProfileController(messageNotifier);
  }

  Future getUser() async {
    await profileController.getUserPages().then((value) {
      cep.text = value.get('end_cep').toString();
      street.text = value.get('end_rua');
      neighborhood.text = value.get('end_bairro');
      complement.text = value.get('end_complemento');
      city.text = value.get('end_cidade').toString();
      state.text = value.get('end_uf');
      number.text = value.get('end_numero').toString();
      information = value;
      complet = 1;
    });
    setState(() {
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
            title: "Endereço",
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
                        key: formKey,
                        onChanged: () {
                          if (complet == 1) {
                            if (cep.text.isNotEmpty &&
                                street.text.isNotEmpty &&
                                number.text.isNotEmpty &&
                                neighborhood.text.isNotEmpty &&
                                city.text.isNotEmpty &&
                                state.text.isNotEmpty &&
                                (cep.text != information.get('end_cep') ||
                                    street.text != information.get('end_rua') ||
                                    neighborhood.text !=
                                        information.get('end_bairro') ||
                                    complement.text !=
                                        information.get('end_complemento') ||
                                    city.text !=
                                        information
                                            .get('end_cidade')
                                            .toString() ||
                                    state.text != information.get('end_uf') ||
                                    number.text !=
                                        information
                                            .get('end_numero')
                                            .toString())) {
                              formValidator.value = true;
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                          child: Column(
                            children: [
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
                                              'name': information.get('nome'),
                                              'kindServise': information
                                                  .get('tipo_sevico'),
                                              'cpfCnpj':
                                                  information.get('cpf_cnpj'),
                                              'typeUser': information
                                                  .get('tipo_usuario'),
                                              'phone':
                                                  information.get('tefone'),
                                              'genre':
                                                  information.get('genero'),
                                              'birthDate': information
                                                  .get('data_nascimento'),
                                              'cep': cep.text.trim(),
                                              'street': street.text,
                                              'number': int.parse(number.text),
                                              'neighborhood': neighborhood.text,
                                              'city': city.text,
                                              'state': state.text,
                                              'complement':
                                                  complement.text == ''
                                                      ? ''
                                                      : complement.text,
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
                  erro == '' ? 'Endereço alterado com sucesso' : erro,
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
