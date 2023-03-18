import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/controllers/professionals_controller.dart';
import 'package:flutter_application_project_clim/models/professional_model.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/components/custom_appBar.dart';
import 'package:flutter_application_project_clim/views/components/elevated_button.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionalsProfile extends StatefulWidget {
  static const routeNamed = '/professionals-profile';

  const ProfessionalsProfile({super.key});

  @override
  State<ProfessionalsProfile> createState() => _ProfessionalsProfileState();
}

class _ProfessionalsProfileState extends State<ProfessionalsProfile> {
  var professionalsController;
  final ValueNotifier<List> listCommentsLikesValue = ValueNotifier([]);
  final ValueNotifier<String> messageNotifier = ValueNotifier('');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    professionalsController =
        ProfessionalsController(listCommentsLikesValue, messageNotifier);
  }

  final comment = TextEditingController();

  _modalComments(id) {
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
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 7),
                child: const Text(
                  'Comentário',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(38, 79, 183, 1),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  controller: comment,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Button(
                onPressed: () {
                  List dataCommentList;
                  String idDoc = '';
                  List commentsList = [];
                  if (listCommentsLikesValue.value.isNotEmpty) {
                    dataCommentList = listCommentsLikesValue.value
                        .where((element) =>
                            element['UID_receptor'] == id &&
                            element['UID_comentarista'] ==
                                FirebaseAuth.instance.currentUser!.uid)
                        .toList();

                    if (dataCommentList.isNotEmpty) {
                      QueryDocumentSnapshot dataComment = dataCommentList.first;
                      commentsList = dataComment.get('comentario');
                      idDoc = dataComment.id;
                    }
                  }

                  professionalsController.addComment(
                      id, comment.text, commentsList, idDoc);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Comentar',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.background,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget listComments(comment, profile) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              decoration: BoxDecoration(
                border: GradientBoxBorder(
                  gradient: AppColors.gradientAppBar,
                ),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(profile),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              //height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color.fromRGBO(74, 74, 74, 0.3))),
              child: Text(
                comment,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(89, 89, 89, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _openWhatapp(number, nome) async {
    String text =
        "Olá $nome. Vi seu perfil no APP Clim e achei interessante. Gostaria de conversar sobre uma oportunidade de trabalho. Estaria interessado(a)?";
    var url = "https://wa.me/55$number?text=${Uri.encodeComponent(text)}";

    try {
      // ignore: deprecated_member_use
      launch(url);
    } catch (e) {
      //To handle error and display error message
      print('Erro');
    }
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as ProfessionalModel;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: CustomAppBar(
          title: args.nome,
          back: true,
          listActions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 35),
              child: IconButton(
                icon: const Icon(FeatherIcons.share2),
                color: AppColors.background,
                onPressed: () {
                  SocialShare.shareOptions(
                      'Venha ver meu perfil no novo APP Clim!! Obrigada ${args.nome}!');
                },
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColors.green,
              strokeWidth: 3,
            ))
          : Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundImage: NetworkImage(args.foto),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                        child: Column(
                          children: [
                            Text(
                              "Olá, sou ${args.nome}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blue,
                              ),
                            ),
                            Text(
                              'Faço serviços de ${args.serviceType.toString().substring(1, args.serviceType.toString().length - 1)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(74, 74, 74, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                        child: Text(
                          args.descricao,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          String number = args.phoneNumber
                              .toString()
                              .replaceAll('-', '')
                              .replaceAll(')', '')
                              .replaceAll('(', '')
                              .replaceAll(' ', '');
                          _openWhatapp(number, args.nome);
                        },
                        icon: const Icon(
                          Icons.whatsapp,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          'Conversar',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(38, 183, 174, 1),
                          fixedSize: const Size(150, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 25, 30, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ValueListenableBuilder<List>(
                                    valueListenable: listCommentsLikesValue,
                                    builder: (BuildContext context, List value,
                                        Widget? child) {
                                      int likeValue = 0;
                                      String idDoc = '';
                                      List dataCommentLike;
                                      if (value.isNotEmpty) {
                                        dataCommentLike = value
                                            .where((element) =>
                                                element['UID_receptor'] ==
                                                    args.id &&
                                                element['UID_comentarista'] ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid)
                                            .toList();

                                        if (dataCommentLike.isNotEmpty) {
                                          QueryDocumentSnapshot dataLike =
                                              dataCommentLike.first;
                                          likeValue =
                                              dataLike.get('curtida') == 1
                                                  ? 1
                                                  : 0;
                                          idDoc = dataLike.id;
                                        }
                                      }
                                      return IconButton(
                                        icon: Icon(
                                          likeValue == 0
                                              ? FeatherIcons.thumbsUp
                                              : Icons.thumb_up_rounded,
                                          size: 17,
                                          color:
                                              Color.fromRGBO(38, 183, 174, 1),
                                        ),
                                        onPressed: () async {
                                          professionalsController.addLike(
                                              args.id, likeValue, idDoc);
                                        },
                                      );
                                    }),
                                IconButton(
                                  icon: const Icon(
                                    FeatherIcons.messageSquare,
                                    size: 17,
                                    color: Color.fromRGBO(38, 183, 174, 1),
                                  ),
                                  onPressed: () {
                                    _modalComments(args.id);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 2),
                                        child: ValueListenableBuilder<List>(
                                            valueListenable:
                                                listCommentsLikesValue,
                                            builder: (BuildContext context,
                                                List value, Widget? child) {
                                              int like = 0;
                                              if (value.isNotEmpty) {
                                                like = value
                                                    .where((element) =>
                                                        element['curtida'] == 1)
                                                    .length;
                                              }
                                              return Text(
                                                like.toString(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      38,
                                                      183,
                                                      174,
                                                      1), //rgba(38, 183, 174, 1)
                                                ),
                                              );
                                            }),
                                      ),
                                      const Text(
                                        ' Curtidas',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromRGBO(38, 183, 174, 1),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 2),
                                        child: ValueListenableBuilder<List>(
                                            valueListenable:
                                                listCommentsLikesValue,
                                            builder: (BuildContext context,
                                                List value, Widget? child) {
                                              int comments = 0;
                                              if (value.isNotEmpty) {
                                                value.forEach((element) {
                                                  List listComment =
                                                      element['comentario'];
                                                  comments = comments +
                                                      listComment.length;
                                                });
                                              }
                                              return Text(
                                                comments.toString(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      38, 183, 174, 1),
                                                ),
                                              );
                                            }),
                                      ),
                                      RichText(
                                        text: const TextSpan(
                                          text: ' Comentários',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color:
                                                Color.fromRGBO(38, 183, 174, 1),
                                          ),
                                        ),
                                      ),
                                      // const Text(
                                      //   ' Comentários',
                                      //   style: TextStyle(
                                      //     fontSize: 12,
                                      //     color:
                                      //         Color.fromRGBO(38, 183, 174, 1),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: StreamBuilder(
                          stream: professionalsController
                              .getDetailsProfessional(args.id),
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
                                {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: Text('Não há comentários.'),
                                    );
                                  }
                                  List data = snapshot.requireData as List;
                                  QuerySnapshot coments = data[0];
                                  QuerySnapshot profile = data[1];

                                  if (coments.docs.isEmpty) {
                                    return const Center(
                                      child: Text('Não há comentários.'),
                                    );
                                  }

                                  var commentsList = [];
                                  var likeUpdate = 0;
                                  var commentUpdate = 0;
                                  coments.docs.forEach((e) {
                                    if (e.get('comentario').isNotEmpty) {
                                      var profileEspecific = profile.docs
                                          .where((element) =>
                                              element.get('usuario') ==
                                              e.get('UID_receptor'))
                                          .first;
                                      for (var element in e.get('comentario')) {
                                        commentsList.add({
                                          'photo': profileEspecific.get('foto'),
                                          'comment': element
                                        });
                                        commentUpdate = commentUpdate + 1;
                                      }
                                    }
                                    if (e.get('curtida') == 1) {
                                      likeUpdate = likeUpdate + 1;
                                    }
                                  });
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: commentsList.length,
                                    itemBuilder: (constext, index) {
                                      return listComments(
                                          commentsList[index]['comment'],
                                          commentsList[index]['photo']);
                                    },
                                  );
                                }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
