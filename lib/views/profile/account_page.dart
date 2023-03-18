import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/controllers/profile_controller.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/components/custom_appBar.dart';
import 'package:flutter_application_project_clim/views/components/elevated_button.dart';
import 'package:flutter_application_project_clim/views/components/text_input_field.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isLoading = false;
  bool _sucess = false;
  bool _isLoadingInicial = true;

  var nickName = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var newPassword = TextEditingController();

  var formValidator = ValueNotifier<bool>(false);
  var formKey = GlobalKey<FormState>();
  var information;
  int complet = 0;
  bool checkCurrentPasswordValid = true;

  var profileController;
  final ValueNotifier<String> messageNotifier = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    profileController = ProfileController(messageNotifier);
  }

  Future getUser() async {
    await profileController.getUserPages().then((value) {
      nickName.text = value.get('apelido').toString();
      email.text = value.get('email');
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
            title: "Conta",
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
                          if (formKey.currentState!.validate()) {
                            if (password.text.isNotEmpty &&
                                newPassword.text.isNotEmpty) {
                              if (password.text != newPassword.text ||
                                  nickName.text != information.get('apelido')) {
                                formValidator.value = true;
                              } else {
                                formValidator.value = false;
                              }
                            } else {
                              if (nickName.text != information.get('apelido')) {
                                formValidator.value = true;
                              } else {
                                formValidator.value = false;
                              }
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                          child: Column(
                            children: [
                              TextInputFeild(
                                textLabel: 'Apelido',
                                hintText: 'Apelido que você terá na plataforma',
                                type: TextInputType.text,
                                obscureText: false,
                                controller: nickName,
                                validator: (value) => null,
                              ),
                              TextInputFeild(
                                read: false,
                                textLabel: 'E-mail*',
                                key: const Key('form_email'),
                                hintText: 'exemplo@teste.com',
                                type: TextInputType.emailAddress,
                                obscureText: false,
                                controller: email,
                                validator: (value) => null,
                              ),
                              TextInputFeild(
                                textLabel: 'Senha atual*',
                                hintText: '********',
                                erroMessage: 'Senha atual incorreta',
                                error: checkCurrentPasswordValid,
                                type: TextInputType.text,
                                obscureText: true,
                                controller: password,
                                key: const Key('form_password'),
                                validator: (value) => null,
                                sufix: true,
                              ),
                              TextInputFeild(
                                textLabel: 'Nova senha*',
                                hintText: '********',
                                type: TextInputType.text,
                                obscureText: true,
                                sufix: true,
                                key: const Key('form_newPassword'),
                                controller: newPassword,
                                validator: (value) {
                                  if (password.text.isEmpty) {
                                    return null;
                                  }

                                  if (value == password.text) {
                                    return 'A nova senha deve ser diferente que a senha atual';
                                  } else if (value!.length < 7) {
                                    return 'Insira uma nova senha maior que 6 caracteres';
                                  }
                                },
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
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            if (password.text.isNotEmpty &&
                                                newPassword.text.isNotEmpty) {
                                              if (password.text !=
                                                  newPassword.text) {
                                                checkCurrentPasswordValid =
                                                    await profileController
                                                        .validatePassword(
                                                            password.text);
                                              }
                                            } else {
                                              checkCurrentPasswordValid = true;
                                            }

                                            if (formKey.currentState!
                                                    .validate() &&
                                                checkCurrentPasswordValid ==
                                                    true) {
                                              var parameters = {
                                                'nickName': nickName.text == ''
                                                    ? ''
                                                    : nickName.text,
                                                'password':
                                                    newPassword.text == ''
                                                        ? ''
                                                        : newPassword.text
                                              };
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              profileController
                                                  .setParametersNickNameAndPassword(
                                                      parameters);
                                              await profileController
                                                  .updateUserAndPassword();
                                              setState(() {
                                                _isLoading = false;
                                              });

                                              if (messageNotifier.value ==
                                                  'Sucess') {
                                                message('');
                                                setState(() {
                                                  _sucess = true;
                                                });
                                              } else {
                                                message(messageNotifier.value);
                                              }
                                            } else {
                                              setState(() {
                                                _isLoading = false;
                                              });
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
                  erro == '' ? 'Dados da conta alterados com sucesso' : erro,
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
