import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quanly_sp_teca_fe/api/product_price.dart';
import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';
import 'package:quanly_sp_teca_fe/screens/home/bloc/home_bloc.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

void showImportDialog(
  BuildContext context,
  HomeBloc homeBloc,
  VoidCallback onImportComplete,
) {
  bool isLoading = false;

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Nhập dữ liệu từ Excel",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    const Text(
                      "Chọn file Excel với các cột: code, name, specific_product, unit, price, price_date, origin, brand, supplier, asker, note",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Chọn file Excel"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          var status = await Permission.storage.request();
                          if (!status.isGranted) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Không có quyền truy cập bộ nhớ")),
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx'],
                          );

                          if (result == null || result.files.isEmpty) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Không thể chọn file Excel")),
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          final filePath = result.files.single.path;
                          if (filePath == null) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Không thể truy cập file Excel")),
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          final file = File(filePath);
                          var bytes = await file.readAsBytes();

                          var excel = Excel.decodeBytes(bytes);

                          Sheet? sheet = excel.tables[excel.tables.keys.first];
                          if (sheet == null) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("File Excel không hợp lệ")),
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          if (sheet.rows.isEmpty) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("File Excel trống")),
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          final expectedHeaders = [
                            'code',
                            'name',
                            'specific_product',
                            'unit',
                            'price',
                            'price_date',
                            'origin',
                            'brand',
                            'supplier',
                            'asker',
                            'note'
                          ];

                          final headerRow = sheet.rows[0];
                          if (headerRow == null || headerRow.isEmpty) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("File Excel không có tiêu đề")),
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          Map<String, int> headerIndices = {};
                          for (int i = 0; i < headerRow.length; i++) {
                            final header = headerRow[i]?.value?.toString().toLowerCase();
                            if (header != null && expectedHeaders.contains(header)) {
                              headerIndices[header] = i;
                            }
                          }

                          for (var required in ['code', 'price', 'supplier', 'asker']) {
                            if (!headerIndices.containsKey(required)) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Thiếu cột bắt buộc: $required")),
                                );
                              }
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }
                          }

                          String? parseDate(String? rawDate) {
                            if (rawDate == null || rawDate.trim().isEmpty) return null;
                            try {
                              final dateNum = double.tryParse(rawDate);
                              if (dateNum != null) {
                                final excelEpoch = DateTime(1899, 12, 31);
                                final correctedDays = dateNum.toInt() - 1;
                                final date = excelEpoch.add(Duration(days: correctedDays));
                                return date.toIso8601String();
                              }

                              final formats = [
                                DateFormat('MM/dd/yyyy'),
                                DateFormat('dd/MM/yyyy'),
                                DateFormat('yyyy/MM/dd'),
                                DateFormat('dd-MM-yyyy'),
                                DateFormat('yyyy-MM-dd'),
                              ];

                              for (var format in formats) {
                                try {
                                  final date = format.parse(rawDate);
                                  return DateTime(date.year, date.month, date.day)
                                      .toIso8601String();
                                } catch (_) {}
                              }

                              final parsedDateTime = DateTime.tryParse(rawDate);
                              if (parsedDateTime != null) {
                                return parsedDateTime.toIso8601String();
                              }

                              return null;
                            } catch (_) {
                              return null;
                            }
                          }

                          List<ProductPriceModel> products = [];
                          int errorCount = 0;
                          int emptyRowCount = 0;
                          Map<String, int> errorSummary = {};

                          for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
                            final row = sheet.rows[rowIndex];

                            bool isRowEmpty = row.every(
                              (cell) =>
                                  cell == null ||
                                  cell.value == null ||
                                  cell.value.toString().trim().isEmpty,
                            );
                            if (isRowEmpty) {
                              emptyRowCount++;
                              continue;
                            }

                            try {
                              String? getValue(String key) {
                                final index = headerIndices[key];
                                return (index != null && index < row.length)
                                    ? row[index]?.value?.toString()
                                    : null;
                              }

                              final code = getValue('code')?.trim() ?? '';
                              final priceStr = getValue('price')?.trim() ?? '';
                              final supplier = getValue('supplier')?.trim() ?? '';
                              final asker = getValue('asker')?.trim() ?? '';

                              List<String> missingFields = [];
                              if (code.isEmpty) missingFields.add('code');
                              if (priceStr.isEmpty) missingFields.add('price');
                              if (supplier.isEmpty) missingFields.add('supplier');
                              if (asker.isEmpty) missingFields.add('asker');

                              if (missingFields.isNotEmpty) {
                                String errorKey = 'Dòng ${rowIndex + 1} thiếu: ${missingFields.join(", ")}';
                                errorSummary.update(errorKey, (value) => value + 1, ifAbsent: () => 1);
                                errorCount++;
                                continue;
                              }

                              final price = int.tryParse(priceStr) ??
                                  double.tryParse(priceStr)?.toInt();
                              if (price == null || price < 0) {
                                String errorKey =
                                    'Dòng ${rowIndex + 1} có giá không hợp lệ ($priceStr)';
                                errorSummary.update(errorKey, (value) => value + 1, ifAbsent: () => 1);
                                errorCount++;
                                continue;
                              }

                              final rawDate = getValue('price_date');
                              String? parsedDate = parseDate(rawDate);

                              final product = ProductPriceModel(
                                code: code,
                                name: getValue('name')?.trim(),
                                specificProduct: getValue('specific_product')?.trim(),
                                unit: getValue('unit')?.trim(),
                                price: price,
                                priceDate: parsedDate,
                                origin: getValue('origin')?.trim(),
                                brand: getValue('brand')?.trim(),
                                supplier: supplier,
                                asker: asker,
                                note: getValue('note')?.trim(),
                              );

                              products.add(product);
                            } catch (_) {
                              String errorKey = 'Lỗi dòng ${rowIndex + 1}';
                              errorSummary.update(errorKey, (value) => value + 1, ifAbsent: () => 1);
                              errorCount++;
                              continue;
                            }
                          }

                          if (products.isEmpty) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Không có dữ liệu hợp lệ. $errorCount dòng bị lỗi, $emptyRowCount dòng trống.",
                                  ),
                                ),
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          int successCount = 0;
                          for (var product in products) {
                            try {
                              await ApiServiceProductPrice().createProduct(product);
                              successCount++;
                            } catch (_) {
                              errorCount++;
                            }
                          }

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Đã nhập $successCount/${products.length} sản phẩm. $errorCount dòng bị lỗi, $emptyRowCount dòng trống.",
                                ),
                              ),
                            );
                            onImportComplete();
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Lỗi khi nhập file: $e")),
                            );
                          }
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
        ),
      ),
    ),
  );
}