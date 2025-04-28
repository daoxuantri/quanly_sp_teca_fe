import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final TextEditingController specificProductController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = {
        'code': codeController.text,
        'name': nameController.text,
        'specific_product': specificProductController.text,
        'unit': unitController.text,
        'note': noteController.text,
      };

      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "✅ Đã thêm sản phẩm: ${product['name']}",
            style: GoogleFonts.montserrat(),
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      // Clear form with animation
      for (final controller in [
        codeController,
        nameController,
        specificProductController,
        unitController,
        noteController,
      ]) {
        controller.clear();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Thêm Sản Phẩm",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(16),
            vertical: getProportionateScreenHeight(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildSectionCard("Thông tin sản phẩm", [
                  buildTextField(
                    "Mã sản phẩm",
                    codeController,
                    hint: "Nhập mã sản phẩm (VD: 4003DW)",
                  ),
                  buildTextField(
                    "Tên sản phẩm",
                    nameController,
                    hint: "Nhập tên sản phẩm",
                  ),
                  buildTextField(
                    "Chi tiết sản phẩm",
                    specificProductController,
                    hint: "Mô tả chi tiết sản phẩm",
                    maxLines: 2,
                  ),
                  buildTextField(
                    "Đơn vị",
                    unitController,
                    hint: "VD: Bộ, Cái, Hệ thống",
                  ),
                  buildTextField(
                    "Ghi chú",
                    noteController,
                    hint: "Thông tin bổ sung (nếu có)",
                    maxLines: 3,
                  ),
                ]),
                SizedBox(height: getProportionateScreenHeight(30)),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tạo sản phẩm mới",
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.blue.shade900,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(8)),
        Text(
          "Nhập thông tin sản phẩm để thêm vào hệ thống",
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 6,
      shadowColor: Colors.blue.shade100.withOpacity(0.3),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(getProportionateScreenWidth(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(16)),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(8)),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.montserrat(
            color: Colors.blue.shade600,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: GoogleFonts.montserrat(
            color: Colors.grey.shade400,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(16),
            horizontal: getProportionateScreenWidth(16),
          ),
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

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.save_alt,
            size: 24,
            color: Colors.white,
          ),
          label: Text(
            "Lưu Sản Phẩm",
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          onPressed: _saveProduct,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(16),
            ),
            elevation: 4,
            shadowColor: Colors.blue.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}