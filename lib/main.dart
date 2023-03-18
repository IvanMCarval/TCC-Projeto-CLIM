import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_project_clim/views/Professionals/professionals_page.dart';
import 'package:flutter_application_project_clim/views/Professionals/professionals_profile.dart';
import 'package:flutter_application_project_clim/views/ad/ad_client_page.dart';
import 'package:flutter_application_project_clim/views/ad/ad_details_page.dart';
import 'package:flutter_application_project_clim/views/ad/ad_edit_new_page.dart';
import 'package:flutter_application_project_clim/views/ad/ad_professional_page.dart';
import 'package:flutter_application_project_clim/views/home/home_page_client.dart';
import 'package:flutter_application_project_clim/views/home/home_page_professional.dart';
import 'package:flutter_application_project_clim/views/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/views/menu/sidebar_client.dart.dart';
import 'package:flutter_application_project_clim/views/menu/sidebar_professional.dart';
import 'package:flutter_application_project_clim/views/profile/account_page.dart';
import 'package:flutter_application_project_clim/views/profile/location_page.dart';
import 'package:flutter_application_project_clim/views/profile/personal_data_page.dart';
import 'package:flutter_application_project_clim/views/profile/profile_page.dart';
import 'package:flutter_application_project_clim/views/profile/service_page.dart';
import 'package:flutter_application_project_clim/views/registerUser/register_user_page.dart';
import 'package:flutter_application_project_clim/views/splash/splash_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(/*Informaçõe de conexão com Banco de dados*/);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/menu_professional': (context) => const SideBarProfessional(),
        '/menu_client': (context) => const SideBarClient(),
        '/home_client': (context) => const HomePageClient(),
        '/home_professional': (context) => const HomePageProfessional(),
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register-user': (context) => const RegisterUserPage(),
        '/profile': (context) => const ProfilePage(),
        '/profile/service': (context) => const ServicePage(),
        '/profile/personalData': (context) => const PersonalDataPage(),
        '/profile/location': (context) => const LocationPage(),
        '/profile/account': (context) => const AccountPage(),
        '/ad_professional': (context) => const AdProfessional(),
        '/ad_client': (context) => const AdClient(),
        '/ad_client/details': (context) => const AdDetails(),
        '/ad_client/edit_new': (context) => const AdEditNew(),
        '/professional-page': (context) => const ProfessionalsPage(),
        ProfessionalsProfile.routeNamed: (context) =>
            const ProfessionalsProfile(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
    );
  }
}
