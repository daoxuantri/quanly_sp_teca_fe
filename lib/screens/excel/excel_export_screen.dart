// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ExcelExportScreen extends StatefulWidget {
//   static String routeName = "/excel-export";

//   const ExcelExportScreen({super.key});

//   @override
//   State<ExcelExportScreen> createState() => _ExcelExportScreenState();
// }

// enum ExportOption { none, byProduct, byProject }

// class _ExcelExportScreenState extends State<ExcelExportScreen> {
//   ExportOption selectedOption = ExportOption.none;
//   List<String> selectedProducts = [];
//   String? selectedProject;

//   // Fake data để demo (sau này bạn sẽ lấy từ API nhé)
//   final List<Map<String, dynamic>> productList = [
//     {"id": 1, "name": "Máy in văn phòng", "price": 10400000, "supplier": "Ms Thảo HP"},
//     {"id": 2, "name": "Máy tính bộ", "price": 12400960, "supplier": "IDC Mr Thịnh"},
//     {"id": 3, "name": "Smart Tivi 65 inch", "price": 25400000, "supplier": "Điện máy Ngô Hoàng"},
//   ];

//   final List<Map<String, dynamic>> projectList = [
//     {"id": 1, "project_name": "Bộ tư lệnh HCM (Trang bị thiết bị CNTT)", "delivery_date": "2025-04-25"},
//   ];

//   bool isExporting = false;

//   Future<void> createAndSaveExcel({
//     required List<Map<String, dynamic>> dataList,
//     required String fileName,
//   }) async {
//     var excel = Excel.createExcel();
//     Sheet sheetObject = excel['Sheet1'];

//     if (dataList.isNotEmpty) {
//       sheetObject.appendRow(dataList.first.keys.toList());
//     }

//     for (var item in dataList) {
//       sheetObject.appendRow(item.values.toList());
//     }

//     var status = await Permission.storage.request();
//     if (!status.isGranted) {
//       throw Exception('Không có quyền lưu file');
//     }

//     final directory = await getExternalStorageDirectory();
//     final filePath = '${directory!.path}/$fileName.xlsx';

//     final fileBytes = excel.encode();
//     final File file = File(filePath)
//       ..createSync(recursive: true)
//       ..writeAsBytesSync(fileBytes!);

//     print('✅ File saved at: $filePath');
//   }

//   void exportSelected() async {
//     try {
//       setState(() {
//         isExporting = true;
//       });

//       List<Map<String, dynamic>> exportData = [];

//       if (selectedOption == ExportOption.byProduct) {
//         // Lọc sản phẩm đã chọn
//         exportData = productList
//             .where((product) => selectedProducts.contains(product['name']))
//             .map((product) => {
//                   "Tên sản phẩm": product['name'],
//                   "Giá": product['price'],
//                   "Nhà cung cấp": product['supplier'],
//                 })
//             .toList();
//       } else if (selectedOption == ExportOption.byProject) {
//         // Lọc dự án đã chọn (ví dụ: mỗi dự án có 1 sản phẩm list)
//         exportData = projectList
//             .where((project) => project['project_name'] == selectedProject)
//             .map((project) => {
//                   "Tên dự án": project['project_name'],
//                   "Ngày giao": project['delivery_date'],
//                 })
//             .toList();
//       }

//       await createAndSaveExcel(
//         dataList: exportData,
//         fileName: selectedOption == ExportOption.byProduct ? 'sanpham_export' : 'duan_export',
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('✅ Xuất Excel thành công!')),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('❌ Lỗi khi xuất file: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           isExporting = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Xuất Excel'),
//         backgroundColor: Colors.blue.shade700,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: isExporting
//             ? const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(),
//                     SizedBox(height: 16),
//                     Text('Đang xuất file...'),
//                   ],
//                 ),
//               )
//             : buildBody(),
//       ),
//     );
//   }

//   Widget buildBody() {
//     switch (selectedOption) {
//       case ExportOption.none:
//         return Column(
//           children: [
//             buildCardOption(
//               title: "Xuất thông tin nhà cung cấp với từng sản phẩm",
//               onTap: () => setState(() => selectedOption = ExportOption.byProduct),
//             ),
//             const SizedBox(height: 20),
//             buildCardOption(
//               title: "Xuất thông tin dự án đã cung cấp",
//               onTap: () => setState(() => selectedOption = ExportOption.byProject),
//             ),
//           ],
//         );
//       case ExportOption.byProduct:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Chọn sản phẩm:",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView(
//                 children: productList.map((product) {
//                   return CheckboxListTile(
//                     title: Text(product['name']),
//                     value: selectedProducts.contains(product['name']),
//                     onChanged: (value) {
//                       setState(() {
//                         if (value == true) {
//                           selectedProducts.add(product['name']);
//                         } else {
//                           selectedProducts.remove(product['name']);
//                         }
//                       });
//                     },
//                   );
//                 }).toList(),
//               ),
//             ),
//             buildExportButton(enabled: selectedProducts.isNotEmpty),
//           ],
//         );
//       case ExportOption.byProject:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Chọn dự án:",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView(
//                 children: projectList.map((project) {
//                   return RadioListTile<String>(
//                     title: Text(project['project_name']),
//                     value: project['project_name'],
//                     groupValue: selectedProject,
//                     onChanged: (value) {
//                       setState(() {
//                         selectedProject = value;
//                       });
//                     },
//                   );
//                 }).toList(),
//               ),
//             ),
//             buildExportButton(enabled: selectedProject != null),
//           ],
//         );
//     }
//   }

//   Widget buildCardOption({required String title, required VoidCallback onTap}) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       child: ListTile(
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         trailing: const Icon(Icons.arrow_forward_ios),
//         onTap: onTap,
//       ),
//     );
//   }

//   Widget buildExportButton({required bool enabled}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: SizedBox(
//         width: double.infinity,
//         child: ElevatedButton(
//           onPressed: enabled ? exportSelected : null,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue.shade700,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//           child: const Text('Xuất Excel', style: TextStyle(fontSize: 16)),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanly_sp_teca_fe/components_buttons/snackbar.dart';
import 'package:quanly_sp_teca_fe/model/product/detail/detail_product_data_model.dart';
import 'package:quanly_sp_teca_fe/screens/excel/bloc/excel_bloc.dart'; 

class ExcelExportScreen extends StatefulWidget {
  static String routeName = "/excel-export";

  const ExcelExportScreen({super.key});

  @override
  State<ExcelExportScreen> createState() => _ExcelExportScreenState();
}

enum ExportOption { none, byProduct }

class _ExcelExportScreenState extends State<ExcelExportScreen> {
  final ExcelBloc excelBloc = ExcelBloc();

  @override
  void initState() {
    super.initState();
    excelBloc.add(ExcelInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExcelBloc, ExcelState>(
      bloc: excelBloc,
      listenWhen: (previous, current) => current is ExcelActionState,
      buildWhen: (previous, current) => current is! ExcelActionState,
      listener: (context, state) {
        if (state is ExcelExportSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(state.message),
          );
          Navigator.pop(context);
        } else if (state is ExcelErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.errorMessage}'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ExcelLoadingState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Xuất Excel'),
              backgroundColor: Colors.blue.shade700,
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải dữ liệu...'),
                ],
              ),
            ),
          );
        } else if (state is ExcelErrorState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Xuất Excel'),
              backgroundColor: Colors.blue.shade700,
            ),
            body: Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        }

        ExportOption selectedOption = ExportOption.none;
        List<DetailProductData> products = [];
        List<String> selectedProductNames = [];

        if (state is ExcelOptionSelectedState) {
          selectedOption = state.selectedOption;
          products = state.products;
          selectedProductNames = state.selectedProductNames;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Xuất Excel'),
            backgroundColor: Colors.blue.shade700,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildBody(
              selectedOption,
              products,
              selectedProductNames,
            ),
          ),
        );
      },
    );
  }

  Widget buildBody(
    ExportOption selectedOption,
    List<DetailProductData> products,
    List<String> selectedProductNames,
  ) {
    switch (selectedOption) {
      case ExportOption.none:
        return Column(
          children: [
            buildCardOption(
              title: "Xuất thông tin nhà cung cấp với từng sản phẩm",
              onTap: () => excelBloc
                  .add(ExcelSelectOptionEvent(option: ExportOption.byProduct)),
            ),
          ],
        );
      case ExportOption.byProduct:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chọn sản phẩm:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('Không có sản phẩm nào'))
                  : ListView(
                      children: products.map((product) {
                        return CheckboxListTile(
                          title: Text(product.name ?? 'Không có tên'),
                          value:
                              selectedProductNames.contains(product.name),
                          onChanged: (value) {
                            excelBloc.add(ExcelSelectProductEvent(
                              productName: product.name ?? '',
                              isSelected: value ?? false,
                            ));
                          },
                        );
                      }).toList(),
                    ),
            ),
            buildExportButton(enabled: selectedProductNames.isNotEmpty),
          ],
        );
    }
  }

  Widget buildCardOption({required String title, required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget buildExportButton({required bool enabled}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: enabled
              ? () => excelBloc.add(const ExcelExportEvent())
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Xuất Excel', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}