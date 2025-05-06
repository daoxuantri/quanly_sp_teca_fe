

import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/components_buttons/bottom_navbar_home.dart';
import 'package:quanly_sp_teca_fe/screens/CRUD/crud_screen.dart';
import 'package:quanly_sp_teca_fe/screens/darshboard/darshboard_screen.dart';
import 'package:quanly_sp_teca_fe/screens/detailproduct/detail_product_screen.dart'; 
import 'package:quanly_sp_teca_fe/screens/home/home_screen.dart';
import 'package:quanly_sp_teca_fe/screens/productandproject/project_and_product_screen.dart'; 
import 'package:quanly_sp_teca_fe/screens/splash/splash_screen.dart';
import 'package:quanly_sp_teca_fe/screens/excel/excel_export_screen.dart';
import 'package:quanly_sp_teca_fe/screens/updatedel/update_delete_product_screen.dart'; 

final Map<String , WidgetBuilder> routes ={ 

  // /*-----------------------------------------------------------------------------*/
//splash
  SplashScreen.routeName : (context) => const SplashScreen(),

  //Navigator Bottom bar
  NavigatorBottomBarHome.routeName : (context) => const NavigatorBottomBarHome(),

  //home
  HomeScreen.routeName : (context) => const HomeScreen(),

  DetailProductScreen.routeName : (context) => const DetailProductScreen(),


  //CRUD
  CRUDScreen.routeName : (context) => CRUDScreen(),

  //darsh board

  DarshBoard.routeName : (context) => DarshBoard(),

  //update-delete product screen
  UpdateDeleteProductScreen.routeName : (context) => UpdateDeleteProductScreen() ,

  //excel 
  ExcelExportScreen.routeName : (context) => ExcelExportScreen() , 

  ProjectAndProductScreen.routeName: (context) => ProjectAndProductScreen (),



  // //form email pass
  // // FormEmailPass.routeName : (context) => const FormEmailPass(),
  // IDEmail.routeName : (context) => const IDEmail(),

  // //respass
  // ResetPassScreen.routeName : (context) => const ResetPassScreen(),
  
  // //all product screen
  // AllProductScreen.routeName :(context) => const AllProductScreen(),
  // ProductScreen.routeName :(context) => const ProductScreen(),
  // MyCartScreen.routeName :(context) => const MyCartScreen(),



  // //children file user profile 
  // EditUserInfo.routeName :(context) => const EditUserInfo(),
  // AddressScreen.routeName :(context) => const AddressScreen(),
  // AddAddressScreen.routeName: (context) => const AddAddressScreen(),

  // //check-out
  // CheckoutScreen.routeName : (context) => const CheckoutScreen(),
  // VNPayScreen.routeName : (context) => const VNPayScreen(),

  
  // MyOrdersScreen.routeName : (context) => const MyOrdersScreen(),
  // ListAllProductCategoryScreen.routeName : (context) => const ListAllProductCategoryScreen(),
  







};