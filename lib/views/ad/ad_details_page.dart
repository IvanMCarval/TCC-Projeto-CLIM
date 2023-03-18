import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/controllers/ad_client_controller.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/Professionals/professionals_profile.dart';
import 'package:flutter_application_project_clim/views/components/custom_appBar.dart';
import 'package:flutter_application_project_clim/views/components/elevated_button.dart';
import 'package:flutter_application_project_clim/views/components/outlined_button.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AdDetails extends StatefulWidget {
  const AdDetails({Key? key}) : super(key: key);

  @override
  State<AdDetails> createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {
  bool _isLoading = false;
  bool _isLoadingInicial = true;

  var adClientController;
  final ValueNotifier<String> messageNotifier = ValueNotifier('');

  var title = '';
  var adress;
  var servicesAd;
  var information;
  var serviceDate;
  var servicesValue;
  var status;
  int complet = 0;

  @override
  void initState() {
    super.initState();
    adClientController = AdClientController(messageNotifier);
  }

  Future getDetails(id) async {
    var info = await adClientController.getDetailsClient(id);
    setState(() {
      title = info['titulo'].toString();
      if (info['end_rua'].toString().isNotEmpty) {
        adress =
            "${info['end_rua']}, ${info['end_bairro']} - ${info['end_cidade']} ${info['end_estado']}";
      } else {
        adress = '';
      }
      servicesAd = info['services'];
      servicesValue = info['valor'];
      status = info['status'];
      information = info;
      complet = 1;
      DateTime dateTime = info['data_realizacao'].toDate();
      serviceDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      _isLoadingInicial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (complet == 0) {
      getDetails(args);
    }
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: CustomAppBar(
            back: true,
            title: title,
            listActions: [
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 35),
                child: IconButton(
                  icon: const Icon(FeatherIcons.trash),
                  color: AppColors.background,
                  onPressed: () => _dialog(context, title, args),
                ),
              )
            ],
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
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.fromLTRB(24, 5, 24, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .middle,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 16,
                                                      color: status == 'A'
                                                          ? AppColors.green
                                                          : AppColors.red,
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: title,
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: 'Poppins',
                                                      color: AppColors.blue),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "R\$ $servicesValue",
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              color: AppColors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Icon(
                                              FeatherIcons.briefcase,
                                              size: 14.0,
                                              color: AppColors.green,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: servicesAd,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'Poppins',
                                              color: AppColors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (adress.toString().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Icon(
                                                    FeatherIcons.mapPin,
                                                    size: 14.0,
                                                    color: AppColors.green,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: adress.toString(),
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: 'Poppins',
                                                    color: AppColors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Icon(
                                              FeatherIcons.calendar,
                                              size: 14.0,
                                              color: AppColors.green,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: serviceDate,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'Poppins',
                                              color: AppColors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                color: AppColors.lightGrey,
                                height: 2,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                'Candidatos',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Poppins',
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 5),
                              child: StreamBuilder(
                                  stream: adClientController
                                      .getListCandidates(args),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.green,
                                          strokeWidth: 4,
                                        ),
                                      );
                                    }
                                    List data = snapshot.requireData as List;
                                    QuerySnapshot likes = data[0];
                                    QuerySnapshot user = data[1];

                                    // listview height needs to be set
                                    return ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Divider(
                                          height: 3.0,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap:
                                          true, // I thought this line was supposed to stop the overflow
                                      itemCount: user.size,
                                      itemBuilder: (context, index) {
                                        var likesCount = likes.docs
                                            .where((element) =>
                                                element
                                                    .get('UID_receptor')
                                                    .contains(
                                                        user.docs[index].id) ==
                                                true)
                                            .length;

                                        return ListTile(
                                          title: Text(
                                              "${user.docs[index].get('nome')}"),
                                          trailing: RichText(
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5),
                                                    child: Text(
                                                      likesCount.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 18.0,
                                                          fontFamily: 'Poppins',
                                                          color:
                                                              AppColors.green),
                                                    ),
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5, bottom: 10),
                                                    child: Icon(
                                                      FeatherIcons.thumbsUp,
                                                      size: 18,
                                                      color: AppColors.green,
                                                    ),
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 7),
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        var info =
                                                            await adClientController
                                                                .sendInformationProvider(
                                                                    user
                                                                        .docs[
                                                                            index]
                                                                        .id);
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/professionals-profile',
                                                            arguments: info);
                                                      },
                                                      icon: const Icon(
                                                        FeatherIcons
                                                            .chevronRight,
                                                        size: 18,
                                                        color: AppColors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          // Row(
                                          //   children: [

                                          //     const Padding(
                                          //       padding:
                                          //           EdgeInsets.only(left: 5),
                                          //       child: Icon(
                                          //         FeatherIcons.arrowRight,
                                          //         size: 16,
                                          //         color: AppColors.green,
                                          //       ),
                                          //     )
                                          //   ],
                                          // ),
                                        );
                                      },
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Button(
                    border: 0,
                    onPressed: () {
                      Navigator.pushNamed(context, '/ad_client/edit_new',
                          arguments: {'id': args, 'type': 2});
                    },
                    child: const Text('Editar anúncio'),
                  ),
                ],
              ),
      ),
    );
  }

  _dialog(BuildContext context, titulo, id) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(
          child: Text(
            'Excluir anúncio',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            const TextSpan(
                text: 'Tem certeza que deseja ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                )),
            const TextSpan(
                text: 'excluir',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            TextSpan(
                text: ' o anúncio $titulo?',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                )),
          ]),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: EdgeInsets.zero,
        buttonPadding: EdgeInsets.zero,
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Outlined(
                  border: 0,
                  text: 'Cancelar',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: Button(
                  border: 0,
                  onPressed: () async {
                    Navigator.pop(context, 'OK');
                    setState(() {
                      _isLoadingInicial = true;
                    });
                    await adClientController.deleteAd(id);
                    setState(() => _isLoadingInicial = false);
                    if (messageNotifier.value == 'Sucess') {
                      message('');
                    } else {
                      message(messageNotifier.value);
                    }
                  },
                  child: const Text('Excluir'),
                ),
              ),
            ],
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
                  erro == '' ? 'Anúncio excluido com sucesso' : erro,
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
