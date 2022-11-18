import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timepro/pages/home.dart';
import 'package:timepro/pages/login.dart';
import 'package:timepro/widgets/dbhelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: Image.asset('assets/timesmall.png'),
        //nextScreen: loginPage(),
        nextScreen: loginPage(),
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: Colors.deepPurple,
        //pageTransitionType: pageTransitionType.scale,
        //home: LoginPage(),
      ),
    );
  }
}
