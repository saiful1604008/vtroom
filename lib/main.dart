import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vtroom/Screens//SplashScreen.dart';
import 'package:vtroom/Screens//WelcomeScreen.dart';
import 'package:vtroom/Screens//LoginPage.dart';
import 'package:vtroom/Screens/home_screen/HomePage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
