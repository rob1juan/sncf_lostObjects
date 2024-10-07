import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/loading_screen.dart';
import 'screens/onboarding_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost and Found',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
        future: _checkIfFirstLaunch(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return OnboardingPage(
                pages: [
                  OnboardingPageModel(
                    title: 'Bienvenue',
                    description: 'Découvrez les objets perdus dans les trains',
                    image: 'assets/images/img.png',
                  ),
                  OnboardingPageModel(
                    title: 'Filtrez les objets',
                    description: 'Trouvez vos objets perdus par catégories',
                    image: 'assets/images/img2.png',
                  ),
                  OnboardingPageModel(
                    title: 'Analysez',
                    description: 'Accédez à une base de données riche',
                    image: 'assets/images/img3.png',
                  ),
                ],
              );
            } else {
              return LoadingScreen();
            }
          } else {
            return Container();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> _checkIfFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstLaunch = prefs.getBool('firstLaunch') ?? true;
    if (firstLaunch) {
      await prefs.setBool('firstLaunch', false);
    }
    return firstLaunch;
  }
}
