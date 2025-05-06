// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:excel/excel.dart';
// import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';
// import 'package:quanly_sp_teca_fe/screens/home/bloc/home_bloc.dart';
// import 'package:quanly_sp_teca_fe/size_config.dart';
// import 'package:quanly_sp_teca_fe/api/product_price.dart';

// void showImportDialog(
//   BuildContext context,
//   HomeBloc homeBloc,
//   VoidCallback onImportComplete,
// ) {
//   showDialog(
//     context: context,
//     builder: (_) => Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade50, Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "Nhập dữ liệu từ Excel",
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue.shade900,
//                   ),
//             ),
//             SizedBox(height: getProportionateScreenHeight(16)),
//             const Text(
//               "Chọn file Excel với các cột: code, name, specific_product, unit, price, price_date, origin, brand, supplier, asker, note",
//               style: TextStyle(fontSize: 14),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: getProportionateScreenHeight(16)),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.upload_file),
//               label: const Text("Chọn file Excel"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue.shade700,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               onPressed: () async {
//                 try {
//                   FilePickerResult? result = await FilePicker.platform.pickFiles(
//                     type: FileType.custom,
//                     allowedExtensions: ['xlsx'],
//                   );

//                   if (result == null || result.files.single.bytes == null) {
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Không thể đọc file Excel")),
//                       );
//                     }
//                     return;
//                   }

//                   var bytes = result.files.single.bytes!;
//                   var excel = Excel.decodeBytes(bytes);
//                   Sheet? sheet = excel.tables[excel.tables.keys.first];

//                   if (sheet == null) {
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("File Excel không hợp lệ")),
//                       );
//                     }
//                     return;
//                   }

//                   // Expected headers
//                   List<String> expectedHeaders = [
//                     'code',
//                     'name',
//                     'specific_product',
//                     'unit',
//                     'price',
//                     'price_date',
//                     'origin',
//                     'brand',
//                     'supplier',
//                     'asker',
//                     'note'
//                   ];

//                   // Validate headers
//                   List<dynamic> headerRow = sheet.rows.first;
//                   bool headersValid = expectedHeaders.every((header) =>
//                       headerRow.contains(header) ||
//                       headerRow.contains(header.toUpperCase()));

//                   if (!headersValid) {
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text(
//                                 "File Excel không đúng định dạng. Cần các cột: code, name, specific_product, unit, price, price_date, origin, brand, supplier, asker, note")),
//                       );
//                     }
//                     return;
//                   }

//                   // Map headers to indices
//                   Map<String, int> headerIndices = {};
//                   for (int i = 0; i < headerRow.length; i++) {
//                     String header = headerRow[i].toString().toLowerCase();
//                     if (expectedHeaders.contains(header)) {
//                       headerIndices[header] = i;
//                     }
//                   }

//                   // Validate headerIndices contains all required keys
//                   for (var header in ['code', 'price', 'supplier', 'asker']) {
//                     if (!headerIndices.containsKey(header)) {
//                       if (context.mounted) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                               content: Text(
//                                   "Thiếu cột bắt buộc trong Excel: $header")),
//                         );
//                       }
//                       return;
//                     }
//                   }

//                   // Process rows
//                   List<ProductPriceModel> products = [];
//                   for (var rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
//                     var row = sheet.rows[rowIndex];
//                     try {
//                       String? priceDate = headerIndices.containsKey('price_date')
//                           ? row[headerIndices['price_date']]?.value?.toString()
//                           : null;
//                       // Validate required fields
//                       var code = headerIndices.containsKey('code')
//                           ? row[headerIndices['code']]?.value?.toString()
//                           : null;
//                       var priceValue = headerIndices.containsKey('price')
//                           ? row[headerIndices['price']]?.value?.toString()
//                           : null;
//                       var supplier = headerIndices.containsKey('supplier')
//                           ? row[headerIndices['supplier']]?.value?.toString()
//                           : null;
//                       var asker = headerIndices.containsKey('asker')
//                           ? row[headerIndices['asker']]?.value?.toString()
//                           : null;

//                       if (code == null ||
//                           code.isEmpty ||
//                           priceValue == null ||
//                           supplier == null ||
//                           supplier.isEmpty ||
//                           asker == null ||
//                           asker.isEmpty) {
//                         debugPrint(
//                             'Skipping row $rowIndex: Missing or empty required fields');
//                         continue; // Skip invalid rows
//                       }

//                       double? price = double.tryParse(priceValue) ?? 0.0;

//                       var product = ProductPriceModel(
//                         code: code,
//                         name: headerIndices.containsKey('name')
//                             ? row[headerIndices['name']]?.value?.toString()
//                             : null,
//                         specificProduct:
//                             headerIndices.containsKey('specific_product')
//                                 ? row[headerIndices['specific_product']]
//                                     ?.value
//                                     ?.toString()
//                                 : null,
//                         unit: headerIndices.containsKey('unit')
//                             ? row[headerIndices['unit']]?.value?.toString()
//                             : null,
//                         price: price,
//                         priceDate: priceDate != null &&
//                                 DateTime.tryParse(priceDate) != null
//                             ? priceDate
//                             : null,
//                         origin: headerIndices.containsKey('origin')
//                             ? row[headerIndices['origin']]?.value?.toString()
//                             : null,
//                         brand: headerIndices.containsKey('brand')
//                             ? row[headerIndices['brand']]?.value?.toString()
//                             : null,
//                         supplier: supplier,
//                         asker: asker,
//                         note: headerIndices.containsKey('note')
//                             ? row[headerIndices['note']]?.value?.toString()
//                             : null,
//                       );
//                       products.add(product);
//                     } catch (e) {
//                       debugPrint('Error processing row $rowIndex: $e');
//                       continue; // Skip rows with errors
//                     }
//                   }

//                   if (products.isEmpty) {
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text("Không có dữ liệu hợp lệ để nhập")),
//                       );
//                     }
//                     return;
//                   }

//                   // Send products to server
//                   int successCount = 0;
//                   for (var product in products) {
//                     try {
//                       await ApiServiceProductPrice().createProduct(product);
//                       successCount++;
//                     } catch (e) {
//                       debugPrint('Error uploading product: $e');
//                     }
//                   }

//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                           content: Text(
//                               "Đã nhập $successCount/${products.length} sản phẩm")),
//                     );
//                     // Refresh product list
//                     onImportComplete();
//                     Navigator.pop(context);
//                   }
//                 } catch (e) {
//                   debugPrint('Error importing Excel: $e');
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Lỗi khi nhập file: $e")),
//                     );
//                   }
//                 }
//               },
//             ),
//             SizedBox(height: getProportionateScreenHeight(16)),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }