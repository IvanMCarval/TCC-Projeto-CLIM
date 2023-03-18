import 'package:flutter_application_project_clim/controllers/user_controller.dart';
import 'package:flutter_application_project_clim/views/components/elevated_button.dart';
import 'package:flutter_application_project_clim/views/components/text_button.dart';
import 'package:flutter_application_project_clim/views/components/text_input_field.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ValueNotifier<String> authMessage = ValueNotifier('');
  final ValueNotifier<bool> resetPasswordCheckMessage = ValueNotifier(false);
  late ValueNotifier<bool> resetPassword = ValueNotifier(false);

  final _formKeyModalLogar = GlobalKey<FormState>();

  var userController;

  @override
  void initState() {
    userController = UserController();
    super.initState();
  }

  var txtEmailLogin = TextEditingController();
  var txtPassword = TextEditingController();
  var txtEmailResetPassword = TextEditingController();

  final loading = ValueNotifier<bool>(false);
  final loadingResetPassword = ValueNotifier<bool>(false);

  _modalLogarRedefinirSenha(BuildContext context) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ValueListenableBuilder(
            valueListenable: resetPassword,
            builder: (BuildContext context, bool value, Widget? child) {
              return value == false
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                        right: 30,
                        left: 30,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Form(
                        key: _formKeyModalLogar,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextInputFeild(
                              textLabel: 'E-mail',
                              hintText: 'exemplo@email.com',
                              type: TextInputType.emailAddress,
                              obscureText: false,
                              controller: txtEmailLogin,
                              validator: (value) {
                                if (value == null || value == '') {
                                  return 'Preencha o campo';
                                }
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                if (!emailValid) {
                                  return 'E-mail não é válido.';
                                }
                                return null;
                              },
                            ),
                            TextInputFeild(
                              textLabel: 'Senha',
                              hintText: '********',
                              type: TextInputType.visiblePassword,
                              obscureText: true,
                              controller: txtPassword,
                              sufix: true,
                            ),
                            ValueListenableBuilder<String>(
                              valueListenable: authMessage,
                              builder: (BuildContext context, String value,
                                  Widget? child) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.red,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ButtonText(
                              text: 'Esqueci minha senha',
                              fontSize: 12,
                              alignment: Alignment.center,
                              onPressed: () {
                                resetPassword.value = true;
                              },
                            ),
                            Button(
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_formKeyModalLogar.currentState!
                                    .validate()) {
                                  loading.value = !loading.value;
                                  authMessage.value =
                                      await userController.authUser(
                                          txtEmailLogin.text,
                                          txtPassword.text,
                                          context);
                                  if (authMessage.value != '') {
                                    loading.value = !loading.value;
                                  }
                                }
                              },
                              child: AnimatedBuilder(
                                animation: loading,
                                builder: (context, _) {
                                  return loading.value
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(),
                                        )
                                      : const Text(
                                          'Entrar',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.background),
                                        );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ButtonText(
                                text: 'Abrir Conta',
                                fontSize: 14,
                                alignment: Alignment.center,
                                onPressed: () => Navigator.pushNamed(
                                    context, '/register-user'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                        right: 30,
                        left: 30,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Form(
                        key: _formKeyModalLogar,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              alignment: Alignment.center,
                              child: const Text(
                                'Alteração de senha',
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            TextInputFeild(
                              textLabel: 'E-mail',
                              hintText: 'exemplo@email.com',
                              type: TextInputType.emailAddress,
                              controller: txtEmailResetPassword,
                            ),
                            ValueListenableBuilder(
                              valueListenable: resetPasswordCheckMessage,
                              builder: (BuildContext context, bool value,
                                  Widget? child) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  alignment: Alignment.center,
                                  child: Text(
                                    value == false
                                        ? ''
                                        : 'Um link para redefinir a senha foi enviado para o e-mail informado',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Button(
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_formKeyModalLogar.currentState!
                                    .validate()) {
                                  loadingResetPassword.value =
                                      !loadingResetPassword.value;
                                  loadingResetPassword.value =
                                      await userController.registerNewPassworld(
                                          txtEmailResetPassword.text);
                                  resetPasswordCheckMessage.value = true;
                                }
                              },
                              child: AnimatedBuilder(
                                animation: loadingResetPassword,
                                builder: (context, _) {
                                  return loadingResetPassword.value
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(),
                                        )
                                      : const Text(
                                          'Enviar',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.background),
                                        );
                                },
                              ),
                            ),
                            ButtonText(
                              text: 'Cancelar',
                              fontSize: 12,
                              alignment: Alignment.center,
                              onPressed: () {
                                resetPassword.value = false;
                                txtEmailResetPassword.text = '';
                                resetPasswordCheckMessage.value = false;
                              },
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Image(
                image: AssetImage('assets/images/backgroud_login.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Button(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register-user');
                  },
                  child: const Text(
                    'Abrir Conta',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.background,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  onPressed: () => _modalLogarRedefinirSenha(context),
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    side: const BorderSide(
                      color: AppColors.blue,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Já tenho conta',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
