import 'package:flutter/material.dart';

class ExcelExportScreen extends StatefulWidget {
  static String routeName = "/excel-export";

  const ExcelExportScreen({super.key});

  @override
  State<ExcelExportScreen> createState() => _ExcelExportScreenState();
}

class _ExcelExportScreenState extends State<ExcelExportScreen> {
  Map<String, bool> fieldSelection = {
    "Tên sản phẩm": true,
    "Giá": true,
    "Nhà cung cấp": true,
    "Nguồn gốc": false,
    "Đơn vị": false,
  };

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showExportDialog(context, fieldSelection, exportFile);
    });
  }

  void exportFile() {
    // TODO: Gọi HomeBloc hoặc API xuất Excel tại đây
    print("Đang xuất với các trường: ${fieldSelection.entries.where((e) => e.value).map((e) => e.key).toList()}");
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Đang xử lý xuất file Excel...")),
    );
  }
}

void showExportDialog(
  BuildContext context,
  Map<String, bool> fieldSelection,
  VoidCallback onExport,
) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Chọn trường cần xuất",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
            ),
            const SizedBox(height: 16),
            ...fieldSelection.keys.map((field) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: fieldSelection[field]!
                      ? Colors.blue.shade100
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CheckboxListTile(
                  title: Text(field),
                  value: fieldSelection[field],
                  activeColor: Colors.blue.shade700,
                  onChanged: (val) {
                    fieldSelection[field] = val!;
                    (context as Element).markNeedsBuild(); // update UI
                  },
                ),
              );
            }),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onExport(); // Gọi hàm xuất
                  },
                  child: const Text("Xuất", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
