import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  //final String? text;
  final Function()? onPressed;
  final Widget? child;
  final double? border;
  final Color? color;
  final Color? colorDiabled;

  const Button(
      {this.onPressed,
      this.child,
      this.border,
      this.color,
      this.colorDiabled,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return colorDiabled == null ? AppColors.lightBlue : colorDiabled!;
          } else {
            return color == null ? AppColors.blue : color!;
          }
        }),
        fixedSize: MaterialStateProperty.all<Size>(
            Size(MediaQuery.of(context).size.width, 40)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(border != null ? border! : 35),
          ),
        ),
      ),
      child: child!,
      // child: Text(
      //   text!,
      //   style: const TextStyle(fontSize: 14, color: AppColors.background),
      // ),
    );
  }
}
