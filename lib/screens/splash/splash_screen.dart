import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';
import 'package:quanly_sp_teca_fe/screens/splash/components/body.dart'; 

class SplashScreen extends StatelessWidget {
  static String routeName ="/splash";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
    );
  }
}