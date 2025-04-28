part of 'detail_bloc.dart';

abstract class DetailEvent {
  const DetailEvent();
}

class DetailInitialEvent extends DetailEvent {
  final int productId;
  const DetailInitialEvent({required this.productId});
}

class DetailErrorScreenToLoginEvent extends DetailEvent {}

class DetailProductClickedEvent extends DetailEvent {
  final int productId;
  const DetailProductClickedEvent({
    required this.productId,
  });
}

class EditDetailMainProductClickedEvent extends DetailEvent {
  final int productId;
  final String code;
  final String name;
  final String specificProduct;
  final String unit;
  final String note;
  const EditDetailMainProductClickedEvent({
    required this.code,
    required this.name,
    required this.specificProduct,
    required this.unit,
    required this.note,
    required this.productId,
  });
}

class DeletePriceEntriesClickedEvent extends DetailEvent {
  final int idPriceEntries; 
  const DeletePriceEntriesClickedEvent({
    required this.idPriceEntries
  });
}

