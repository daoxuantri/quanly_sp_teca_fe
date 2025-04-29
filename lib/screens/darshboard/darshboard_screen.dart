import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/screens/CRUD/crud_screen.dart';
import 'package:quanly_sp_teca_fe/screens/investor_info/investor_info_screen.dart';
import 'package:quanly_sp_teca_fe/screens/price_entries/price_entries_screen.dart';
import 'package:quanly_sp_teca_fe/screens/excel/excel_export_screen.dart';
import 'package:quanly_sp_teca_fe/screens/product_investor/product_investor_screen.dart';
import 'package:quanly_sp_teca_fe/screens/updatedel/update_delete_product_screen.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class DarshBoard extends StatefulWidget {
  static String routeName = "/dashboard";
  const DarshBoard({super.key});

  @override
  State<DarshBoard> createState() => _DarshBoardState();
}

class _DarshBoardState extends State<DarshBoard> {
  final List<_DashboardSection> sections = [
    _DashboardSection(
      title: "📁 Danh sách quản lý người dùng(đag phát triển)",
      items: [
        _DashboardItem(title: "Quản lý người dùng", routeName: ""),
        _DashboardItem(title: "Phân quyền người dùng", routeName: ""),
        _DashboardItem(title: "Lịch sử thay đổi dữ liệu", routeName: ""),
      ],
    ),
    _DashboardSection(
      title: "📦 Quản lý nhập - xuất sản phẩm",
      items: [
        _DashboardItem(title: "Thêm sản phẩm", routeName: CRUDScreen.routeName),
        _DashboardItem(
            title: "Xóa / Sửa sản phẩm", routeName: UpdateDeleteProductScreen.routeName),
        _DashboardItem(title: "Thêm giá nhà cung cấp", routeName: PriceEntriesScreen.routeName),
        _DashboardItem(title: "Xuất Excel", routeName: ExcelExportScreen.routeName),
      ],
    ),
    _DashboardSection(
      title: "📊 Quản lý dự án & danh mục sản phẩm",
      items: [
        _DashboardItem(title: "Danh sách dự án", routeName: InvestorInfoScreen.routeName),
        _DashboardItem(title: "Danh sách sản phẩm cung cấp", routeName: ProductInvestorScreen.routeName),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách quản lý",
        style: TextStyle(fontWeight: FontWeight.bold), ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return _buildSection(context, section);
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, _DashboardSection section) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          section.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: section.items.map((item) {
          return ListTile(
            title: Text(item.title),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              if (item.routeName.isNotEmpty) {
                Navigator.pushNamed(context, item.routeName);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final String routeName;

  _DashboardItem({required this.title, required this.routeName});
}

class _DashboardSection {
  final String title;
  final List<_DashboardItem> items;

  _DashboardSection({required this.title, required this.items});
}
