// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:quanly_sp_teca_fe/size_config.dart';

// class CRUDScreen extends StatefulWidget {
//   static String routeName = '/crud-screen';
//   const CRUDScreen({super.key});

//   @override
//   State<CRUDScreen> createState() => _CRUDScreenState();
// }

// class _CRUDScreenState extends State<CRUDScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController codeController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController specificProductController = TextEditingController();
//   final TextEditingController unitController = TextEditingController();
//   final TextEditingController noteController = TextEditingController();

//   void _saveProduct() {
//     if (_formKey.currentState!.validate()) {
//       final product = {
//         'code': codeController.text,
//         'name': nameController.text,
//         'specific_product': specificProductController.text,
//         'unit': unitController.text,
//         'note': noteController.text,
//       };

//       HapticFeedback.lightImpact();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "✅ Đã thêm sản phẩm: ${product['name']}",
//             style: GoogleFonts.montserrat(),
//           ),
//           backgroundColor: Colors.green.shade600,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );

//       // Clear form with animation
//       for (final controller in [
//         codeController,
//         nameController,
//         specificProductController,
//         unitController,
//         noteController,
//       ]) {
//         controller.clear();
//       }
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(
//           "Thêm sản phẩm",
//           style: GoogleFonts.montserrat(
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue.shade800,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blue.shade800, Colors.blue.shade600],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//             horizontal: getProportionateScreenWidth(16),
//             vertical: getProportionateScreenHeight(20),
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader(),
//                 SizedBox(height: getProportionateScreenHeight(20)),
//                 buildSectionCard("Thông tin sản phẩm", [
//                   buildTextField(
//                     "Mã sản phẩm",
//                     codeController,
//                     hint: "Nhập mã sản phẩm (VD: 4003DW)",
//                   ),
//                   buildTextField(
//                     "Tên sản phẩm",
//                     nameController,
//                     hint: "Nhập tên sản phẩm",
//                   ),
//                   buildTextField(
//                     "Chi tiết sản phẩm",
//                     specificProductController,
//                     hint: "Mô tả chi tiết sản phẩm",
//                     maxLines: 2,
//                   ),
//                   buildTextField(
//                     "Đơn vị",
//                     unitController,
//                     hint: "VD: Bộ, Cái, Hệ thống",
//                   ),
//                   buildTextField(
//                     "Ghi chú",
//                     noteController,
//                     hint: "Thông tin bổ sung (nếu có)",
//                     maxLines: 3,
//                   ),
//                 ]),
//                 SizedBox(height: getProportionateScreenHeight(30)),
//                 _buildSaveButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Tạo sản phẩm mới",
//           style: GoogleFonts.montserrat(
//             fontSize: 24,
//             fontWeight: FontWeight.w700,
//             color: Colors.blue.shade900,
//           ),
//         ),
//         SizedBox(height: getProportionateScreenHeight(8)),
//         Text(
//           "Nhập thông tin sản phẩm để thêm vào hệ thống",
//           style: GoogleFonts.montserrat(
//             fontSize: 14,
//             color: Colors.grey.shade600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildSectionCard(String title, List<Widget> children) {
//     return Card(
//       elevation: 6,
//       shadowColor: Colors.blue.shade100.withOpacity(0.3),
//       margin: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: EdgeInsets.all(getProportionateScreenWidth(16)),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: GoogleFonts.montserrat(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 18,
//                 color: Colors.blue.shade700,
//               ),
//             ),
//             SizedBox(height: getProportionateScreenHeight(16)),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(
//     String label,
//     TextEditingController controller, {
//     String? hint,
//     bool isNumber = false,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(8)),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//         maxLines: maxLines,
//         style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black87),
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           labelStyle: GoogleFonts.montserrat(
//             color: Colors.blue.shade600,
//             fontWeight: FontWeight.w500,
//           ),
//           hintStyle: GoogleFonts.montserrat(
//             color: Colors.grey.shade400,
//           ),
//           floatingLabelBehavior: FloatingLabelBehavior.auto,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.red.shade400),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.red.shade400, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.grey.shade50,
//           contentPadding: EdgeInsets.symmetric(
//             vertical: getProportionateScreenHeight(16),
//             horizontal: getProportionateScreenWidth(16),
//           ),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Vui lòng nhập $label';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _buildSaveButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         child: ElevatedButton.icon(
//           icon: Icon(
//             Icons.save_alt,
//             size: 24,
//             color: Colors.white,
//           ),
//           label: Text(
//             "Lưu Sản Phẩm",
//             style: GoogleFonts.montserrat(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           onPressed: _saveProduct,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue.shade700,
//             foregroundColor: Colors.white,
//             padding: EdgeInsets.symmetric(
//               vertical: getProportionateScreenHeight(16),
//             ),
//             elevation: 4,
//             shadowColor: Colors.blue.shade200,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quanly_sp_teca_fe/components_buttons/loading.dart';
import 'package:quanly_sp_teca_fe/screens/CRUD/bloc/crud_bloc.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class CRUDScreen extends StatefulWidget {
  static String routeName = '/crud-screen';
  const CRUDScreen({super.key});

  @override
  State<CRUDScreen> createState() => _CRUDScreenState();
}

class _CRUDScreenState extends State<CRUDScreen> {
  final _formKey = GlobalKey<FormState>();
  final CRUDBloc crudBloc = CRUDBloc();

  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController specificProductController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController priceDateController = TextEditingController();
  final TextEditingController originController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController askerController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    crudBloc.add(CRUDInitialScreenEvent());
    super.initState();
  }

  void _saveProduct(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Chuyển đổi priceController.text thành int
      final price = int.tryParse(priceController.text) ?? 0;

      crudBloc.add(CRUDAddProductClickedEvent(
        code: codeController.text,
        name: nameController.text,
        specific_product: specificProductController.text,
        unit: unitController.text,
        price: price, // Truyền trực tiếp int
        price_date: priceDateController.text,
        origin: originController.text,
        brand: brandController.text,
        supplier: supplierController.text,
        asker: askerController.text,
        note: noteController.text,
      ));

      // Clear form with animation
      for (final controller in [
        codeController,
        nameController,
        specificProductController,
        unitController,
        priceController,
        priceDateController,
        originController,
        brandController,
        supplierController,
        askerController,
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
    return BlocConsumer<CRUDBloc, CRUDState>(
      bloc: crudBloc,
      listenWhen: (previous, current) => current is CRUDActionState || current is CRUDErrorState,
      buildWhen: (previous, current) => current is! CRUDActionState && current is! CRUDErrorState,
      listener: (context, state) {
        if (state is CRUDAddProductClickedState) {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "✅ Đã thêm sản phẩm: ${state.message}",
                style: GoogleFonts.montserrat(),
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );

          setState(() {
            crudBloc.add(CRUDInitialScreenEvent());
          });
        } else if (state is CRUDErrorScreenToLoginState) {
          Navigator.pushReplacementNamed(context, '/login-screen');
        } else if (state is CRUDErrorState) {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "❌ Lỗi: ${state.errorMessage}",
                style: GoogleFonts.montserrat(),
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case CRUDLoadingState:
            return Center(child: LoadingScreen());
          case CRUDInitialScreenState:
            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                title: Text(
                  "Thêm sản phẩm",
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
                            "Giá",
                            priceController,
                            hint: "Nhập giá (VD: 1000000)",
                            isNumber: true,
                          ),
                          buildTextField(
                            "Ngày giá",
                            priceDateController,
                            hint: "VD: 2025-05-02",
                          ),
                          buildTextField(
                            "Nguồn gốc",
                            originController,
                            hint: "Nhập nguồn gốc sản phẩm",
                          ),
                          buildTextField(
                            "Thương hiệu",
                            brandController,
                            hint: "Nhập thương hiệu",
                          ),
                          buildTextField(
                            "Nhà cung cấp",
                            supplierController,
                            hint: "Nhập nhà cung cấp",
                          ),
                          buildTextField(
                            "Người hỏi giá",
                            askerController,
                            hint: "Nhập tên người hỏi giá",
                          ),
                          buildTextField(
                            "Ghi chú",
                            noteController,
                            hint: "Thông tin bổ sung (nếu có)",
                            maxLines: 3,
                          ),
                        ]),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        _buildSaveButton(context),
                      ],
                    ),
                  ),
                ),
              ),
            );
          
          
          default:
            return SizedBox();
        }
      },
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
          if ((label == "Mã sản phẩm" ||
                  label == "Giá" ||
                  label == "Nhà cung cấp" ||
                  label == "Người hỏi giá") &&
              (value == null || value.isEmpty)) {
            return 'Vui lòng nhập $label';
          }
          if (label == "Giá" && value != null) {
            final parsedPrice = int.tryParse(value);
            if (parsedPrice == null || parsedPrice <= 0) {
              return 'Giá phải là số nguyên dương hợp lệ';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
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
          onPressed: () => _saveProduct(context),
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