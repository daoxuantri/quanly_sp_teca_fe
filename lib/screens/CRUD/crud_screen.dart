import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class CRUDScreen extends StatefulWidget {
  static String routeName = '/crud-screen';
  const CRUDScreen({super.key});

  @override
  State<CRUDScreen> createState() => _CRUDScreenState();
}

class _CRUDScreenState extends State<CRUDScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController originController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController priceDateController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final newProduct = {
        "code": codeController.text,
        "name": nameController.text,
        "origin": originController.text,
        "unit": unitController.text,
        "price": double.tryParse(priceController.text) ?? 0.0,
        "price_date": priceDateController.text,
        "supplier": supplierController.text,
        "note": noteController.text,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã lưu sản phẩm: ${newProduct['name']}')),
      );

      // Clear form
      codeController.clear();
      nameController.clear();
      originController.clear();
      unitController.clear();
      priceController.clear();
      priceDateController.clear();
      supplierController.clear();
      noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thêm sản phẩm",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(child: buildTextField("Mã sản phẩm", codeController)),
                  SizedBox(width: 12),
                  Expanded(child: buildTextField("Xuất xứ", originController)),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: buildTextField("Đơn vị", unitController)),
                  SizedBox(width: 12),
                  Expanded(child: buildTextField("Giá", priceController, isNumber: true)),
                ],
              ),
              SizedBox(height: 12),
              buildTextField("Tên sản phẩm", nameController),
              buildTextField("Ngày cập nhật giá", priceDateController),
              buildTextField("Nhà cung cấp", supplierController),
              buildTextField("Ghi chú", noteController, maxLines: 3),
              SizedBox(height: getProportionateScreenHeight(20)),
              ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: Icon(Icons.save),
                label: Text("Lưu sản phẩm"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập $label';
          }
          return null;
        },
      ),
    );
  }
}
