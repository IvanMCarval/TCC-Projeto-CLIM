import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/controllers/profile_controller.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/components/custom_appBar.dart';
import 'package:flutter_application_project_clim/views/components/outlined_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:social_share/social_share.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<List> listMenu = [
    ["Serviços", FeatherIcons.user, '/profile/service'],
    ["Dados Pessoais", FeatherIcons.briefcase, '/profile/personalData'],
    ["Endereço", FeatherIcons.mapPin, '/profile/location'],
    ["Conta", FeatherIcons.key, '/profile/account'],
    ["Sair", FeatherIcons.logOut, 'exit']
  ];
  File? imageAvatar;
  String? imageString;
  String? imageOriginal;
  var name = '';
  var description = TextEditingController();
  var services = '';
  var idProfile = "";
  var typeUser = 0;
  int complet = 0;
  bool _isLoading = true;

  XFile? pickedFile;

  var profileController;
  final ValueNotifier<String> messageNotifier = ValueNotifier('');
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    profileController = ProfileController(messageNotifier);
  }

  Future getUser() async {
    var info = await profileController.getUser();

    setState(() {
      name = info['nome'].toString();
      description.text = info['descricao'].toString();
      imageString = info['foto'];
      imageAvatar = File(info['foto']);
      imageOriginal = info['foto'];
      if (info['tipo_usuario'] == 1) {
        services = 'Faço ';
      } else {
        services = 'Procuro ';
      }
      services = services + info['services'];
      complet = 1;
      _isLoading = false;
      typeUser = info['tipo_usuario'] == 1 ? 1 : 2;
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: CustomAppBar(
            back: false,
            title: name,
            listActions: name.isNotEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 35),
                      child: IconButton(
                        icon: const Icon(FeatherIcons.share2),
                        color: AppColors.background,
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          SocialShare.shareOptions(
                              'Venha ver meu perfil no novo APP Clim!! Obrigada $name!');
                        },
                      ),
                    )
                  ]
                : [],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: AppColors.green,
                strokeWidth: 3,
              ))
            : SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 26.23),
                        child: InkWell(
                          onTap: () async {
                            _dialog(context);
                          },
                          child: Stack(
                            children: [
                              CircleAvatar(
                                  radius: 52,
                                  backgroundImage: imageString == null
                                      ? const AssetImage(
                                          'assets/images/iconUser_bg.png')
                                      : imageOriginal == null
                                          ? Image.file(imageAvatar!).image
                                          : Image.network(imageString!).image),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Olá, sou ${name}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: AppColors.blue,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 19, left: 15, right: 15),
                        child: Text(
                          services,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: AppColors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          height: 80,
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
                              suffixIcon: IconButton(
                                alignment: Alignment.bottomRight,
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  size: 20.0,
                                  color: AppColors.green,
                                ),
                                onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() => _isLoading = true);
                                  var parameters = {
                                    'image': imageOriginal == ''
                                        ? ''
                                        : imageOriginal,
                                    'description': description.text == ''
                                        ? ''
                                        : description.text
                                  };

                                  profileController.setParametersProfile(
                                      parameters, 1);
                                  await profileController.updateProfile(2);
                                  setState(() => _isLoading = false);
                                  if (messageNotifier.value == 'Sucess') {
                                    message('', 3);
                                  } else {
                                    message(messageNotifier.value, 3);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 34, left: 34),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listMenu.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              horizontalTitleGap: 0,
                              contentPadding: const EdgeInsets.all(0),
                              title: Text(listMenu[index][0],
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: listMenu[index][0] == "Sair"
                                          ? AppColors.red
                                          : AppColors.blue,
                                      fontWeight: FontWeight.w400)),
                              leading: Icon(
                                listMenu[index][1],
                                color: listMenu[index][0] == "Sair"
                                    ? AppColors.red
                                    : AppColors.blue,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: listMenu[index][0] == "Sair"
                                    ? AppColors.red
                                    : AppColors.blue,
                              ),
                              onTap: () async {
                                if (listMenu[index][0] == "Sair") {
                                  await profileController.logout();
                                  if (messageNotifier.value == 'Sucess') {
                                    message('', 1);
                                  } else {
                                    message(messageNotifier.value, 1);
                                  }
                                } else {
                                  Navigator.pushNamed(
                                      context, listMenu[index][2]);
                                }
                              },
                            );
                            // return listItem(listMenu[index]);
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  message(erro, type) {
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
                  erro == ''
                      ? (type == 1
                          ? 'Logout com sucesso.'
                          : type == 2
                              ? 'Alterado foto com sucesso.'
                              : 'Alterado descricao com sucesso.')
                      : erro,
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
      if (erro == '' && type == 1) {
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
                  FocusManager.instance.primaryFocus?.unfocus();
                  XFile? pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                  if (pickedFile != null) {
                    setState(() {
                      imageOriginal = null;
                      imageString = pickedFile.path;
                      imageAvatar = File(pickedFile.path);
                      _isLoading = true;
                    });
                    var parameters = {
                      'image': imageAvatar!,
                      'description':
                          description.text == '' ? '' : description.text
                    };
                    profileController.setParametersProfile(parameters, 2);
                    await profileController.updateProfile(1);
                    setState(() => _isLoading = false);
                    if (messageNotifier.value == 'Sucess') {
                      message('', 2);
                    } else {
                      message(messageNotifier.value, 2);
                    }
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
                  FocusManager.instance.primaryFocus?.unfocus();
                  XFile? pickedFile =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  Navigator.pop(context);
                  if (pickedFile != null) {
                    setState(() {
                      imageOriginal = null;
                      imageString = pickedFile.path;
                      imageAvatar = File(pickedFile.path);
                      _isLoading = true;
                    });
                    var parameters = {
                      'image': imageAvatar!,
                      'description':
                          description.text == '' ? '' : description.text
                    };
                    profileController.setParametersProfile(parameters, 2);
                    await profileController.updateProfile(1);
                    setState(() => _isLoading = false);
                    if (messageNotifier.value == 'Sucess') {
                      message('', 2);
                    } else {
                      message(messageNotifier.value, 2);
                    }
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
