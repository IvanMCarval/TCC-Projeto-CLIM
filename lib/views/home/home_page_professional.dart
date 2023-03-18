import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/controllers/user_controller.dart';

class HomePageProfessional extends StatefulWidget {
  const HomePageProfessional({Key? key}) : super(key: key);

  @override
  State<HomePageProfessional> createState() => _HomePageProfessionalState();
}

class _HomePageProfessionalState extends State<HomePageProfessional> {
  var userController = UserController();

  @override
  void initState() {
    userController.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home_professional.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 35),
              child: ListTile(
                title: const Text(
                  'Bem Vindo(a)!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: FutureBuilder(
                  future: userController.getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var res = snapshot.data as Map<String, dynamic>;
                      return Text(
                        res['nome'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
            Container(
              height: 150,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 25, bottom: 25),
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: Container(
                //color: Colors.red,
                height: 100,
                width: 150,
                alignment: Alignment.center,
                child: const Text(
                  'ANÚNCIOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const SideBarProfessional(),
    );
  }
}
