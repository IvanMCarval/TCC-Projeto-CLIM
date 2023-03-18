import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';

class Outlined extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final double? size;
  final double? border;
  const Outlined({Key? key, this.text, this.onPressed, this.size, this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(border != null ? border! : 35),
        ),
        side: BorderSide(
          color: AppColors.blue,
          width: 1,
        ),
      ),
      child: Text(
        text!,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          color: AppColors.blue,
        ),
      ),
    );
  }
}
