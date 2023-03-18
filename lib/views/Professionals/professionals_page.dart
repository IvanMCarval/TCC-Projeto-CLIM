import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/controllers/professionals_controller.dart';
import 'package:flutter_application_project_clim/models/professional_model.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/Professionals/professionals_profile.dart';
import 'package:flutter_application_project_clim/views/components/custom_appBar.dart';
import 'package:flutter_application_project_clim/views/components/elevated_button.dart';
import 'package:flutter_application_project_clim/views/components/outlined_button.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class ProfessionalsPage extends StatefulWidget {
  const ProfessionalsPage({Key? key}) : super(key: key);

  @override
  State<ProfessionalsPage> createState() => _ProfessionalsPageState();
}

class _ProfessionalsPageState extends State<ProfessionalsPage> {
  var professionalsController =
      ProfessionalsController(ValueNotifier([]), ValueNotifier(''));
  var professionals;
  var serviceFilter;
  int orderList = 0;

  @override
  void initState() {
    super.initState();
  }

  _modalFiltro(BuildContext context) {
    String? filter = serviceFilter;
    int order = orderList;

    showModalBottomSheet(
      enableDrag: true,
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
            top: 30,
            right: 30,
            left: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipo de serviço',
                      style: TextStyle(
                        color: AppColors.blue,
                      ),
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return FutureBuilder(
                          future:
                              professionalsController.getFilterKindServices(),
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
                                  QuerySnapshot data =
                                      snapshot.requireData as QuerySnapshot;
                                  return DropdownButton<String>(
                                    isExpanded: true,
                                    value: filter,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                    ),
                                    hint: const Text(
                                        'Selecione um tipo de serviço'),
                                    key: const Key('form_filter_service'),
                                    onChanged: (String? value) {
                                      setState(() {
                                        filter = value.toString();
                                      });
                                    },
                                    underline: Container(
                                      height: 2,
                                      color: AppColors.blue,
                                    ),
                                    icon: const Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Icon(
                                        FeatherIcons.chevronDown,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                    items:
                                        data.docs.map((DocumentSnapshot value) {
                                      var docId = value.id;
                                      return DropdownMenuItem(
                                        value: docId,
                                        child: Text(
                                          value.get('categoria'),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromRGBO(89, 89, 89, 1),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: const Text(
                        'Ordenação',
                        style: TextStyle(
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() => order = order == 1 ? 0 : 1);
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(242, 243, 247, 1),
                                  padding: const EdgeInsets.all(10),
                                  fixedSize: Size.fromHeight(50),
                                  side: order == 1
                                      ? BorderSide(color: AppColors.blue)
                                      : BorderSide.none),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: Row(
                                      children: const [
                                        Text(
                                          'A',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Color.fromRGBO(38, 79, 183, 1),
                                          ),
                                        ),
                                        Icon(
                                          FeatherIcons.arrowUp,
                                          color: Color.fromRGBO(38, 79, 183, 1),
                                          size: 20,
                                        ),
                                        Icon(
                                          FeatherIcons.arrowDown,
                                          color:
                                              Color.fromRGBO(38, 183, 174, 1),
                                          size: 20,
                                        ),
                                        Text(
                                          'Z',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Color.fromRGBO(38, 183, 174, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    'Ordem\nalfabética',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(152, 153, 173, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() => order = order == 2 ? 0 : 2);
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(242, 243, 247, 1),
                                  padding: const EdgeInsets.all(10),
                                  fixedSize: Size.fromHeight(50),
                                  side: order == 2
                                      ? BorderSide(color: AppColors.blue)
                                      : BorderSide.none),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(
                                    FeatherIcons.thumbsUp,
                                    color: Color.fromRGBO(38, 183, 174, 1),
                                  ),
                                  Text(
                                    'Curtidas',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(152, 153, 173, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Outlined(
                          text: 'Limpar',
                          onPressed: () {
                            setState(() {
                              if (filter.toString().isNotEmpty &&
                                  filter.toString() != 'null') {
                                filter = null;
                                serviceFilter = null;
                              }
                              if (order != 0) {
                                orderList = 0;
                                order = 0;
                              }
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Button(
                          onPressed: () {
                            if ((filter.toString().isNotEmpty &&
                                    filter.toString() != 'null') ||
                                order != 0) {
                              setState(() {
                                if (filter.toString().isNotEmpty &&
                                    filter.toString() != 'null') {
                                  serviceFilter = filter.toString();
                                }

                                if (order != 0) {
                                  orderList = order;
                                }
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Filtrar / Ordenar',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.background),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget displayProfessionals(ProfessionalModel index) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400, width: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: GradientBoxBorder(
                gradient: AppColors.gradientAppBar,
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                index.foto,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            index.nome,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromRGBO(38, 183, 174, 1),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Text(
                                index.likes.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(38, 183, 174, 1),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.thumb_up,
                              size: 15,
                              color: Color.fromRGBO(38, 183, 174, 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "• ${index.serviceType.toString().substring(1, index.serviceType.toString().length - 1)}",
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/professionals-profile',
                          arguments: index,
                        ),
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: CustomAppBar(
          back: false,
          title: 'Profissionais',
          listActions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 35),
              child: IconButton(
                icon: const Icon(FeatherIcons.filter),
                color: AppColors.background,
                onPressed: () => _modalFiltro(context),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: professionalsController.getProfessionals(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.requireData as List;
              QuerySnapshot usersQuery = data[0];
              QuerySnapshot likesQuery = data[1];
              QuerySnapshot profile = data[2];
              QuerySnapshot kindService = data[3];

              List<Map> users = [];
              usersQuery.docs.forEach((element) {
                var likes = likesQuery.docs
                    .where((t) =>
                        t['UID_receptor'] == element.id && t['curtida'] == 1)
                    .length;
                users.add({'user': element, 'curtida': likes});
              });

              if (serviceFilter.toString().isNotEmpty &&
                  serviceFilter.toString() != 'null') {
                //Filtrando tipo de serviço
                var newUsers = users
                    .where((element) =>
                        element['user']['tipo_sevico']
                            .contains(serviceFilter.toString()) ==
                        true)
                    .toList();
                users.clear();
                users.addAll(newUsers);
              }

              if (orderList == 1) {
                users.sort((a, b) {
                  return a['user']['nome']
                      .toLowerCase()
                      .compareTo(b['user']['nome'].toLowerCase());
                });
              } else if (orderList == 2) {
                users.sort((a, b) {
                  return b['curtida'].compareTo(a['curtida']);
                });
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var especificServices = [];
                  kindService.docs
                      .where((element) =>
                          users[index]['user']['tipo_sevico']
                              .toList()
                              .contains(element.id) ==
                          true)
                      .forEach((element) {
                    especificServices.add(element.get('categoria'));
                  });
                  var especificProfile = profile.docs
                      .where((element) =>
                          element.get('usuario') == users[index]['user'].id)
                      .first;

                  var especific = ProfessionalModel(
                      users[index]['user'].id,
                      users[index]['user']['nome'],
                      especificProfile['descricao'],
                      especificProfile['foto'],
                      users[index]['curtida'],
                      especificServices,
                      users[index]['user']['tefone']);
                  return displayProfessionals(especific);
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
