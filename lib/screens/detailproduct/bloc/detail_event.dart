// part of 'detail_bloc.dart';

// abstract class DetailEvent {
//   const DetailEvent();
// }

// class EditDetailMainProductClickedEvent extends DetailEvent {
//   final int productId;
//   final String code;
//   final String name;
//   final String specificProduct;
//   final String unit;
//   final int price;
//   final String priceDate;
//   final String origin;
//   final String brand;
//   final String supplier;
//   final String asker;
//   final String note;
//   const EditDetailMainProductClickedEvent({
//     required this.productId,
//     required this.code,
//     required this.name,
//     required this.specificProduct,
//     required this.unit,
//     required this.price,
//     required this.priceDate,
//     required this.origin,
//     required this.brand,
//     required this.supplier,
//     required this.asker,
//     required this.note,
//   });
// }

// class DeleteProductClickedEvent extends DetailEvent {
//   final int productId;
//   const DeleteProductClickedEvent({
//     required this.productId,
//   });
// }




part of 'detail_bloc.dart';

abstract class DetailEvent {
  const DetailEvent();
}

class EditDetailMainProductClickedEvent extends DetailEvent {
  final int productId;
  final String code;
  final String? name;
  final String? specificProduct;
  final String? unit;
  final int? price;
  final String priceDate;
  final String? origin;
  final String? brand;
  final String supplier;
  final String asker;
  final String? note;
  const EditDetailMainProductClickedEvent({
    required this.productId,
    required this.code,
    required this.name,
    required this.specificProduct,
    required this.unit,
    required this.price,
    required this.priceDate,
    required this.origin,
    required this.brand,
    required this.supplier,
    required this.asker,
    required this.note,
  });
}

class DeleteProductClickedEvent extends DetailEvent {
  final int productId;
  const DeleteProductClickedEvent({
    required this.productId,
  });
}