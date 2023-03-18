import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TextInputFeild extends StatefulWidget {
  final String? textLabel;
  final String? hintText;
  final TextInputType? type;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? format;
  final bool? read;
  final bool? error;
  final String? erroMessage;
  final bool? sufix;

  const TextInputFeild(
      {this.textLabel,
      this.hintText,
      this.type,
      this.obscureText = false,
      this.controller,
      this.validator,
      this.format,
      this.read,
      this.error,
      this.erroMessage,
      Key? key,
      this.sufix = false})
      : super(key: key);

  @override
  State<TextInputFeild> createState() => _TextInputFeildState();
}

class _TextInputFeildState extends State<TextInputFeild> {
  var _visivel = false;
  var _show = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.textLabel!,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: AppColors.blue,
              ),
            ),
          ),
          TextFormField(
            readOnly: widget.read == null ? false : true,
            key: widget.key.toString() == null ? null : widget.key,
            validator: widget.validator ??
                ((value) {
                  if (value == null || value == '') {
                    return 'Preencha o campo';
                  }
                  return null;
                }),
            controller: widget.controller,
            obscureText: widget.obscureText == false ? false : _show,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: widget.type,
            inputFormatters: widget.format ?? [],
            decoration: InputDecoration(
                errorStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.red,
                ),
                errorText: widget.error == null || widget.error != false
                    ? null
                    : widget.erroMessage ?? '',
                fillColor: widget.read == null
                    ? AppColors.background
                    : AppColors.lightGrey,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                hintText: widget.hintText!,
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(47),
                  borderSide: const BorderSide(
                    color: AppColors.blueInputField,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(47),
                  borderSide: const BorderSide(
                    color: AppColors.blueInputField,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(47),
                  borderSide: const BorderSide(
                    color: AppColors.red,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(47),
                  borderSide: const BorderSide(
                    color: AppColors.red,
                  ),
                ),
                suffixIcon: widget.sufix == true
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _visivel = !_visivel;
                            _show = !_show;
                          });
                        },
                        icon: Icon(_visivel == false
                            ? FeatherIcons.eyeOff
                            : FeatherIcons.eye),
                        color: AppColors.blue)
                    : null),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
