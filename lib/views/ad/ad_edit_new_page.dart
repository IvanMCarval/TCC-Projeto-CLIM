import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_project_clim/controllers/ad_client_controller.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/components/custom_appBar.dart';
import 'package:flutter_application_project_clim/views/components/elevated_button.dart';
import 'package:flutter_application_project_clim/views/components/text_input_field.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:multiselect/multiselect.dart';

class AdEditNew extends StatefulWidget {
  const AdEditNew({Key? key}) : super(key: key);

  @override
  State<AdEditNew> createState() => _AdEditNewState();
}

class _AdEditNewState extends State<AdEditNew> {
  bool _isLoading = false;
  bool _sucess = false;
  bool _isLoadingInicial = false;
  bool _fillAdress = false;
  var completServices = 0;
  var selectedServices = [];
  var selectedServicesOriginal = [];

  var title = TextEditingController();
  var street = TextEditingController();
  var neighborhood = TextEditingController();
  var city = TextEditingController();
  var state = TextEditingController();
  var serviceDateController = TextEditingController();
  late DateTime serviceDate;
  var serviceValue = TextEditingController();

  List<String> servicesSelected = [];
  List<String> services = [];
  List servicesOriginal = [];
  List servicesAd = [];

  var formValidator = ValueNotifier<bool>(false);
  var formKey = GlobalKey<FormState>();
  var information;
  int complet = 0;

  var adClientController;
  final ValueNotifier<String> messageNotifier = ValueNotifier('');

  List<String> listStatus = ['Ativo', 'Inativo'];
  String valueStatus = 'Ativo';

  @override
  void initState() {
    super.initState();
    adClientController = AdClientController(messageNotifier);
  }

  Future getAd(id) async {
    await adClientController.getOnlyAdOnlyClient(id).then((value) {
      title.text = value['titulo'].toString();
      street.text = value['end_rua'];
      neighborhood.text = value['end_bairro'].toString();
      city.text = value['end_cidade'].toString();
      state.text = value['end_estado'];
      serviceValue.text = value['valor'].toString();
      servicesAd = value['tipo_servico'];
      information = value;
      complet = 1;
      DateTime dateTime = value['data_realizacao'].toDate();
      serviceDateController.text =
          '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    });
    setState(() {
      if (street.text.isNotEmpty) {
        _fillAdress = true;
      }
      if (information['status'] != 'A') {
        valueStatus = 'Inativo';
      }
      complet = 1;
      _isLoadingInicial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    if (complet == 0 && args['type'] == 2) {
      setState(() {
        _isLoadingInicial = true;
      });
      getAd(args['id']);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: CustomAppBar(
            back: true,
            title: args['type'] == 1 ? 'Novo anúncio' : 'Editar anúncio',
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
                          if (args['type'] == 2) {
                            _validForm();
                          } else {
                            _validFormCreate();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                          child: Column(
                            children: [
                              TextInputFeild(
                                textLabel: 'Titulo*',
                                hintText: 'Digite o título de forma resumida',
                                type: TextInputType.text,
                                obscureText: false,
                                controller: title,
                                validator: (value) => null,
                              ),
                              if (args['type'] == 2)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          "Status*",
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
                                            child: DropdownButton(
                                              key: const Key('form_status'),
                                              hint: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.0)),
                                              isExpanded: true,
                                              value: valueStatus,
                                              style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: 14,
                                              ),
                                              items: listStatus.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  valueStatus = value!;
                                                });
                                                _validForm();
                                              },
                                              icon: Icon(
                                                FeatherIcons.chevronDown,
                                                color: AppColors.fields,
                                              ),
                                              underline: const SizedBox(),
                                            ),
                                          )),
                                    ],
                                  ),
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
                                        "Serviços*",
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
                                              stream: adClientController
                                                  .getListTypeService(),
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
                                                    if (completServices == 0) {
                                                      snapshot.data?.docs
                                                          .forEach((element) {
                                                        services.add(element
                                                            .get('categoria'));
                                                        servicesOriginal.add([
                                                          element.id,
                                                          element
                                                              .get('categoria'),
                                                        ]);
                                                        if (servicesAd.contains(
                                                            element.id)) {
                                                          servicesSelected.add(
                                                              element.get(
                                                                  'categoria'));
                                                        }
                                                      });
                                                      completServices = 1;
                                                    }

                                                    // return Container();
                                                    return DropDownMultiSelect(
                                                      icon: Icon(
                                                        FeatherIcons
                                                            .chevronDown,
                                                        color: AppColors.fields,
                                                      ),
                                                      decoration:
                                                          InputDecoration
                                                              .collapsed(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: '',
                                                        hintStyle: TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      onChanged: (x) {
                                                        setState(() {
                                                          servicesSelected = x;
                                                        });
                                                        setState(() {
                                                          if (args['type'] ==
                                                              2) {
                                                            _validForm();
                                                          } else {
                                                            _validFormCreate();
                                                          }
                                                        });
                                                      },
                                                      options: services,
                                                      selectedValues:
                                                          servicesSelected,
                                                      hint: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    15.0),
                                                        key: Key(
                                                            'form_services'),
                                                      ),
                                                    );
                                                }
                                              }),
                                        )),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: date(context, args['type']),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextInputFeild(
                                      textLabel: 'Valor (R\$)',
                                      hintText: 'R\$ 0,00',
                                      type:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      obscureText: false,
                                      controller: serviceValue,
                                      validator: (value) => null,
                                      format: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _fillAdress,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    activeColor: AppColors.blue,
                                    side: const BorderSide(
                                        color: AppColors.blue, width: 1.2),
                                    onChanged: (_) {
                                      setState(() {
                                        _fillAdress = !_fillAdress;
                                        street.text = '';
                                        neighborhood.text = '';
                                        city.text = '';
                                        state.text = '';
                                        if (args['type'] == 2) {
                                          _validForm();
                                        } else {
                                          _validFormCreate();
                                        }
                                      });
                                    },
                                  ),
                                  const Flexible(
                                    child: Text(
                                      'Preencher local de realização do serviço',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: _fillAdress,
                                child: Column(
                                  children: [
                                    TextInputFeild(
                                      textLabel: 'Rua*',
                                      hintText: 'Rua exemplo',
                                      type: TextInputType.text,
                                      obscureText: false,
                                      controller: street,
                                      validator: (value) => null,
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
                                            padding:
                                                const EdgeInsets.only(right: 8),
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
                                  ],
                                ),
                              )
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
                                            var kindService = [];
                                            servicesOriginal.forEach((element) {
                                              if (servicesSelected
                                                  .contains(element[1])) {
                                                kindService.add(element[0]);
                                              }
                                            });

                                            DateTime dateTime2 = DateTime.parse(
                                                serviceDateController.text
                                                    .split('/')
                                                    .reversed
                                                    .join());

                                            var parameters = {
                                              'id': args['id'],
                                              'dataCreation': args['id'] == ''
                                                  ? Timestamp.now()
                                                  : information['data_criacao'],
                                              'value': serviceValue.text == ''
                                                  ? ''
                                                  : double.parse(
                                                      serviceValue.text),
                                              'status': args['id'] == ''
                                                  ? 'A'
                                                  : (valueStatus == 'Ativo'
                                                      ? 'A'
                                                      : 'I'),
                                              'title': title.text,
                                              'street': street.text == ''
                                                  ? ''
                                                  : street.text,
                                              'neighborhood':
                                                  neighborhood.text == ''
                                                      ? ''
                                                      : neighborhood.text,
                                              'kindServise': kindService,
                                              'dataAd':
                                                  Timestamp.fromDate(dateTime2),
                                              'state': state.text == ''
                                                  ? ''
                                                  : state.text,
                                              'city': city.text == ''
                                                  ? ''
                                                  : city.text,
                                            };
                                            setState(() => _isLoading = true);

                                            adClientController
                                                .setParameters(parameters);
                                            if (args['type'] == 1) {
                                              await adClientController
                                                  .createAd();
                                            } else {
                                              await adClientController
                                                  .updateAd();
                                            }

                                            setState(() => _isLoading = false);
                                            if (messageNotifier.value ==
                                                'Sucess') {
                                              setState(() => _sucess = true);
                                              message('', args['type']);
                                            } else {
                                              message(messageNotifier.value,
                                                  args['type']);
                                            }
                                          },
                                    child: Text(
                                      args['type'] == 1
                                          ? 'Criar anúncio'
                                          : 'Salvar alterações',
                                      style: const TextStyle(
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
                          ? 'Anúncio criado com sucesso'
                          : 'Anúncio alterado com sucesso')
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
      if (erro == '') {
        Navigator.pop(context);
      }
    });
  }

  Widget date(context, type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Data de serviço*',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: AppColors.blue,
              ),
            ),
          ),
          TextFormField(
            key: const Key('form_serviceDate'),
            controller: serviceDateController,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              MaskTextInputFormatter(mask: '##/##/####')
            ],
            onChanged: ((value) {
              if (type == 2) {
                _validForm();
              } else {
                _validFormCreate();
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
                  serviceDate = _dateTime;
                  serviceDateController.text =
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

  _validForm() {
    var statusOriginal = information['status'] == 'A' ? 'Ativo' : 'Inativo';
    if (_fillAdress == true) {
      if (title.text.isNotEmpty &&
          street.text.isNotEmpty &&
          city.text.isNotEmpty &&
          state.text.isNotEmpty &&
          serviceDateController.text.isNotEmpty &&
          serviceValue.text.isNotEmpty &&
          servicesSelected != [] &&
          neighborhood.text.isNotEmpty &&
          serviceDateController.text.isNotEmpty &&
          (title.text != information['titulo'] ||
              street.text != information['end_rua'] ||
              city.text != information['end_cidade'] ||
              state.text != information['end_estado'] ||
              serviceDateController.text != information['data_realizacao'] ||
              serviceValue.text != information['valor'] ||
              servicesSelected != information['tipo_servico'] ||
              neighborhood.text.toString().isNotEmpty !=
                  information['end_bairro'] ||
              statusOriginal != valueStatus)) {
        formValidator.value = true;
      } else {
        formValidator.value = false;
      }
    } else {
      if (title.text.isNotEmpty &&
          serviceDateController.text.isNotEmpty &&
          serviceValue.text.isNotEmpty &&
          servicesSelected != [] &&
          serviceDateController.text.isNotEmpty &&
          (title.text != information['titulo'] ||
              serviceDateController.text != information['data_realizacao'] ||
              serviceValue.text != information['valor'] ||
              servicesSelected != information['tipo_servico'] ||
              statusOriginal != valueStatus)) {
        formValidator.value = true;
      } else {
        formValidator.value = false;
      }
    }
  }

  _validFormCreate() {
    if (_fillAdress == true) {
      if (title.text.isNotEmpty &&
          street.text.isNotEmpty &&
          city.text.isNotEmpty &&
          state.text.isNotEmpty &&
          serviceDateController.text.isNotEmpty &&
          serviceValue.text.isNotEmpty &&
          servicesSelected.isNotEmpty &&
          neighborhood.text.isNotEmpty &&
          serviceDateController.text.isNotEmpty) {
        formValidator.value = true;
      } else {
        formValidator.value = false;
      }
    } else {
      if (title.text.isNotEmpty &&
          serviceDateController.text.isNotEmpty &&
          serviceValue.text.isNotEmpty &&
          servicesSelected.isNotEmpty &&
          serviceDateController.text.isNotEmpty) {
        formValidator.value = true;
      } else {
        formValidator.value = false;
      }
    }
  }
}
