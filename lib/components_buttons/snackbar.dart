import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';


//THÔNG BÁO : Đăng ký thành công 
SnackBar SnackBarLoginSuccess(String notification) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
        height: getProportionateScreenHeight(50),
        width: SizeConfig.screenWidth * 0.6,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
            SizedBox(width: getProportionateScreenWidth(25)),
            Text(
              notification,
              style: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(15),
              ),
            ),
          ],
        ),
      ),
    );
  }


//THÔNG BÁO : login fail 

  SnackBar SnackBarLoginFail(String notification) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
        height: getProportionateScreenHeight(50),
        width: SizeConfig.screenWidth * 0.6,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            SizedBox(width: getProportionateScreenWidth(25)),
            Text(
              notification,
              style: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(14),
              ),
            ),
          ],
        ),
      ),
    );
  }



