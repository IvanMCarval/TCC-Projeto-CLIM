import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/controllers/user_controller.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/ad/ad_professional_page.dart';
import 'package:flutter_application_project_clim/views/home/home_page_professional.dart';
import 'package:flutter_application_project_clim/views/profile/profile_page.dart';

class SideBarProfessional extends StatefulWidget {
  const SideBarProfessional({Key? key}) : super(key: key);

  @override
  State<SideBarProfessional> createState() => _SideBarProfessionalState();
}

class _SideBarProfessionalState extends State<SideBarProfessional> {
  int _opcaoSelecionada = 0;
  var userController = UserController();

  @override
  void initState() {
    userController.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listRoutes = const [
      HomePageProfessional(),
      AdProfessional(),
      ProfilePage(),
    ];
    return Scaffold(
      body: listRoutes[_opcaoSelecionada],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            const TextStyle(fontSize: 10, color: AppColors.blue),
        unselectedLabelStyle:
            const TextStyle(fontSize: 13, color: AppColors.blue),
        currentIndex: _opcaoSelecionada,
        onTap: (op) {
          setState(() {
            _opcaoSelecionada = op;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/home_page.png',
                scale: 1,
              ),
              label: 'Pagina Inicial',
              tooltip: ''),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/adverts.png',
                scale: 1,
              ),
              label: 'Anúncios',
              tooltip: ''),
          BottomNavigationBarItem(
              icon: FutureBuilder(
                future: userController.getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var res = snapshot.data as Map<String, dynamic>;
                    return CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(
                        res['foto'].toString(),
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              label: 'Perfil',
              tooltip: ''),
        ],
      ),
    );
  }
}
