import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '\home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> products = [
    {"name": "Sản phẩm A", "price": 100, "provider": "Nhà A", "selected": false},
    {"name": "Sản phẩm B", "price": 200, "provider": "Nhà B", "selected": false},
    {"name": "Sản phẩm C", "price": 300, "provider": "Nhà A", "selected": false},
  ];

  bool isLoading = false;
  String selectedProvider = 'Tất cả';
  String selectedPrice = 'Tất cả';

  List<String> fieldsToExport = ["name", "price", "provider"];
  Map<String, bool> fieldSelection = {
    "Tên sản phẩm": true,
    "Giá": true,
    "Nhà cung cấp": true,
  };

  void showExportDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Chọn trường cần xuất"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: fieldSelection.keys.map((field) {
            return CheckboxListTile(
              title: Text(field),
              value: fieldSelection[field],
              onChanged: (val) {
                setState(() {
                  fieldSelection[field!] = val!;
                });
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              exportFile();
            },
            child: Text("Xuất"),
          ),
        ],
      ),
    );
  }

  void exportFile() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() => isLoading = false);
    Fluttertoast.showToast(msg: "Xuất file Excel thành công!");
  }

  void showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedPrice,
              items: ['Tất cả', '< 200', '>= 200']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedPrice = val!),
              decoration: InputDecoration(labelText: "Lọc theo giá"),
            ),
            DropdownButtonFormField<String>(
              value: selectedProvider,
              items: ['Tất cả', 'Nhà A', 'Nhà B']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedProvider = val!),
              decoration: InputDecoration(labelText: "Nhà cung cấp"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Áp dụng"),
            )
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((product) {
      bool matchPrice = selectedPrice == 'Tất cả' ||
          (selectedPrice == '< 200' && product['price'] < 200) ||
          (selectedPrice == '>= 200' && product['price'] >= 200);
      bool matchProvider = selectedProvider == 'Tất cả' || product['provider'] == selectedProvider;
      return matchPrice && matchProvider;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý sản phẩm"),
        actions: [
          IconButton(onPressed: showExportDialog, icon: Icon(Icons.download)),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm...",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: showFilterDialog,
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("Chọn")),
                      DataColumn(label: Text("Tên")),
                      DataColumn(label: Text("Giá")),
                      DataColumn(label: Text("Nhà cung cấp")),
                    ],
                    rows: filteredProducts.map((product) {
                      return DataRow(
                        cells: [
                          DataCell(Checkbox(
                            value: product['selected'],
                            onChanged: (val) {
                              setState(() {
                                product['selected'] = val;
                              });
                            },
                          )),
                          DataCell(Text(product['name'])),
                          DataCell(Text(product['price'].toString())),
                          DataCell(Text(product['provider'])),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.download),
                  label: Text("Xuất Excel"),
                  onPressed: showExportDialog,
                ),
              )
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
} 
