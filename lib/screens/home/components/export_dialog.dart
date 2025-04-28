import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class ExportDialog extends StatefulWidget {
  final Map<String, bool> fieldSelection;
  final VoidCallback onExport;

  const ExportDialog({
    super.key,
    required this.fieldSelection,
    required this.onExport,
  });

  @override
  _ExportDialogState createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  late Map<String, bool> localFieldSelection;

  @override
  void initState() {
    super.initState();
    localFieldSelection = Map.from(widget.fieldSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
            SizedBox(height: getProportionateScreenHeight(16)),
            ...localFieldSelection.keys.map((field) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: localFieldSelection[field]!
                      ? Colors.blue.shade100
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CheckboxListTile(
                  title: Text(field),
                  value: localFieldSelection[field],
                  activeColor: Colors.blue.shade700,
                  onChanged: (val) {
                    setState(() {
                      localFieldSelection[field] = val!;
                      widget.fieldSelection[field] = val;
                    });
                  },
                ),
              );
            }),
            SizedBox(height: getProportionateScreenHeight(16)),
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
                    widget.onExport();
                  },
                  child: const Text("Xuất", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}