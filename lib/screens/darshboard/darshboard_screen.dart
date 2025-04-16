import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/screens/CRUD/crud_screen.dart';
import 'package:quanly_sp_teca_fe/screens/updatedel/components/excel_export_screen.dart';
import 'package:quanly_sp_teca_fe/screens/updatedel/update_delete_product_screen.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class DarshBoard extends StatefulWidget {
  static String routeName = "/dashboard";
  const DarshBoard({super.key});

  @override
  State<DarshBoard> createState() => _DarshBoardState();
}

class _DarshBoardState extends State<DarshBoard> {
  final List<_DashboardItem> dashboardItems = [
    _DashboardItem(title: "Thêm sản phẩm", routeName: CRUDScreen.routeName),
    _DashboardItem(
        title: "Tất cả sản phẩm",
        routeName: UpdateDeleteProductScreen.routeName),
    _DashboardItem(
      title: "Xuất file Excel",
      routeName: ExcelExportScreen.routeName,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lý',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dashboardItems.length,
        itemBuilder: (context, index) {
          final item = dashboardItems[index];

          return GestureDetector(
            onTap: () {
              if (item.routeName.isNotEmpty) {
                Navigator.pushNamed(context, item.routeName);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  item.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final String routeName;

  _DashboardItem({required this.title, required this.routeName});
}
