import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';

class ButtonText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Alignment? alignment;
  final void Function()? onPressed;

  const ButtonText(
      {this.text, this.fontSize, this.alignment, Key? key, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment!,
      margin: const EdgeInsets.only(top: 2.5, bottom: 2.5),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text!,
          style: TextStyle(
            shadows: const [
              Shadow(
                color: AppColors.blue,
                offset: Offset(0, -3),
              ),
            ],
            fontSize: fontSize,
            color: Colors.transparent,
            decorationColor: AppColors.blue,
            decoration: TextDecoration.underline,
            decorationThickness: 1,
          ),
        ),
      ),
    );
  }
}
