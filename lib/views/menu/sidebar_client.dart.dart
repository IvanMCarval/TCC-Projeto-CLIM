import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/controllers/user_controller.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';
import 'package:flutter_application_project_clim/views/Professionals/professionals_page.dart';
import 'package:flutter_application_project_clim/views/Professionals/professionals_profile.dart';
import 'package:flutter_application_project_clim/views/ad/ad_client_page.dart';
import 'package:flutter_application_project_clim/views/ad/ad_professional_page.dart';
import 'package:flutter_application_project_clim/views/home/home_page_client.dart';
import 'package:flutter_application_project_clim/views/profile/profile_page.dart';

class SideBarClient extends StatefulWidget {
  const SideBarClient({Key? key}) : super(key: key);

  @override
  State<SideBarClient> createState() => _SideBarClientState();
}

class _SideBarClientState extends State<SideBarClient> {
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
      HomePageClient(),
      AdClient(),
      ProfessionalsPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: listRoutes[_opcaoSelecionada],
      // IndexedStack(
      //   index: _opcaoSelecionada,
      //   children: const [
      //     HomePageClient(),
      //     AdProfessional(),
      //     AdProfessional(),
      //     ProfilePage(),
      //   ],
      // ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _opcaoSelecionada,
        selectedLabelStyle:
            const TextStyle(fontSize: 13, color: AppColors.blue),
        unselectedLabelStyle:
            const TextStyle(fontSize: 10, color: AppColors.blue),
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
            tooltip: '',
          ),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/professionals.png',
                scale: 1,
              ),
              label: 'Anúncios',
              tooltip: ''),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/adverts.png',
                scale: 1,
              ),
              label: 'Profissionais',
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
    ;
  }
}
