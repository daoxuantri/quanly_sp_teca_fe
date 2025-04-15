import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quanly_sp_teca_fe/routes.dart';
import 'package:quanly_sp_teca_fe/screens/splash/splash_screen.dart';
import 'package:quanly_sp_teca_fe/theme.dart';

void main() {
  runApp(const MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Management Product',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: theme(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
        
    );
  }
}
