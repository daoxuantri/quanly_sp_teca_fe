import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/screens/CRUD/crud_screen.dart';
import 'package:quanly_sp_teca_fe/screens/darshboard/darshboard_screen.dart';
import 'package:quanly_sp_teca_fe/screens/home/home_screen.dart';

class NavigatorBottomBarHome extends StatefulWidget {
  const NavigatorBottomBarHome({super.key, this.currentIndex = 0});
  static String routeName = '/navigator-bottom-bar';
  final int currentIndex;

  @override
  State<NavigatorBottomBarHome> createState() => _NavigatorBottomBarState();
}

class _NavigatorBottomBarState extends State<NavigatorBottomBarHome> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  // Danh sách các màn hình tương ứng
  final screens = [
    const HomeScreen(),
    const DarshBoard()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF9500), // AppColor.colorFF9500
        unselectedItemColor: Colors.black, // AppColor.colorBlack
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              const AssetImage('assets/images/IC_Dashboard.png'),
              size: 24,
            ),
            activeIcon: ImageIcon(
              const AssetImage('assets/images/IC_Dashboard.png'),
              size: 24,
              color: const Color(0xFFFF9500),
            ),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            activeIcon: const Icon(Icons.bar_chart, color: Color(0xFFFF9500)),
            label: 'CRUD',
          ),
        ],
      ),
    );
  }
}