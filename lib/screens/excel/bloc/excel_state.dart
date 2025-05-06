part of 'excel_bloc.dart';

abstract class ExcelState {
  const ExcelState();
}

abstract class ExcelActionState extends ExcelState {}

class ExcelInitial extends ExcelState {}

class ExcelLoadingState extends ExcelState {}

class ExcelExportSuccessState extends ExcelActionState {
  final String message;
  ExcelExportSuccessState({required this.message});
}

class ExcelErrorState extends ExcelState {
  final String errorMessage;
  const ExcelErrorState({required this.errorMessage});
}

class ExcelOptionSelectedState extends ExcelState {
  final ExportOption selectedOption;
  final List<ProductPriceModel> products;
  final List<ProductForProjectDataModel> projects;
  final List<String> selectedProductNames;
  final List<String> selectedProjectNames;
  const ExcelOptionSelectedState({
    required this.selectedOption,
    required this.products,
    required this.projects,
    this.selectedProductNames = const [],
    this.selectedProjectNames = const [],
  });
}