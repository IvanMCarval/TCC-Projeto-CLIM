import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/components/custom_shape.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool back;
  final List<Widget>? listActions;

  const CustomAppBar(
      {Key? key, required this.title, required this.back, this.listActions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: back
          ? Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 35),
              child: IconButton(
                icon: const Icon(FeatherIcons.chevronLeft),
                color: AppColors.background,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Text(
          title,
          style: const TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.background,
              fontWeight: FontWeight.w500),
        ),
      ),
      elevation: 0,
      toolbarHeight: 110,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipPath(
        clipper: CustomShape(),
        child: Container(
          decoration: BoxDecoration(gradient: AppColors.gradientAppBar),
        ),
      ),
      centerTitle: true,
      actions: listActions ?? [],
    );
  }
}
