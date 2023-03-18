import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4))
        .then((_) => Navigator.of(context).pushReplacementNamed('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(gradient: AppColors.gradientInicial),
      alignment: Alignment.center,
      width: 400,
      child: AnimatedSize(
        duration: const Duration(seconds: 3),
        curve: Curves.bounceOut,
        child: SvgPicture.asset('assets/images/logo.svg', fit: BoxFit.cover),
      ),
    );
  }
}
