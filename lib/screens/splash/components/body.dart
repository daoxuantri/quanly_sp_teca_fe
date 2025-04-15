import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/components_buttons/bottom_navbar_home.dart';
import 'package:quanly_sp_teca_fe/components_buttons/colors.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late final String? email;
  late final String? password;
  late bool firstTime;

  @override
  void initState() {
    super.initState();
    _initialize();

  }

  Future<void> _initialize() async {
  startTimer();
}

  
  Timer ?_timer ; 
  void startTimer() {
  _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
    try {
      Navigator.pushReplacementNamed(context, NavigatorBottomBarHome.routeName);
    } catch (e) {
      if (mounted) { 
        Navigator.pushReplacementNamed(context, NavigatorBottomBarHome.routeName);
      }
    } finally {
      timer.cancel();
    }
  });
}

@override
void dispose() {
  _timer?.cancel();  
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: AppColor.colorWhite,
      child: Center(
        child: Image.asset(
          "assets/images/logo_tecapro.png",
          width: 200,
          height: getProportionateScreenHeight(140),
        ),
      ),
    );
  }
  
  


}