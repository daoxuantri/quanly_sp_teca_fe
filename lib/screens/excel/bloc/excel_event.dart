part of 'excel_bloc.dart';

abstract class ExcelEvent {
  const ExcelEvent();
}

class ExcelInitialEvent extends ExcelEvent {}

class ExcelSelectOptionEvent extends ExcelEvent {
  final ExportOption option;
  const ExcelSelectOptionEvent({required this.option});
}

class ExcelSelectProductEvent extends ExcelEvent {
  final String productName;
  final bool isSelected;
  const ExcelSelectProductEvent({
    required this.productName,
    required this.isSelected,
  });
}

class ExcelExportEvent extends ExcelEvent {
  const ExcelExportEvent();
}