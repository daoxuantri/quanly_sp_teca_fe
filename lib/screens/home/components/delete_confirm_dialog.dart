import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart'; 

void showDeleteConfirmDialog(
  BuildContext context,
  ProductPriceModel product,
  VoidCallback onDelete,
) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Xóa sản phẩm?"),
      content: Text("Bạn có chắc muốn xóa ${product.name ?? ''}?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          child: const Text("Xóa", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}