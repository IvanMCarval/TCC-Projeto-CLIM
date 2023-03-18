import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_project_clim/controllers/ad_client_controller.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/components/custom_appBar.dart';
import 'package:flutter_application_project_clim/views/components/elevated_button.dart';
import 'package:flutter_application_project_clim/views/components/outlined_button.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AdClient extends StatefulWidget {
  const AdClient({Key? key}) : super(key: key);

  @override
  State<AdClient> createState() => _AdClientState();
}

class _AdClientState extends State<AdClient> {
  var adClientController;
  final ValueNotifier<String> messageNotifier = ValueNotifier('');
  bool _isLoading = false;

  late DateTime date;
  String dateString = '';
  var serviceFilter;

  @override
  void initState() {
    super.initState();
    adClientController = AdClientController(messageNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: CustomAppBar(
            back: false,
            title: 'Anúncios',
            listActions: [
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 35),
                child: IconButton(
                  icon: const Icon(FeatherIcons.filter),
                  color: AppColors.background,
                  onPressed: () => _modalFiltro(context),
                ),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Icon(
                            Icons.circle,
                            size: 16,
                            color: AppColors.green,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: "Anúncio aberto",
                        style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Poppins',
                            color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Icon(
                            Icons.circle,
                            size: 16,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: "Anúncio fechado",
                        style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Poppins',
                            color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: AppColors.lightGrey,
                height: 2,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TabBar(
                indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                indicatorWeight: 1.5,
                indicatorColor: AppColors.green,
                labelColor: AppColors.green,
                labelStyle: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Poppins',
                ),
                tabs: [
                  Text('Todos anúncios'),
                  Text('Meus anúncios'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  tab1(),
                  tab2(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tab1() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: StreamBuilder(
                stream: adClientController.getAllAd(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.green,
                        strokeWidth: 4,
                      ),
                    );
                  }

                  var res =
                      snapshot.requireData as Iterable<QueryDocumentSnapshot>;
                  var data = res.toList();
                  QuerySnapshot kindService =
                      adClientController.getKindService() as QuerySnapshot;
                  if (dateString.toString().isNotEmpty &&
                      dateString.toString() != 'null' &&
                      serviceFilter.toString().isNotEmpty &&
                      serviceFilter.toString() != 'null') {
                    var newData = data
                        .where((element) =>
                            element.get('data_realizacao').toDate() == date &&
                            element
                                    .get('tipo_servico')
                                    .contains(serviceFilter.toString()) ==
                                true)
                        .toList();

                    data.clear();
                    data.addAll(newData);
                  } else if (dateString.toString().isNotEmpty &&
                      dateString.toString() != 'null') {
                    var newData = data
                        .where((element) =>
                            element.get('data_realizacao').toDate() == date)
                        .toList();

                    data.clear();
                    data.addAll(newData);
                  } else if (serviceFilter.toString().isNotEmpty &&
                      serviceFilter.toString() != 'null') {
                    //Filtrando tipo de serviço
                    var newData = data
                        .where((element) =>
                            element
                                .get('tipo_servico')
                                .contains(serviceFilter.toString()) ==
                            true)
                        .toList();

                    data.clear();
                    data.addAll(newData);
                  }

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DateTime dateTime =
                          data[index]['data_realizacao'].toDate();

                      var kindServiceString = '';
                      kindService.docs.forEach((element) {
                        if (data[index]['tipo_servico'].contains(element.id)) {
                          if (kindServiceString == '') {
                            kindServiceString = element.get('categoria');
                          } else {
                            kindServiceString =
                                "$kindServiceString / ${element.get('categoria')} ";
                          }
                        }
                      });
                      return Container(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Card(
                          color: AppColors.lightGrey,
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, right: 5),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 16,
                                                    color: data[index]
                                                                ['status'] ==
                                                            'A'
                                                        ? AppColors.green
                                                        : AppColors.red,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: data[index]['titulo'],
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: 'Poppins',
                                                    color: AppColors.blue),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          "R\$ ${data[index]['valor']}",
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              color: AppColors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
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
                                                  FeatherIcons.briefcase,
                                                  size: 14.0,
                                                  color: AppColors.green,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: kindServiceString,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'Poppins',
                                                  color: AppColors.black),
                                            ),
                                          ],
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
                                            text:
                                                '${dateTime.day}/${dateTime.month}/${dateTime.year}',
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
                                if (data[index]['end_rua']
                                    .toString()
                                    .isNotEmpty)
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
                                              text:
                                                  "${data[index]['end_rua']}, ${data[index]['end_bairro']} - ${data[index]['end_cidade']} ${data[index]['end_estado']}",
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
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget tab2() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.green,
                          strokeWidth: 4,
                        ),
                      ),
                    )
                  : StreamBuilder(
                      stream: adClientController.getAdOnlyClient(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.green,
                              strokeWidth: 4,
                            ),
                          );
                        }

                        final res = snapshot.requireData
                            as Iterable<QueryDocumentSnapshot>;
                        var data = res.toList();
                        QuerySnapshot kindService = adClientController
                            .getKindService() as QuerySnapshot;

                        if (dateString.toString().isNotEmpty &&
                            dateString.toString() != 'null' &&
                            serviceFilter.toString().isNotEmpty &&
                            serviceFilter.toString() != 'null') {
                          var newData = data
                              .where((element) =>
                                  element.get('data_realizacao').toDate() ==
                                      date &&
                                  element
                                          .get('tipo_servico')
                                          .contains(serviceFilter.toString()) ==
                                      true)
                              .toList();

                          data.clear();
                          data.addAll(newData);
                        } else if (dateString.toString().isNotEmpty &&
                            dateString.toString() != 'null') {
                          var newData = data
                              .where((element) =>
                                  element.get('data_realizacao').toDate() ==
                                  date)
                              .toList();

                          data.clear();
                          data.addAll(newData);
                        } else if (serviceFilter.toString().isNotEmpty &&
                            serviceFilter.toString() != 'null') {
                          //Filtrando tipo de serviço
                          var newData = data
                              .where((element) =>
                                  element
                                      .get('tipo_servico')
                                      .contains(serviceFilter.toString()) ==
                                  true)
                              .toList();

                          data.clear();
                          data.addAll(newData);
                        }

                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          shrinkWrap:
                              true, // I thought this line was supposed to stop the overflow
                          itemBuilder: (context, index) {
                            DateTime dateTime =
                                data[index]['data_realizacao'].toDate();
                            var kindServiceString = '';
                            kindService.docs.forEach((element) {
                              if (data[index]['tipo_servico']
                                  .contains(element.id)) {
                                if (kindServiceString == '') {
                                  kindServiceString = element.get('categoria');
                                } else {
                                  kindServiceString =
                                      "$kindServiceString / ${element.get('categoria')} ";
                                }
                              }
                            });
                            return Container(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Card(
                                color: AppColors.lightGrey,
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
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
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5,
                                                                right: 5),
                                                        child: Icon(
                                                          Icons.circle,
                                                          size: 16,
                                                          color: data[index][
                                                                      'status'] ==
                                                                  'A'
                                                              ? AppColors.green
                                                              : AppColors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: data[index]
                                                          ['titulo'],
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontFamily: 'Poppins',
                                                          color:
                                                              AppColors.blue),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "R\$ ${data[index]['valor']}",
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontFamily: 'Poppins',
                                                        color: AppColors.blue),
                                                  ),
                                                  menu(data[index].id, context,
                                                      data[index]['titulo']),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  const WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
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
                                                    text: kindServiceString,
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontFamily: 'Poppins',
                                                        color: AppColors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                const WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .middle,
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
                                                  text:
                                                      '${dateTime.day}/${dateTime.month}/${dateTime.year}',
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
                                      if (data[index]['end_rua']
                                          .toString()
                                          .isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  const WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
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
                                                    text:
                                                        "${data[index]['end_rua']}, ${data[index]['end_bairro']} - ${data[index]['end_cidade']} ${data[index]['end_estado']}",
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
        Button(
          border: 0,
          onPressed: () {
            Navigator.pushNamed(context, '/ad_client/edit_new',
                arguments: {'id': '', 'type': 1});
          },
          child: const Text('+ Criar novo anúncio'),
        ),
      ],
    );
  }

  _modalFiltro(BuildContext context) {
    String? filter = serviceFilter;
    late DateTime dateFilter = date;
    var dateController = TextEditingController();
    dateController.text = dateString;
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
                    StreamBuilder<QuerySnapshot>(
                      stream: adClientController.getFilterKindServices(),
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
                              var data = snapshot.requireData;
                              return DropdownButton<String>(
                                isExpanded: true,
                                value: filter,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                ),
                                hint:
                                    const Text('Selecione um tipo de serviço'),
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
                                items: data.docs.map((DocumentSnapshot value) {
                                  var docId = value.id;
                                  return DropdownMenuItem(
                                    value: docId,
                                    child: Text(
                                      value.get('categoria'),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(89, 89, 89, 1),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data',
                      style: TextStyle(
                        color: AppColors.blue,
                      ),
                    ),
                    TextFormField(
                      key: const Key('form_birthDate'),
                      controller: dateController,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        MaskTextInputFormatter(mask: '##/##/####')
                      ],
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
                                      splashColor: const Color.fromRGBO(
                                          38, 183, 174, 1)),
                                  child: child!);
                            },
                            initialDate: DateTime.now(),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            firstDate: DateTime(1930),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)));
                        if (_dateTime != null) {
                          setState(() {
                            dateFilter = _dateTime;
                            dateController.text =
                                '${_dateTime.day}/${_dateTime.month}/${_dateTime.year}';
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(bottom: 10, right: 10.0),
                        suffixIcon: Icon(
                          FeatherIcons.calendar,
                          color: AppColors.blue,
                          size: 20,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.blue,
                              style: BorderStyle.solid,
                              width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.blue,
                              style: BorderStyle.solid,
                              width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.blue,
                              style: BorderStyle.solid,
                              width: 2),
                        ),
                        hintText: '00/00/0000',
                      ),
                    ),
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
                              if (dateController.text.toString().isNotEmpty) {
                                dateString = '';
                                dateController.text = '';
                              }
                              if (filter.toString().isNotEmpty &&
                                  filter.toString() != 'null') {
                                filter = null;
                                serviceFilter = null;
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
                            if (dateController.text.toString().isNotEmpty ||
                                (filter.toString().isNotEmpty &&
                                    filter.toString() != 'null')) {
                              setState(() {
                                if (dateController.text.toString().isNotEmpty) {
                                  date = dateFilter;
                                  dateString = dateController.text.toString();
                                }
                                if (filter.toString().isNotEmpty &&
                                    filter.toString() != 'null') {
                                  serviceFilter = filter.toString();
                                }
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Filtrar',
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

  menu(id, context, titulo) {
    return PopupMenuButton<int>(
      icon: Icon(
        FeatherIcons.moreVertical,
        color: AppColors.shadowBlack,
      ),
      onSelected: (int value) {
        if (value == 2) {
          Navigator.pushNamed(context, '/ad_client/edit_new',
              arguments: {'id': id, 'type': 2});
        } else if (value == 3) {
          _dialog(context, titulo, id);
        } else {
          Navigator.pushNamed(context, '/ad_client/details', arguments: id);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 1,
          child: Text('Detalhes'),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Text('Editar'),
        ),
        const PopupMenuItem<int>(
          value: 3,
          child: Text('Excluir'),
        ),
      ],
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
                      _isLoading = true;
                    });
                    await adClientController.deleteAd(id);
                    setState(() => _isLoading = false);
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
        .closed;
  }
}
