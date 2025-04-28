import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quanly_sp_teca_fe/api/price_entries.dart';
import 'package:quanly_sp_teca_fe/model/product/detail/detail_product_data_model.dart';
import 'package:quanly_sp_teca_fe/screens/excel/excel_export_screen.dart';

part 'excel_event.dart';
part 'excel_state.dart';

class ExcelBloc extends Bloc<ExcelEvent, ExcelState> {
  ExcelBloc() : super(ExcelInitial()) {
    on<ExcelInitialEvent>(excelInitialEvent);
    on<ExcelSelectOptionEvent>(excelSelectOptionEvent);
    on<ExcelSelectProductEvent>(excelSelectProductEvent);
    on<ExcelExportEvent>(excelExportEvent);
  }

  Future<void> excelInitialEvent(
      ExcelInitialEvent event, Emitter<ExcelState> emit) async {
    emit(ExcelLoadingState());
    try {
      List<DetailProductData> products =
          await ApiServicePriceEntries().getPriceEntriesForProduct();
      emit(ExcelOptionSelectedState(
        selectedOption: ExportOption.none,
        products: products,
        selectedProductNames: [],
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
        selectedProductNames: currentState.selectedProductNames,
      ));
    } else {
      try {
        List<DetailProductData> products =
            await ApiServicePriceEntries().getPriceEntriesForProduct();
        emit(ExcelOptionSelectedState(
          selectedOption: event.option,
          products: products,
          selectedProductNames: [],
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
        selectedProductNames: updatedProductNames,
      ));
    }
  }

  Future<void> excelExportEvent(
      ExcelExportEvent event, Emitter<ExcelState> emit) async {
    if (state is ExcelOptionSelectedState) {
      final currentState = state as ExcelOptionSelectedState;
      emit(ExcelLoadingState());
      try {
        if (currentState.selectedProductNames.isEmpty) {
          emit(ExcelErrorState(errorMessage: 'Vui lòng chọn ít nhất một sản phẩm'));
          return;
        }

        // Lọc sản phẩm đã chọn
        final exportData = currentState.products
            .where((product) =>
                currentState.selectedProductNames.contains(product.name))
            .map((product) => {
                  "Tên sản phẩm": product.name ?? 'Không có',
                  "Mã sản phẩm": product.code ?? 'Không có',
                  "Giá": product.priceEntries?.isNotEmpty ?? false
                      ? product.priceEntries!.first.price ?? 0
                      : 0,
                  "Nhà cung cấp": product.priceEntries?.isNotEmpty ?? false
                      ? product.priceEntries!.first.supplier ?? 'Không có'
                      : 'Không có',
                })
            .toList();

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

        final directory = await getApplicationDocumentsDirectory(); // Đổi sang thư mục tài liệu
        const fileName = 'sanpham_export';
        final filePath = '${directory.path}/$fileName.xlsx';

        final fileBytes = excel.encode();
        final File file = File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);

        // Mở file sau khi lưu
        final openResult = await OpenFile.open(filePath);
        if (openResult.type != ResultType.done) {
          emit(ExcelErrorState(
              errorMessage: 'Không thể mở file: ${openResult.message}'));
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