import 'package:flutter/material.dart';
import 'package:vtroom/Screens//WelcomeScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    });

    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: ClipOval(
            child: Image.asset("assets/images/splash.jpg"),
          ),
        ),
      ),
    );
  }
}
