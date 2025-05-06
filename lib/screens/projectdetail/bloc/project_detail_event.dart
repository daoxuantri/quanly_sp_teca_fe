// part of 'project_detail_bloc.dart';

// abstract class ProjectDetailEvent {
//   const ProjectDetailEvent();
// }

// class ProjectDetailInitialEvent extends ProjectDetailEvent {
//   final int projectId;
//   const ProjectDetailInitialEvent({required this.projectId});
// }

// class ProjectDetailFetchProductsEvent extends ProjectDetailEvent {
//   final int projectId;
//   const ProjectDetailFetchProductsEvent({required this.projectId});
// }

// class ProjectDetailFetchPriceEntriesEvent extends ProjectDetailEvent {
//   final int? projectId;
//   const ProjectDetailFetchPriceEntriesEvent({this.projectId});
// }

// class ProjectDetailAddProductEvent extends ProjectDetailEvent {
//   final int idInvestor;
//   final int priceEntriesId;
//   final double priceNhap;
//   final double priceBan;
//   final int quantity;
//   const ProjectDetailAddProductEvent({
//     required this.idInvestor,
//     required this.priceEntriesId,
//     required this.priceNhap,
//     required this.priceBan,
//     required this.quantity,
//   });
// }

// class ProjectDetailDeleteProductEvent extends ProjectDetailEvent {
//   final int productId;
//   final int projectId;
//   const ProjectDetailDeleteProductEvent({
//     required this.productId,
//     required this.projectId,
//   });
// }

// class ProjectDetailCancelAddProductEvent extends ProjectDetailEvent {}




part of 'project_detail_bloc.dart';

abstract class ProjectDetailEvent {
  const ProjectDetailEvent();
}

class ProjectDetailInitialEvent extends ProjectDetailEvent {
  final int projectId;
  const ProjectDetailInitialEvent({required this.projectId});
}

class ProjectDetailFetchProductsEvent extends ProjectDetailEvent {
  final int projectId;
  const ProjectDetailFetchProductsEvent({required this.projectId});
}

class ProjectDetailFetchPriceEntriesEvent extends ProjectDetailEvent {
  final int? projectId;
  const ProjectDetailFetchPriceEntriesEvent({this.projectId});
}

class ProjectDetailAddProductEvent extends ProjectDetailEvent {
  final int idInvestor;
  final int priceEntriesId;
  final double priceNhap;
  final double priceBan;
  final int quantity;
  const ProjectDetailAddProductEvent({
    required this.idInvestor,
    required this.priceEntriesId,
    required this.priceNhap,
    required this.priceBan,
    required this.quantity,
  });
}

class ProjectDetailDeleteProductEvent extends ProjectDetailEvent {
  final int productId;
  final int projectId;
  const ProjectDetailDeleteProductEvent({
    required this.productId,
    required this.projectId,
  });
}

class ProjectDetailCreateProductEvent extends ProjectDetailEvent {
  final String code;
  final String? name;
  final String? specificProduct;
  final String? unit;
  final int? price;
  final String? priceDate;
  final String? origin;
  final String? brand;
  final String? supplier;
  final String? asker;
  final String? note;
  final int projectId;
  final String searchQuery;

  const ProjectDetailCreateProductEvent({
    required this.code,
    this.name,
    this.specificProduct,
    this.unit,
    this.price,
    this.priceDate,
    this.origin,
    this.brand,
    required this.supplier,
    required this.asker,
    this.note,
    required this.projectId,
    required this.searchQuery,
  });
}

class ProjectDetailCancelAddProductEvent extends ProjectDetailEvent {}