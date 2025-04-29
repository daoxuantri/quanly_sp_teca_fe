// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quanly_sp_teca_fe/components_buttons/snackbar.dart';
// import 'package:quanly_sp_teca_fe/model/product/detail/detail_product_data_model.dart';
// import 'package:quanly_sp_teca_fe/screens/excel/bloc/excel_bloc.dart';

// class ExcelExportScreen extends StatefulWidget {
//   static String routeName = "/excel-export";

//   const ExcelExportScreen({super.key});

//   @override
//   State<ExcelExportScreen> createState() => _ExcelExportScreenState();
// }

// enum ExportOption { none, byProduct }

// class _ExcelExportScreenState extends State<ExcelExportScreen> {
//   final ExcelBloc excelBloc = ExcelBloc();

//   @override
//   void initState() {
//     super.initState();
//     excelBloc.add(ExcelInitialEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ExcelBloc, ExcelState>(
//       bloc: excelBloc,
//       listenWhen: (previous, current) => current is ExcelActionState,
//       buildWhen: (previous, current) => current is! ExcelActionState,
//       listener: (context, state) {
//         if (state is ExcelExportSuccessState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBarLoginSuccess(state.message),
//           );
//           Navigator.pop(context);
//         } else if (state is ExcelErrorState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('❌ ${state.errorMessage}'),
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         if (state is ExcelLoadingState) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Xuất Excel'),
//               backgroundColor: Colors.blue.shade700,
//             ),
//             body: const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Đang tải dữ liệu...'),
//                 ],
//               ),
//             ),
//           );
//         } else if (state is ExcelErrorState) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Xuất Excel'),
//               backgroundColor: Colors.blue.shade700,
//             ),
//             body: Center(
//               child: Text(
//                 state.errorMessage,
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             ),
//           );
//         }

//         ExportOption selectedOption = ExportOption.none;
//         List<DetailProductData> products = [];
//         List<String> selectedProductNames = [];

//         if (state is ExcelOptionSelectedState) {
//           selectedOption = state.selectedOption;
//           products = state.products;
//           selectedProductNames = state.selectedProductNames;
//         }

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Xuất Excel'),
//             backgroundColor: Colors.blue.shade700,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: buildBody(
//               selectedOption,
//               products,
//               selectedProductNames,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget buildBody(
//     ExportOption selectedOption,
//     List<DetailProductData> products,
//     List<String> selectedProductNames,
//   ) {
//     switch (selectedOption) {
//       case ExportOption.none:
//         return Column(
//           children: [
//             buildCardOption(
//               title: "Xuất thông tin nhà cung cấp với từng sản phẩm",
//               onTap: () => excelBloc
//                   .add(ExcelSelectOptionEvent(option: ExportOption.byProduct)),
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
//               child: products.isEmpty
//                   ? const Center(child: Text('Không có sản phẩm nào'))
//                   : ListView(
//                       children: products.map((product) {
//                         return CheckboxListTile(
//                           title: Text(product.name ?? 'Không có tên'),
//                           value:
//                               selectedProductNames.contains(product.name),
//                           onChanged: (value) {
//                             excelBloc.add(ExcelSelectProductEvent(
//                               productName: product.name ?? '',
//                               isSelected: value ?? false,
//                             ));
//                           },
//                         );
//                       }).toList(),
//                     ),
//             ),
//             buildExportButton(enabled: selectedProductNames.isNotEmpty),
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
//           onPressed: enabled
//               ? () => excelBloc.add(const ExcelExportEvent())
//               : null,
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
import 'package:quanly_sp_teca_fe/model/investor_info/product_for_proj/prod_for_proj_data.dart';
import 'package:quanly_sp_teca_fe/model/product/detail/detail_product_data_model.dart';
import 'package:quanly_sp_teca_fe/screens/excel/bloc/excel_bloc.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class ExcelExportScreen extends StatefulWidget {
  static String routeName = "/excel-export";

  const ExcelExportScreen({super.key});

  @override
  State<ExcelExportScreen> createState() => _ExcelExportScreenState();
}

enum ExportOption { none, byProduct, byProject }

class _ExcelExportScreenState extends State<ExcelExportScreen> {
  final ExcelBloc excelBloc = ExcelBloc();

  @override
  void initState() {
    super.initState();
    excelBloc.add(ExcelInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<ExcelBloc, ExcelState>(
      bloc: excelBloc,
      listenWhen: (previous, current) =>
          current is ExcelActionState || current is ExcelErrorState,
      buildWhen: (previous, current) => current is! ExcelActionState,
      listener: (context, state) {
        if (state is ExcelExportSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(state.message),
          );
          Navigator.pop(context);
        } else if (state is ExcelErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBarLoginFail(state.errorMessage));
        }
      },
      builder: (context, state) {
        if (state is ExcelLoadingState) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Xuất Excel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  Text('Đang tải dữ liệu...'),
                ],
              ),
            ),
          );
        } else if (state is ExcelErrorState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Xuất Excel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
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
        List<ProductForProjectDataModel> projects = [];
        List<String> selectedProductNames = [];
        List<String> selectedProjectNames = [];

        if (state is ExcelOptionSelectedState) {
          selectedOption = state.selectedOption;
          products = state.products;
          projects = state.projects;
          selectedProductNames = state.selectedProductNames;
          selectedProjectNames = state.selectedProjectNames;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Xuất Excel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: buildBody(
              selectedOption,
              products,
              projects,
              selectedProductNames,
              selectedProjectNames,
            ),
          ),
        );
      },
    );
  }

  Widget buildBody(
    ExportOption selectedOption,
    List<DetailProductData> products,
    List<ProductForProjectDataModel> projects,
    List<String> selectedProductNames,
    List<String> selectedProjectNames,
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
            SizedBox(height: getProportionateScreenHeight(20)),
            buildCardOption(
              title: "Xuất thông tin dự án đã cung cấp",
              onTap: () => excelBloc
                  .add(ExcelSelectOptionEvent(option: ExportOption.byProject)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('Không có sản phẩm nào'))
                  : ListView(
                      children: products.map((product) {
                        return CheckboxListTile(
                          title: Text(product.name ?? 'Không có tên'),
                          value: selectedProductNames.contains(product.name),
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
      case ExportOption.byProject:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chọn dự án:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Expanded(
              child: projects.isEmpty
                  ? const Center(child: Text('Không có dự án nào'))
                  : ListView(
                      children: projects.map((project) {
                        return CheckboxListTile(
                          title: Text(project.projectName ?? 'Không có tên'),
                          value: selectedProjectNames
                              .contains(project.projectName),
                          onChanged: (value) {
                            excelBloc.add(ExcelSelectProjectEvent(
                              projectName: project.projectName ?? '',
                              isSelected: value ?? false,
                            ));
                          },
                        );
                      }).toList(),
                    ),
            ),
            buildExportButton(enabled: selectedProjectNames.isNotEmpty),
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
          onPressed:
              enabled ? () => excelBloc.add(const ExcelExportEvent()) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('Xuất Excel', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
