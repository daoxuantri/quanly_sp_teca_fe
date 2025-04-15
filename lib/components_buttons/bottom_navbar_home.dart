import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/components_buttons/colors.dart';
import 'package:quanly_sp_teca_fe/screens/home/home_screen.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class NavigatorBottomBarHome extends StatefulWidget {
  const NavigatorBottomBarHome({super.key, this.currentIndex = 0});
  static String routeName = '/navigator-bottom-bar';
  final int currentIndex; // Thêm biến để lưu currentIndex

  @override
  State<NavigatorBottomBarHome> createState() => _NavigatorBottomBarState();
}

class _NavigatorBottomBarState extends State<NavigatorBottomBarHome> {
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex; // Gán giá trị cho currentIndex
  }

  // List of icons for the navigation bar
  List<String> listAssetsIcons = [
    "IC_Dashboard.png",
  ];

  // List of labels for the navigation bar
  List<String> listLabels = [
    "Trang chủ",
  ];

  // Corresponding screens for the navigation bar
  final screens = [
    HomeScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        height: getProportionateScreenHeight(75), 
        decoration: BoxDecoration(
          color: AppColor.colorWhite,
          boxShadow: [
            BoxShadow(
              color: AppColor.colorBlack.withOpacity(.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: listAssetsIcons.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(24),
                      height: getProportionateScreenHeight(24),
                      child: Image.asset(
                        'assets/images/${listAssetsIcons[index]}',
                        color: index == currentIndex
                            ? AppColor.colorFF9500
                            : AppColor.colorBlack,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Add the label text
                    Text(
                      listLabels[index],
                      style: TextStyle(
                        color: index == currentIndex
                            ? AppColor.colorFF9500
                            : AppColor.colorBlack,
                        fontSize: getProportionateScreenWidth(10),
                        fontWeight: index == currentIndex
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Animated underline for the active tab
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.fastEaseInToSlowEaseOut,
                      width: getProportionateScreenWidth(33),
                      height: index == currentIndex
                          ? getProportionateScreenWidth(5)
                          : 0,
                      decoration: BoxDecoration(
                        color: AppColor.colorFF9500,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}