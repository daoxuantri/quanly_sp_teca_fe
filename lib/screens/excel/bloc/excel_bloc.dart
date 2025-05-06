// import 'dart:io';
// import 'package:bloc/bloc.dart';
// import 'package:excel/excel.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:quanly_sp_teca_fe/api/investor_info.dart';
// import 'package:quanly_sp_teca_fe/api/product_price.dart';
// import 'package:quanly_sp_teca_fe/model/investor_info/product_for_proj/prod_for_proj_data.dart';
// import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';
// import 'package:quanly_sp_teca_fe/screens/excel/bloc/excel_bloc.dart';
// import 'package:quanly_sp_teca_fe/screens/excel/excel_export_screen.dart';
// import 'package:share_plus/share_plus.dart';

// part 'excel_event.dart';
// part 'excel_state.dart';

// class ExcelBloc extends Bloc<ExcelEvent, ExcelState> {
//   ExcelBloc() : super(ExcelInitial()) {
//     on<ExcelInitialEvent>(excelInitialEvent);
//     on<ExcelSelectOptionEvent>(excelSelectOptionEvent);
//     on<ExcelSelectProductEvent>(excelSelectProductEvent);
//     on<ExcelSelectProjectEvent>(excelSelectProjectEvent);
//     on<ExcelExportEvent>(excelExportEvent);
//   }

//   Future<void> excelInitialEvent(
//       ExcelInitialEvent event, Emitter<ExcelState> emit) async {
//     emit(ExcelLoadingState());
//     try {
//       //Lấy danh sách sản phẩm đã hỏi giá
//       List<ProductPriceModel> products =
//           await ApiServiceProductPrice().getAllProduct();
//       // Lấy danh sách dự án
//       List<ProductForProjectDataModel> projects =
//           await ApiServiceInvestorInfo().getProductForProject();
//       emit(ExcelOptionSelectedState(
//         selectedOption: ExportOption.none,
//         products: products,
//         projects: projects,
//         selectedProductNames: [],
//         selectedProjectNames: [],
//       ));
//     } catch (e) {
//       emit(ExcelErrorState(errorMessage: 'Lỗi khi tải dữ liệu: $e'));
//     }
//   }

//   Future<void> excelSelectOptionEvent(
//       ExcelSelectOptionEvent event, Emitter<ExcelState> emit) async {
//     if (state is ExcelOptionSelectedState) {
//       final currentState = state as ExcelOptionSelectedState;
//       emit(ExcelOptionSelectedState(
//         selectedOption: event.option,
//         products: currentState.products,
//         projects: currentState.projects,
//         selectedProductNames: currentState.selectedProductNames,
//         selectedProjectNames: currentState.selectedProjectNames,
//       ));
//     } else {
//       try {
//         List<ProductPriceModel> products =
//             await ApiServiceProductPrice().getAllProduct();
//         List<ProductForProjectDataModel> projects =
//             await ApiServiceInvestorInfo().getProductForProject();
//         emit(ExcelOptionSelectedState(
//           selectedOption: event.option,
//           products: products,
//           projects: projects,
//           selectedProductNames: [],
//           selectedProjectNames: [],
//         ));
//       } catch (e) {
//         emit(ExcelErrorState(errorMessage: 'Lỗi khi tải dữ liệu: $e'));
//       }
//     }
//   }

//   Future<void> excelSelectProductEvent(
//       ExcelSelectProductEvent event, Emitter<ExcelState> emit) async {
//     if (state is ExcelOptionSelectedState) {
//       final currentState = state as ExcelOptionSelectedState;
//       final updatedProductNames = List<String>.from(currentState.selectedProductNames);
//       if (event.isSelected) {
//         if (!updatedProductNames.contains(event.productName)) {
//           updatedProductNames.add(event.productName);
//         }
//       } else {
//         updatedProductNames.remove(event.productName);
//       }
//       emit(ExcelOptionSelectedState(
//         selectedOption: currentState.selectedOption,
//         products: currentState.products,
//         projects: currentState.projects,
//         selectedProductNames: updatedProductNames,
//         selectedProjectNames: currentState.selectedProjectNames,
//       ));
//     }
//   }

//   Future<void> excelSelectProjectEvent(
//       ExcelSelectProjectEvent event, Emitter<ExcelState> emit) async {
//     if (state is ExcelOptionSelectedState) {
//       final currentState = state as ExcelOptionSelectedState;
//       final updatedProjectNames = List<String>.from(currentState.selectedProjectNames);
//       if (event.isSelected) {
//         if (!updatedProjectNames.contains(event.projectName)) {
//           updatedProjectNames.add(event.projectName);
//         }
//       } else {
//         updatedProjectNames.remove(event.projectName);
//       }
//       emit(ExcelOptionSelectedState(
//         selectedOption: currentState.selectedOption,
//         products: currentState.products,
//         projects: currentState.projects,
//         selectedProductNames: currentState.selectedProductNames,
//         selectedProjectNames: updatedProjectNames,
//       ));
//     }
//   }

//   Future<void> excelExportEvent(
//       ExcelExportEvent event, Emitter<ExcelState> emit) async {
//     if (state is ExcelOptionSelectedState) {
//       final currentState = state as ExcelOptionSelectedState;
//       emit(ExcelLoadingState());
//       try {
//         List<Map<String, dynamic>> exportData = [];
//         String fileName = '';

//         if (currentState.selectedOption == ExportOption.byProduct) {
//           if (currentState.selectedProductNames.isEmpty) {
//             emit(ExcelErrorState(
//                 errorMessage: 'Vui lòng chọn ít nhất một sản phẩm'));
//             return;
//           }
//           fileName = 'sanpham_export';
//           exportData = currentState.products
//               .where((product) =>
//                   currentState.selectedProductNames.contains(product.name))
//               .map((product) => {
//                     "Tên sản phẩm": product.name ?? 'Không có',
//                     "Mã sản phẩm": product.code ?? 'Không có',
//                     "Giá": product.price?.isNotEmpty ?? false
//                         ? product.price!.first.price ?? 0
//                         : 0,
//                     "Nhà cung cấp": product.priceEntries?.isNotEmpty ?? false
//                         ? product.priceEntries!.first.supplier ?? 'Không có'
//                         : 'Không có',
//                   })
//               .toList();
//         } else if (currentState.selectedOption == ExportOption.byProject) {
//           if (currentState.selectedProjectNames.isEmpty) {
//             emit(ExcelErrorState(
//                 errorMessage: 'Vui lòng chọn ít nhất một dự án'));
//             return;
//           }
//           fileName = 'duan_export';
//           exportData = [];
//           for (var projectName in currentState.selectedProjectNames) {
//             final selectedProject = currentState.projects
//                 .firstWhere((project) => project.projectName == projectName);
//             final projectData = selectedProject.products?.map((product) => {
//                       "Tên dự án": selectedProject.projectName ?? 'Không có',
//                       "Tên sản phẩm": product.name ?? 'Không có',
//                       "Mã sản phẩm": product.code ?? 'Không có',
//                       "Chi tiết sản phẩm": product.specificProduct ?? 'Không có',
//                       "Đơn vị": product.unit ?? 'Không có',
//                       "Giá nhập": product.priceNhap ?? 0,
//                       "Giá bán": product.priceBan ?? 0,
//                       "Số lượng": product.quantity ?? 0,
//                       "Tổng nhập": product.totalNhap ?? 0,
//                       "Tổng bán": product.totalBan ?? 0,
//                       "Xuất xứ": product.origin ?? 'Không có',
//                       "Thương hiệu": product.brand ?? 'Không có',
//                       "Nhà cung cấp": product.supplier ?? 'Không có',
//                       "Ngày hỏi giá": product.priceDate ?? 'Không có',
//                       "Người hỏi giá": product.asker ?? 'Không có',
//                       "Ghi chú": product.note ?? 'Không có',
//                     }).toList() ??
//                 [];
//             exportData.addAll(projectData);
//           }
//         }

//         if (exportData.isEmpty) {
//           emit(ExcelErrorState(errorMessage: 'Không có dữ liệu để xuất'));
//           return;
//         }

//         var excel = Excel.createExcel();
//         Sheet sheetObject = excel['Sheet1'];

//         if (exportData.isNotEmpty) {
//           sheetObject.appendRow(exportData.first.keys.toList());
//         }

//         for (var item in exportData) {
//           sheetObject.appendRow(item.values.toList());
//         }

//         var status = await Permission.storage.request();
//         if (!status.isGranted) {
//           emit(ExcelErrorState(errorMessage: 'Không có quyền lưu file'));
//           return;
//         }

//         final directory = await getApplicationDocumentsDirectory();
//         final filePath = '${directory.path}/$fileName.xlsx';

//         final fileBytes = excel.encode();
//         final File file = File(filePath)
//           ..createSync(recursive: true)
//           ..writeAsBytesSync(fileBytes!);

//         // Thử mở file
//         final openResult = await OpenFile.open(filePath);
//         if (openResult.type != ResultType.done) {
//           await Share.shareFiles([filePath],
//               text:
//                   'Không thể mở file. Bạn có thể chia sẻ file này để xem trên thiết bị khác.');
//           emit(ExcelExportSuccessState(
//               message:
//                   'Xuất Excel thành công. Không có ứng dụng để mở file, đã chia sẻ file. File lưu tại: $filePath'));
//           return;
//         }

//         emit(ExcelExportSuccessState(
//             message: 'Xuất Excel thành công và đã mở file'));
//       } catch (e) {
//         emit(ExcelErrorState(errorMessage: 'Lỗi khi xuất file: $e'));
//       }
//     }
//   }
// }



import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quanly_sp_teca_fe/api/investor_info.dart';
import 'package:quanly_sp_teca_fe/api/product_price.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/product_for_proj/prod_for_proj_data.dart';
import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';
import 'package:quanly_sp_teca_fe/screens/excel/bloc/excel_bloc.dart';
import 'package:quanly_sp_teca_fe/screens/excel/excel_export_screen.dart';
import 'package:share_plus/share_plus.dart';

part 'excel_event.dart';
part 'excel_state.dart';

class ExcelBloc extends Bloc<ExcelEvent, ExcelState> {
  ExcelBloc() : super(ExcelInitial()) {
    on<ExcelInitialEvent>(excelInitialEvent);
    on<ExcelSelectOptionEvent>(excelSelectOptionEvent);
    on<ExcelSelectProductEvent>(excelSelectProductEvent);
    on<ExcelSelectProjectEvent>(excelSelectProjectEvent);
    on<ExcelExportEvent>(excelExportEvent);
  }

  Future<void> excelInitialEvent(
      ExcelInitialEvent event, Emitter<ExcelState> emit) async {
    emit(ExcelLoadingState());
    try {
      // Lấy danh sách sản phẩm đã hỏi giá
      List<ProductPriceModel> products =
          await ApiServiceProductPrice().getAllProduct();
      // Lấy danh sách dự án
      List<ProductForProjectDataModel> projects =
          await ApiServiceInvestorInfo().getProductForProject();
      emit(ExcelOptionSelectedState(
        selectedOption: ExportOption.none,
        products: products,
        projects: projects,
        selectedProductNames: [],
        selectedProjectNames: [],
      ));
    } catch (e) {
      emit(ExcelErrorState(errorMessage: 'Lỗi khi tải dữ liệu: $e'));
    }
  }

  Future<void> excelSelectOptionEvent(
      ExcelSelectOptionEvent event, Emitter<ExcelState> emit) async {
    if (state is ExcelOptionSelectedState) {
      final currentState = state as ExcelOptionSelectedState;
      emit(ExcelOptionSelectedState(
        selectedOption: event.option,
        products: currentState.products,
        projects: currentState.projects,
        selectedProductNames: currentState.selectedProductNames,
        selectedProjectNames: currentState.selectedProjectNames,
      ));
    } else {
      try {
        List<ProductPriceModel> products =
            await ApiServiceProductPrice().getAllProduct();
        List<ProductForProjectDataModel> projects =
            await ApiServiceInvestorInfo().getProductForProject();
        emit(ExcelOptionSelectedState(
          selectedOption: event.option,
          products: products,
          projects: projects,
          selectedProductNames: [],
          selectedProjectNames: [],
        ));
      } catch (e) {
        emit(ExcelErrorState(errorMessage: 'Lỗi khi tải dữ liệu: $e'));
      }
    }
  }

  Future<void> excelSelectProductEvent(
      ExcelSelectProductEvent event, Emitter<ExcelState> emit) async {
    if (state is ExcelOptionSelectedState) {
      final currentState = state as ExcelOptionSelectedState;
      final updatedProductNames = List<String>.from(currentState.selectedProductNames);
      if (event.isSelected) {
        if (!updatedProductNames.contains(event.productName)) {
          updatedProductNames.add(event.productName);
        }
      } else {
        updatedProductNames.remove(event.productName);
      }
      emit(ExcelOptionSelectedState(
        selectedOption: currentState.selectedOption,
        products: currentState.products,
        projects: currentState.projects,
        selectedProductNames: updatedProductNames,
        selectedProjectNames: currentState.selectedProjectNames,
      ));
    }
  }

  Future<void> excelSelectProjectEvent(
      ExcelSelectProjectEvent event, Emitter<ExcelState> emit) async {
    if (state is ExcelOptionSelectedState) {
      final currentState = state as ExcelOptionSelectedState;
      final updatedProjectNames = List<String>.from(currentState.selectedProjectNames);
      if (event.isSelected) {
        if (!updatedProjectNames.contains(event.projectName)) {
          updatedProjectNames.add(event.projectName);
        }
      } else {
        updatedProjectNames.remove(event.projectName);
      }
      emit(ExcelOptionSelectedState(
        selectedOption: currentState.selectedOption,
        products: currentState.products,
        projects: currentState.projects,
        selectedProductNames: currentState.selectedProductNames,
        selectedProjectNames: updatedProjectNames,
      ));
    }
  }

  Future<void> excelExportEvent(
      ExcelExportEvent event, Emitter<ExcelState> emit) async {
    if (state is ExcelOptionSelectedState) {
      final currentState = state as ExcelOptionSelectedState;
      emit(ExcelLoadingState());
      try {
        List<Map<String, dynamic>> exportData = [];
        String fileName = '';

        if (currentState.selectedOption == ExportOption.byProduct) {
          if (currentState.selectedProductNames.isEmpty) {
            emit(ExcelErrorState(
                errorMessage: 'Vui lòng chọn ít nhất một sản phẩm'));
            return;
          }
          fileName = 'sanpham_export';
          exportData = currentState.products
              .where((product) =>
                  currentState.selectedProductNames.contains(product.name))
              .map((product) => {
                    "Tên sản phẩm": product.name ?? 'Không có',
                    "Mã sản phẩm": product.code ?? 'Không có',
                    "Giá": product.price ?? 0,
                    "Nhà cung cấp": product.supplier ?? 'Không có',
                  })
              .toList();
        } else if (currentState.selectedOption == ExportOption.byProject) {
          if (currentState.selectedProjectNames.isEmpty) {
            emit(ExcelErrorState(
                errorMessage: 'Vui lòng chọn ít nhất một dự án'));
            return;
          }
          fileName = 'duan_export';
          exportData = [];
          for (var projectName in currentState.selectedProjectNames) {
            final selectedProject = currentState.projects
                .firstWhere((project) => project.projectName == projectName);
            final projectData = selectedProject.products?.map((product) => {
                      "Tên dự án": selectedProject.projectName ?? 'Không có',
                      "Tên sản phẩm": product.name ?? 'Không có',
                      "Mã sản phẩm": product.code ?? 'Không có',
                      "Chi tiết sản phẩm": product.specificProduct ?? 'Không có',
                      "Đơn vị": product.unit ?? 'Không có',
                      "Giá nhập": product.priceNhap ?? 0,
                      "Giá bán": product.priceBan ?? 0,
                      "Số lượng": product.quantity ?? 0,
                      "Tổng nhập": product.totalNhap ?? 0,
                      "Tổng bán": product.totalBan ?? 0,
                      "Xuất xứ": product.origin ?? 'Không có',
                      "Thương hiệu": product.brand ?? 'Không có',
                      "Nhà cung cấp": product.supplier ?? 'Không có',
                      "Ngày hỏi giá": product.priceDate ?? 'Không có',
                      "Người hỏi giá": product.asker ?? 'Không có',
                      "Ghi chú": product.note ?? 'Không có',
                    }).toList() ??
                [];
            exportData.addAll(projectData);
          }
        }

        if (exportData.isEmpty) {
          emit(ExcelErrorState(errorMessage: 'Không có dữ liệu để xuất'));
          return;
        }

        var excel = Excel.createExcel();
        Sheet sheetObject = excel['Sheet1'];

        if (exportData.isNotEmpty) {
          sheetObject.appendRow(exportData.first.keys.toList());
        }

        for (var item in exportData) {
          sheetObject.appendRow(item.values.toList());
        }

        var status = await Permission.storage.request();
        if (!status.isGranted) {
          emit(ExcelErrorState(errorMessage: 'Không có quyền lưu file'));
          return;
        }

        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName.xlsx';

        final fileBytes = excel.encode();
        final File file = File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);

        // Thử mở file
        final openResult = await OpenFile.open(filePath);
        if (openResult.type != ResultType.done) {
          await Share.shareFiles([filePath],
              text:
                  'Không thể mở file. Bạn có thể chia sẻ file này để xem trên thiết bị khác.');
          emit(ExcelExportSuccessState(
              message:
                  'Xuất Excel thành công. Không có ứng dụng để mở file, đã chia sẻ file. File lưu tại: $filePath'));
          return;
        }

        emit(ExcelExportSuccessState(
            message: 'Xuất Excel thành công và đã mở file'));
      } catch (e) {
        emit(ExcelErrorState(errorMessage: 'Lỗi khi xuất file: $e'));
      }
    }
  }
}