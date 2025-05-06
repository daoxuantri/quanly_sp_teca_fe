part of "crud_bloc.dart";

abstract class CRUDEvent {
  const CRUDEvent();
}

class CRUDInitialEvent extends CRUDEvent {}

class CRUDErrorScreenToLoginEvent extends CRUDEvent {}

//tra trang thai state 1 bloc dung 2 screen
class CRUDInitialScreenEvent extends CRUDEvent {}

class CRUDProductClickedEvent extends CRUDEvent {
  final String productId;
  const CRUDProductClickedEvent({
    required this.productId,
  });
}

class CRUDAddProductClickedEvent extends CRUDEvent {
  final String code;
  final String name;
  final String specific_product;
  final String unit;
  final int price;
  final String price_date;
  final String origin;
  final String brand;
  final String supplier;
  final String asker;
  final String note;
  const CRUDAddProductClickedEvent({
    required this.code,
    required this.name,
    required this.specific_product,
    required this.unit,
    required this.price,
    required this.price_date,
    required this.origin,
    required this.brand,
    required this.supplier,
    required this.asker,
    required this.note,
  });
}
