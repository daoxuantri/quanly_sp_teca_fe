import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quanly_sp_teca_fe/model/product/product_data_model.dart';
import 'package:quanly_sp_teca_fe/screens/home/bloc/home_bloc.dart';

Future<void> exportFile({
  required BuildContext context,
  required HomeBloc homeBloc,
  required List<ProductDataModel> products,
  required Map<String, bool> fieldSelection,
  required List<ProductDataModel> Function(List<ProductDataModel>) getFilteredProducts,
}) async {
  print('Export file - Current state: ${homeBloc.state.runtimeType}');
  if (Platform.isAndroid) {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Quyền truy cập bộ nhớ bị từ chối")),
        );
        return;
      }
    }
  }

  if (products.isEmpty) {
    homeBloc.add(HomeInitialEvent());
    await homeBloc.stream.firstWhere((state) => state is HomeLoadedSuccessState || state is HomeErrorState);
    final state = homeBloc.state;
    if (state is HomeLoadedSuccessState) {
      products = state.listproduct;
    } else {
      print('Export file - Failed to load products');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể tải dữ liệu sản phẩm")),
      );
      return;
    }
  }

  final filteredProducts = getFilteredProducts(products);
  print('Export file - Filtered products count: ${filteredProducts.length}');
  if (filteredProducts.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Không có sản phẩm nào khớp với bộ lọc")),
    );
    return;
  }

  var excel = Excel.createExcel();
  Sheet sheet = excel['Sheet1'];

  List<String> headers = [];
  if (fieldSelection["Tên sản phẩm"]!) headers.add("Tên sản phẩm");
  if (fieldSelection["Giá"]!) headers.add("Giá");
  if (fieldSelection["Nhà cung cấp"]!) headers.add("Nhà cung cấp");
  if (fieldSelection["Xuất xứ"]!) headers.add("Xuất xứ");
  if (fieldSelection["Thương hiệu"]!) headers.add("Thương hiệu");

  sheet.appendRow(headers);

  for (var product in filteredProducts) {
    List<dynamic> row = [];
    if (fieldSelection["Tên sản phẩm"]!) row.add(product.name ?? '');
    if (fieldSelection["Giá"]!) row.add(product.price?.toString() ?? '0');
    if (fieldSelection["Nhà cung cấp"]!) row.add(product.supplier ?? '');
    if (fieldSelection["Xuất xứ"]!) row.add(product.origin ?? 'N/A');
    if (fieldSelection["Thương hiệu"]!) row.add(product.brand ?? '');
    sheet.appendRow(row);
  }

  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/products_export.xlsx';

    final excelData = excel.encode();
    if (excelData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi: Không thể mã hóa file Excel")),
      );
      return;
    }

    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excelData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã xuất file tại $filePath")),
    );

    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không thể mở file: ${result.message}")),
      );
    }
  } catch (e) {
    print('Lỗi xuất file: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Lỗi khi xuất file: $e")),
    );
  }
}